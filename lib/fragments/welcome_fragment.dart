
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emails = TextEditingController();
  final _passwords = TextEditingController();
  final _shopName = TextEditingController();
  final _address = TextEditingController();

  @override
  initState() {
    _loginTabController = TabController(length: 2, vsync: this);
    _signupController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                        child: Image.asset('assets/system/smartkyat.png', height: 68, width: 68,)
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 182,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _signupController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 15, right: 15),
                            child: Column(
                              children: [
                                Container(
                                    child: Image.asset('assets/system/retialshop.png', height: 188, width: 374,)
                                ),
                            Container(
                        height: MediaQuery.of(context).size.height -410,
                        child: TabBarView(
                         physics: NeverScrollableScrollPhysics(),
                            controller: _loginTabController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('All-in-one ',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    SizedBox(height: 8),
                                    Text('POS system mobile ',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    SizedBox(height: 8),
                                    Text('in your hands',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    SizedBox(height: 50,),
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
                                        onPressed: () {
                                          _signupController.animateTo(1);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              bottom: 2.0),
                                          child: Container(
                                            child: Text(
                                              'Create an account',
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
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
                                              onPressed: ()  {
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
                              Padding(
                                padding: const EdgeInsets.only(top: 35.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    SizedBox(height: 35),
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
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => chooseStore()));
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
                                    //SizedBox(height: 50,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Row(
                                        children: [
                                          Text('New to smart kyat pos?',
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
                                              onPressed: () {
                                               _signupController.animateTo(1);
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
                            ],
                        ),
                      ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Text('REGISTRATION', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15, letterSpacing: 2,
                                        color: Colors.grey,),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: TextFormField(
//The validator receives the text that the user has entered.
                                        controller: _emails,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          }
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: TextFormField(
                                        obscureText: true,
//The validator receives the text that the user has entered.
                                        controller: _passwords,
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
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      height: 2,
                                      width: MediaQuery.of(context).size.width,
                                        color: AppTheme.skBorderColor,

                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Text('SHOP REGISTRATION',style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15, letterSpacing: 2,
                                        color: Colors.grey,)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: TextFormField(
//The validator receives the text that the user has entered.
                                        controller: _shopName,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          }
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
                                          labelText: 'Shop name',
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
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: TextFormField(
//The validator receives the text that the user has entered.
                                        controller: _address,
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
                                          labelText: 'Shop address',
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
//filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: ButtonTheme(
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
                                            auth.createUserWithEmailAndPassword(email: _emails.text, password: _passwords.text).then((_){
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyScreen()));
                                            });

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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 22,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Row(
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Row(
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
                                    ),
                                    //SizedBox(height: 50,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
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
                                                _signupController.animateTo(0);
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
          ],
        ),
      ),
    );
  }
}