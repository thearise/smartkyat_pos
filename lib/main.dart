import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartkyat_pos/pages/home_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: 'Flutter UI',
      debugShowCheckedModeBanner: false,

      theme: new ThemeData(
        // primarySwatch: Colors.teal,
        canvasColor: Colors.white,
      ),
      //home: App(settings),
      home: HomePage(),
    );
  }
}

