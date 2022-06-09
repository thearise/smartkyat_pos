import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/customers_fragment2.dart';
import 'package:smartkyat_pos/fragments/subs/forgot_password.dart';
import 'package:smartkyat_pos/pages2/first_launch_page.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import 'add_new_shop_fragment.dart';
import 'add_shop_fragment.dart';
import 'choose_store_fragment.dart';
// import 'package:loader_overlay/loader_overlay.dart';

class Welcome extends StatefulWidget {
  final double? gloBotPadd;
  const Welcome({Key? key, this.gloBotPadd,}) : super(key: key);

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

  bool isLoading = true;
  bool overLoading = false;
  bool loadingState = false;

  String lang = 'english';

  bool isEnglish = true;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {

    } else {
      Navigator.of(context).push(
          FadeRoute(page: FirstLaunchPage(),)
      );
      await prefs.setBool('seen', true);
    }
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  @override
  initState() {
    if(Platform.isIOS)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    if(Platform.isAndroid)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark// status bar color
      ));

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
        Future.delayed(const Duration(milliseconds: 1000), () {
          if(this.mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });

        getStoreId().then((value) {
          debugPrint('Out ID -> ' + value.toString());
        });

        setStoreId('');

        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          checkFirstSeen();
          // await Navigator.of(context).push(
          //     FadeRoute(page: FirstLaunchPage(),)
          // );

          getLangId().then((val) {
            debugPrint('ffirs ' + val.toString());
            lang = val;
            if(lang == 'english') {
              isEnglish = true;
            } else {
              isEnglish = false;
            }
          });

          // setState(() {
          //   debugPrint('setting state ' + lang.toString());
          // });

        });
      } else {
        getStoreId().then((value) {
          if(!auth.currentUser!.emailVerified) {
            Navigator.of(context).pushReplacement(FadeRoute(page: VerifyScreen()),);
          } else {
            debugPrint('ID -> ' + value.toString());
            Future.delayed(const Duration(milliseconds: 1000), () async {
              if(value.toString() != '' && value.toString() != 'idk') {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));

                _getId().then((val) {
                  String deviceId = val!;
                  if(this.mounted) {
                    Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                  }
                });
              } else {
                // Future.delayed(const Duration(milliseconds: 1000), () {
                //   setState(() {
                //     isLoading = false;
                //   });
                // });
                if(this.mounted) {
                  Navigator.of(context).popUntil((_) => true);
                  Navigator.of(context).pushReplacement(FadeRoute(page: chooseStore()));
                }


              }
            });
          }
        });



        debugPrint('User is signed in!');
      }
    });

    _loginTabController = TabController(length: 2, vsync: this);
    _signupController = TabController(length: 2, vsync: this);
    _bottomTabBarCtl = TabController(length: 4, vsync: this);
    _bottomTabBarCtl.animateTo(1);



    super.initState();
  }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    debugPrint(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    prefs.setString('store', id);
  }

  @override
  void dispose() {
    _loginTabController.dispose();
    _signupController.dispose();
    _bottomTabBarCtl.dispose();
    super.dispose();
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
      body: Stack(
        children: [
          SafeArea(
            bottom: true,
            top: true,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 900? MediaQuery.of(context).size.width/4:0.0),
              child: Stack(
                children: [
                  Column(
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
                                height: MediaQuery.of(context).size.width > 900? 305 + 40 + (((MediaQuery.of(context).size.width/2) - 30) * (752/1496)) : 305 + 40 + ((MediaQuery.of(context).size.width - 30) * (752/1496)) ,
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
                                            height: 305,
                                            child: TabBarView(
                                              physics: NeverScrollableScrollPhysics(),
                                              controller: _loginTabController,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 45.0, left: 15.0, right: 15.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('All-in-one ',
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              fontWeight: FontWeight.w700,
                                                              letterSpacing: 0.02
                                                          ),),
                                                      ),
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
                                                                isEnglish? 'Create an account': 'အကောင့်ဖန်တီးပါ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    height: 1.3,
                                                                    fontSize: 17.5,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Colors.black
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1.3,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 22,),
                                                      RichText(
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                        text: new TextSpan(
                                                          children: [
                                                            new TextSpan(
                                                              text: isEnglish? 'By signing up, you agree to our ': 'အကောင့်ဖန််တီးပြီးသည်နှင့် ကျွန်ုပ်တို့၏ ',
                                                              style: new TextStyle(
                                                                fontSize: 12.5,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
                                                              ),
                                                            ),
                                                            new TextSpan(
                                                              text: 'Terms',
                                                              style: new TextStyle(
                                                                fontSize: 12.5,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
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
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
                                                              ),
                                                            ),
                                                            new TextSpan(
                                                              text: 'Privacy Policy',
                                                              style: new TextStyle(
                                                                fontSize: 12.5,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
                                                              ),
                                                              recognizer: new TapGestureRecognizer()
                                                                ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                },
                                                            ),
                                                            new TextSpan(
                                                              text: isEnglish? ', and ': ', နှင့် ',
                                                              style: new TextStyle(
                                                                fontSize: 12.5,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
                                                              ),
                                                            ),
                                                            new TextSpan(
                                                              text: isEnglish? 'Cookie Use.': 'Cookie Use ',
                                                              style: new TextStyle(
                                                                fontSize: 12.5,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
                                                              ),
                                                              recognizer: new TapGestureRecognizer()
                                                                ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                },
                                                            ),
                                                            if(!isEnglish)
                                                              new TextSpan(
                                                                text: 'တို့ကို လက်ခံပြီးဖြစ််သည််။',
                                                                style: new TextStyle(
                                                                  fontSize: 12.5,
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.2,
                                                                ),
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
                                                                keyboardType: TextInputType.emailAddress,
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
                                                                // strutStyle: StrutStyle(
                                                                //   height: 1,
                                                                //   // fontSize:,
                                                                //   forceStrutHeight: true,
                                                                // ),
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
                                                                  //suffixText: 'Required',
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
                                                                      height: 1
                                                                  ),
// errorText: 'Error message',
                                                                  labelText: isEnglish? 'Email address': 'အီးမေးလ်',
                                                                  // labelStrutStyle: StrutStyle(
                                                                  //   height: 1,
                                                                  //   // fontSize:,
                                                                  //   forceStrutHeight: true,
                                                                  // ),
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
                                                              keyboardType: TextInputType.text,
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
                                                                labelText: isEnglish? 'Password': 'လျှို့ဝှက်စာလုံး',
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
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    ButtonTheme(
                                                                      // minWidth: MediaQuery.of(context).size.width/3 - 22.5,
                                                                      splashColor: Colors.transparent,
                                                                      height: 50,
                                                                      child: FlatButton(
                                                                        color: AppTheme.buttonColor2,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(10.0),
                                                                          side: BorderSide(
                                                                            color: AppTheme.buttonColor2,
                                                                          ),
                                                                        ),
                                                                        onPressed: ()  {
                                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 5.0,
                                                                              right: 5.0,
                                                                              bottom: 2.0),
                                                                          child: Container(
                                                                            child: Text(
                                                                              isEnglish? 'Forgot?': 'မေ့နေလား?',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                  height: 1.3,
                                                                                  fontSize: 17.5,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.black
                                                                              ),
                                                                              strutStyle: StrutStyle(
                                                                                height: 1.3,
                                                                                // fontSize:,
                                                                                forceStrutHeight: true,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 15),
                                                                    Expanded(
                                                                      child: ButtonTheme(
                                                                        // minWidth: double.infinity,
                                                                        // minWidth: (MediaQuery.of(context).size.width * 2/3.1) - 22.5,
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
                                                                              loadingState = true;

                                                                            });
                                                                            try {
                                                                              final result = await InternetAddress.lookup('google.com');
                                                                              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                                                if (_formKey.currentState!.validate()) {
                                                                                  setState(() {
                                                                                    overLoading = true;
                                                                                  });
                                                                                  try {
                                                                                    debugPrint('mmsp 0');
                                                                                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                                                                                      email: _email.text,
                                                                                      password: _password.text,
                                                                                    );
                                                                                    if(!auth.currentUser!.emailVerified) {
                                                                                      Navigator.of(context).pushReplacement(FadeRoute(page: VerifyScreen()),);
                                                                                    } else {
                                                                                      debugPrint('mmsp 0.1');
                                                                                      bool shopExists = false;
                                                                                      FirebaseFirestore.instance
                                                                                          .collection('shops')
                                                                                          .where('users', arrayContains: auth.currentUser!.email.toString())
                                                                                          .get()
                                                                                          .then((QuerySnapshot querySnapshot) {
                                                                                        querySnapshot.docs.forEach((doc) {
                                                                                          shopExists = true;
                                                                                        });
                                                                                        debugPrint('shop shi lar ' + shopExists.toString());

                                                                                        if(shopExists) {
                                                                                          Navigator.of(context).popUntil((_) => true);
                                                                                          Navigator.of(context).pushReplacement(FadeRoute(page: chooseStore()));
                                                                                        } else Navigator.of(context).pushReplacement(FadeRoute(page: AddNewShop()));
                                                                                      });
                                                                                    }

                                                                                  } on FirebaseAuthException catch (e) {
                                                                                    debugPrint('mmsp 1' + e.code.toString());

                                                                                    if (e.code == 'user-not-found') {
                                                                                      setState(() {
                                                                                        wrongEmail = ' may be incorrect ';
                                                                                        wrongPassword = ' may be incorrect ';
                                                                                        loadingState = false;
                                                                                        overLoading = false;
                                                                                      });
                                                                                      debugPrint('No user found for that email.');
                                                                                    } else if (e.code == 'wrong-password') {
                                                                                      setState(() {
                                                                                        wrongEmail = ' may be incorrect ';
                                                                                        wrongPassword = ' may be incorrect ';
                                                                                        loadingState = false;
                                                                                        overLoading = false;
                                                                                      });
                                                                                      debugPrint('Wrong password provided for that user.');
                                                                                    } else if (e.code == 'invalid-email') {
                                                                                      setState(() {
                                                                                        wrongEmail = ' is invalid email ';
                                                                                        loadingState = false;
                                                                                        overLoading = false;
                                                                                        // wrongPassword = ' may be incorrect ';
                                                                                      });
                                                                                      debugPrint('Invalid email.');
                                                                                    }
                                                                                  } on PlatformException catch(e) {
                                                                                    debugPrint('mmsp ee ' + e.toString());
                                                                                  }
                                                                                  debugPrint('mmsp 34 ');

                                                                                } else {
                                                                                  setState(() {
                                                                                    loadingState = false;
                                                                                    overLoading = false;
                                                                                  });
                                                                                }
                                                                              }
                                                                            } on SocketException catch (_) {
                                                                              setState(() {
                                                                                smartKyatFMod(context,'Internet connection is required to take this action.', 'w');
                                                                                loadingState = false;
                                                                                overLoading = false;
                                                                              });
                                                                            }
                                                                          },
                                                                          child:  loadingState? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                              child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 5.0,
                                                                                right: 5.0,
                                                                                bottom: 2.0),
                                                                            child: Container(
                                                                              child: Text(
                                                                                isEnglish? 'Login': 'လော့ဂ်အင်',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    height: 1.3,
                                                                                    fontSize: 17.5,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.black
                                                                                ),
                                                                                strutStyle: StrutStyle(
                                                                                  height: 1.3,
                                                                                  // fontSize:,
                                                                                  forceStrutHeight: true,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 22,),
                                                                RichText(
                                                                  strutStyle: StrutStyle(
                                                                    height: 1,
                                                                    // fontSize:,
                                                                    forceStrutHeight: true,
                                                                  ),
                                                                  text: new TextSpan(
                                                                    children: [
                                                                      new TextSpan(
                                                                        text: isEnglish? 'By signing in, you agree to our ': 'အကောင့်ဖန််တီးပြီးသည်နှင့် ကျွန်ုပ်တို့၏ ',
                                                                        style: new TextStyle(
                                                                          fontSize: 12.5,
                                                                          color: Colors.grey,
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.2,
                                                                        ),
                                                                      ),
                                                                      new TextSpan(
                                                                        text: 'Terms',
                                                                        style: new TextStyle(
                                                                          fontSize: 12.5,
                                                                          color: Colors.blue,
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.2,
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
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.2,
                                                                        ),
                                                                      ),
                                                                      new TextSpan(
                                                                        text: 'Privacy Policy',
                                                                        style: new TextStyle(
                                                                          fontSize: 12.5,
                                                                          color: Colors.blue,
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.2,
                                                                        ),
                                                                        recognizer: new TapGestureRecognizer()
                                                                          ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                          },
                                                                      ),
                                                                      new TextSpan(
                                                                        text: isEnglish? ', and ': ', နှင့် ',
                                                                        style: new TextStyle(
                                                                          fontSize: 12.5,
                                                                          color: Colors.grey,
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.2,
                                                                        ),
                                                                      ),
                                                                      new TextSpan(
                                                                        text: isEnglish? 'Cookie Use.': 'Cookie Use ',
                                                                        style: new TextStyle(
                                                                          fontSize: 12.5,
                                                                          color: Colors.blue,
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.2,
                                                                        ),
                                                                        recognizer: new TapGestureRecognizer()
                                                                          ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                                          },
                                                                      ),
                                                                      if(!isEnglish)
                                                                        new TextSpan(
                                                                          text: 'တို့ကို လက်ခံပြီးဖြစ််သည််။',
                                                                          style: new TextStyle(
                                                                            fontSize: 12.5,
                                                                            color: Colors.grey,
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 1.2,
                                                                          ),
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
//                                                   debugPrint('The password provided is too weak.');
//                                                 } else if (e.code == 'email-already-in-use') {
//                                                   setState(() {
//                                                     emailExist = ' Account already exists ';
//                                                   });
//                                                   debugPrint('The account already exists for that email.');
//                                                 }
//                                               } catch (e) {
//                                                 debugPrint(e);
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
//                                                     fontSize: 17,
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
                                                    keyboardType: TextInputType.name,
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
                                                      // suffixText: 'Required',
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
                                                      labelText: isEnglish? 'Name': 'အမည်',
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
                                                  keyboardType: TextInputType.emailAddress,
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
                                                    //suffixText: 'Required' ,
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
                                                    labelText: isEnglish? 'Email address': 'အီးမေးလ်',
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
                                                    keyboardType: TextInputType.text,
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
                                                      labelText: isEnglish? 'Password': 'လျှို့ဝှက်စာလုံး',
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
                                                  keyboardType: TextInputType.text,
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
                                                    labelText: isEnglish? 'Confirm password': 'လျှိုဝှက်စာလုံး ပြန်ရိုက်ပါ',
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
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                            emailExist = null;
                                                            weakPassword = null;

                                                          });
                                                          try {
                                                            final result = await InternetAddress.lookup('google.com');
                                                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                              if (_formKey.currentState!.validate()) {
                                                                setState(() {
                                                                  loadingState = true;
                                                                  overLoading = true;
                                                                });

                                                                try {
                                                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                                                      email: _emails.text,
                                                                      password: _passwords.text).then((_) async {

                                                                    final User? user = auth.currentUser;
                                                                    final uid = user!.uid;
                                                                    final mail = user.email;
                                                                    FirebaseFirestore.instance.collection('users').add({
                                                                      'user_id' : uid.toString(),
                                                                      'name': _name.text.toString(),
                                                                      'email': mail.toString(),
                                                                      'plan_type' : 'basic',
                                                                    }).then((val) {
                                                                      if(!auth.currentUser!.emailVerified) {
                                                                        Navigator.of(context).pushReplacement(FadeRoute(page: VerifyScreen()),);
                                                                      } else {
                                                                        debugPrint('uid +' + mail.toString());
                                                                        bool shopExists = false;
                                                                        FirebaseFirestore.instance
                                                                            .collection('shops')
                                                                            .where('users', arrayContains: mail.toString())
                                                                            .get()
                                                                            .then((QuerySnapshot querySnapshot) {
                                                                          querySnapshot.docs.forEach((doc) {
                                                                            shopExists = true;
                                                                          });


                                                                          // setState(() {
                                                                          //   loadingState = false;
                                                                          // });

                                                                          if(shopExists) {
                                                                            Navigator.of(context).pushReplacement(FadeRoute(page: chooseStore()));
                                                                          } else Navigator.of(context).pushReplacement(FadeRoute(page: AddNewShop()));

                                                                          debugPrint('username' + mail.toString() + uid.toString());
                                                                        });
                                                                      }
                                                                    });

                                                                  });
                                                                } on FirebaseAuthException catch (e) {
                                                                  setState(() {
                                                                    loadingState = false;
                                                                  });
                                                                  if (e.code == 'weak-password') {
                                                                    setState(() {
                                                                      weakPassword = ' must be 6 characters long ';
                                                                      overLoading = false;
                                                                    });
                                                                    debugPrint('The password provided is too weak.');
                                                                  } else if (e.code == 'email-already-in-use') {
                                                                    setState(() {
                                                                      emailExist = ' Account already exists ';
                                                                      overLoading = false;
                                                                    });
                                                                    debugPrint('The account already exists for that email.');
                                                                  } else if (e.code == 'invalid-email') {
                                                                    setState(() {
                                                                      emailExist = ' is invalid email ';
                                                                      overLoading = false;
                                                                      // wrongPassword = ' may be incorrect ';
                                                                    });
                                                                    debugPrint('Invalid email.');
                                                                  }
                                                                } catch (e) {
                                                                  debugPrint(e.toString());
                                                                }
                                                              }
                                                            }
                                                          } on SocketException catch (_) {
                                                            setState(() {
                                                              smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                                              loadingState = false;
                                                              overLoading = false;
                                                            });
                                                          }

                                                        },
                                                        child:  loadingState? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                            child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5.0,
                                                              bottom: 2.0),
                                                          child: Container(
                                                            child: Text(
                                                              isEnglish? 'Sign up': 'ဆိုင်းအပ်',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  height: 1.3,
                                                                  fontSize: 17.5,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Colors.black
                                                              ),
                                                              strutStyle: StrutStyle(
                                                                height: 1.3,
                                                                // fontSize:,
                                                                forceStrutHeight: true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 22,),
                                                    RichText(
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      text: new TextSpan(
                                                        children: [
                                                          new TextSpan(
                                                            text: isEnglish? 'By signing up, you agree to our ': 'အကောင့်ဖန််တီးပြီးသည်နှင့် ကျွန်ုပ်တို့၏ ',
                                                            style: new TextStyle(
                                                              fontSize: 12.5,
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                          new TextSpan(
                                                            text: 'Terms',
                                                            style: new TextStyle(
                                                              fontSize: 12.5,
                                                              color: Colors.blue,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2,
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
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                          new TextSpan(
                                                            text: 'Privacy Policy',
                                                            style: new TextStyle(
                                                              fontSize: 12.5,
                                                              color: Colors.blue,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2,
                                                            ),
                                                            recognizer: new TapGestureRecognizer()
                                                              ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                              },
                                                          ),
                                                          new TextSpan(
                                                            text: isEnglish? ', and ': ', နှင့် ',
                                                            style: new TextStyle(
                                                              fontSize: 12.5,
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                          new TextSpan(
                                                            text: isEnglish? 'Cookie Use.': 'Cookie Use ',
                                                            style: new TextStyle(
                                                              fontSize: 12.5,
                                                              color: Colors.blue,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2,
                                                            ),
                                                            recognizer: new TapGestureRecognizer()
                                                              ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                                              },
                                                          ),
                                                          if(!isEnglish)
                                                            new TextSpan(
                                                              text: 'တို့ကို လက်ခံပြီးဖြစ််သည််။',
                                                              style: new TextStyle(
                                                                fontSize: 12.5,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.2,
                                                              ),
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
                            Container(
                                height: MediaQuery.of(context).viewInsets.bottom
                            )
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
                                      child: Text(isEnglish? 'New to smart kyat pos?': 'စတင်အသုံးပြုသူ ဖြစ်ပါသလား?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.02
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.3,
                                          // fontSize:,
                                          forceStrutHeight: true,
                                        ),
                                      ),
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
                                            isEnglish? 'Sign up': 'ဆိုင်းအပ်',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.2,
                                              // fontSize:,
                                              forceStrutHeight: true,
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
                                      child: Text(isEnglish? 'Have an account already?': 'အကောင့်ရှိပြီးသားဆိုရင်',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.02
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.3,
                                          // fontSize:,
                                          forceStrutHeight: true,
                                        ),
                                      ),
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
                                            isEnglish? 'Login': 'လော့ဂ်အင်',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.2,
                                              // fontSize:,
                                              forceStrutHeight: true,
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
                                      child: Text(isEnglish? 'New to smart kyat pos?': 'စတင်အသုံးပြုသူ ဖြစ်ပါသလား?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.02
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.3,
                                          // fontSize:,
                                          forceStrutHeight: true,
                                        ),
                                      ),
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
                                            isEnglish? 'Sign up': 'ဆိုင်းအပ်',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.2,
                                              // fontSize:,
                                              forceStrutHeight: true,
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
                                      child: Text(isEnglish? 'Have an account already?': 'အကောင့်ရှိပြီးသားဆိုရင်',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.02
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.3,
                                          // fontSize:,
                                          forceStrutHeight: true,
                                        ),
                                      ),
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
                                            isEnglish? 'Login': 'လော့ဂ်အင်',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.2,
                                              // fontSize:,
                                              forceStrutHeight: true,
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
                  Visibility(
                    visible: isLoading,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                    child: CupertinoActivityIndicator(radius: 15,)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: overLoading,
            child: Container(
              color: Colors.white.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlashController? _previousController;

  Future smartKyatFMod<T>(BuildContext context, String message, String type) async {
    if(_previousController != null) {
      if (_previousController!.isDisposed == false) _previousController!.dismiss();
    }

    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }

    _previousController = FlashController<T>(
      context,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(message, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
        );
        // return Flash.dialog(
        //   controller: controller,
        //   alignment: const Alignment(0, 0.5),
        //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        //   backgroundColor: Colors.black87,
        //   child: DefaultTextStyle(
        //     style: const TextStyle(fontSize: 16.0, color: Colors.white),
        //     child: Padding(
        //       padding:
        //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //       child: Text(message),
        //     ),
        //   ),
        // );
      },
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
    );
    return _previousController!.show();
  }

  void smartKyatFlash(String text, String type) {
    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }
    showFlash(
      context: context,
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(text, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
          // child: Padding(
          //   padding: const EdgeInsets.only(
          //       top: 93.0, left: 15, right: 15),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(10.0),
          //       ),
          //       color: bgColor,
          //       border: Border.all(
          //           color: bdColor,
          //           width: 1.0
          //       ),
          //     ),
          //     child: Padding(
          //         padding: const EdgeInsets.only(
          //             top: 15.0, left: 10, right: 10, bottom: 15),
          //         child: Row(
          //           children: [
          //             SizedBox(width: 5),
          //             widgetCon,
          //             SizedBox(width: 10),
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 2.5),
          //               child: Container(
          //                 child: Text(text, overflow: TextOverflow.visible, style: TextStyle(
          //                     fontWeight: FontWeight.w400, fontSize: 14.5)),
          //               ),
          //             )
          //           ],
          //         )
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  @override
  bool get opaque => false;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 150),
  );
}