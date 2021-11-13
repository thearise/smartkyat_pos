
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import 'choose_store_fragment.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome>
    with TickerProviderStateMixin<Welcome>{

  late TabController _loginTabController;
  late TabController _signupController;
  late TabController _bottomTabBarCtl;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emails = TextEditingController();
  final _passwords = TextEditingController();
  final _name = TextEditingController();
  final _confirm = TextEditingController();

  bool pressedCreate = false;
  bool _obscureText = true;
  bool _obscureText1 = true;
  String? wrongEmail;
  String? wrongPassword;
  String? weakPassword;
  String? emailExist;

  @override
  initState() {
    _loginTabController = TabController(length: 2, vsync: this);
    _signupController = TabController(length: 2, vsync: this);
    _bottomTabBarCtl = TabController(length: 4, vsync: this);
    _bottomTabBarCtl.animateTo(1);
    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 23.0),
                    child: Container(
                        child: Image.asset('assets/system/smartkyat.png', height: 63, width: 63,)
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _signupController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 0, right: 0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Container(
                                      child: Image.asset('assets/system/retialshop.png',)
                                  ),
                                ),
                                Container(
                                  height: 342,
                                  child: TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: _loginTabController,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 45.0, left: 15.0, right: 15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('All-in-one ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.02
                                              ),),
                                            SizedBox(height: 8),
                                            Text('POS system mobile ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.02
                                              ),),
                                            SizedBox(height: 8),
                                            Text('in your hands',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.02
                                              ),),
                                            SizedBox(height: 50,),
                                            ButtonTheme(
                                              minWidth: MediaQuery.of(context).size.width,
                                              splashColor: Colors.transparent,
                                              height: 50,
                                              child: FlatButton(
                                                color: AppTheme.themeColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  side: BorderSide(
                                                    color: AppTheme.themeColor,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  pressedCreate = true;
                                                  _signupController.animateTo(1);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5.0,
                                                      bottom: 3.0),
                                                  child: Container(
                                                    child: Text(
                                                      'Create an account',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing:-0.1
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 22,),
                                            RichText(
                                              text: new TextSpan(
                                                children: [
                                                  new TextSpan(
                                                    text: 'By signing up, you agree to our ',
                                                    style: new TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  new TextSpan(
                                                    text: 'Terms',
                                                    style: new TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                    recognizer: new TapGestureRecognizer()
                                                      ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                      },
                                                  ),
                                                  new TextSpan(
                                                    text: ', ',
                                                    style: new TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  new TextSpan(
                                                    text: 'Privacy Policy',
                                                    style: new TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                    recognizer: new TapGestureRecognizer()
                                                      ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                      },
                                                  ),
                                                  new TextSpan(
                                                    text: ', and ',
                                                    style: new TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  new TextSpan(
                                                    text: 'Cookie Use.',
                                                    style: new TextStyle(
                                                        fontSize: 12.5,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                    recognizer: new TapGestureRecognizer()
                                                      ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                      },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 29.0, left: 15.0, right: 15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0, bottom: 15.0),
                                                  child: Container(
                                                    child: TextFormField(
//The validator receives the text that the user has entered.
                                                      controller: _email,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          // return '';
                                                          return ' This field is required ';
                                                        }
                                                        if (wrongEmail != '') {
                                                          return wrongEmail;
                                                        }

                                                        return null;
                                                      },
                                                      style: TextStyle(
                                                          height: 0.95
                                                      ),
                                                      maxLines: 1,
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
                                                                color: AppTheme.themeColor,
                                                                width: 2.0),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                                        // isDense: true,
                                                        contentPadding: const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 20,
                                                            bottom: 20.0),
                                                        suffixText: 'Required',
                                                        suffixStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontFamily: 'capsulesans',
                                                        ),
                                                        errorText: wrongEmail,
                                                        errorStyle: TextStyle(
                                                            backgroundColor: Colors.white,
                                                            fontSize: 12,
                                                            fontFamily: 'capsulesans',
                                                            height: 0.1
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
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 75.0),
                                                  child: TextFormField(
                                                    obscureText: _obscureText,
                                                    controller: _password,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return ' This field is required ';
                                                      }
                                                      if (wrongPassword != '') {
                                                        return wrongPassword;
                                                      }
                                                      return null;
                                                    },
                                                    style: TextStyle(
                                                      height: 0.95,
                                                    ),
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
                                                              color: AppTheme.themeColor,
                                                              width: 2.0),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10.0))),
                                                      contentPadding: const EdgeInsets.only(
                                                          left: 15.0,
                                                          right: 15.0,
                                                          top: 20.0,
                                                          bottom: 20.0),
                                                      suffixIcon: Padding(
                                                        padding: const EdgeInsets.only(bottom: 3.0),
                                                        child: IconButton(
                                                          icon: _obscureText? Icon(Icons.remove_red_eye_outlined, size: 21,): Icon(Icons.remove_red_eye, size: 21,),
                                                          //tooltip: 'Increase volume by 10',
                                                          onPressed: () {
                                                            setState(() {
                                                              _toggle();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      // suffixStyle: TextStyle(
                                                      //   color: Colors.grey,
                                                      //   fontSize: 12,
                                                      //   fontFamily: 'capsulesans',
                                                      // ),
                                                      errorText: wrongPassword,
                                                      errorStyle: TextStyle(
                                                          backgroundColor: Colors.white,
                                                          fontSize: 12,
                                                          fontFamily: 'capsulesans',
                                                          height: 0.1
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
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 160.0),
                                                  child: Column(
                                                    children: [
                                                      ButtonTheme(
                                                        minWidth: MediaQuery.of(context).size.width,
                                                        splashColor: Colors.transparent,
                                                        height: 50,
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
                                                            setState(() {
                                                              wrongEmail = null;
                                                              wrongPassword = null;
                                                            });
                                                            if (_formKey.currentState!.validate()) {
                                                              try {
                                                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                                                  email: _email.text,
                                                                  password: _password.text,
                                                                ).then((_){
                                                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chooseStore()));
                                                                });
                                                              } on FirebaseAuthException catch (e) {
                                                                print(e.code.toString());
                                                                if (e.code == 'user-not-found') {
                                                                  setState(() {
                                                                    wrongEmail = ' may be incorrect ';
                                                                    wrongPassword = ' may be incorrect ';
                                                                  });
                                                                  print('No user found for that email.');
                                                                } else if (e.code == 'wrong-password') {
                                                                  setState(() {
                                                                    wrongEmail = ' may be incorrect ';
                                                                    wrongPassword = ' may be incorrect ';
                                                                  });
                                                                  print('Wrong password provided for that user.');
                                                                } else if (e.code == 'invalid-email') {
                                                                  setState(() {
                                                                    wrongEmail = ' is invalid email ';
                                                                    // wrongPassword = ' may be incorrect ';
                                                                  });
                                                                  print('Invalid email.');
                                                                }
                                                              }

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
                                                                    fontWeight: FontWeight.w600,
                                                                    letterSpacing:-0.1
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 22,),
                                                      RichText(
                                                        text: new TextSpan(
                                                          children: [
                                                            new TextSpan(
                                                              text: 'By signing up, you agree to our ',
                                                              style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                            ),
                                                            new TextSpan(
                                                              text: 'Terms',
                                                              style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                              recognizer: new TapGestureRecognizer()
                                                                ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                },
                                                            ),
                                                            new TextSpan(
                                                              text: ', ',
                                                              style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                            ),
                                                            new TextSpan(
                                                              text: 'Privacy Policy',
                                                              style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                              recognizer: new TapGestureRecognizer()
                                                                ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                },
                                                            ),
                                                            new TextSpan(
                                                              text: ', and ',
                                                              style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                            ),
                                                            new TextSpan(
                                                              text: 'Cookie Use.',
                                                              style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                              recognizer: new TapGestureRecognizer()
                                                                ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                },
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 17),
//                             child: Column(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: Text('REGISTRATION', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, letterSpacing: 2,
//                                         color: Colors.grey,),),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 15, right: 15, bottom: 16, top: 15.5),
//                                       child: TextFormField(
//                                         //obscureText: _obscureText,
// //The validator receives the text that the user has entered.
//                                         controller: _name,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return ' This field is required ';
//                                           }
//                                           return null;
//                                         },
//                                         style: TextStyle(
//                                             height: 0.95
//                                         ),
//                                         decoration: InputDecoration(
//                                           enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skBorderColor,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//
//                                           focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skThemeColor2,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//                                           contentPadding: const EdgeInsets.only(
//                                               left: 15.0,
//                                               right: 15.0,
//                                               top: 20.0,
//                                               bottom: 20.0),
//                                           suffixText: 'Required',
//                                           suffixStyle: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 12,
//                                             fontFamily: 'capsulesans',
//                                           ),
//                                           //errorText: wrongPassword,
//                                           errorStyle: TextStyle(
//                                               backgroundColor: Colors.white,
//                                               fontSize: 12,
//                                               fontFamily: 'capsulesans',
//                                               height: 0.1
//                                           ),
//                                           labelStyle: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
// // errorText: 'Error message',
//                                           labelText: 'Name',
//                                           floatingLabelBehavior:
//                                           FloatingLabelBehavior.auto,
// //filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: TextFormField(
//                                         //obscureText: _obscureText,
// //The validator receives the text that the user has entered.
//                                         controller: _emails,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return ' This field is required ';
//                                           }
//                                           if (emailExist != '') {
//                                             return emailExist;
//                                           }
//                                           return null;
//                                         },
//                                         style: TextStyle(
//                                             height: 0.95
//                                         ),
//                                         decoration: InputDecoration(
//                                           enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skBorderColor,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//
//                                           focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skThemeColor2,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//                                           contentPadding: const EdgeInsets.only(
//                                               left: 15.0,
//                                               right: 15.0,
//                                               top: 20.0,
//                                               bottom: 20.0),
//                                           suffixText: 'Required' ,
//                                               //tooltip: 'Increase volume by 10',
//                                           suffixStyle: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 12,
//                                             fontFamily: 'capsulesans',
//                                           ),
//                                           errorText: emailExist,
//                                           errorStyle: TextStyle(
//                                               backgroundColor: Colors.white,
//                                               fontSize: 12,
//                                               fontFamily: 'capsulesans',
//                                               height: 0.1
//                                           ),
//                                           labelStyle: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
// // errorText: 'Error message',
//                                           labelText: 'Email Address',
//                                           floatingLabelBehavior:
//                                           FloatingLabelBehavior.auto,
// //filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 20,),
//                                     Container(
//                                       height: 2,
//                                       width: MediaQuery.of(context).size.width,
//                                       color: AppTheme.skBorderColor,
//                                     ),
//                                     SizedBox(height: 16,),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: Text('SHOP REGISTRATION',style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, letterSpacing: 2,
//                                         color: Colors.grey,)),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 15, right: 15, bottom: 16, top: 16),
//                                       child: TextFormField(
//                                         obscureText: _obscureText1,
// //The validator receives the text that the user has entered.
//                                         controller: _passwords,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return ' This field is required ';
//                                           }
//                                           if (weakPassword != '') {
//                                             return weakPassword;
//                                           }
//                                           return null;
//                                         },
//                                         style: TextStyle(
//                                             height: 0.95
//                                         ),
//                                         decoration: InputDecoration(
//                                           enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skBorderColor,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//
//                                           focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skThemeColor2,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//                                           contentPadding: const EdgeInsets.only(
//                                               left: 15.0,
//                                               right: 15.0,
//                                               top: 20.0,
//                                               bottom: 20.0),
//                                           suffixIcon: Padding(
//                                             padding: const EdgeInsets.only(bottom: 3.0),
//                                             child: IconButton(
//                                               icon: const Icon(Icons.visibility),
//                                               //tooltip: 'Increase volume by 10',
//                                               onPressed: () {
//                                                 setState(() {
//                                                   _toggle1();
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                           // suffixStyle: TextStyle(
//                                           //   color: Colors.grey,
//                                           //   fontSize: 12,
//                                           //   fontFamily: 'capsulesans',
//                                           // ),
//                                           errorText: weakPassword,
//                                           errorStyle: TextStyle(
//                                               backgroundColor: Colors.white,
//                                               fontSize: 12,
//                                               fontFamily: 'capsulesans',
//                                               height: 0.1
//                                           ),
//                                           labelStyle: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
// // errorText: 'Error message',
//                                           labelText: 'Password',
//                                           floatingLabelBehavior:
//                                           FloatingLabelBehavior.auto,
// //filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: TextFormField(
//                                         obscureText: _obscureText1,
// //The validator receives the text that the user has entered.
//                                         controller: _confirm,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return ' This field is required ';
//                                           }
//                                           // if (weakPassword != '') {
//                                           //   return weakPassword;
//                                           // }
//                                           return null;
//                                         },
//                                         style: TextStyle(
//                                             height: 0.95
//                                         ),
//                                         decoration: InputDecoration(
//                                           enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skBorderColor,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//
//                                           focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                               borderSide: const BorderSide(
//                                                   color: AppTheme.skThemeColor2,
//                                                   width: 2.0),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0))),
//                                           contentPadding: const EdgeInsets.only(
//                                               left: 15.0,
//                                               right: 15.0,
//                                               top: 20.0,
//                                               bottom: 20.0),
//                                           suffixIcon: Padding(
//                                             padding: const EdgeInsets.only(bottom: 3.0),
//                                             child: IconButton(
//                                               icon: const Icon(Icons.visibility),
//                                               //tooltip: 'Increase volume by 10',
//                                               onPressed: () {
//                                                 setState(() {
//                                                   _toggle1();
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                           // suffixStyle: TextStyle(
//                                           //   color: Colors.grey,
//                                           //   fontSize: 12,
//                                           //   fontFamily: 'capsulesans',
//                                           // ),
//                                           errorText: weakPassword,
//                                           errorStyle: TextStyle(
//                                               backgroundColor: Colors.white,
//                                               fontSize: 12,
//                                               fontFamily: 'capsulesans',
//                                               height: 0.1
//                                           ),
//                                           labelStyle: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
// // errorText: 'Error message',
//                                           labelText: 'Confirm Password',
//                                           floatingLabelBehavior:
//                                           FloatingLabelBehavior.auto,
// //filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 30),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: ButtonTheme(
//                                         minWidth: MediaQuery.of(context).size.width,
//                                         splashColor: Colors.transparent,
//                                         height: 50,
//                                         child: FlatButton(
//                                           color: AppTheme.themeColor,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(10.0),
//                                             side: BorderSide(
//                                               color: AppTheme.themeColor,
//                                             ),
//                                           ),
//                                           onPressed: () async {
//                                             emailExist = null;
//                                             weakPassword = null;
//                                             if (_formKey.currentState!.validate()) {
//                                               try {
//                                                 await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                                                     email: _emails.text,
//                                                     password: _passwords.text).then((_) {
//                                                   // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
//                                                   //     VerifyScreen()));
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) => VerifyScreen()),);
//                                                 });
//                                               } on FirebaseAuthException catch (e) {
//                                                 if (e.code == 'weak-password') {
//                                                   setState(() {
//                                                     weakPassword = ' Password is too weak (must be at least 6 characters long) ';
//                                                   });
//                                                   print('The password provided is too weak.');
//                                                 } else if (e.code == 'email-already-in-use') {
//                                                   setState(() {
//                                                     emailExist = ' Account already exists ';
//                                                   });
//                                                   print('The account already exists for that email.');
//                                                 }
//                                               } catch (e) {
//                                                 print(e);
//                                               }
//                                             }
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5.0,
//                                                 right: 5.0,
//                                                 bottom: 2.0),
//                                             child: Container(
//                                               child: Text(
//                                                 'Sign up',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing:-0.1
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 22,),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: Row(
//                                         children: [
//                                           Text('By singing up, you agree to our ',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey,
//                                             ),),
//                                           Text('Terms',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.blue,
//                                             ),),
//                                           Text(', ',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey,
//                                             ),),
//                                           Text('Privacy Policy',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.blue,
//                                             ),),
//                                           Text(', ',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey,
//                                             ),),
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: Row(
//                                         children: [
//                                           Text('and ',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey,
//                                             ),),
//                                           Text('Cookie Use',
//                                             style: TextStyle(
//                                               fontSize: 12.5,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.blue,
//                                             ),),
//                                         ],
//                                       ),
//                                     ),
//                                     //SizedBox(height: 50,),
//                                     // Padding(
//                                     //   padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
//                                     //   child: Row(
//                                     //     children: [
//                                     //       Text('Have an account already?',
//                                     //         style: TextStyle(
//                                     //           fontSize: 16,
//                                     //           fontWeight: FontWeight.bold,
//                                     //         ),),
//                                     //       SizedBox(width: 15,),
//                                     //       ButtonTheme(
//                                     //         minWidth: 35,
//                                     //         splashColor: Colors.transparent,
//                                     //         height: 30,
//                                     //         child: FlatButton(
//                                     //           color: AppTheme.themeColor,
//                                     //           shape: RoundedRectangleBorder(
//                                     //             borderRadius:
//                                     //             BorderRadius.circular(50.0),
//                                     //             side: BorderSide(
//                                     //               color: AppTheme.themeColor,
//                                     //             ),
//                                     //           ),
//                                     //           onPressed: ()  {
//                                     //             _signupController.animateTo(0);
//                                     //             _loginTabController.animateTo(1);
//                                     //           },
//                                     //           child: Container(
//                                     //             child: Text(
//                                     //               'Login',
//                                     //               textAlign: TextAlign.center,
//                                     //               style: TextStyle(
//                                     //                 fontSize: 13,
//                                     //                 fontWeight: FontWeight.bold,
//                                     //               ),
//                                     //             ),
//                                     //           ),
//                                     //         ),
//                                     //       )],
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
                          Padding(
                            padding: const EdgeInsets.only(top: 27.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text('REGISTRATION', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, letterSpacing: 2,
                                    color: Colors.grey,),),
                                ),
                                SizedBox(height: 8),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, bottom: 15.0, left: 15.0, right: 15.0),
                                      child: Container(
                                        child: TextFormField(
                                          //obscureText: _obscureText,
//The validator receives the text that the user has entered.
                                          controller: _name,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return ' This field is required ';
                                            }
                                            return null;
                                          },
                                          style: TextStyle(
                                              height: 0.95
                                          ),
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
                                                    color: AppTheme.themeColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            contentPadding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 20.0,
                                                bottom: 20.0),
                                            suffixText: 'Required',
                                            suffixStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: 'capsulesans',
                                            ),
                                            //errorText: wrongPassword,
                                            errorStyle: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'capsulesans',
                                                height: 0.1
                                            ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
