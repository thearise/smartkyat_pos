import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/shop_information.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../../app_theme.dart';
import '../app_theme.dart';
import 'staff_settings_sub.dart';
import 'switch_shop_sub.dart';

class ShopSettingsSub extends StatefulWidget {
  final _chgShopCB2;
  final _homePageLoadingOn;
  final _homePageLoadingOff;

  ShopSettingsSub( {required void changeShopCallback2(), required void homePageLoadingOn(), required void homePageLoadingOff()} ) :
        _chgShopCB2 = changeShopCallback2, _homePageLoadingOn = homePageLoadingOn, _homePageLoadingOff = homePageLoadingOff;

  @override
  _ShopSettingsSubState createState() => _ShopSettingsSubState();
}

class _ShopSettingsSubState extends State<ShopSettingsSub>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ShopSettingsSub>{
  @override
  bool get wantKeepAlive => true;

  var shopId;
  var _shop ;
  bool firstTime = true;
  var ownerId;
  final auth = FirebaseAuth.instance;

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  String textSetShopSetting = 'Shop setting';
  String textSetSwitchShop = 'Switch shop';
  String textSetStaffSetting = 'Staff setting';
  String textSetShopInfo = 'Shop info';



  @override
  void initState() {
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetShopSetting = 'Shop setting';
          textSetSwitchShop = 'ဆိုင်များ';
          textSetStaffSetting = 'ဝန်ထမ်းများ';
          textSetShopInfo = 'အချက်အလက်';
        });
      } else if(value=='english') {
        setState(() {
          textSetShopSetting = 'Shop setting';
          textSetSwitchShop = 'Switch shop';
          textSetStaffSetting = 'Staff setting';
          textSetShopInfo = 'Shop info';
        });
      }
    });
    getStoreId().then((value) {
      setState(() {
        shopId = value.toString();
      });

    });
    super.initState();
  }
  String? nameShop;
  String? addressShop;
  String? phoneShop;

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
    debugPrint(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

  chgShopFromSubSwitch() {
    widget._chgShopCB2();
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
      resizeToAvoidBottomInset: false,
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
                                'Information',  textScaleFactor: 1,
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
                                textSetShopSetting,  textScaleFactor: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
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
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('INFORMATION',  textScaleFactor: 1, style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,color: Colors.grey,
                          ),),
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              final result = await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SwitchShopSub(homePageLoadingOn: homePageLoadingOn, homePageLoadingOff: homePageLoadingOff, changeShopCallback3: chgShopFromSubSwitch)),
                                );
                              }
                            } on SocketException catch (_) {
                              smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                            }

                          },
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('shops')
                                  .where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
                                  .snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if(snapshot.hasData) {
                                  // debugPrint(snapshot.data!.docs.length);
                                  int ownShopsCount = 0;
                                  for(int i = 0; i < snapshot.data!.docs.length; i++) {
                                    ownShopsCount++;
                                  }
                                  debugPrint('Own shop count ' + ownShopsCount.toString());
                                  var index = 0;
                                  return eachTile(textSetSwitchShop, 'Total ' + ownShopsCount.toString());
                                }
                                return eachTile(textSetSwitchShop, '...');
                              }),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users')
                                .where('email', isEqualTo: auth.currentUser!.email.toString())
                                .limit(1)
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUser) {
                             if(snapshotUser.hasData) {
                               if(snapshotUser.data!.docs.length == 0) {
                                 return Container();
                               }
                               Map<String, dynamic> dataUser = snapshotUser.data!.docs[0].data()! as Map<String, dynamic>;
                               var role = dataUser['role'];

                               return (role == 'admin' || role == 'owner') ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    color: AppTheme.skBorderColor2,
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => StaffSettingsSub(ownerId: ownerId.toString(),)),
                                        );
                                      }
                                    } on SocketException catch (_) {
                                      smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                    }

                                  },
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users').where('role', isNotEqualTo: 'owner').snapshots(),
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if(snapshot.hasData) {
                                          return eachTile(textSetStaffSetting, 'Total ' + snapshot.data!.docs.length.toString());
                                        }
                                        return eachTile(textSetStaffSetting, '...');
                                      }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    color: AppTheme.skBorderColor2,
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ShopInformation(name: nameShop.toString(), address: addressShop.toString(), phone: phoneShop.toString(),)),
                                    );
                                  },
                                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots(),
                                      builder: (BuildContext context, snapshot) {
                                        if(snapshot.hasData) {
                                          var output = snapshot.data!.data();
                                          // String shopName = output?['shop_name'];
                                          nameShop = output?['shop_name'];
                                          addressShop = output?['shop_address'];
                                          phoneShop = output?['shop_phone'];
                                          ownerId = output?['owner_id'];
                                          return eachTile(textSetShopInfo, output?['shop_name'] == null? '...': output?['shop_name']);
                                        }
                                        return eachTile(textSetShopInfo, '...');
                                      }
                                  ),
                                  // child: Container(
                                  //   height: 72,
                                  //   decoration: BoxDecoration(
                                  //       border: Border(
                                  //         top: BorderSide(
                                  //             color: AppTheme.skBorderColor2,
                                  //             width: 1.0),
                                  //       )),
                                  //   child: Center(
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(bottom: 4.0),
                                  //       child: ListTile(
                                  //         title: Text('Shop info', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                                  //         trailing: Row(
                                  //           mainAxisSize: MainAxisSize.min,
                                  //           children: [
                                  //             Expanded(
                                  //               child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                  //                   stream: FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots(),
                                  //                   builder: (BuildContext context, snapshot) {
                                  //                     if(snapshot.hasData) {
                                  //                       var output = snapshot.data!.data();
                                  //                       // String shopName = output?['shop_name'];
                                  //                       nameShop = output?['shop_name'];
                                  //                       addressShop = output?['shop_address'];
                                  //                       phoneShop = output?['shop_phone'];
                                  //                       ownerId = output?['owner_id'];
                                  //                       return Container(
                                  //                         // width: MediaQuery.of(context).size.width/2,
                                  //                           child: Text(output?['shop_name'] == null? 'Loading': output?['shop_name'],textAlign: TextAlign.right,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),)
                                  //                       );
                                  //                     }
                                  //                     return Container();
                                  //                   }
                                  //               ),
                                  //             ),
                                  //             SizedBox(width: 8,),
                                  //             Icon(
                                  //               Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //
                                  //
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ],
                            ) : Container();
                             }
                             return Container();
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }

  Widget eachTile(String leftTxt, String rightTxt) {
    return Container(
      color: Colors.white,
      height: 72,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, left: 15, right: 15),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 3),
              child: Text(leftTxt,  textScaleFactor: 1,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),
                  strutStyle: StrutStyle(
                    height: 2,
                    forceStrutHeight: true,
                  )
              ),
            ),
            // Spacer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Container(
                  // color: Colors.yellow,
                  // width: MediaQuery.of(context).size.width/6,
                    child: Text(
                        rightTxt,  textScaleFactor: 1,
                        textAlign: TextAlign.right,overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey,),
                        strutStyle: StrutStyle(
                          height: 2,
                          forceStrutHeight: true,
                        )
                    )
                ),
              ),
            ),
            SizedBox(width: 8,),
            Icon(
              Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,
            ),
          ],
        ),
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



