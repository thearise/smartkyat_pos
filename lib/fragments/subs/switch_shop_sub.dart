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
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/api/purchase_api.dart';
import 'package:smartkyat_pos/fragments/add_shop_fragment.dart';
import 'package:smartkyat_pos/fragments/add_shop_from_setting.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';
import 'package:smartkyat_pos/widgets/paywall_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String textSetAddShop = 'Add new shop';

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('store', id);
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  bool isLoading = true;
  bool isEnglish = true;

  @override
  initState() {

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          isEnglish = false;
          textSetAddShop = 'ဆိုင်အသစ် ပြုလုပ်ရန်';
        });
      } else if(value=='english') {
        setState(() {
          isEnglish = true;
          textSetAddShop = 'Add new shop';
        });
      }
    });

    getStoreId().then((value) {
      setState(() {
        _result = value.toString();
      });

    });

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          isLoading = false;
        });
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
    debugPrint(index);
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
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                                    isEnglish? 'Switch shop': 'အခြားဆိုင် ပြောင်းရန်',  textScaleFactor: 1,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Text('CHANGE SHOP',  textScaleFactor: 1, style: TextStyle(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,color: Colors.grey,
                    ),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('shops')
                          .where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData) {
                        // debugPrint(snapshot.data!.docs.length);
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
                        debugPrint('Own shop count ' + ownShopsCount.toString());
                        var index = 0;
                        return Expanded(
                          child: !isLoading  ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('users')
                                        .where('email', isEqualTo: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
                                        .limit(1)
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUsers) {
                                      if(snapshotUsers.hasData) {
                                        Map<String, dynamic> userData = snapshotUsers.data!.docs[0].data()! as Map<String, dynamic>;
                                        debugPrint('userdocument ' + userData['plan_type'].toString());
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
                                              child: CustomFlatButton(
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
                                                            builder: (context) => AddShopFromSetting(isEnglish: isEnglish,)),);
                                                    }
                                                  } on SocketException catch (_) {
                                                    smartKyatFlash(isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', 'w');
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5.0,
                                                      bottom: 2.0),
                                                  child: Container(
                                                    child: Text(
                                                      textSetAddShop,  textScaleFactor: 1,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
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
                                                          child: Text(data['shop_name'],  overflow: TextOverflow.ellipsis, textScaleFactor: 1,
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
                                                        child: Text('Owner',  textScaleFactor: 1, style: TextStyle(
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
                                                        child: Text('Staff',  textScaleFactor: 1, style: TextStyle(
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
                                                        var _val = value;
                                                        homePageLoadingOn();
                                                        setState(() {
                                                          _shop= data['shop_name'];
                                                          debugPrint(_result);
                                                        });

                                                        if(_val != null) {
                                                          await FirebaseFirestore.instance.collection('shops').doc(_val.toString())
                                                          // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
                                                              .get().then((value2) async {
                                                            debugPrint('got it 2');
                                                            var isPro = value2.data()!['is_pro'];
                                                            String shopName = value2.data()!['shop_name'];
                                                            Timestamp isProStart = isPro['start'];
                                                            Timestamp isProEnd = isPro['end'];
                                                            String ownerId = value2.data()!['owner_id'];

                                                            DateTime startDate = isProStart.toDate();
                                                            DateTime endDate = isProEnd.toDate();
                                                            DateTime nowCheck = DateTime.now();

                                                            if(!(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck))) {
                                                              homePageLoadingOff();
                                                              Future.delayed(const Duration(milliseconds: 500), () {
                                                                // smartKyatFlash('$shopName shop pro version ended', 'e');
                                                                premiumCart(_val.toString(), shopName);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                _result = _val.toString();
                                                              });
                                                              debugPrint('working here ');
                                                              if(ownerId == FirebaseAuth.instance.currentUser!.uid) {
                                                                await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(FirebaseAuth.instance.currentUser!.email).set({
                                                                  'email': FirebaseAuth.instance.currentUser!.email,
                                                                  'role': 'owner'
                                                                }).then((value4) async {
                                                                  FirebaseFirestore.instance
                                                                      .collection('shops')
                                                                      .doc(_result)
                                                                      .collection('users')
                                                                      .doc(FirebaseAuth.instance.currentUser!.email).get().then((userEmailSnap) async {
                                                                    if(userEmailSnap.exists) {
                                                                      if(userEmailSnap.exists) {
                                                                        debugPrint('working here 1');
                                                                        await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                          'email': FirebaseAuth.instance.currentUser!.email,
                                                                          'role': userEmailSnap.data()!['role']
                                                                        }).then((value4) async {
                                                                          debugPrint('working here 2');
                                                                          _getId().then((value1) async {
                                                                            debugPrint('IDD ' + value1.toString());
                                                                            WriteBatch batch = FirebaseFirestore.instance.batch();

                                                                            batch.update(FirebaseFirestore.instance.collection('shops').doc(_result), {
                                                                              'devices': FieldValue.arrayUnion([value1.toString()]),
                                                                            });

                                                                            batch.update(FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(FirebaseAuth.instance.currentUser!.email), {
                                                                              'device0': await _getId(),
                                                                            });

                                                                            try {
                                                                              batch.commit();
                                                                              debugPrint('whating? what ');
                                                                              // FirebaseFirestore.instance.collection('shops').doc(_result).collection('countColl').doc('ordsCnt')
                                                                              //     .get().then((value) async {
                                                                              //
                                                                              // });
                                                                              List<String> cntColFetch = ['', '', '', '', ''];
                                                                              int loop = 0;
                                                                              FirebaseFirestore.instance.collection('shops').doc(_result).collection('countColl')
                                                                                  .get()
                                                                                  .then((QuerySnapshot cntQuery)  async {
                                                                                debugPrint('count checking ' + cntQuery.toString());
                                                                                cntQuery.docs.forEach((doc) {
                                                                                  try{
                                                                                    if(doc['count'] == null) {
                                                                                      cntColFetch[loop] = 'null';
                                                                                    } else {
                                                                                      cntColFetch[loop] = doc['count'].toString();
                                                                                    }
                                                                                    debugPrint('count checking inn ' + doc.id.toString() + ' ' + doc['count'].toString());
                                                                                  } catch(error) {
                                                                                    cntColFetch[loop] = 'null';
                                                                                    debugPrint('count checking inn23 ' + doc.id.toString() + ' ' + 'null'.toString());
                                                                                  }



                                                                                  if(loop == 4) {
                                                                                    debugPrint('cntColFetch 3 ' + cntColFetch.toString());
                                                                                    debugPrint('checking cond ' + cntColFetch.contains('1').toString());
                                                                                    if(cntColFetch.contains('') || cntColFetch.contains('null')) {
                                                                                      smartKyatFlash('Something went wrong. Please try again later', 'e');
                                                                                      // setState(() {
                                                                                      //   loadingState = false;
                                                                                      // });

                                                                                    } else {
                                                                                      setStoreId(_result);
                                                                                      List devicesList = value2.data()!['devices'];
                                                                                      int? deviceIdNum;
                                                                                      for(int i = 0; i < devicesList.length; i++) {
                                                                                        if(devicesList[i] == value1.toString()) {
                                                                                          debugPrint('DV LIST 54' + devicesList[i].toString());
                                                                                          setState(() {
                                                                                            deviceIdNum = i;
                                                                                            debugPrint('DV LIST 2 32' + deviceIdNum.toString());
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                      debugPrint('vola');
                                                                                      showOkAlertDialog(
                                                                                          context: context,
                                                                                          title: 'Restart required',
                                                                                          message: 'Selected shop\'s been switched successfully and please restart the application to enter your shop.'
                                                                                      ).then((result) async {
                                                                                        if (Platform.isAndroid) {
                                                                                          SystemNavigator.pop();
                                                                                        } else if (Platform.isIOS) {
                                                                                          exit(0);
                                                                                        }
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                  loop++;
                                                                                });

                                                                              });

                                                                              debugPrint('cntColFetch ' + cntColFetch.toString());


                                                                            } catch (error) {

                                                                            }

                                                                            // await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                                                                            //   'devices': FieldValue.arrayUnion([value1.toString()]),
                                                                            // }).then((value3) async {
                                                                            //   debugPrint('got it 1');
                                                                            //
                                                                            //   debugPrint('got it 3');
                                                                            //   await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                                                            //       .where('email', isEqualTo: auth.currentUser!.email)
                                                                            //       .get()
                                                                            //       .then((QuerySnapshot querySnapshot) async {
                                                                            //     debugPrint('got it 4');
                                                                            //     debugPrint('shit ' + querySnapshot.docs[0].id.toString());
                                                                            //     await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                                                                            //       // 'device0': FieldValue.arrayUnion([await _getId()]),
                                                                            //       'device0': await _getId(),
                                                                            //     }).then((value3) async {
                                                                            //       debugPrint('whating? what ');
                                                                            //
                                                                            //
                                                                            //       setStoreId(_result);
                                                                            //       List devicesList = value2.data()!['devices'];
                                                                            //       int? deviceIdNum;
                                                                            //       for(int i = 0; i < devicesList.length; i++) {
                                                                            //         if(devicesList[i] == value1.toString()) {
                                                                            //           debugPrint('DV LIST ' + devicesList[i].toString());
                                                                            //           setState(() {
                                                                            //             deviceIdNum = i;
                                                                            //             debugPrint('DV LIST 2 ' + deviceIdNum.toString());
                                                                            //           });
                                                                            //         }
                                                                            //       }
                                                                            //       setDeviceId(deviceIdNum.toString()).then((value) {
                                                                            //         // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage()));
                                                                            //         _getId().then((val) {
                                                                            //           String deviceId = val!;
                                                                            //           Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                                                                            //         });
                                                                            //       });
                                                                            //     });
                                                                            //   });
                                                                            // });
                                                                          });
                                                                        });
                                                                      }
                                                                    }
                                                                  });
                                                                });
                                                              } else {
                                                                FirebaseFirestore.instance
                                                                    .collection('shops')
                                                                    .doc(_result)
                                                                    .collection('users')
                                                                    .doc(FirebaseAuth.instance.currentUser!.email).get().then((userEmailSnap) async {
                                                                  if(userEmailSnap.exists) {
                                                                    if(userEmailSnap.exists) {
                                                                      debugPrint('working here 1');
                                                                      FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                        'email': FirebaseAuth.instance.currentUser!.email,
                                                                        'role': userEmailSnap.data()!['role']
                                                                      }).then((value4) async {
                                                                        debugPrint('working here 2');
                                                                        _getId().then((value1) async {
                                                                          debugPrint('IDD ' + value1.toString());
                                                                          WriteBatch batch = FirebaseFirestore.instance.batch();

                                                                          batch.update(FirebaseFirestore.instance.collection('shops').doc(_result), {
                                                                            'devices': FieldValue.arrayUnion([value1.toString()]),
                                                                          });

                                                                          batch.update(FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(FirebaseAuth.instance.currentUser!.email), {
                                                                            'device0': await _getId(),
                                                                          });

                                                                          try {
                                                                            batch.commit();
                                                                            debugPrint('whating? what ');
                                                                            // FirebaseFirestore.instance.collection('shops').doc(_result).collection('countColl').doc('ordsCnt')
                                                                            //     .get().then((value) async {
                                                                            //
                                                                            // });
                                                                            List<String> cntColFetch = ['', '', '', '', ''];
                                                                            int loop = 0;
                                                                            FirebaseFirestore.instance.collection('shops').doc(_result).collection('countColl')
                                                                                .get()
                                                                                .then((QuerySnapshot cntQuery)  async {
                                                                              debugPrint('count checking ' + cntQuery.toString());
                                                                              cntQuery.docs.forEach((doc) {
                                                                                try{
                                                                                  if(doc['count'] == null) {
                                                                                    cntColFetch[loop] = 'null';
                                                                                  } else {
                                                                                    cntColFetch[loop] = doc['count'].toString();
                                                                                  }
                                                                                  debugPrint('count checking inn ' + doc.id.toString() + ' ' + doc['count'].toString());
                                                                                } catch(error) {
                                                                                  cntColFetch[loop] = 'null';
                                                                                  debugPrint('count checking inn23 ' + doc.id.toString() + ' ' + 'null'.toString());
                                                                                }



                                                                                if(loop == 4) {
                                                                                  debugPrint('cntColFetch 3 ' + cntColFetch.toString());
                                                                                  debugPrint('checking cond ' + cntColFetch.contains('1').toString());
                                                                                  if(cntColFetch.contains('') || cntColFetch.contains('null')) {
                                                                                    smartKyatFlash('Something went wrong. Please try again later', 'e');
                                                                                    // setState(() {
                                                                                    //   loadingState = false;
                                                                                    // });

                                                                                  } else {
                                                                                    setStoreId(_result);
                                                                                    List devicesList = value2.data()!['devices'];
                                                                                    int? deviceIdNum;
                                                                                    for(int i = 0; i < devicesList.length; i++) {
                                                                                      if(devicesList[i] == value1.toString()) {
                                                                                        debugPrint('DV LIST fewjail ' + devicesList[i].toString());
                                                                                        setState(() {
                                                                                          deviceIdNum = i;
                                                                                          debugPrint('DV LIST 2 jfeia ' + deviceIdNum.toString());
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                    debugPrint('vola 3');
                                                                                    showOkAlertDialog(
                                                                                        context: context,
                                                                                        title: 'Restart required',
                                                                                        message: 'Selected shop\'s been switched successfully and please restart the application to enter your shop.'
                                                                                    ).then((result) async {
                                                                                      if (Platform.isAndroid) {
                                                                                        SystemNavigator.pop();
                                                                                      } else if (Platform.isIOS) {
                                                                                        exit(0);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                }
                                                                                loop++;
                                                                              });

                                                                            });

                                                                            debugPrint('cntColFetch ' + cntColFetch.toString());


                                                                          } catch (error) {

                                                                          }

                                                                          // await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                                                                          //   'devices': FieldValue.arrayUnion([value1.toString()]),
                                                                          // }).then((value3) async {
                                                                          //   debugPrint('got it 1');
                                                                          //
                                                                          //   debugPrint('got it 3');
                                                                          //   await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                                                          //       .where('email', isEqualTo: auth.currentUser!.email)
                                                                          //       .get()
                                                                          //       .then((QuerySnapshot querySnapshot) async {
                                                                          //     debugPrint('got it 4');
                                                                          //     debugPrint('shit ' + querySnapshot.docs[0].id.toString());
                                                                          //     await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                                                                          //       // 'device0': FieldValue.arrayUnion([await _getId()]),
                                                                          //       'device0': await _getId(),
                                                                          //     }).then((value3) async {
                                                                          //       debugPrint('whating? what ');
                                                                          //
                                                                          //
                                                                          //       setStoreId(_result);
                                                                          //       List devicesList = value2.data()!['devices'];
                                                                          //       int? deviceIdNum;
                                                                          //       for(int i = 0; i < devicesList.length; i++) {
                                                                          //         if(devicesList[i] == value1.toString()) {
                                                                          //           debugPrint('DV LIST ' + devicesList[i].toString());
                                                                          //           setState(() {
                                                                          //             deviceIdNum = i;
                                                                          //             debugPrint('DV LIST 2 ' + deviceIdNum.toString());
                                                                          //           });
                                                                          //         }
                                                                          //       }
                                                                          //       setDeviceId(deviceIdNum.toString()).then((value) {
                                                                          //         // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage()));
                                                                          //         _getId().then((val) {
                                                                          //           String deviceId = val!;
                                                                          //           Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                                                                          //         });
                                                                          //       });
                                                                          //     });
                                                                          //   });
                                                                          // });
                                                                        });
                                                                      });
                                                                    }
                                                                  }
                                                                });
                                                              }
                                                              // FirebaseFirestore.instance.runTransaction((transaction) async {
                                                              //   DocumentSnapshot userEmailSnap = await transaction.get(userDocEmail);
                                                              //   if(userEmailSnap.exists) {
                                                              //     // userEmailSnap.data()['role']
                                                              //     var role = userEmailSnap.data() != null? userEmailSnap.data()['role']: '';
                                                              //     debugPrint('working here 1');
                                                              //     await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver').doc(auth.currentUser!.uid).set({
                                                              //       'email': auth.currentUser!.email,
                                                              //       'role':
                                                              //     }).then((value4) async {
                                                              //       debugPrint('working here 2');
                                                              //       _getId().then((value1) async {
                                                              //         debugPrint('IDD ' + value1.toString());
                                                              //         WriteBatch batch = FirebaseFirestore.instance.batch();
                                                              //
                                                              //         batch.update(FirebaseFirestore.instance.collection('shops').doc(_result), {
                                                              //           'devices': FieldValue.arrayUnion([value1.toString()]),
                                                              //         });
                                                              //
                                                              //         batch.update(FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(auth.currentUser!.email), {
                                                              //           'device0': await _getId(),
                                                              //         });
                                                              //
                                                              //         batch.commit().then((value) {
                                                              //           debugPrint('whating? what ');
                                                              //
                                                              //
                                                              //           setStoreId(_result);
                                                              //           List devicesList = value2.data()!['devices'];
                                                              //           int? deviceIdNum;
                                                              //           for(int i = 0; i < devicesList.length; i++) {
                                                              //             if(devicesList[i] == value1.toString()) {
                                                              //               debugPrint('DV LIST ' + devicesList[i].toString());
                                                              //               setState(() {
                                                              //                 deviceIdNum = i;
                                                              //                 debugPrint('DV LIST 2 ' + deviceIdNum.toString());
                                                              //               });
                                                              //             }
                                                              //           }
                                                              //           setDeviceId(deviceIdNum.toString()).then((value) {
                                                              //             // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage()));
                                                              //             _getId().then((val) {
                                                              //               String deviceId = val!;
                                                              //               Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                                                              //             });
                                                              //           });
                                                              //         });
                                                              //
                                                              //         // await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                                                              //         //   'devices': FieldValue.arrayUnion([value1.toString()]),
                                                              //         // }).then((value3) async {
                                                              //         //   debugPrint('got it 1');
                                                              //         //
                                                              //         //   debugPrint('got it 3');
                                                              //         //   await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                                              //         //       .where('email', isEqualTo: auth.currentUser!.email)
                                                              //         //       .get()
                                                              //         //       .then((QuerySnapshot querySnapshot) async {
                                                              //         //     debugPrint('got it 4');
                                                              //         //     debugPrint('shit ' + querySnapshot.docs[0].id.toString());
                                                              //         //     await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                                                              //         //       // 'device0': FieldValue.arrayUnion([await _getId()]),
                                                              //         //       'device0': await _getId(),
                                                              //         //     }).then((value3) async {
                                                              //         //       debugPrint('whating? what ');
                                                              //         //
                                                              //         //
                                                              //         //       setStoreId(_result);
                                                              //         //       List devicesList = value2.data()!['devices'];
                                                              //         //       int? deviceIdNum;
                                                              //         //       for(int i = 0; i < devicesList.length; i++) {
                                                              //         //         if(devicesList[i] == value1.toString()) {
                                                              //         //           debugPrint('DV LIST ' + devicesList[i].toString());
                                                              //         //           setState(() {
                                                              //         //             deviceIdNum = i;
                                                              //         //             debugPrint('DV LIST 2 ' + deviceIdNum.toString());
                                                              //         //           });
                                                              //         //         }
                                                              //         //       }
                                                              //         //       setDeviceId(deviceIdNum.toString()).then((value) {
                                                              //         //         // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage()));
                                                              //         //         _getId().then((val) {
                                                              //         //           String deviceId = val!;
                                                              //         //           Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                                                              //         //         });
                                                              //         //       });
                                                              //         //     });
                                                              //         //   });
                                                              //         // });
                                                              //       });
                                                              //     });
                                                              //   }
                                                              // });



                                                              // FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                                              //     .where('email', isEqualTo: auth.currentUser!.email)
                                                              //     .limit(1)
                                                              //     .get()
                                                              //     .then((QuerySnapshot userSnap) async {
                                                              //
                                                              // });
                                                            }
                                                          });





                                                        }
                                                      }
                                                    }
                                                    );
                                                  }
                                                } on SocketException catch (_) {
                                                  smartKyatFlash(isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', 'w');
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
                          ) :
                          Container(
                            height: 100,
                            child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                child: CupertinoActivityIndicator(radius: 15,)),
                          ),
                        );
                      }
                      return Center(
                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                            child: CupertinoActivityIndicator(radius: 15,)),
                      );
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
                  //                                   debugPrint(_result);
                  //                                 });
                  //                                 // setStoreId(_result);
                  //                                 // widget._chgShopCB3();
                  //
                  //                                 _getId().then((value1) async {
                  //                                   debugPrint('IDD ' + value1.toString());
                  //                                   await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                  //                                     'devices': FieldValue.arrayUnion([value1.toString()]),
                  //                                   }).then((value3) async {
                  //                                     debugPrint('done');
                  //                                     await FirebaseFirestore.instance.collection('shops').doc(_result)
                  //                                     // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
                  //                                         .get().then((value2) async {
                  //                                       List devicesList = value2.data()!['devices'];
                  //                                       int? deviceIdNum;
                  //                                       for(int i = 0; i < devicesList.length; i++) {
                  //                                         if(devicesList[i] == value1.toString()) {
                  //                                           debugPrint('DV LIST ' + devicesList[i].toString());
                  //                                           setState(() {
                  //                                             deviceIdNum = i;
                  //                                             debugPrint('DV LIST 2 ' + deviceIdNum.toString());
                  //                                           });
                  //                                         }
                  //                                       }
                  //
                  //                                       setDeviceId(deviceIdNum.toString()).then((value) {
                  //                                         _getId().then((val) async {
                  //                                           String deviceId = val!;
                  //                                           debugPrint('valuee ' + val.toString());
                  //                                           await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                  //                                               .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  //                                               .get()
                  //                                               .then((QuerySnapshot querySnapshot) async {
                  //                                             debugPrint('shit ' + querySnapshot.docs[0].id.toString());
                  //                                             await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                  //                                               // 'device0': FieldValue.arrayUnion([await _getId()]),
                  //                                               'device0': deviceId,
                  //                                             }).then((value3) async {
                  //                                               debugPrint('done');
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
                  //                           smartKyatFlash(widget.isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', 'w');
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
                                  'Information',  textScaleFactor: 1,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5
                                  ),
                                ),
                                Text(
                                  'Account settings',  textScaleFactor: 1,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
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
                            Text('INFORMATION',  textScaleFactor: 1, style: TextStyle(
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
                              child: CustomFlatButton(
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
                                      'Save and exit',  textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                                    'Information',  textScaleFactor: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                isEnglish? 'Switch shop': 'အခြားဆိုင် ပြောင်းရန်',  textScaleFactor: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
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
                            child: Text('CURRENT SHOP', textScaleFactor: 1, style: TextStyle(
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
                            child: CustomFlatButton(
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
                                    'New shop', textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
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
                                        "New Expense", textScaleFactor: 1,
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
                                          debugPrint('clicked');
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
      return androidDeviceInfo.id; // unique ID on Android
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

  List<Package> offPackages = [];
  bool disableTouch = false;

  premiumCart(String shopId, String shopName) {
    final List<String> prodFieldsValue = [];
    // myController.clear();
    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter purcState) {
                Future<void> fetchingOffering(StateSetter purcState) async {
                  final offerings = await PurchaseApi.fetchOffers();

                  if (offerings.isEmpty) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('No plan found.')));
                  } else {
                    final packages = offerings.map((offer) => offer.availablePackages)
                        .expand((pair) => pair)
                        .toList();
                    offPackages = packages;
                    debugPrint('offpack ' + packages.toString());
                  }
                }

                fetchingOffering(purcState);

                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.0),
                                topRight: Radius.circular(18.0),
                              ),
                              color: Colors.white,
                            ),
                            height:
                            MediaQuery.of(context).size.height -
                                45,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height -
                                      45,
                                  // color: Colors.yellow,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.withOpacity(0.2),
                                              width: 1.0),
                                        ),
                                        height: (MediaQuery.of(context).size.height -
                                            60)/ 2,
                                      ),
                                      Container(
                                        color: Color(0xFFF2F1F6),
                                        height: (MediaQuery.of(context).size.height -
                                            60)/ 2,
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                stream: FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots(),
                                                builder: (context, snapshot) {
                                                  if(snapshot.hasData) {
                                                    var output = snapshot.data != null? snapshot.data!.data(): null;
                                                    var isPro = output?['is_pro'];
                                                    Timestamp isProStart = isPro['start'];
                                                    Timestamp isProEnd = isPro['end'];

                                                    DateTime start = isProStart.toDate();
                                                    DateTime end = isProEnd.toDate();
                                                    return Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 55),
                                                                  Center(
                                                                    child: Text(
                                                                      isEnglish? 'End of pro version': 'သက်တမ်းကုန်နေသည်', textScaleFactor: 1, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 26,
                                                                        letterSpacing: -0.4
                                                                    ),
                                                                      strutStyle: StrutStyle(
                                                                        height: 2.2,
                                                                        // fontSize:,
                                                                        forceStrutHeight: true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 20.0),
                                                                    child: Text( isEnglish ? 'Your plan purchased for ' + shopName + '(updated at ' + start.day.toString() + ' ' + convertToDate(zeroToTen(start.month.toString())) + ' ' + start.year.toString() + ') ended at ' + end.day.toString() + ' ' + convertToDate(zeroToTen(end.month.toString())) + ' ' + end.year.toString() + '.':
                                                                    // "Your plan purchased for " + ​shopName +​ "(updated at " + start.day.toString() + ' ' + convertToDate(zeroToTen(start.month.toString())) + ' ' + start.year.toString() + ') will end at '  + end.day.toString() + ' ' + convertToDate(zeroToTen(end.month.toString())) + ' ' + end.year.toString() +  '.' :
                                                                    "\'" + shopName + "\'" + " အတွက် (" + start.day.toString() + ' ' + convertToDate(zeroToTen(start.month.toString())) + ' ' + start.year.toString() + ') မှ ဝယ်ယူထားသော အစီအစဉ်သည် ('   + end.day.toString() + ' ' + convertToDate(zeroToTen(end.month.toString())) + ' ' + end.year.toString() +  ') တည်းက ကုန်ဆုံးနေပြီ ဖြစ်ပါသည်။',
                                                                      textScaleFactor: 1, style: TextStyle( fontSize: 14),
                                                                      strutStyle: StrutStyle(
                                                                        height: 1.2,
                                                                        // fontSize:,
                                                                        forceStrutHeight: true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          // Padding(
                                                          //   padding: const EdgeInsets.only(left: 15, right: 15, top: 20.0),
                                                          //   child: Container(
                                                          //       decoration: BoxDecoration(
                                                          //         borderRadius: BorderRadius.all(
                                                          //           Radius.circular(15.0),
                                                          //         ),
                                                          //         color: Color(0xFFF5F5F5),
                                                          //         border: Border.all(
                                                          //             color: Colors.grey.withOpacity(0.2),
                                                          //             width: 1.0),
                                                          //       ),
                                                          //       width: MediaQuery.of(context).size.width,
                                                          //       child: Padding(
                                                          //         padding: const EdgeInsets.only(left: 20.0),
                                                          //         child: Column(
                                                          //           crossAxisAlignment: CrossAxisAlignment.start,
                                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                                          //           children: [
                                                          //             SizedBox(height: 18),
                                                          //             Text('1 month pro version', textScaleFactor: 1, style: TextStyle(
                                                          //                 fontWeight: FontWeight.w500,
                                                          //                 fontSize: 18,
                                                          //                 letterSpacing: -0.3
                                                          //             ),
                                                          //               strutStyle: StrutStyle(
                                                          //                 height: 1.5,
                                                          //                 // fontSize:,
                                                          //                 forceStrutHeight: true,
                                                          //               ),
                                                          //             ),
                                                          //             SizedBox(height: 5),
                                                          //             Text('15,000 Kyats /month',textScaleFactor: 1, style: TextStyle(
                                                          //                 fontWeight: FontWeight.w500,
                                                          //                 fontSize: 14,
                                                          //                 letterSpacing: -0.3
                                                          //             ),
                                                          //               strutStyle: StrutStyle(
                                                          //                 height: 1.2,
                                                          //                 // fontSize:,
                                                          //                 forceStrutHeight: true,
                                                          //               ),
                                                          //             ),
                                                          //             SizedBox(height: 22),
                                                          //           ],
                                                          //         ),
                                                          //       )
                                                          //   ),
                                                          // ),
                                                          // Padding(
                                                          //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
                                                          //   child: Container(
                                                          //       decoration: BoxDecoration(
                                                          //           borderRadius: BorderRadius.all(
                                                          //             Radius.circular(15.0),
                                                          //           ),
                                                          //           gradient: LinearGradient(
                                                          //               colors: [Color(0xFFFFE18A), Color(0xFFC2FC1D)],
                                                          //               begin: Alignment(-1.0, -2.0),
                                                          //               end: Alignment(1.0, 2.0),
                                                          //               tileMode: TileMode.clamp)),
                                                          //       width: MediaQuery.of(context).size.width,
                                                          //       child: Padding(
                                                          //         padding: const EdgeInsets.only(left: 20.0),
                                                          //         child: Column(
                                                          //           crossAxisAlignment: CrossAxisAlignment.start,
                                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                                          //           children: [
                                                          //             SizedBox(height: 18),
                                                          //             Text('3 month pro version (save 20%)', textScaleFactor: 1, style: TextStyle(
                                                          //                 fontWeight: FontWeight.w500,
                                                          //                 fontSize: 18,
                                                          //                 letterSpacing: -0.3
                                                          //             ),
                                                          //               strutStyle: StrutStyle(
                                                          //                 height: 1.5,
                                                          //                 // fontSize:,
                                                          //                 forceStrutHeight: true,
                                                          //               ),
                                                          //             ),
                                                          //             SizedBox(height: 5),
                                                          //             Text('12,000 Kyats /month',textScaleFactor: 1, style: TextStyle(
                                                          //                 fontWeight: FontWeight.w500,
                                                          //                 fontSize: 14,
                                                          //                 letterSpacing: -0.3
                                                          //             ),
                                                          //               strutStyle: StrutStyle(
                                                          //                 height: 1.2,
                                                          //                 // fontSize:,
                                                          //                 forceStrutHeight: true,
                                                          //               ),
                                                          //             ),
                                                          //             SizedBox(height: 22),
                                                          //           ],
                                                          //         ),
                                                          //       )),
                                                          // ),
                                                          // Padding(
                                                          //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
                                                          //   child: Container(
                                                          //       decoration: BoxDecoration(
                                                          //           borderRadius: BorderRadius.all(
                                                          //             Radius.circular(15.0),
                                                          //           ),
                                                          //           gradient: LinearGradient(
                                                          //               colors: [Color(0xFFDBFF76), Color(0xFF9FFFD1)],
                                                          //               begin: Alignment(-1.0, -2.0),
                                                          //               end: Alignment(1.0, 2.0),
                                                          //               tileMode: TileMode.clamp)),
                                                          //       width: MediaQuery.of(context).size.width,
                                                          //       child: Padding(
                                                          //         padding: const EdgeInsets.only(left: 20.0),
                                                          //         child: Column(
                                                          //           crossAxisAlignment: CrossAxisAlignment.start,
                                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                                          //           children: [
                                                          //             SizedBox(height: 18),
                                                          //             Text('5 month pro version (save 30%)', textScaleFactor: 1, style: TextStyle(
                                                          //                 fontWeight: FontWeight.w500,
                                                          //                 fontSize: 18,
                                                          //                 letterSpacing: -0.3
                                                          //             ),
                                                          //               strutStyle: StrutStyle(
                                                          //                 height: 1.5,
                                                          //                 // fontSize:,
                                                          //                 forceStrutHeight: true,
                                                          //               ),
                                                          //             ),
                                                          //             SizedBox(height: 5),
                                                          //             Text('10,500 Kyats /month',textScaleFactor: 1, style: TextStyle(
                                                          //                 fontWeight: FontWeight.w500,
                                                          //                 fontSize: 14,
                                                          //                 letterSpacing: -0.3
                                                          //             ),
                                                          //               strutStyle: StrutStyle(
                                                          //                 height: 1.2,
                                                          //                 // fontSize:,
                                                          //                 forceStrutHeight: true,
                                                          //               ),
                                                          //             ),
                                                          //             SizedBox(height: 22),
                                                          //           ],
                                                          //         ),
                                                          //       )),
                                                          // ),
                                                          SizedBox(height: 10),
                                                          offPackages.length!=0?PaywallWidget(
                                                            isEnglish: isEnglish,
                                                            packages: offPackages,
                                                            title: 'Upgrade your plan',
                                                            description: 'Upgrade to new plan to enjoy',
                                                            onClickedPackage: (package) async {
                                                              debugPrint('running? ');
                                                              setState(() {
                                                                disableTouch = true;
                                                              });
                                                              purcState(() {
                                                                disableTouch = true;
                                                                setState(() {
                                                                  disableTouch = true;
                                                                });
                                                              });
                                                              final success = await PurchaseApi.purchasePackage(package);
                                                              Navigator.pop(context);

                                                              if(success) {

                                                                if(package.storeProduct.identifier.toString() == 'sk_0999_1m_1w') {
                                                                  if(DateTime.now().compareTo(end) > 0) {
                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .update({
                                                                      'is_pro' :  {'start': start, 'end': DateTime.now().add(const Duration(days: 30))},

                                                                    }).then((value) {

                                                                      smartKyatFlash( isEnglish ? 'Congratulations! Your one month plan purchase has been successful' : 'ဂုဏ်ယူပါတယ်။ သင်၏ တစ်လအစီအစဉ် ဝယ်ယူမှု အောင်မြင်သွားပါပြီ။', 's');
                                                                    }).catchError((error) => debugPrint("Failed to update Plan: $error"));

                                                                    debugPrint('date kyaw nay p');
                                                                  } else
                                                                  {
                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .update({
                                                                      'is_pro' :  {'start': start, 'end': end.add(const Duration(days: 30))},

                                                                    })
                                                                        .then((value) {

                                                                      smartKyatFlash( isEnglish ? 'Congratulations! Your one month plan purchase has been successful' : 'ဂုဏ်ယူပါတယ်။ သင်၏ တစ်လအစီအစဉ် ဝယ်ယူမှု အောင်မြင်သွားပါပြီ။', 's');
                                                                    })
                                                                        .catchError((error) => debugPrint("Failed to update Plan: $error"));
                                                                    debugPrint('date kyaw thae bu');
                                                                  }
                                                                  debugPrint('1 month added');
                                                                }
                                                                else if(package.storeProduct.identifier.toString() == 'sk_0999_3m_1w') {
                                                                  if(DateTime.now().compareTo(end) > 0) {
                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .update({
                                                                      'is_pro' :  {'start': start, 'end': DateTime.now().add(const Duration(days: 90))},

                                                                    })
                                                                        .then((value) {

                                                                      smartKyatFlash( isEnglish ? 'Congratulations! Your three month plan purchase has been successful' : 'ဂုဏ်ယူပါတယ်။ သင်၏ သုံးလအစီအစဉ် ဝယ်ယူမှု အောင်မြင်သွားပါပြီ။', 's');

                                                                    })
                                                                        .catchError((error) => debugPrint("Failed to update Plan: $error"));

                                                                    debugPrint('date kyaw nay p');
                                                                  } else
                                                                  {
                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .update({
                                                                      'is_pro' :  {'start': start, 'end': end.add(const Duration(days: 90))},

                                                                    })
                                                                        .then((value) {

                                                                      smartKyatFlash( isEnglish ? 'Congratulations! Your three month plan purchase has been successful' : 'ဂုဏ်ယူပါတယ်။ သင်၏ သုံးလအစီအစဉ် ဝယ်ယူမှု အောင်မြင်သွားပါပြီ။', 's');
                                                                    })
                                                                        .catchError((error) => debugPrint("Failed to update Plan: $error"));
                                                                    debugPrint('date kyaw thae bu');
                                                                  }
                                                                  debugPrint('3 month added');
                                                                }
                                                                else {
                                                                  if(DateTime.now().compareTo(end) > 0) {
                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .update({
                                                                      'is_pro' :  {'start': start, 'end': DateTime.now().add(const Duration(days: 150))},

                                                                    })
                                                                        .then((value) {

                                                                      smartKyatFlash( isEnglish ? 'Congratulations! Your five month plan purchase has been successful' : 'ဂုဏ်ယူပါတယ်။ သင်၏ ငါးလအစီအစဉ် ဝယ်ယူမှု အောင်မြင်သွားပါပြီ။', 's');
                                                                    })
                                                                        .catchError((error) => debugPrint("Failed to update Plan: $error"));

                                                                    debugPrint('date kyaw nay p');
                                                                  } else
                                                                  {
                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .update({
                                                                      'is_pro' :  {'start': start, 'end': end.add(const Duration(days: 150))},

                                                                    })
                                                                        .then((value) {

                                                                      smartKyatFlash( isEnglish ? 'Congratulations! Your five month plan purchase has been successful' : 'ဂုဏ်ယူပါတယ်။ သင်၏ ငါးလအစီအစဉ် ဝယ်ယူမှု အောင်မြင်သွားပါပြီ။', 's');

                                                                    })
                                                                        .catchError((error) => debugPrint("Failed to update Plan: $error"));
                                                                    debugPrint('date kyaw thae bu');
                                                                  }
                                                                  debugPrint('5 month added');
                                                                }

                                                              } else {
                                                                smartKyatFlash( isEnglish ? 'Try again! Unknown error occurred.' : 'ထပ်ကြိုးစားပါ! အမည်မသိ အမှားအယွင်း ဖြစ်ပေါ်ခဲ့သည်။', 'w');

                                                              }
                                                              purcState(() {
                                                                disableTouch = false;
                                                                setState(() {
                                                                  disableTouch = false;
                                                                });
                                                              });

                                                              setState(() {
                                                                disableTouch = false;
                                                              });
                                                            },
                                                          ):
                                                          Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(15.0),
                                                                        ),
                                                                        color: Color(0xFFF5F5F5),
                                                                        border: Border.all(
                                                                            color: Colors.grey.withOpacity(0.2),
                                                                            width: 1.0),
                                                                      ),
                                                                      child: ListTile(
                                                                        leading: Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left:3.0, top: 0.0),
                                                                              child: Icon(
                                                                                // Icons.home_filled,
                                                                                Icons.verified_rounded,
                                                                                size: 32,
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 11.0, top: 8),
                                                                              child: Container(
                                                                                  color: Colors.blue,
                                                                                  width: 15,
                                                                                  height: 15
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 13.0, top: 4.5),
                                                                              child: Text(
                                                                                '1',
                                                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                                                style: GoogleFonts.lato(
                                                                                    textStyle: TextStyle(
                                                                                        letterSpacing: 1,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.white
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        title: Padding(
                                                                          padding: const EdgeInsets.only(top: 10.0),
                                                                          child: Text('1 month pro version', textScaleFactor: 1, style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 18,
                                                                              letterSpacing: -0.3
                                                                          ),
                                                                            strutStyle: StrutStyle(
                                                                              height: 1.8,
                                                                              // fontSize:,
                                                                              forceStrutHeight: true,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        subtitle: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(height: 6),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                  border: Border(
                                                                                      bottom: BorderSide(
                                                                                          color: Colors.grey
                                                                                              .withOpacity(0.3),
                                                                                          width: 1.0))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                                                child: Text(
                                                                                  isEnglish?
                                                                                  'MMK 10,000.0 /month - Access to all features for 1 month with this package for the selected shop.':
                                                                                  'တစ်လလျှင် MMK 10,000.0 နှုန်းဖြင့်တစ်လစာ - ယခု ဝင်ရောက်ထားသော ဆိုင်အတွက် (၁) လစာ အသုံးပြုခွင့်ရရှိမှာဖြစ်ပါသည်။',
                                                                                  textScaleFactor: 1, style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 15, color: Colors.black.withOpacity(0.6),
                                                                                ),
                                                                                  strutStyle: StrutStyle(
                                                                                    height: 1.35,
                                                                                    // fontSize:,
                                                                                    forceStrutHeight: true,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            // CustomFlatButton(
                                                                            //
                                                                            // child: new Text("Call now", style: TextStyle(
                                                                            //   fontWeight: FontWeight.w500,
                                                                            //   fontSize: 17, color: Colors.blue,
                                                                            // ),
                                                                            //   strutStyle: StrutStyle(
                                                                            //     height: 1.3,
                                                                            //     // fontSize:,
                                                                            //     forceStrutHeight: true,
                                                                            //   ),)),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                // widget.onClickedPackage(package);
                                                                              },
                                                                              child: Text(isEnglish? 'Buy now ': 'ဝယ်မည်', textScaleFactor: 1, style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 17, color: Colors.blue.withOpacity(0.3),
                                                                              ),
                                                                                strutStyle: StrutStyle(
                                                                                  height: 1.3,
                                                                                  // fontSize:,
                                                                                  forceStrutHeight: true,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                          ],
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(15.0),
                                                                          ),
                                                                          gradient: LinearGradient(
                                                                              colors: [Color(0xFFFFE18A), Color(0xFFC2FC1D)],
                                                                              begin: Alignment(-1.0, -2.0),
                                                                              end: Alignment(1.0, 2.0),
                                                                              tileMode: TileMode.clamp)),
                                                                      child: ListTile(
                                                                        leading: Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left:3.0, top: 0.0),
                                                                              child: Icon(
                                                                                // Icons.home_filled,
                                                                                Icons.verified_rounded,
                                                                                size: 32,
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 11.0, top: 8),
                                                                              child: Container(
                                                                                  color: Colors.blue,
                                                                                  width: 15,
                                                                                  height: 15
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 13.0, top: Platform.isAndroid? 5:4.5),
                                                                              child: Text(
                                                                                '3',
                                                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                                                style: GoogleFonts.lato(
                                                                                    textStyle: TextStyle(
                                                                                        letterSpacing: 1,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.white
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        title: Padding(
                                                                          padding: const EdgeInsets.only(top: 10.0),
                                                                          child: Text('3 months pro version', textScaleFactor: 1, style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 18,
                                                                              letterSpacing: -0.3
                                                                          ),
                                                                            strutStyle: StrutStyle(
                                                                              height: 1.6,
                                                                              // fontSize:,
                                                                              forceStrutHeight: true,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        subtitle: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(height: 6),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                  border: Border(
                                                                                      bottom: BorderSide(
                                                                                          color: Colors.grey
                                                                                              .withOpacity(0.3),
                                                                                          width: 1.0))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                                                child: Text(
                                                                                  isEnglish?
                                                                                  'MMK 9,000.0 /month - Access to all features for 3 months with this package for the selected shop.':
                                                                                  'တစ်လလျှင် MMK 9,000.0 နှုန်းဖြင့်သုံးလစာ - ယခု ဝင်ရောက်ထားသော ဆိုင်အတွက် (၃) လစာ အသုံးပြုခွင့်ရရှိမှာဖြစ်ပါသည်။'
                                                                                  , textScaleFactor: 1, style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 15, color: Colors.black.withOpacity(0.6),
                                                                                ),
                                                                                  strutStyle: StrutStyle(
                                                                                    height: 1.35,
                                                                                    // fontSize:,
                                                                                    forceStrutHeight: true,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            // CustomFlatButton(
                                                                            //
                                                                            // child: new Text("Call now", style: TextStyle(
                                                                            //   fontWeight: FontWeight.w500,
                                                                            //   fontSize: 17, color: Colors.blue,
                                                                            // ),
                                                                            //   strutStyle: StrutStyle(
                                                                            //     height: 1.3,
                                                                            //     // fontSize:,
                                                                            //     forceStrutHeight: true,
                                                                            //   ),)),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                // widget.onClickedPackage(package);
                                                                              },
                                                                              child: Text(isEnglish? 'Buy now (save 10%)': 'ဝယ်မည် (10% သက်သာ)', textScaleFactor: 1, style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 17, color: Colors.blue.withOpacity(0.3),
                                                                              ),
                                                                                strutStyle: StrutStyle(
                                                                                  height: 1.3,
                                                                                  // fontSize:,
                                                                                  forceStrutHeight: true,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                          ],
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(15.0),
                                                                          ),
                                                                          gradient: LinearGradient(
                                                                              colors: [Color(0xFFDBFF76), Color(0xFF9FFFD1)],
                                                                              begin: Alignment(-1.0, -2.0),
                                                                              end: Alignment(1.0, 2.0),
                                                                              tileMode: TileMode.clamp)),
                                                                      child: ListTile(
                                                                        leading: Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left:3.0, top: 0.0),
                                                                              child: Icon(
                                                                                // Icons.home_filled,
                                                                                Icons.verified_rounded,
                                                                                size: 32,
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 11.0, top: 8),
                                                                              child: Container(
                                                                                  color: Colors.blue,
                                                                                  width: 15,
                                                                                  height: 15
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 13.0, top: Platform.isAndroid? 5.5:4.5),
                                                                              child: Text(
                                                                                '5',
                                                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                                                style: GoogleFonts.lato(
                                                                                    textStyle: TextStyle(
                                                                                        letterSpacing: 1,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.white
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        title: Padding(
                                                                          padding: const EdgeInsets.only(top: 10.0),
                                                                          child: Text('5 months pro version', textScaleFactor: 1, style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 18,
                                                                              letterSpacing: -0.3
                                                                          ),
                                                                            strutStyle: StrutStyle(
                                                                              height: 1.6,
                                                                              // fontSize:,
                                                                              forceStrutHeight: true,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        subtitle: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(height: 6),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                  border: Border(
                                                                                      bottom: BorderSide(
                                                                                          color: Colors.grey
                                                                                              .withOpacity(0.3),
                                                                                          width: 1.0))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                                                child: Text(
                                                                                  isEnglish?
                                                                                  'MMK 8,000.0 /month - Access to all features for 5 months with this package for the selected shop.':
                                                                                  'တစ်လလျှင် MMK 8,000.0 နှုန်းဖြင့်ငါးလစာ - ယခု ဝင်ရောက်ထားသော ဆိုင်အတွက် (၅) လစာ အသုံးပြုခွင့်ရရှိမှာဖြစ်ပါသည်။'
                                                                                  , textScaleFactor: 1, style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 15, color: Colors.black.withOpacity(0.6),
                                                                                ),
                                                                                  strutStyle: StrutStyle(
                                                                                    height: 1.35,
                                                                                    // fontSize:,
                                                                                    forceStrutHeight: true,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            // CustomFlatButton(
                                                                            //
                                                                            // child: new Text("Call now", style: TextStyle(
                                                                            //   fontWeight: FontWeight.w500,
                                                                            //   fontSize: 17, color: Colors.blue,
                                                                            // ),
                                                                            //   strutStyle: StrutStyle(
                                                                            //     height: 1.3,
                                                                            //     // fontSize:,
                                                                            //     forceStrutHeight: true,
                                                                            //   ),)),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                // widget.onClickedPackage(package);
                                                                              },
                                                                              child: Text(isEnglish? 'Buy now (save 20%)': 'ဝယ်မည် (20% သက်သာ)', textScaleFactor: 1, style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 17, color: Colors.blue.withOpacity(0.3),
                                                                              ),
                                                                                strutStyle: StrutStyle(
                                                                                  height: 1.3,
                                                                                  // fontSize:,
                                                                                  forceStrutHeight: true,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                          ],
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                          )
                                                          ,
                                                          SizedBox(height: 15),
                                                        ]
                                                    );
                                                  }
                                                  return Container();
                                                }
                                            ),
                                          ),
                                          Container(
                                            color: Color(0xFFF2F1F6),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.grey.withOpacity(0.2),
                                                          width: 1.0),
                                                    ),
                                                    child: ListTile(
                                                      leading: Padding(
                                                        padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                                        child: Image(image: AssetImage('assets/system/call_now.png'), width: 28,),
                                                      ),
                                                      title: Padding(
                                                        padding: const EdgeInsets.only(top: 10.0),
                                                        child: Text(isEnglish? 'Contact us via phone': 'ဖုန်းဖြင့်ဆက်သွယ်ရန်', textScaleFactor: 1, style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18,
                                                            letterSpacing: -0.3
                                                        ),
                                                          strutStyle: StrutStyle(
                                                            height: 1.5,
                                                            // fontSize:,
                                                            forceStrutHeight: true,
                                                          ),
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 6),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    bottom: BorderSide(
                                                                        color: Colors.grey
                                                                            .withOpacity(0.3),
                                                                        width: 1.0))),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 10.0),
                                                              child: Text(isEnglish? 'You can contact us now to purchase above plans. (09794335708)': 'အပေါ်မှ plan များအားဝယ်ယူရန် ဖုန်းဖြင့်ဆက်သွယ် မေးမြန်းနိုင်ပါသည်။ (09794335708)', textScaleFactor: 1, style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 15, color: Colors.black.withOpacity(0.6),
                                                              ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1.35,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          // CustomFlatButton(
                                                          //
                                                          // child: new Text("Call now", style: TextStyle(
                                                          //   fontWeight: FontWeight.w500,
                                                          //   fontSize: 17, color: Colors.blue,
                                                          // ),
                                                          //   strutStyle: StrutStyle(
                                                          //     height: 1.3,
                                                          //     // fontSize:,
                                                          //     forceStrutHeight: true,
                                                          //   ),)),
                                                          GestureDetector(
                                                            onTap: () => launch("tel://+959794335708"),
                                                            child: Text(isEnglish? 'Call now': 'ခေါ်ဆိုမည်', textScaleFactor: 1, style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 17, color: Colors.blue,
                                                            ),
                                                              strutStyle: StrutStyle(
                                                                height: 1.3,
                                                                // fontSize:,
                                                                forceStrutHeight: true,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                        ],
                                                      ),

                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.grey.withOpacity(0.2),
                                                          width: 1.0),
                                                    ),
                                                    child: ListTile(
                                                      leading: Padding(
                                                        padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                                        child: Image(image: AssetImage('assets/system/messenger.png'), width: 28,),
                                                      ),
                                                      title: Padding(
                                                        padding: const EdgeInsets.only(top: 10.0),
                                                        child: Text(isEnglish? 'Via messenger': 'Messenger မှဆက်သွယ်ရန်', textScaleFactor: 1, style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18,
                                                            letterSpacing: -0.3
                                                        ),
                                                          strutStyle: StrutStyle(
                                                            height: 1.5,
                                                            // fontSize:,
                                                            forceStrutHeight: true,
                                                          ),
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 6),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    bottom: BorderSide(
                                                                        color: Colors.grey
                                                                            .withOpacity(0.3),
                                                                        width: 1.0))),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 10.0),
                                                              child: Text(isEnglish? 'You can contact us now to purchase above plans (delay response).':
                                                              'အပေါ်မှ plan များအားဝယ်ယူရန် Facebook/ Messenger မှလည်းဆက်သွယ် မေးမြန်းနိုင်ပါသည်။ (reply အနည်းငယ် ကြာနိုင်ပါသည်).',
                                                                textScaleFactor: 1, style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 15, color: Colors.black.withOpacity(0.6),
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1.35,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          GestureDetector(
                                                            onTap: () => launch("http://m.me/smartkyat.pos"),
                                                            child: Text('Messenger', textScaleFactor: 1, style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 17, color: Colors.blue,
                                                            ),
                                                              strutStyle: StrutStyle(
                                                                height: 1.3,
                                                                // fontSize:,
                                                                forceStrutHeight: true,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                        ],
                                                      ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0, right: 15.0, bottom: 15.0, left: 15.0),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25.0),
                                              ),
                                              color: AppTheme.buttonColor2),
                                          child: Icon(
                                            // Icons.home_filled,
                                            Icons.close_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                disableTouch? Expanded(
                                    child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                color: Colors.white),
                                            width: 250,
                                            height: 160,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                    child: CupertinoActivityIndicator(radius: 15,)),
                                                SizedBox(height: 20),
                                                Text(isEnglish? 'Processing request...': 'လုပ်ဆောင်နေပါသည်...', textScaleFactor: 1, style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15, color: Colors.grey,
                                                ),
                                                  strutStyle: StrutStyle(
                                                    height: 1.3,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    )
                                ): Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 42,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
          );
          // return SingleAssetPage(toggleCoinCallback: closeNewProduct);
        });
  }

  convertToDate(String input) {
    switch (input) {
      case '01':
        return 'January';
        break;
      case '02':
        return 'February';
        break;
      case '03':
        return 'March';
        break;
      case '04':
        return 'April';
        break;
      case '05':
        return 'May';
        break;
      case '06':
        return 'June';
        break;
      case '07':
        return 'July';
        break;
      case '08':
        return 'August';
        break;
      case '09':
        return 'September';
        break;
      case '10':
        return 'October';
        break;
      case '11':
        return 'November';
        break;
      case '12':
        return 'December';
        break;
    }
  }

  zeroToTen(String string) {
    if (double.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
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


