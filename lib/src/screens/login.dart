import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages/home_page.dart';
// import 'package:smartkyat_pos/src/screens/home.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password;
  final auth = FirebaseAuth.instance;


  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(  
      // appBar: AppBar(title: Text('Login'),),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(  
                hintText: 'Email'
              ),
               onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
            
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:[
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Signin'),
              onPressed: (){
                  auth.signInWithEmailAndPassword(email: _email, password: _password).then((_){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chooseStore()));
                  });
                  
            }),
            RaisedButton( 
              color: Theme.of(context).accentColor,
              child: Text('Signup'),
              onPressed: (){
                auth.createUserWithEmailAndPassword(email: _email, password: _password).then((_){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyScreen()));
                });
                
              },
            )
          ])
        ],),
    );
  }
}