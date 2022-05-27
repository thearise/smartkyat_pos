import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {

    Widget child = Container(height: 400,color: Colors.red,);
    if(tabItem == "Page1")
      child = GestureDetector(child: Container(height: 400,color: Colors.yellow,));
    else if(tabItem == "Page2")
      child = Container(height: 400,color: Colors.blue,);
    else if(tabItem == "Page3")
      child = Container(height: 400,color: Colors.green,);

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child
        );
      },
    );
  }
}