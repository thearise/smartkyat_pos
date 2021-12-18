import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import '../../app_theme.dart';
import 'change_password.dart';
// import 'package:bottom_picker/bottom_picker.dart';

class AddStaffSub extends StatefulWidget {
  AddStaffSub({
    Key? key,
  });

  @override
  _AddStaffSubState createState() => _AddStaffSubState();
}

class _AddStaffSubState extends State<AddStaffSub> {

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _result;

  final _accountName = TextEditingController();

  List _testList = [
    {'no': 1, 'keyword': 'Cashier'},
    {'no': 2, 'keyword': 'Admin'},
  ];
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedTest;

  @override
  void initState() {
    HomePageState().getStoreId().then((value) {
      setState(() {
        _result = value.toString();
      });

    });
    _dropdownTestItems = buildDropdownTestItems(_testList);
    // _accountName.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    _accountName.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword']),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    // String gg = '';
    //
    // gg = selectedTest;


    setState(() {
      _selectedTest = selectedTest;
    });

    print(_selectedTest['keyword'].toString() + ({'no': 1, 'keyword': 'Roll-55'}).toString() + selectedTest.toString() + ' ' + selectedTest.runtimeType.toString() + ' __ ' + _selectedTest.runtimeType.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                        keyboardType: TextInputType.emailAddress,
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
                          //suffixText: 'Required',
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
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: DropdownBelow(
                        itemWidth: MediaQuery.of(context).size.width-30,
                        itemTextstyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                        boxTextstyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                        boxPadding: EdgeInsets.fromLTRB(15, 12, 13, 12),
                        boxWidth: double.infinity,
                        boxHeight: 50,
                        boxDecoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            color: AppTheme.buttonColor2,
                            border: Border.all(width: 1, color: Colors.transparent)),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black,
                        ),
                        hint: Text('Sale'),
                        value: _selectedTest,
                        items: _dropdownTestItems,
                        onChanged: onChangeDropdownTests,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: RichText(
                        text: new TextSpan(
                          children: [
                            new TextSpan(
                              text: 'Choose the paper size correctly to work well with your printer.',
                              style: new TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            // CollectionReference accountName = await FirebaseFirestore.instance.collection('users');
                            // if (_formKey.currentState!.validate()) {
                            //   accountName.doc(widget.id).update({
                            //     'name': _accountName.text,
                            //   });
                            // }
                            // Navigator.pop(context);
                            if(_formKey.currentState!.validate()) {
                              await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                  {'users': FieldValue.arrayUnion([_accountName.text]),}
                              ).then((value) async {
                                print('users added');

                                FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').add({
                                  'email': _accountName.text,
                                  'role': roleModify()
                                }).then((value) async {
                                  Navigator.pop(context);
                                });


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
                                'Add staff',
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
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }

  // _openSimpleItemPicker(BuildContext context, List<Text> items) {
  //   BottomPicker(
  //     // displayButtonIcon: false,
  //     buttonText: 'Set permission',
  //     displayButtonIcon: false,
  //     buttonSingleColor: Colors.grey,
  //     dismissable: true,
  //     items: items,
  //     title: "",
  //     buttonTextStyle: TextStyle(color: Colors.blue),
  //     titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //     onSubmit: (index) {
  //       print(index);
  //     },
  //   ).show(context);
  // }

  roleModify() {
    print('role modify ' + _selectedTest.toString());
    if(_selectedTest == null) {
      return 'cashier';
    }

    if(_selectedTest['keyword'].toString() == 'Cashier') {
      return 'cashier';
    } else if(_selectedTest['keyword'].toString() == 'Admin') {
      return 'admin';
    } else if(_selectedTest==null) {
      return 'cashier';
    }
    //return _selectedTest==null?  'sale': _selectedTest['keyword'].toString();
  }
}
