import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';
import 'package:smartkyat_pos/fragments/settings_fragment.dart';
import 'package:smartkyat_pos/fragments/staff_fragment.dart';
import 'package:smartkyat_pos/fragments/support_fragment.dart';

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

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    print('user ' + FirebaseAuth.instance.currentUser!.uid);
    print('newUserCheck ' + newUserCheck(FirebaseAuth.instance.currentUser!.uid).toString());

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

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomeFragment(toggleCoinCallback: addCounter);
      case 1:
        return new OrdersFragment();
      case 2:
        return new CustomersFragment();
      case 3:
        return new ProductsFragment();
      case 4:
        return new StaffFragment();
      case 5:
        return new SettingsFragment();
      case 6:
        return new SupportFragment();

      default:
        return new Text("Error");
    }
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
                      Column(
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
                          Text(
                            'Lock screen',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ],
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
                  child: new Column(children: drawerOptions),
                ),
              ],
            ),
          ),
        ),
        body: Builder(builder: (context) {
          return SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                _getDrawerItemWidget(_selectedDrawerIndex),
                MediaQuery.of(context).size.width>900?Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 56.0),
                    child: Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width*(1.5/3.5),
                      child: checkoutCart(),
                    ),
                  ),
                ):Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // color: Colors.black,
                    height: MediaQuery.of(context).size.width>900?57:157,
                    child: Column(
                      children: [
                        MediaQuery.of(context).size.width>900?Container():Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.withOpacity(0.2), width: 1.0),
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
                                    color: Colors.grey.withOpacity(0.2),
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
                                                  color: Colors.black.withOpacity(0.6)
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
                                color: Colors.grey.withOpacity(0.2), width: 1.0),
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
                                        Scaffold.of(context).openDrawer();
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
              ],
            ),
          );
        }));
  }

  var counter = 0;

  checkoutCart() {
    var width = MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(1.5/3.5):MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height-105,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
        child: Stack(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    addCounter();
                  },
                  child: Container(
                    width: (width/2)-20,
                    height: 56,
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
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
                              child: Container(child:
                              Text(
                                'Clear cart',
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
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0,),
                Container(
                  width: (width/2)-20,
                  height: 56,
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
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                child: Text('Counter: ' + counter.toString())
              ),
            )
          ],
        ),
      ),
    );
  }

  addCounter() {
    setState(() {
      counter++;
    });
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
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: Colors.grey.withOpacity(0.3)
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 20,
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
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: AppTheme.skThemeColor
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },

                                          ),
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