// errorText: 'Error message',
                                            labelText: 'Name',
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
//filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 75.0, left: 15.0, right: 15.0),
                                      child: TextFormField(
                                        //obscureText: _obscureText,
//The validator receives the text that the user has entered.
                                        controller: _emails,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return ' This field is required ';
                                          }
                                          if (emailExist != '') {
                                            return emailExist;
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            height: 0.95
                                        ),
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
                                                  color: AppTheme.themeColor,
                                                  width: 2.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          contentPadding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 20.0,
                                              bottom: 20.0),
                                          suffixText: 'Required' ,
                                          //tooltip: 'Increase volume by 10',
                                          suffixStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontFamily: 'capsulesans',
                                          ),
                                          errorText: emailExist,
                                          errorStyle: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'capsulesans',
                                              height: 0.1
                                          ),
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
// errorText: 'Error message',
                                          labelText: 'Email Address',
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
//filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 150.0,),
                                      child: Container(
                                        height: 2,
                                        width: MediaQuery.of(context).size.width,
                                        color: AppTheme.skBorderColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 165.0, left: 15.0, right: 15.0),
                                      child: Text('AUTHENTICATION',style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, letterSpacing: 2,
                                        color: Colors.grey,)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 195.0, left: 15.0, right: 15.0),
                                      child: Container(
                                        child: TextFormField(
                                          obscureText: _obscureText1,
//The validator receives the text that the user has entered.
                                          controller: _passwords,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return ' This field is required ';
                                            }
                                            if (weakPassword != '') {
                                              return weakPassword;
                                            }
                                            return null;
                                          },
                                          style: TextStyle(
                                              height: 0.95
                                          ),
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
                                                    color: AppTheme.themeColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            contentPadding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 20.0,
                                                bottom: 20.0),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(bottom: 3.0),
                                              child: IconButton(
                                                icon: _obscureText1? Icon(Icons.remove_red_eye_outlined, size: 21,): Icon(Icons.remove_red_eye, size: 21,),
                                                //tooltip: 'Increase volume by 10',
                                                onPressed: () {
                                                  setState(() {
                                                    _toggle1();
                                                  });
                                                },
                                              ),
                                            ),
                                            // suffixStyle: TextStyle(
                                            //   color: Colors.grey,
                                            //   fontSize: 12,
                                            //   fontFamily: 'capsulesans',
                                            // ),
                                            errorText: weakPassword,
                                            errorStyle: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'capsulesans',
                                                height: 0.1
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
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 266.0, left: 15.0, right: 15.0),
                                      child: TextFormField(
                                        obscureText: _obscureText1,
//The validator receives the text that the user has entered.
                                        controller: _confirm,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return ' This field is required ';
                                          }
                                          if (_passwords.text != _confirm.text) {
                                            return ' Passwords are not match ';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            height: 0.95
                                        ),
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
                                                  color: AppTheme.themeColor,
                                                  width: 2.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          contentPadding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 20.0,
                                              bottom: 20.0),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(bottom: 3.0),
                                            child: IconButton(
                                              icon: _obscureText1? Icon(Icons.remove_red_eye_outlined, size: 21,): Icon(Icons.remove_red_eye, size: 21,),
                                              //tooltip: 'Increase volume by 10',
                                              onPressed: () {
                                                setState(() {
                                                  _toggle1();
                                                });
                                              },
                                            ),
                                          ),
                                          // suffixStyle: TextStyle(
                                          //   color: Colors.grey,
                                          //   fontSize: 12,
                                          //   fontFamily: 'capsulesans',
                                          // ),
                                          //errorText: weakPassword,
                                          errorStyle: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'capsulesans',
                                              height: 0.1
                                          ),
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
// errorText: 'Error message',
                                          labelText: 'Confirm Password',
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
//filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 351.0, left: 15.0, right: 15.0),
                                      child: Column(
                                        children: [
                                          ButtonTheme(
                                            minWidth: MediaQuery.of(context).size.width,
                                            splashColor: Colors.transparent,
                                            height: 50,
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
                                                emailExist = null;
                                                weakPassword = null;
                                                if (_formKey.currentState!.validate()) {
                                                  try {
                                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                                        email: _emails.text,
                                                        password: _passwords.text).then((_) {
                                                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                                      //     VerifyScreen()));
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => VerifyScreen()),);
                                                    });
                                                  } on FirebaseAuthException catch (e) {
                                                    if (e.code == 'weak-password') {
                                                      setState(() {
                                                        weakPassword = ' must be 6 characters long ';
                                                      });
                                                      print('The password provided is too weak.');
                                                    } else if (e.code == 'email-already-in-use') {
                                                      setState(() {
                                                        emailExist = ' Account already exists ';
                                                      });
                                                      print('The account already exists for that email.');
                                                    } else if (e.code == 'invalid-email') {
                                                      setState(() {
                                                        emailExist = ' is invalid email ';
                                                        // wrongPassword = ' may be incorrect ';
                                                      });
                                                      print('Invalid email.');
                                                    }
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    right: 5.0,
                                                    bottom: 2.0),
                                                child: Container(
                                                  child: Text(
                                                    'Sign up',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                        letterSpacing:-0.1
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 22,),
                                          RichText(
                                            text: new TextSpan(
                                              children: [
                                                new TextSpan(
                                                  text: 'By signing up, you agree to our ',
                                                  style: new TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                                new TextSpan(
                                                  text: 'Terms',
                                                  style: new TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                  recognizer: new TapGestureRecognizer()
                                                    ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                    },
                                                ),
                                                new TextSpan(
                                                  text: ', ',
                                                  style: new TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                                new TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: new TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                  recognizer: new TapGestureRecognizer()
                                                    ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                    },
                                                ),
                                                new TextSpan(
                                                  text: ', and ',
                                                  style: new TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                                new TextSpan(
                                                  text: 'Cookie Use.',
                                                  style: new TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                  recognizer: new TapGestureRecognizer()
                                                    ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                    },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 10.0, bottom: 10.0),
              child: Container(
                height: 40,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _bottomTabBarCtl,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text('New to smart kyat pos?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.02
                              ),),
                          ),
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
                              onPressed: () {
                                _signupController.animateTo(1);
                                _bottomTabBarCtl.animateTo(3);
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


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text('Have an account already?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.02
                              ),),
                          ),
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
                              onPressed: ()  {
                                // _signupController.animateTo(1);

                                if(pressedCreate) {
                                  _loginTabController.animateTo(1);
                                  _bottomTabBarCtl.animateTo(0);
                                  _signupController.animateTo(0);
                                } else {
                                  _bottomTabBarCtl.animateTo(2);
                                  _loginTabController.animateTo(1);
                                }

                              },
                              child: Container(
                                child: Text(
                                  'Login',
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text('New to smart kyat pos?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.02
                              ),),
                          ),
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
                              onPressed: () {
                                _signupController.animateTo(1);
                                _bottomTabBarCtl.animateTo(3);
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text('Have an account already?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.02
                              ),),
                          ),
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
                              onPressed: ()  {
                                _signupController.animateTo(0);
                                _bottomTabBarCtl.animateTo(2);
                                _loginTabController.animateTo(1);
                              },
                              child: Container(
                                child: Text(
                                  'Login',
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
          ],
        ),
      ),
    );
  }
}