import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'change_password.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({
    required this.email, required this.name, required this.id,
    Key? key,
  });
  final String email;
  final String name;
  final String id;

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _accountName = TextEditingController();


  @override
  void initState() {
    _accountName.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    _accountName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35.0),
                                ),
                                color: Colors.grey.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 17,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Information',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Account settings',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
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
                SizedBox(height: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Text('INFORMATION', style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, color: Colors.grey,
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                                    child: TextFormField(
                                      controller: _accountName,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return ' This field is required ';
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
                                        suffixText: 'Required',
                                        suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'capsulesans',
                                        ),
                                        // errorText: wrongPassword,
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
                                        labelText: 'Account Name',
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
//filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Text('Choose the paper size correctly to work well with the printer'),
                                  ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 20.0),
//                                   child: TextFormField(
//                                     //obscureText: _obscureText,
//                                     controller: _email,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return ' This field is required ';
//                                       }
//                                       return null;
//                                     },
//                                     style: TextStyle(
//                                       height: 0.95,
//                                     ),
//                                     decoration: InputDecoration(
//                                       enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.skBorderColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//
//                                       focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.themeColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//                                       contentPadding: const EdgeInsets.only(
//                                           left: 15.0,
//                                           right: 15.0,
//                                           top: 20.0,
//                                           bottom: 20.0),
//                                       suffixText: 'Required',
//                                       suffixStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12,
//                                         fontFamily: 'capsulesans',
//                                       ),
//                                       //errorText: wrongPassword,
//                                       errorStyle: TextStyle(
//                                           backgroundColor: Colors.white,
//                                           fontSize: 12,
//                                           fontFamily: 'capsulesans',
//                                           height: 0.1
//                                       ),
//                                       labelStyle: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
// // errorText: 'Error message',
//                                       labelText: 'Email address',
//                                       floatingLabelBehavior:
//                                       FloatingLabelBehavior.auto,
// //filled: true,
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: ButtonTheme(
                                      minWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
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
                                          CollectionReference accountName = await FirebaseFirestore.instance.collection('users');
                                          if (_formKey.currentState!.validate()) {
                                            accountName.doc(widget.id).update({
                                              'name': _accountName.text,
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              bottom: 2.0),
                                          child: Container(
                                            child: Text(
                                              'Save and exit',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.1
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.withOpacity(0.3),
                                                width: 1.0))),
                                  ),
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Text('EMAIL ADDRESS', style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, color: Colors.grey,
                                    ),),
                                  ),
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                        color: AppTheme.lightBgColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          widget.email.toString(), style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Text('You can\'t change email address by yourside. If you are sure want to change it, you need to contact us.', textAlign: TextAlign.left,),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.withOpacity(0.3),
                                                width: 1.0))),
                                  ),
                                  SizedBox(height: 15.0,),
                                  GestureDetector(
                                    onTap : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChangePassword()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: Row(
                                        children: [
                                          Text('Authentication', style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),),
                                          Spacer(),
                                          Text('change password', style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey,
                                          ),),
                                          SizedBox(width: 5,),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios_rounded,
                                            size: 16,
                                            color: Colors.blueGrey
                                                .withOpacity(
                                                0.8),
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),
                                ],
                              ),
              ]
          ),
        ),
      ),
    );
  }
}
