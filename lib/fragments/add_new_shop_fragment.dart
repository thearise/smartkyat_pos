import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';

import '../app_theme.dart';

class AddNewShop extends StatefulWidget {
  const AddNewShop({Key? key}) : super(key: key);

  @override
  _AddNewShopState createState() => _AddNewShopState();
}



class _AddNewShopState extends State<AddNewShop> {

  static List<String> shopFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 25.0),
                    child: Container(
                      child: Image.asset('assets/system/smartkyat.png', height: 68, width: 68,),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  child: Text('SHOP REGISTRATION', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15, letterSpacing: 2,
                    color: Colors.grey,),),
                ),
                SizedBox(height: 18,),
                TextFormField(
//The validator receives the text that the user has entered.
                  controller: _shopName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    shopFieldsValue.add(value);
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
                SizedBox(height: 15,),
                TextFormField(
//The validator receives the text that the user has entered.
                  controller: _address,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    shopFieldsValue.add(value);
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
                SizedBox(height: 15,),
                TextFormField(
//The validator receives the text that the user has entered.
                  controller: _phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    shopFieldsValue.add(value);
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
                    labelText: 'Phone Number',
                    floatingLabelBehavior:
                    FloatingLabelBehavior.auto,
//filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                ButtonTheme(
                  minWidth: (MediaQuery.of(context).size.width),
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
                      shopFieldsValue = [];

                      final User? user = auth.currentUser;
                      final uid = user!.uid;
                      final email = user.email;
                      if (_formKey.currentState!.validate()) {
                        await FirebaseFirestore.instance.collection('shops').add(
                            {
                              'owner_id' : uid.toString(),
                              'shop_name': shopFieldsValue[0],
                              'shop_address' : shopFieldsValue[1],
                              'shop_phone': shopFieldsValue[2],
                              'users': FieldValue.arrayUnion([email.toString()]),
                            }
                        ).then((value) async {
                          setStoreId(value.id.toString());
                          var resultPop = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                          print('shop added');
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
                          'Create shop',
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

                SizedBox(height: 30,),
                Text('Set up some information about your shop later in shop settings.'),
                Spacer(),
                // Row(
                //   children: [
                //     Text('By singing up, you agree to our ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //     Text('Terms',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.blue,
                //       ),),
                //     Text(', ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //     Text('Privacy Policy',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.blue,
                //       ),),
                //     Text(', ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Text('and ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //     Text('Cookie Use',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.blue,
                //       ),),
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20,bottom: 40.0),
                //   child: ButtonTheme(
                //     minWidth: MediaQuery.of(context).size.width,
                //     splashColor: Colors.transparent,
                //     height: 53,
                //     child: FlatButton(
                //   color: AppTheme.themeColor,
                //   shape: RoundedRectangleBorder(
                //     borderRadius:
                //     BorderRadius.circular(10.0),
                //     side: BorderSide(
                //       color: AppTheme.themeColor,
                //     ),
                //   ),
                //   onPressed: () {
                //
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         left: 5.0,
                //         right: 5.0,
                //         bottom: 2.0),
                //     child: Container(
                //       child: Text(
                //        'Enter',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('store', id);
  }

  getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('store');
  }
}
