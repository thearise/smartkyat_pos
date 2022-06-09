import 'dart:io';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_below/dropdown_below.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/add_staff_sub.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../../app_theme.dart';
import '../app_theme.dart';
import 'package:bottom_picker/bottom_picker.dart';

class StaffSettingsSub extends StatefulWidget {

  const StaffSettingsSub(
      {Key? key, required this.ownerId,});
  final String ownerId;

  @override
  _StaffSettingsSubState createState() => _StaffSettingsSubState();
}

class _StaffSettingsSubState extends State<StaffSettingsSub>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<StaffSettingsSub>{
  var _searchUserMail;

  var _chosenValue;

  final permissionList = [
    Text("Cashier", style: TextStyle(fontSize: 16, height: 1.7),),
    Text("Admin", style: TextStyle(fontSize: 16, height: 1.7),),
  ];

  bool isLoading = true;

  var shopSnapshot;


  @override
  bool get wantKeepAlive => true;

  var _result;
  var _shop ;
  bool firstTime = true;
  var ownerEmail = '';

  String textSetInfo = 'Information';
  String textSetStaff = 'Staff setting';
  String textSetList = 'Staff list';
  String textSetAdd = 'Add new staff';

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  @override
  initState() {

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetInfo = 'Information';
          textSetStaff = 'Staff setting';
          textSetList = 'STAFF LIST';
          textSetAdd = 'ဝန်ထမ်း ထည့်ရန်';
        });
      } else if(value=='english') {
        setState(() {
           textSetInfo = 'Information';
           textSetStaff = 'Staff setting';
           textSetList = 'STAFF LIST';
           textSetAdd = 'Add new staff';
        });
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          isLoading = false;
        });
      });
    });

    var getEmail = '';
    getStoreId().then((value) {
      // setState(() {
        _result = value.toString();
        shopSnapshot =  FirebaseFirestore.instance.collection('shops').doc(_result).snapshots();
      // });

    });

    FirebaseFirestore.instance
        .collection('users')
         .where('user_id', isEqualTo: widget.ownerId.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        getEmail = doc['email'];
      });
      setState(() {
        ownerEmail = getEmail.toString();
      });
    });
    super.initState();
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

  getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('store');
  }

  @override
  void dispose() {
    super.dispose();
  }
  // addShop(shopName) {
  //   CollectionReference spaces = FirebaseFirestore.instance.collection('space');
  //   var exist = false;
  //   var docId = '';
  //   var shopExist = false;
  //   FirebaseFirestore.instance
  //       .collection('space')
  //       .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       docId = doc.id;
  //       exist = true;
  //     });
  //
  //     if(exist) {
  //       debugPrint('space shi p thar');
  //
  //       FirebaseFirestore.instance
  //           .collection('space').doc(docId).collection('shops')
  //           .where('shop_name', isEqualTo: shopName)
  //           .get()
  //           .then((QuerySnapshot querySnapshot) {
  //         querySnapshot.docs.forEach((doc) {
  //           shopExist = true;
  //         });
  //
  //         if(shopExist) {
  //           debugPrint('shop already');
  //
  //         } else {
  //           CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(docId).collection('shops');
  //           return shops
  //               .add({
  //             'shop_name': shopName
  //           })
  //               .then((value) {
  //             debugPrint('shop added');
  //           });
  //         }
  //       });
  //
  //
  //     } else {
  //       debugPrint('space mshi vuu');
  //       return spaces
  //           .add({
  //         'user_id': FirebaseAuth.instance.currentUser!.uid
  //       })
  //           .then((value) {
  //         CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(value.id).collection('shops');
  //
  //         return shops
  //             .add({
  //           'shop_name': shopName
  //         })
  //             .then((value) {
  //           debugPrint('shop added');
  //         });
  //
  //       }).catchError((error) => debugPrint("Failed to add shop: $error"));
  //     }
  //   });
  // }
  final auth = FirebaseAuth.instance;

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
                                  // getEmail(ownerId);
                                  // debugPrint('getEmail' + getEmail(ownerId).toString());
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
                                textSetInfo,
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
                               textSetStaff,
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
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: shopSnapshot,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        var output = snapshot.data != null? snapshot.data!.data(): null;
                        int staffCount = output?['users'].length;
                        debugPrint('staff ' + staffCount.toString() + output?['plan_type']);
                        var usersList = output?['users'];
                        return ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                              child: Text(textSetList, style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,color: Colors.grey,
                              )),
                            ),
                            addStaffBtn(output?['plan_type'], staffCount),

                            SizedBox(height: 10,),
                            !isLoading?
                            Container(
                              child: Column(
                                children: [
                                  for (int i = 0;
                                  i < usersList.length;
                                  i++)
                                  // if((FirebaseAuth.instance.currentUser == null? '':FirebaseAuth.instance.currentUser!.email) != usersList[i].toString())
                                  //   if( ownerEmail != usersList[i].toString())
                                    if( ownerEmail != usersList[i].toString())
                                      Padding(
                                        padding: EdgeInsets.only(left: i == usersList.length-1? 0.0:15.0),
                                        child: Container(
                                          height: 65,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: i == usersList.length-1? Colors.transparent: AppTheme.skBorderColor2,
                                                    width: 1.0),
                                              )
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 4.0),
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('users')
                                                    .where('email', isEqualTo: usersList[i].toString())
                                                //.where('email', isNotEqualTo: ownerEmail.toString())
                                                    .limit(1)
                                                    .snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                                  debugPrint('check1 ' + usersList[i].toString());
                                                  if(snapshot2.hasData) {

                                                    debugPrint('getOwnerrr' + ownerEmail.toString());
                                                    debugPrint('hasData' + snapshot2.data!.docs.length.toString());
                                                    if(snapshot2.data!.docs.length == 0) {

                                                      // debugPrint('ownerrr' + ownerId.toString());

                                                      // return StreamBuilder(
                                                      // stream: FirebaseFirestore.instance
                                                      //     .collection('shops').doc(_result).collection('users')
                                                      //     .where('email', isEqualTo: usersList[i].toString())
                                                      //     .limit(1)
                                                      //     .snapshots(),
                                                      // builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                                                      //     if(snapshot3.hasData) {
                                                      //       return Container(
                                                      //         height: 50,
                                                      //         child: Column(
                                                      //             mainAxisAlignment: MainAxisAlignment.center,
                                                      //             crossAxisAlignment: CrossAxisAlignment.center,
                                                      //             children: [
                                                      //               Container(
                                                      //                 height: 45,
                                                      //                 child: Row(
                                                      //                   mainAxisAlignment: MainAxisAlignment.center,
                                                      //                   crossAxisAlignment: CrossAxisAlignment.center,
                                                      //                   children: [
                                                      //                     SizedBox(
                                                      //                       width: i == usersList.length-1? 15: 0,
                                                      //                     ),
                                                      //                     Column(
                                                      //                       children: [
                                                      //                         Text('Unknown user', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.blue),),
                                                      //                         Expanded(child: Text(usersList[i].toString(), textAlign: TextAlign.end, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.black54),)),
                                                      //                       ],
                                                      //                     ),
                                                      //                     SizedBox(
                                                      //                       width: 15,
                                                      //                     ),
                                                      //                     Container(
                                                      //                       color: Colors.grey,
                                                      //                       height: 45,
                                                      //                       child: Padding(
                                                      //                         padding: const EdgeInsets.only(top: 2.0),
                                                      //                         child: IconButton(
                                                      //                             icon: Icon(
                                                      //                               Icons.remove_circle_rounded,
                                                      //                               size: 18,
                                                      //                               color: Colors.red,
                                                      //                             ),
                                                      //                             onPressed: () {
                                                      //                               showOkCancelAlertDialog(
                                                      //                                 context: context,
                                                      //                                 title: 'Confirmation alert',
                                                      //                                 message: 'Are you sure you want to remove unknown user (' + usersList[i].toString() + ') from current shop?',
                                                      //                                 defaultType: OkCancelAlertDefaultType.cancel,
                                                      //                               ).then((result) async {
                                                      //                                 if(result == OkCancelResult.ok) {
                                                      //                                   await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                                      //                                       {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                                      //                                   ).then((value) async {
                                                      //                                     debugPrint('users removed');
                                                      //                                   });
                                                      //                                 }
                                                      //                               }
                                                      //                               );
                                                      //                             }
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                   ],
                                                      //                 ),
                                                      //               )
                                                      //             ]
                                                      //         ),
                                                      //       );
                                                      //     }
                                                      //     return Container();
                                                      //   }
                                                      // );

                                                      return StreamBuilder(
                                                          stream: FirebaseFirestore.instance
                                                              .collection('shops').doc(_result).collection('users')
                                                              .where('email', isEqualTo: usersList[i].toString())
                                                              .limit(1)
                                                              .snapshots(),
                                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                                                            if(snapshot3.hasData) {
                                                              Map<String, dynamic> dataUser = snapshot3.data!.docs[0].data()! as Map<String, dynamic>;
                                                              String userDocId = snapshot3.data!.docs[0].id.toString();
                                                              var role = dataUser['role'];

                                                              debugPrint('roooo 6' + role.toString());
                                                              return Container(
                                                                height: 65,
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                        height: 60,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: i == usersList.length-1? 15: 0,
                                                                            ),
                                                                            Container(
                                                                              // color: Colors.grey,
                                                                              height: 45,
                                                                              width: 30,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 13.0),
                                                                                child: IconButton(
                                                                                    icon: Icon(
                                                                                      Icons.remove_circle_rounded,
                                                                                      size: 20,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      try {
                                                                                        final result = await InternetAddress.lookup('google.com');
                                                                                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                                                          showOkCancelAlertDialog(
                                                                                            context: context,
                                                                                            title: 'Confirmation alert',
                                                                                            message: 'Are you sure you want to remove unknown user (' + usersList[i].toString() + ') from current shop?',
                                                                                            defaultType: OkCancelAlertDefaultType.cancel,
                                                                                          ).then((result) async {
                                                                                            if(result == OkCancelResult.ok) {
                                                                                              CollectionReference shops = await FirebaseFirestore.instance.collection('shops');
                                                                                              CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users');
                                                                                              CollectionReference users_ver = await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver');



                                                                                              users_ver
                                                                                                  .where('email', isEqualTo: auth.currentUser!.email)
                                                                                                  .limit(1)
                                                                                                  .get()
                                                                                                  .then((QuerySnapshot userVerSnap) {

                                                                                                WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                                batch.update(shops.doc(_result), {'users': FieldValue.arrayRemove([usersList[i].toString()]),});
                                                                                                batch.delete(users.doc(userDocId));
                                                                                                batch.delete(users_ver.doc(userVerSnap.docs[0].id));

                                                                                                batch.commit().then((value) {
                                                                                                  smartKyatFlash('Selected user is removed successfully.', 's');
                                                                                                });

                                                                                                // shops.doc(_result).update(
                                                                                                //     {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                                                                                // ).then((value) async {
                                                                                                //   users.doc(userDocId)
                                                                                                //       .delete()
                                                                                                //       .then((value) {
                                                                                                //     debugPrint('users removed');
                                                                                                //   }).catchError((error) {
                                                                                                //     users_ver.doc(userVerSnap.docs[0].id)
                                                                                                //         .delete()
                                                                                                //         .then((value) {
                                                                                                //       debugPrint('users ver removed');
                                                                                                //     }).catchError((error) {
                                                                                                //     });
                                                                                                //   });
                                                                                                // });
                                                                                              });

                                                                                            }
                                                                                          });
                                                                                        }
                                                                                      } on SocketException catch (_) {
                                                                                        smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                                                                      }
                                                                                    }
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(height: 11,),
                                                                                  Text(
                                                                                    'Unknown',
                                                                                    style: TextStyle(fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis, fontSize: 16.5, color: Colors.blue), textAlign: TextAlign.left,
                                                                                    strutStyle: StrutStyle(forceStrutHeight: true, height: 1.4),
                                                                                  ),
                                                                                  Expanded(child: Text(usersList[i].toString(), textAlign: TextAlign.left, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.black54),)),
                                                                                  SizedBox(height: 10,),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 2.5),
                                                                                child: Container(
                                                                                  height: 25,
                                                                                  width: 75,
                                                                                  child: ButtonTheme(
                                                                                    // minWidth: 30,
                                                                                    splashColor: Colors.transparent,
                                                                                    // height: 35,
                                                                                    child: FlatButton(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                                      color: AppTheme.buttonColor2,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius:
                                                                                        BorderRadius.circular(8.0),
                                                                                        side: BorderSide(
                                                                                          color: AppTheme.buttonColor2,
                                                                                        ),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        try {
                                                                                          final result = await InternetAddress.lookup('google.com');
                                                                                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                                                            _openSimpleItemPicker(context, permissionList, userDocId, usersList[i].toString(), role, 'Unknown');
                                                                                          }
                                                                                        } on SocketException catch (_) {
                                                                                          smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        child: Text(
                                                                                          role == 'admin'? 'Admin': 'Cashier',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ]
                                                                ),
                                                              );
                                                            }
                                                            return Container();
                                                          }
                                                      );
                                                    }
                                                    return StreamBuilder(
                                                        stream: FirebaseFirestore.instance
                                                            .collection('shops').doc(_result).collection('users')
                                                            .where('email', isEqualTo: usersList[i].toString())
                                                        //.where('email', isNotEqualTo: ownerEmail.toString())
                                                            .limit(1)
                                                            .snapshots(),
                                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                                                          if(snapshot3.hasData) {
                                                            Map<String, dynamic> dataUser = snapshot3.data!.docs[0].data()! as Map<String, dynamic>;
                                                            String userDocId = snapshot3.data!.docs[0].id.toString();
                                                            var role = dataUser['role'];
                                                            debugPrint('roooo ' + role.toString());
                                                            return Container(
                                                              height: 65,
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: snapshot2.data!.docs.map((DocumentSnapshot document) {
                                                                    debugPrint('hasData' + snapshot2.data!.docs.length.toString());
                                                                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                                                    debugPrint('email found ' + data.toString());

                                                                    var _selectedTest;
                                                                    List<DropdownMenuItem<Object?>> _dropdownTestItems = [];

                                                                    _dropdownTestItems = buildDropdownTestItems(_testList);

                                                                    return Container(
                                                                      height: 60,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: i == usersList.length-1? 15: 0,
                                                                          ),
                                                                          Container(
                                                                            // color: Colors.grey,
                                                                            height: 45,
                                                                            width: 30,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top: 13.0),
                                                                              child: IconButton(
                                                                                  icon: Icon(
                                                                                    Icons.remove_circle_rounded,
                                                                                    size: 20,
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    try {
                                                                                      final result = await InternetAddress.lookup('google.com');
                                                                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                                                        showOkCancelAlertDialog(
                                                                                          context: context,
                                                                                          title: 'Confirmation alert',
                                                                                          message: 'Are you sure you want to remove ' + data['name'] + ' (' + usersList[i].toString() + ') from current shop?',
                                                                                          defaultType: OkCancelAlertDefaultType.cancel,
                                                                                        ).then((result) async {
                                                                                          if(result == OkCancelResult.ok) {
                                                                                            CollectionReference shops = await FirebaseFirestore.instance.collection('shops');
                                                                                            CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users');
                                                                                            CollectionReference users_ver = await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver');


                                                                                            debugPrint('emailling check ' + usersList[i].toString());
                                                                                            users_ver
                                                                                                .where('email', isEqualTo: usersList[i].toString())
                                                                                                .limit(1)
                                                                                                .get()
                                                                                                .then((QuerySnapshot userVerSnap) {

                                                                                              WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                              batch.update(shops.doc(_result), {'users': FieldValue.arrayRemove([usersList[i].toString()]),});
                                                                                              batch.delete(users.doc(userDocId));
                                                                                              batch.delete(users_ver.doc(userVerSnap.docs[0].id));

                                                                                              batch.commit().then((value) {
                                                                                                smartKyatFlash('Selected user is removed successfully.', 's');
                                                                                              });

                                                                                              // shops.doc(_result).update(
                                                                                              //     {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                                                                              // ).then((value) async {
                                                                                              //   users.doc(userDocId)
                                                                                              //       .delete()
                                                                                              //       .then((value) {
                                                                                              //     debugPrint('users removed');
                                                                                              //   }).catchError((error) {
                                                                                              //     users_ver.doc(userVerSnap.docs[0].id)
                                                                                              //         .delete()
                                                                                              //         .then((value) {
                                                                                              //       debugPrint('users ver removed');
                                                                                              //     }).catchError((error) {
                                                                                              //     });
                                                                                              //   });
                                                                                              // });
                                                                                            });

                                                                                          }
                                                                                        }
                                                                                        );
                                                                                      }
                                                                                    } on SocketException catch (_) {
                                                                                      smartKyatFMod( context, 'Internet connection is required to take this action.', 'w');
                                                                                    }

                                                                                  }
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Expanded(
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(height: 11,),
                                                                                Text(
                                                                                  data['name'],
                                                                                  style: TextStyle(fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis, fontSize: 16.5), textAlign: TextAlign.left,
                                                                                  strutStyle: StrutStyle(forceStrutHeight: true, height: 1.4),
                                                                                ),
                                                                                Expanded(child: Text(usersList[i].toString(), textAlign: TextAlign.left, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.black54),)),
                                                                                SizedBox(height: 10,),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Center(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top: 2.5),
                                                                              child: Container(
                                                                                height: 25,
                                                                                width: 75,
                                                                                child: ButtonTheme(
                                                                                  // minWidth: 30,
                                                                                  splashColor: Colors.transparent,
                                                                                  // height: 35,
                                                                                  child: FlatButton(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                                    color: AppTheme.buttonColor2,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius:
                                                                                      BorderRadius.circular(8.0),
                                                                                      side: BorderSide(
                                                                                        color: AppTheme.buttonColor2,
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      try {
                                                                                        final result = await InternetAddress.lookup('google.com');
                                                                                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                                                          // if (role == 'admin' && auth.currentUser!.email.toString() == ownerEmail) {
                                                                                          // if (role == 'admin') {
                                                                                          //   await _openSimpleItemPicker(OneContext().context, permissionList, userDocId, usersList[i].toString(), role, data['name']);
                                                                                          // } else {
                                                                                          //   smartKyatFlash('You don\'t have permission to change this staff\'s permission.', 'w');
                                                                                          // }
                                                                                          _openSimpleItemPicker(OneContext().context, permissionList, userDocId, usersList[i].toString(), role, data['name']);
                                                                                        }
                                                                                      } on SocketException catch (_) {
                                                                                        smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                                                                      }

                                                                                      // debugPrint('resultPicker ' + resultPicker.toString());

                                                                                      // _selectTab(0);
                                                                                      // await FirebaseAuth.instance.signOut();
                                                                                      // setStoreId('');
                                                                                      // Navigator.of(context).pushReplacement(
                                                                                      //   FadeRoute(page: Welcome()),
                                                                                      // );
                                                                                    },
                                                                                    child: Container(
                                                                                      child: Text(
                                                                                        role == 'admin'? 'Admin': 'Cashier',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          overflow: TextOverflow.ellipsis
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 15,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList()
                                                              ),
                                                            );
                                                          }
                                                          return Container();
                                                        }
                                                    );

                                                  }
                                                  return Container();
                                                  // return Column(
                                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                                  //     children: [
                                                  //       Text('Pending...', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.blue),)
                                                  //     ]
                                                  // );
                                                }
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ):
                            Container(
                              height: 100,
                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                  child: CupertinoActivityIndicator(radius: 15,)),
                            )
                          ],
                        );
                      }
                      return Center(
                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                            child: CupertinoActivityIndicator(radius: 15,)),
                      );

                    }
                ),
              ),

            ]
        ),
      ),
    );
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

  List _testList = [
    {'no': 1, 'keyword': 'Cashier'},
    {'no': 2, 'keyword': 'Admin'},
  ];

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

  _openSimpleItemPicker(context, List<Text> items, String userDocId, String email, String role, String name) {
    int selectedIndex = 0;
    if(role == 'admin') {
      selectedIndex = 1;
    } else {
      selectedIndex = 0;
    }
    debugPrint('test');
    BottomPicker(
      // displayButtonIcon: false,
      buttonText: 'Set permission',
      displayButtonIcon: false,
      buttonSingleColor: Colors.grey,
      dismissable: true,
      items: items,
      title: name,
      selectedItemIndex: selectedIndex,
      buttonTextStyle: TextStyle(color: Colors.blue),
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      onSubmit: (index) {
        debugPrint(userDocId + ' id -> ' + index.toString());

        FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver')
            .where('email', isEqualTo: userDocId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          debugPrint('what?');
          querySnapshot.docs.forEach((doc) async {
            debugPrint('win lar   lar?');
            if(doc.exists) {
              WriteBatch batch  = FirebaseFirestore.instance.batch();

              batch.update(FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(userDocId), {
                'role': index == 0? 'cashier' : 'admin'
              });
              batch.update(FirebaseFirestore.instance.collection('shops').doc(_result).collection('users_ver').doc(doc.id), {
                'role': index == 0? 'cashier' : 'admin'
              });

              await batch.commit();

              // FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(userDocId)
              //     .update({
              //   'role': index == 0? 'cashier' : 'admin'
              // })
              //     .then((value) => debugPrint("User Updated"))
              //     .catchError((error) => debugPrint("Failed to update user: $error"));
            }
          });
          if(querySnapshot.docs.length==0) {
            FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(userDocId).update({
              'role': index == 0? 'cashier' : 'admin'
            });
          }
        });


      },
    ).show(context);
  }



  final _formKey = GlobalKey<FormState>();
  // final auth = FirebaseAuth.instance;
  final _accountName = TextEditingController();
  final _email = TextEditingController();
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();

  addStaffBtn(output, int staffCount) {
    if(output == 'basic') {
      if(staffCount >= 5) {
        return Container();
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
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
                      MaterialPageRoute(builder: (context) => AddStaffSub()),
                    );
                  }
                } on SocketException catch (_) {
                  smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                }

              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                    bottom: 2.0),
                child: Container(
                  child: Text(
                   textSetAdd,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.3,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    strutStyle: StrutStyle(
                      height: 1.3,
                      // fontSize:,
                      forceStrutHeight: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else if(output == 'medium') {
      if(staffCount >= 9) {
        return Container();
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
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
                      MaterialPageRoute(builder: (context) => AddStaffSub()),
                    );
                  }
                } on SocketException catch (_) {
                  smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                }

              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                    bottom: 2.0),
                child: Container(
                  child: Text(
                    textSetAdd,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.3,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                    strutStyle: StrutStyle(
                      height: 1.3,
                      // fontSize:,
                      forceStrutHeight: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      return Container();
    }

  }

  


}



