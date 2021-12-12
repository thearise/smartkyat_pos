import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/src/screens/loading.dart';

import '../app_theme.dart';
import 'add_shop_fragment.dart';


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
    print('UID -> ' + auth.currentUser!.uid.toString());
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
                    stream: FirebaseFirestore.instance.collection('shops')
                        .where('users', arrayContains: auth.currentUser == null? '' : auth.currentUser!.email.toString())
                        .snapshots(),
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
                                    contentPadding: EdgeInsets.only(top: 1, bottom: 0, left: 5, right: 15),
                                    // title: Text(data['shop_name'], overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.1, fontSize: 17, fontWeight: FontWeight.w500, ),),
                                    title: Container(
                                      // color: Colors.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Row(
                                          children: [

                                            Expanded(child: Transform.translate(
                                              offset: Offset(-12, 0),
                                              child: Container(
                                                child: Text(data['shop_name'], overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.1, fontSize: 17, fontWeight: FontWeight.w500, ),),
                                              ),
                                            ),),
                                            data['owner_id'] == auth.currentUser!.uid.toString()?
                                            Container(
                                              height: 23,
                                              width: 55,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0),
                                                  ),
                                                  color: AppTheme.badgeBgSuccess),
                                              child: Text('Owner', style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.white
                                              ),),
                                            ):
                                            Container(
                                              height: 23,
                                              width: 55,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0),
                                                  ),
                                                  color: AppTheme.badgeBgSecond),
                                              child: Text('Staff', style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.white
                                              ),),
                                            )
                                          ],
                                        ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddShop()),);
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
                      onPressed: () async {
                        setStoreId(_result);
                        _getId().then((value1) async {
                          print('IDD ' + value1.toString());
                          await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                            'devices': FieldValue.arrayUnion([value1.toString()]),
                          }).then((value3) async {
                            print('done');
                            await FirebaseFirestore.instance.collection('shops').doc(_result)
                            // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
                                .get().then((value2) async {
                              List devicesList = value2.data()!['devices'];
                              int? deviceIdNum;
                              for(int i = 0; i < devicesList.length; i++) {
                                if(devicesList[i] == value1.toString()) {
                                  print('DV LIST ' + devicesList[i].toString());
                                  setState(() {
                                    deviceIdNum = i;
                                    print('DV LIST 2 ' + deviceIdNum.toString());
                                  });
                                }
                              }

                              setDeviceId(deviceIdNum.toString()).then((value) {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                              });


                            });


                          });
                        });


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

  setDeviceId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('device', id);
  }

  getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('device');
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
