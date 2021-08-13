import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/src/screens/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    //setStoreId('PucvhZDuUz3XlkTgzcjb');



    return MaterialApp(  
      title: 'Login App',
      theme: ThemeData(  
        accentColor: Colors.orange,
        // primarySwatch: Colors.blue
      ),
      home: LoginScreen(),
    );
  }

  // setStoreId(storeId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // int counter = (prefs.getInt('counter') ?? 0) + 1;
  //   // print('Pressed $counter times.');
  //
  //   prefs.setInt("counter", storeId).then((bool success) {
  //     print('success store saved');
  //   });
  // }
}