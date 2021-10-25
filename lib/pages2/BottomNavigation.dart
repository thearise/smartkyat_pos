import 'package:flutter/services.dart';
// import 'package:soundpool/soundpool.dart';

import 'TabItem.dart';
import 'package:flutter/material.dart';
import 'home_page3.dart';

class BottomNavigation extends StatelessWidget {
  var gindex = 0;
  BottomNavigation({
    required this.onSelectTab,
    required this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white, width: 1.0))),
        child: BottomNavigationBar(
          backgroundColor: Colors.green,
          onTap: (int index) {
            onSelectTab(
              index,
            );
            gindex = index;
            print(gindex);
          },
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: tabs
              .map(
                (e) => _buildItem(
              index: e.getIndex(),
              icon: e.icon,
              tabName: e.tabName,
            ),
          )
              .toList(),

        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {required int index, required Icon icon, required String tabName}) {
    return BottomNavigationBarItem(
      icon: _tabIcon(index, icon),
//      icon: icon,
      title: Text(
        '',
        style: TextStyle(
          fontSize: 0,
        ),
      ),
    );
  }

  Icon _tabIcon(index, icon) {
//    return AppState.currentTab == index ? icon + 's_v2.png' : icon + '_v2.png';
    if(index==0) {
      return HomePageState.currentTab == index ? Icon(
        Icons.add,
        color: Colors.white,
        size: 25,
      ): Icon(
        Icons.add,
        color: Colors.white,
        size: 25,
      );
    } else if(index==1) {
      return HomePageState.currentTab == index ? Icon(
        Icons.add,
        color: Colors.white,
        size: 25,
      ): Icon(
        Icons.add,
        color: Colors.white,
        size: 25,
      );
    } else if(index==2) {
      return HomePageState.currentTab == index ? Icon(
        Icons.add,
        color: Colors.white,
        size: 24,
      ): Icon(
        Icons.add,
        color: Colors.white,
        size: 24,
      );
    } else {
      return HomePageState.currentTab == index ? Icon(
        Icons.add,
        color: Colors.white,
        size: 22,
      ): Icon(
        Icons.add,
        color: Colors.white,
        size: 22,
      );
    }

  }
//  Icon _tabIcon(index, icon) {
//    return
//  }
}