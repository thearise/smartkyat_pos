import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';
import 'package:smartkyat_pos/fragments/settings_fragment.dart';
import 'package:smartkyat_pos/fragments/staff_fragment.dart';
import 'package:smartkyat_pos/fragments/support_fragment.dart';

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

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomeFragment();
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
      drawerOptions.add(
        GestureDetector(
          onTap: () {
            _onSelectItem(i);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: new Container(
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10.0),
                  color: i == _selectedDrawerIndex? Colors.grey.withOpacity(0.2):Colors.transparent
              ),
              height: 55,
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Icon(d.icon, size: 26,),
                  ),
                  Text(
                    d.title,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                    ),
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
                padding: const EdgeInsets.only(left: 15.0, right:15.0, top: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ethereals Shop',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Yangon',
                          style: TextStyle(
                              fontSize: 14
                          ),
                        ),
                        SizedBox(height: 3,),
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
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: new Column(children: drawerOptions),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                _getDrawerItemWidget(_selectedDrawerIndex),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0),
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:15.0,),
                            child: GestureDetector(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child: Icon(Icons.home_filled, size: 26,)
                            ),
                          ),
                          Expanded(
                            child: Container(child:
                            Text(
                              'Phyo Pyae Sohn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6)
                              ),
                            )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:15.0,),
                            child: Icon(Icons.circle, color: Colors.green, size: 22,),
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
      )
    );
  }

}
