import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: Center(child: CustomFlatButton(child: Text('Logout'),onPressed: (){
        auth.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      },),),
    );
  }
}