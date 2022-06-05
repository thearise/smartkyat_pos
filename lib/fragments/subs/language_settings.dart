import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../../app_theme.dart';
import '../app_theme.dart';

class LanguageSettings extends StatefulWidget {
  final _chgShopCB3;

  LanguageSettings( {required void changeShopCallback3()}) :
        _chgShopCB3 = changeShopCallback3;

  @override
  LanguageSettingsState createState() => LanguageSettingsState();
}

class LanguageSettingsState extends State<LanguageSettings>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<LanguageSettings>{
  @override
  bool get wantKeepAlive => true;

  var _result;
  var _shop ;
  bool firstTime = true;

  String textSetDisplay = 'Display';
  String textSetLanguage = 'Languages';
  String textSetChgLang = 'CHANGE LANGUAGE';

  @override
  initState() {
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetDisplay = 'Display';
          textSetLanguage = 'Languages';
          textSetChgLang = 'ဘာသာစကား ပြောင်းလဲရန်';
        });
      } else if(value=='english') {
        setState(() {
          textSetDisplay = 'Display';
          textSetLanguage = 'Languages';
          textSetChgLang = 'CHANGE LANGUAGE';
        });
      }
      setState(() {
        _result = value.toString();
      });

    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  addShop(shopName) {
    CollectionReference spaces = FirebaseFirestore.instance.collection('space');
    var exist = false;
    var docId = '';
    var shopExist = false;
    FirebaseFirestore.instance
        .collection('space')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        docId = doc.id;
        exist = true;
      });

      if(exist) {
        debugPrint('space shi p thar');

        FirebaseFirestore.instance
            .collection('space').doc(docId).collection('shops')
            .where('shop_name', isEqualTo: shopName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            shopExist = true;
          });

          if(shopExist) {
            debugPrint('shop already');

          } else {
            CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(docId).collection('shops');
            return shops
                .add({
              'shop_name': shopName
            })
                .then((value) {
              debugPrint('shop added');
            });
          }
        });


      } else {
        debugPrint('space mshi vuu');
        return spaces
            .add({
          'user_id': FirebaseAuth.instance.currentUser!.uid
        })
            .then((value) {
          CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(value.id).collection('shops');

          return shops
              .add({
            'shop_name': shopName
          })
              .then((value) {
            debugPrint('shop added');
          });

        }).catchError((error) => debugPrint("Failed to add shop: $error"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 81,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 15.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 15.5),
                            Text(
                              textSetDisplay,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                //color: Colors.grey,
                              ),
                              strutStyle: StrutStyle(
                                height: 1.5,
                                // fontSize:,
                                forceStrutHeight: true,
                              ),
                            ),
                            Text(
                              textSetLanguage,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                              strutStyle: StrutStyle(
                                height: 1.5,
                                // fontSize:,
                                forceStrutHeight: true,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Text(textSetChgLang, style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,color: Colors.grey,
                ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
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
                                offset: Offset(-12, -1.1),
                                child: Container(
                                  child: Text('English', overflow: TextOverflow.ellipsis, textScaleFactor: 1,
                                    style: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w500,),
                                    strutStyle: StrutStyle(
                                      height: 1.5,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                    // strutStyle: StrutStyle(
                                    //   fontSize: 17.0,
                                    //   height: 2.1,
                                    // ),
                                  ),
                                ),
                              ),),
                              // Container(
                              //   height: 23,
                              //   width: 55,
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(6.0),
                              //       ),
                              //       color: AppTheme.badgeBgSecond),
                              //   child: Text('Staff', style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 12,
                              //       color: Colors.white
                              //   ),),
                              // )
                            ],
                          ),
                        ),
                      ),
                      activeColor: AppTheme.themeColor,
                      value: 'english',
                      groupValue: _result,
                      onChanged: (value) {
                        showOkCancelAlertDialog(
                          context: context,
                          title: 'Are you sure you want to switch ' + value.toString() +' language?',
                          message: 'This action will restart the application',
                          defaultType: OkCancelAlertDefaultType.cancel,
                        ).then((result) async {
                          if(result == OkCancelResult.ok) {
                            setState(() {
                              _result = value;
                              // _shop= data['shop_name'];
                              debugPrint(_result);
                            });
                            setLangId(_result).then((_) {
                              // widget._chgShopCB3();
                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else if (Platform.isIOS) {
                                exit(0);
                              }
                            });
                          }
                        }
                        );

                      }
                  ),
                ),
              ),
              SizedBox(height: 0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
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
                                offset: Offset(-12, -1.1),
                                child: Container(
                                  child: Text('Burmese', overflow: TextOverflow.ellipsis, textScaleFactor: 1,
                                    style: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w500,),
                                    strutStyle: StrutStyle(
                                      height: 1.5,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                    // strutStyle: StrutStyle(
                                    //   fontSize: 17.0,
                                    //   height: 2.1,
                                    // ),
                                  ),
                                ),
                              ),),
                              // Container(
                              //   height: 23,
                              //   width: 55,
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(6.0),
                              //       ),
                              //       color: AppTheme.badgeBgSecond),
                              //   child: Text('Staff', style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 12,
                              //       color: Colors.white
                              //   ),),
                              // )
                            ],
                          ),
                        ),
                      ),
                      activeColor: AppTheme.themeColor,
                      value: 'burmese',
                      groupValue: _result,
                      onChanged: (value) {
                        showOkCancelAlertDialog(
                          context: context,
                          title: 'Are you sure you want to switch "Burmese" language?',
                          message: 'This action will restart the application',
                          defaultType: OkCancelAlertDefaultType.cancel,
                        ).then((result) async {
                          if(result == OkCancelResult.ok) {
                            setState(() {
                              _result = value;
                              // _shop= data['shop_name'];
                              debugPrint(_result);
                            });
                            setLangId(_result).then((_) {
                              // widget._chgShopCB3();
                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else if (Platform.isIOS) {
                                exit(0);
                              }
                            });
                          }
                        }
                        );

                      }
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  // final auth = FirebaseAuth.instance;
  final _accountName = TextEditingController();
  final _email = TextEditingController();
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();

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

  setLangId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('lang', id);
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
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


}



