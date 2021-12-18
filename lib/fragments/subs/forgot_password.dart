
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String buttonPressed = 'N';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 40),
                        child: Container(
                            child: Image.asset('assets/system/retialshop.png',)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 43),
                        child: buttonPressed == 'N' ? Text(text, style: TextStyle(
                          color: Colors.black,
                        ),) : buttonPressed == 'S' ? Text(text1, style: TextStyle(
                          color: Colors.green,
                        ),) : Text(text2, style: TextStyle(
                          color: Colors.red,
                        ),)
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                            child: TextFormField(
//The validator receives the text that the user has entered.
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // return '';
                                  return ' This field is required ';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  height: 0.95
                              ),
                              maxLines: 1,
                              decoration: InputDecoration(
                                enabledBorder:  OutlineInputBorder(
                                    borderSide:  BorderSide(
                                        color: AppTheme.skBorderColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),

                                focusedBorder:  OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide:  BorderSide(
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
                               // errorText: wrongEmail,
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
                                labelText: 'Type your Email address',
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
                      ),
                      Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                  child: buttonPressed == 'N' || buttonPressed == 'E' ?
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
                     if (_formKey.currentState!.validate()) {
                        resetPassword();
                           }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            bottom: 3.0),
                        child: Container(
                          child: Text(
                            'Reset Password',
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
                  ) :
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
                       Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            bottom: 3.0),
                        child: Container(
                          child: Text(
                            'Return to Login',
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
                ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text('Return to Login screen?',
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
                            Navigator.pop(context);
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  String text = 'Enter the email address you\'ve used to register with us and we\'ll send you a reset link!';
  String text1 = '';
  String text2 = '';
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
      setState(() {
        text1 = 'Reset password link is successfully send to your email!';
        buttonPressed = 'S';
      });
    } catch (e) {
      setState(() {
        text2 = 'Email incorrect! Check your email and try again.';
        buttonPressed = 'E';
      });
     print(e.toString());
    }
  }
}
