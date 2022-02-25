import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/add_shop_fragment.dart';
import 'package:smartkyat_pos/fragments/add_shop_from_setting.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';

import '../../app_theme.dart';
import '../app_theme.dart';

class SwitchShopSub extends StatefulWidget {
  final _chgShopCB3;
  final _homePageLoadingOn;
  final _homePageLoadingOff;

  SwitchShopSub( {required void changeShopCallback3(), required void homePageLoadingOn(), required void homePageLoadingOff()}) :
        _chgShopCB3 = changeShopCallback3, _homePageLoadingOn = homePageLoadingOn, _homePageLoadingOff = homePageLoadingOff;

  @override
  _SwitchShopSubState createState() => _SwitchShopSubState();
}

class _SwitchShopSubState extends State<SwitchShopSub>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SwitchShopSub>{
  @override
  bool get wantKeepAlive => true;

  var _result;
  var _shop ;
  bool firstTime = true;

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('store', id);
  }

  @override
  initState() {
    getStoreId().then((value) {
      setState(() {
        _result = value.toString();
      });

    });
    super.initState();
  }

  homePageLoadingOn() {
    widget._homePageLoadingOn();
  }

  homePageLoadingOff() {
    widget._homePageLoadingOff();
  }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    print(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
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
        print('space shi p thar');

        FirebaseFirestore.instance
            .collection('space').doc(docId).collection('shops')
            .where('shop_name', isEqualTo: shopName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            shopExist = true;
          });

          if(shopExist) {
            print('shop already');

          } else {
            CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(docId).collection('shops');
            return shops
                .add({
              'shop_name': shopName
            })
                .then((value) {
              print('shop added');
            });
          }
        });


      } else {
        print('space mshi vuu');
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
            print('shop added');
          });

        }).catchError((error) => print("Failed to add shop: $error"));
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
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22),
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
                                  Text(
                                    'Information',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.4,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                  Text(
                                    'Switch shop',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.7,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('shops')
                          .where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData) {
                        // print(snapshot.data!.docs.length);
                        int ownShopsCount = 0;
                        for(int i = 0; i < snapshot.data!.docs.length; i++) {
                          if(i == 0) {
                            ownShopsCount = 0;
                          }
                          Map<String, dynamic> shopCusLoop = snapshot.data!.docs[i].data()! as Map<String, dynamic>;
                          if(shopCusLoop['owner_id'] == (FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.uid.toString())) {
                            ownShopsCount++;
                          }
                        }
                        print('Own shop count ' + ownShopsCount.toString());
                        var index = 0;
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: Text('CURRENT SHOP', style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,color: Colors.grey,
                                ),
                                ),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('users')
                                      .where('email', isEqualTo: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
                                      .limit(1)
                                      .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUsers) {
                                    if(snapshotUsers.hasData) {
                                      Map<String, dynamic> userData = snapshotUsers.data!.docs[0].data()! as Map<String, dynamic>;
                                      print('userdocument ' + userData['plan_type'].toString());
                                      if(userData['plan_type'] == 'basic' && ownShopsCount >= 5) {
                                        return Container();
                                      } else if(userData['plan_type'] == 'medium' && ownShopsCount >= 10) {
                                        return Container();
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                                          child: ButtonTheme(
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
                                                try {
                                                  final result = await InternetAddress.lookup('google.com');
                                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AddShopFromSetting()),);
                                                  }
                                                } on SocketException catch (_) {
                                                  smartKyatFlash('Internet connection is required to take this action.', 'w');
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    right: 5.0,
                                                    bottom: 2.0),
                                                child: Container(
                                                  child: Text(
                                                    'Add new shop',
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
                                        );
                                      }

                                    }
                                    return Container();

                                }
                              ),
                              SizedBox(height: 20,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: ListView(
                                    // physics: NeverScrollableScrollPhysics(),
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                      index++;
                                      if(index == 1 && firstTime) {
                                        // _result = document.id.toString();
                                        // _shop= data['shop_name'];
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
                                                      offset: Offset(-12, -1.1),
                                                      child: Container(
                                                        child: Text(data['shop_name'], overflow: TextOverflow.ellipsis, textScaleFactor: 1,
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
                                                    data['owner_id'] == (FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.uid.toString())?
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
                                            onChanged: (value) async {
                                              try {
                                                final result = await InternetAddress.lookup('google.com');
                                                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                  showOkCancelAlertDialog(
                                                    context: context,
                                                    title: 'Are you sure you want to switch to \n" ' + data['shop_name'].toString() + ' " ?',
                                                    message: 'This action will restart the application',
                                                    defaultType: OkCancelAlertDefaultType.cancel,
                                                  ).then((result) async {
                                                    if(result == OkCancelResult.ok) {
                                                      homePageLoadingOn();
                                                      setState(() {
                                                        _result = value;
                                                        _shop= data['shop_name'];
                                                        print(_result);
                                                      });
                                                      // setStoreId(_result);
                                                      // widget._chgShopCB3();

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
                                                              _getId().then((val) async {
                                                                String deviceId = val!;
                                                                print('valuee ' + val.toString());
                                                                await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                                                    .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                                                                    .get()
                                                                    .then((QuerySnapshot querySnapshot) async {
                                                                  print('shit ' + querySnapshot.docs[0].id.toString());
                                                                  await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                                                                    // 'device0': FieldValue.arrayUnion([await _getId()]),
                                                                    'device0': deviceId,
                                                                  }).then((value3) async {
                                                                    print('done');
                                                                    setStoreId(_result);
                                                                    // if (Platform.isAndroid) {
                                                                    //   SystemNavigator.pop();
                                                                    // } else if (Platform.isIOS) {
                                                                    //   exit(0);
                                                                    // }
                                                                    showOkAlertDialog(
                                                                        context: context,
                                                                        title: 'Restart required',
                                                                        message: 'Shop switched successfully and please restart the application to enter your shop.'
                                                                    ).then((result) async {
                                                                      if (Platform.isAndroid) {
                                                                        SystemNavigator.pop();
                                                                      } else if (Platform.isIOS) {
                                                                        exit(0);
                                                                      }
                                                                    });
                                                                  });
                                                                  // if(querySnapshot.docs[0]['devices'].length != 2) {
                                                                  //
                                                                  // }
                                                                  // Navigator.of(context).pop();
                                                                  // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);


                                                                });
                                                              });
                                                            });

                                                          });


                                                        });
                                                      });
                                                    }
                                                  }
                                                  );
                                                }
                                              } on SocketException catch (_) {
                                                smartKyatFlash('Internet connection is required to take this action.', 'w');
                                              }


                                            }
                                        ),
                                      );
                                    }
                                    ).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return Container();
                  }),

                  // StreamBuilder(
                  //     stream: FirebaseFirestore.instance.collection('shops')
                  //         .where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
                  //         .snapshots(),
                  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //       if(snapshot.hasData) {
                  //         var index = 0;
                  //         return Expanded(
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //             child: ListView(
                  //               // physics: NeverScrollableScrollPhysics(),
                  //               children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  //                 Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  //                 index++;
                  //                 if(index == 1 && firstTime) {
                  //                   // _result = document.id.toString();
                  //                   // _shop= data['shop_name'];
                  //                 }
                  //                 firstTime = false;
                  //                 return  Container(
                  //                   height: 54,
                  //                   margin: EdgeInsets.only(bottom: 17),
                  //                   decoration: BoxDecoration(
                  //                     border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                  //                     color: Colors.white,
                  //                     borderRadius: const BorderRadius.all(
                  //                         Radius.circular(10.0)),
                  //                   ),
                  //                   child: RadioListTile(
                  //                       dense: true,
                  //                       contentPadding: EdgeInsets.only(top: 1, bottom: 0, left: 5, right: 15),
                  //                       // title: Text(data['shop_name'], overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.1, fontSize: 17, fontWeight: FontWeight.w500, ),),
                  //                       title: Container(
                  //                         // color: Colors.blue,
                  //                         child: Padding(
                  //                           padding: const EdgeInsets.only(left: 0.0),
                  //                           child: Row(
                  //                             children: [
                  //                               Expanded(child: Transform.translate(
                  //                                 offset: Offset(-12, -1.1),
                  //                                 child: Container(
                  //                                   child: Text(data['shop_name'], overflow: TextOverflow.ellipsis, textScaleFactor: 1,
                  //                                     style: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w500,),
                  //                                     strutStyle: StrutStyle(
                  //                                       height: 1.5,
                  //                                       // fontSize:,
                  //                                       forceStrutHeight: true,
                  //                                     ),
                  //                                     // strutStyle: StrutStyle(
                  //                                     //   fontSize: 17.0,
                  //                                     //   height: 2.1,
                  //                                     // ),
                  //                                   ),
                  //                                 ),
                  //                               ),),
                  //                               data['owner_id'] == (FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.uid.toString())?
                  //                               Container(
                  //                                 height: 23,
                  //                                 width: 55,
                  //                                 alignment: Alignment.center,
                  //                                 decoration: BoxDecoration(
                  //                                     borderRadius: BorderRadius.all(
                  //                                       Radius.circular(6.0),
                  //                                     ),
                  //                                     color: AppTheme.badgeBgSuccess),
                  //                                 child: Text('Owner', style: TextStyle(
                  //                                     fontWeight: FontWeight.w500,
                  //                                     fontSize: 12,
                  //                                     color: Colors.white
                  //                                 ),),
                  //                               ):
                  //                               Container(
                  //                                 height: 23,
                  //                                 width: 55,
                  //                                 alignment: Alignment.center,
                  //                                 decoration: BoxDecoration(
                  //                                     borderRadius: BorderRadius.all(
                  //                                       Radius.circular(6.0),
                  //                                     ),
                  //                                     color: AppTheme.badgeBgSecond),
                  //                                 child: Text('Staff', style: TextStyle(
                  //                                     fontWeight: FontWeight.w500,
                  //                                     fontSize: 12,
                  //                                     color: Colors.white
                  //                                 ),),
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       activeColor: AppTheme.themeColor,
                  //                       value: document.id.toString(),
                  //                       groupValue: _result,
                  //                       onChanged: (value) async {
                  //                         try {
                  //                           final result = await InternetAddress.lookup('google.com');
                  //                           if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  //                             showOkCancelAlertDialog(
                  //                               context: context,
                  //                               title: 'Are you sure you want to switch to \n" ' + data['shop_name'].toString() + ' " ?',
                  //                               message: 'This action will restart the application',
                  //                               defaultType: OkCancelAlertDefaultType.cancel,
                  //                             ).then((result) async {
                  //                               if(result == OkCancelResult.ok) {
                  //                                 homePageLoadingOn();
                  //                                 setState(() {
                  //                                   _result = value;
                  //                                   _shop= data['shop_name'];
                  //                                   print(_result);
                  //                                 });
                  //                                 // setStoreId(_result);
                  //                                 // widget._chgShopCB3();
                  //
                  //                                 _getId().then((value1) async {
                  //                                   print('IDD ' + value1.toString());
                  //                                   await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                  //                                     'devices': FieldValue.arrayUnion([value1.toString()]),
                  //                                   }).then((value3) async {
                  //                                     print('done');
                  //                                     await FirebaseFirestore.instance.collection('shops').doc(_result)
                  //                                     // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
                  //                                         .get().then((value2) async {
                  //                                       List devicesList = value2.data()!['devices'];
                  //                                       int? deviceIdNum;
                  //                                       for(int i = 0; i < devicesList.length; i++) {
                  //                                         if(devicesList[i] == value1.toString()) {
                  //                                           print('DV LIST ' + devicesList[i].toString());
                  //                                           setState(() {
                  //                                             deviceIdNum = i;
                  //                                             print('DV LIST 2 ' + deviceIdNum.toString());
                  //                                           });
                  //                                         }
                  //                                       }
                  //
                  //                                       setDeviceId(deviceIdNum.toString()).then((value) {
                  //                                         _getId().then((val) async {
                  //                                           String deviceId = val!;
                  //                                           print('valuee ' + val.toString());
                  //                                           await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                  //                                               .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  //                                               .get()
                  //                                               .then((QuerySnapshot querySnapshot) async {
                  //                                             print('shit ' + querySnapshot.docs[0].id.toString());
                  //                                             await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                  //                                               // 'device0': FieldValue.arrayUnion([await _getId()]),
                  //                                               'device0': deviceId,
                  //                                             }).then((value3) async {
                  //                                               print('done');
                  //                                               setStoreId(_result);
                  //                                               // if (Platform.isAndroid) {
                  //                                               //   SystemNavigator.pop();
                  //                                               // } else if (Platform.isIOS) {
                  //                                               //   exit(0);
                  //                                               // }
                  //                                               showOkAlertDialog(
                  //                                                   context: context,
                  //                                                   title: 'Restart required',
                  //                                                   message: 'Shop switched successfully and please restart the application to enter your shop.'
                  //                                               ).then((result) async {
                  //                                                 if (Platform.isAndroid) {
                  //                                                   SystemNavigator.pop();
                  //                                                 } else if (Platform.isIOS) {
                  //                                                   exit(0);
                  //                                                 }
                  //                                               });
                  //                                             });
                  //                                             // if(querySnapshot.docs[0]['devices'].length != 2) {
                  //                                             //
                  //                                             // }
                  //                                             // Navigator.of(context).pop();
                  //                                             // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                  //
                  //
                  //                                           });
                  //                                         });
                  //                                       });
                  //
                  //                                     });
                  //
                  //
                  //                                   });
                  //                                 });
                  //                               }
                  //                             }
                  //                             );
                  //                           }
                  //                         } on SocketException catch (_) {
                  //                           smartKyatFlash('Internet connection is required to take this action.', 'w');
                  //                         }
                  //
                  //
                  //                       }
                  //                   ),
                  //                 );
                  //               }
                  //               ).toList(),
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //       return Container();
                  //     }
                  // ),
                ]
            ),
            // Positioned.fill(
            //   child: Container(
            //     color: Colors.white.withOpacity(0.8),
            //     child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
            //         child: CupertinoActivityIndicator(radius: 15,)),
            //   ),
            // )
          ],
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

  accountSetting(priContext) {
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
                                Text(
                                  'Information',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5
                                  ),
                                ),
                                Text(
                                  'Account settings',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3
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
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('INFORMATION', style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,color: Colors.grey,
                            ),),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                //obscureText: _obscureText,
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
                                  suffixText: 'Required' ,
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
                                  labelText: 'Account name',
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
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                //obscureText: _obscureText,
                                controller: _email,
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
                                  suffixText: 'Required' ,
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
                            SizedBox(height: 30,),
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
                                  if (_formKey.currentState!.validate()) {


                                  }
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
                                          letterSpacing:-0.1
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
                )
              ]
          ),
        ),
      ),
    );
  }



  addStaffPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
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
                                'Switch shop',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text('CURRENT SHOP', style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,color: Colors.grey,
                            ),),
                          ),
                          SizedBox(height: 30,),
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
                                if (_formKey.currentState!.validate()) {


                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    bottom: 2.0),
                                child: Container(
                                  child: Text(
                                    'New shop',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag:false,
        isScrollControlled:true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(priContext).padding.top,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              color: Colors.white.withOpacity(0.5)
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            color: Colors.white,
                          ),

                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: () {
                                        },

                                      ),
                                      Text(
                                        "New Expense",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'capsulesans',
                                            fontWeight: FontWeight.w600
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          print('clicked');
                                        },

                                      )

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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.yellow,
                    height: 100,
                  ),
                )
              ],
            ),
          );

        });
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

  setDeviceId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('device', id);
  }

  getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('device');
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
          child: Text ('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
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


