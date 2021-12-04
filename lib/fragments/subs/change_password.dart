
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}


class _ChangePasswordState extends State<ChangePassword> {


  final _password = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  late bool checkCurrentPasswordValid = true;
  final auth = FirebaseAuth.instance;
  String? wrongPassword;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 43),
                      //   child: Text(text, style: TextStyle(
                      //     color: Colors.red,
                      //   ),),
                      // ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                              child: TextFormField(
//The validator receives the text that the user has entered.
                                controller: _password,
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
                                  suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',
                                  ),
                                   errorText: checkCurrentPasswordValid ? null : 'Please check yur current password',
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
                                  labelText: 'Current Password',
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
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                              child: TextFormField(
//The validator receives the text that the user has entered.
                                controller: _newPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    // return '';
                                    return ' This field is required ';
                                  }
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
                                  suffixText: 'Required',
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
                                  labelText: 'New Password',
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
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                              child: TextFormField(
//The validator receives the text that the user has entered.
                                controller: _confirmPassword,
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
                                  suffixText: 'Required',
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                        child: ButtonTheme(
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
                            // checkCurrentPasswordValid = await validateCurrentPassword(_password.text);
                            // setState(() {
                            //
                            // });

                              final user = await FirebaseAuth.instance.currentUser;
                              final cred = EmailAuthProvider.credential(
                                  email: 'thearise.sps@gmail.com', password: _password.text);

                              user!.reauthenticateWithCredential(cred).then((value) {
                                user.updatePassword(_newPassword.text).then((success) {
                                  //Success, do something
                                  print('success changed');
                                }).catchError((error) {
                                  //Error, show something
                                  print('error changed');
                                });
                              }).catchError((err) {
                                print('current password is wrong. ');
                              });

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  bottom: 3.0),
                              child: Container(
                                child: Text(
                                  'Change Password',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<bool> validatePassword(String password) async {
    final User? user = auth.currentUser;
    var authCredentials = EmailAuthProvider.credential(email: user!.email.toString(), password: password);
    
    var authResult = await user.reauthenticateWithCredential(authCredentials);

    return authResult.user != null;
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await validatePassword(password);
  }
  
  String text = 'Enter the email address you\'ve used to register with us and we\'ll send you a reset link!';
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _password.text);
      setState(() {
        text = 'Reset password link is successfully send to your email!';
      });
    } catch (e) {
      setState(() {
        text = 'Email incorrect! Check your email and try again.';
      });
      print(e.toString());
    }
  }
}
