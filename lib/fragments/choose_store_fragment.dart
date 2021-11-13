import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';
import 'package:smartkyat_pos/src/screens/loading.dart';

import '../app_theme.dart';


class chooseStore extends StatefulWidget {
  const chooseStore({Key? key}) : super(key: key);



  @override
  chooseStoreState createState() => chooseStoreState();
}

class chooseStoreState extends State<chooseStore> {

  var _result;
  var _shop ;
  bool firstTime = true;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // jiggleCtl.toggle();
    // user = auth.currentUser!;
    // user.sendEmailVerification();

    // timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   checkEmailVerified();
    // });
    super.initState();
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   FirebaseAuth.instance
    //       .authStateChanges()
    //       .listen((User? user) {
    //     if (user == null) {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
    //       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Welcome()));
    //       print('User is currently signed out!');
    //     } else {
    //       print('User is signed in!');
    //     }
    //   });
    // });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 23.0),
                        child: Container(
                            child: Image.asset('assets/system/smartkyat.png', height: 63, width: 63,)
                        ),
                      ),
                    ),
                SizedBox(height: 26.5,),
                Text('REGISTERED SHOPS', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, letterSpacing: 2,
                  color: Colors.grey,),),
                SizedBox(height: 13,),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData) {
                        var index = 0;
                        return Expanded(
                          child: ListView(
                           // physics: NeverScrollableScrollPhysics(),
                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                              index++;
                              if(index == 1 && firstTime) {
                                _result = document.id.toString();
                                _shop= data['shop_name'];
                              }
                              firstTime = false;
                              return  Container(
                                height: 54,
                                margin: EdgeInsets.only(bottom: 17),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: RadioListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.only(top: 1, bottom: 0, left: 10, right: 15),
                                  title: Container(
                                    // color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Text(data['shop_name'], style: TextStyle(height: 1.1, fontSize: 17, fontWeight: FontWeight.w500),),
                                    ),
                                  ),
                                  activeColor: AppTheme.themeColor,
                                  value: document.id.toString(),
                                  groupValue: _result,
                                  onChanged: (value) {
                                    setState(() {
                                      _result = value;
                                      _shop= data['shop_name'];
                                      print(_result);
                                      //
                                    });
                                  }
                                ),
                              );
                            }
                            ).toList(),
                          ),
                        );
                      }
                      return Container();
                    }
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
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
                    onPressed: () async {
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 3.0),
                      child: Container(
                        child: Text(
                          'Create new shop',
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
                SizedBox(height: 20,),
                Text('Set up some information about your shop later in shop settings.'),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
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
                      onPressed: () {

                        showOkCancelAlertDialog(
                          context: context,
                          title: 'Are you sure to change $_shop ?',
                          message: 'Click OK to Continue !',
                          defaultType: OkCancelAlertDefaultType.cancel,
                        ).then((result) async {
                          if(result == OkCancelResult.ok) {
                            setStoreId(_result);
                            var resultPop = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                            // if(resultPop == 'logout') {
                            //   Future.delayed(const Duration(milliseconds: 1000), () {
                            //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Welcome()));
                            //   });
                            // }
                          }
                        }
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            bottom: 3.0),
                        child: Container(
                          child: Text(
                            // 'Switch as $_shop',
                            'Go to dashboard',
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
      )
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
