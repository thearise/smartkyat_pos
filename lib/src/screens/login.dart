import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';

// import 'package:smartkyat_pos/src/screens/home.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';

import '../../app_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 // late String _email, _password;
  final auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ListView(
                    children: [
                      Container(
                          child: Image.asset('assets/system/smartkyat.png', height: 68, width: 68,)
                      ),
                      SizedBox(height: 40,),
                      Container(
                          child: Image.asset('assets/system/retialshop.png', height: 188, width: 374,)
                      ),
                      SizedBox(height: 45,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: TextFormField(
//The validator receives the text that the user has entered.
                                controller: _email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  //prodFieldsValue.add(value);
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: AppTheme.skBorderColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),

                                  focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: AppTheme.skThemeColor2,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  contentPadding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 18.0,
                                      bottom: 18.0),
                                  suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
// errorText: 'Error message',
                                  labelText: 'Email address',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
//filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                        TextFormField(
                          obscureText: true,
//The validator receives the text that the user has entered.
                          controller: _password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            //prodFieldsValue.add(value);
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: AppTheme.skBorderColor,
                                    width: 2.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0))),

                            focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: AppTheme.skThemeColor2,
                                    width: 2.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0))),
                            contentPadding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 18.0,
                                bottom: 18.0),
                            suffixText: 'Required',
                            suffixStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'capsulesans',
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
// errorText: 'Error message',
                            labelText: 'Password',
                            floatingLabelBehavior:
                            FloatingLabelBehavior.auto,
//filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                          ],
                        ),
                      ),
                      SizedBox(height: 45),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        splashColor: Colors.transparent,
                        height: 53,
                        child: FlatButton(
                          color: AppTheme.themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: AppTheme.themeColor,
                            ),
                          ),
                          onPressed: () async {
                           if (_formKey.currentState!.validate()) {
                            auth.signInWithEmailAndPassword(email: _email.text, password: _password.text).then((_){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                            });
                           }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 5.0,
                                bottom: 2.0),
                            child: Container(
                              child: Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 22,),
                      Row(
                        children: [
                          Text('By singing up, you agree to our ',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),),
                          Text('Terms',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),),
                          Text(', ',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),),
                          Text('Privacy Policy',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),),
                          Text(', ',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('and ',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),),
                          Text('Cookie Use',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),),
                        ],
                      ),

              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  children: [
                    Text('Have an account already?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                    SizedBox(width: 15,),
                    ButtonTheme(
                      minWidth: 35,
                      splashColor: Colors.transparent,
                      height: 30,
                      child: FlatButton(
                        color: AppTheme.themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(50.0),
                          side: BorderSide(
                            color: AppTheme.themeColor,
                          ),
                        ),
                        onPressed: () async {
                          auth.createUserWithEmailAndPassword(email: _email.text, password: _password.text).then((_){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyScreen()));
                          });
                        },
                        child: Container(
                          child: Text(
                            'Sign up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )],
                ),
              ),
                    ],
                  ),
                ),
              ),

            ],),
        ),
      ),
    );
  }
}