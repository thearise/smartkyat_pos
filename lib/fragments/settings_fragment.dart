import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/api/purchase_api.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/account_setting.dart';
import 'package:smartkyat_pos/fragments/subs/change_currency.dart';
import 'package:smartkyat_pos/fragments/subs/change_password.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/print_settings_sub.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../app_theme.dart';
import 'subs/shop_setting_sub.dart';
import 'subs/switch_shop_sub.dart';

class SettingsFragment extends StatefulWidget {
  final _chgShopCB;
  final _openDrawerBtn;
  final _closeDrawerBtn;
  final _premiumCart;
  final _homePageLoadingOn;
  final _homePageLoadingOff;
  SettingsFragment({required this.usersSnapshot, required this.isEnglish,required void changeShopCallback(), required void closeDrawerBtn(String str),
    required void openDrawerBtn(String str), required void premiumCart(), Key? key, required void homePageLoadingOn(), required void homePageLoadingOff()}):
        _chgShopCB = changeShopCallback,_openDrawerBtn = openDrawerBtn, _homePageLoadingOn = homePageLoadingOn, _homePageLoadingOff = homePageLoadingOff,
        _closeDrawerBtn = closeDrawerBtn, _premiumCart = premiumCart, super(key: key);
  final usersSnapshot;
  final bool isEnglish;

  @override
  SettingsFragmentState createState() => SettingsFragmentState();
}

class SettingsFragmentState extends State <SettingsFragment>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SettingsFragment>{
  String? shopId;
  String? paperId;
  String? languageId;
  String? currencyId;

  String textSetTitle = 'Settings';
  String textSetAccount = 'Account';
  String textSetShopSetting = 'Shop setting';
  String textSetLanguage = 'Languages';
  String textSetPrint = 'Print setting';
  String textInfo = 'INFORMATION';
  String textDisplay = 'DISPLAY';
  String textSetCur = 'Currency';

  @override
  bool get wantKeepAlive => true;
  @override

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

  homePageLoadingOn() {
    widget._homePageLoadingOn();
  }

  homePageLoadingOff() {
    widget._homePageLoadingOff();
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('currency') == null) {
      return 'Myanmar Kyat (MMK)';
    }
    return prefs.getString('currency');
  }

  void closeDrawerFrom() {
    widget._closeDrawerBtn('settings');
  }

  void openDrawerFrom() {
    widget._openDrawerBtn('settings');
  }

  getPaperId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('paper') == null) {
      return 'Roll-80';
    }
    return prefs.getString('paper');
  }
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('paper');
  // }

  bool searchOpening = false;
  changeSearchOpening(bool index) {
    setState(() {
      searchOpening = index;
    });
  }

  String isPro = 'free';
  isProSet(String index) {
    setState(() {
      isPro = index;
    });
  }


  initState() {
    fetchingOffering();
    getPaperId().then((value) {
      setState(() {
        paperId = value.toString();
      });
    });

    getCurrency().then((value) {
      setState(() {
        currencyId = value.toString();
      });
    });

    getStoreId().then((value) {
      setState(() {
        shopId = value.toString();
      });

    });
      if(widget.isEnglish == true) {
        setState(() {
          languageId = 'English';
          textSetTitle = 'Settings';
          textSetAccount = 'Account';
          textSetShopSetting = 'Shop setting';
          textSetLanguage = 'Languages';
          textSetPrint = 'Print setting';
          textInfo = 'INFORMATION';
          textDisplay = 'DISPLAY';
          textSetCur = 'Currency';
        });
      } else  {
        setState(() {
          languageId = 'Burmese';
          textSetTitle = 'အပြင်အဆင်';
          textSetAccount = 'အကောင့်';
          textSetShopSetting = 'ဆိုင်အပြင်အဆင်';
          textSetLanguage = 'ဘာသာစကား';
          textSetPrint = 'ပရင်တာအပြင်အဆင်';
          textInfo = 'INFORMATION';
          textDisplay = 'DISPLAY';
          textSetCur = 'ငွေကြေးအမျိုးအမည်';
        });
      }
    super.initState();
  }

  chgShopIdFrmHomePage() {
    setState(() {
      getStoreId().then((value) => shopId = value);
    });
  }

  chgShopFromSubSet() {
    widget._chgShopCB();
  }

  @override
  void dispose() {
    super.dispose();
  }
  final auth = FirebaseAuth.instance;

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
  String name = '';
  String email = '';
  String version = '';

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
              child: Text(leftTxt, textScaleFactor: 1,
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
                        rightTxt, textScaleFactor: 1,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: true,
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 81,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0, left: 15.0 , right: 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(textSetTitle, textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          widget._premiumCart();
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              color: Colors.grey.withOpacity(0.3)),
                          child: Text(isPro == 'free'? 'Free version': 'Pro version', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                          ),textScaleFactor: 1, ),
                        ),
                      ),
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
                          child: Text(textInfo, textScaleFactor: 1, style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,color: Colors.grey,
                          ),),),
                        GestureDetector(
                          onTap: () async {
                            closeDrawerFrom();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountSetting(email: email, name: name, id: version.toString(),)),
                            );
                            openDrawerFrom();
                          },
                          child: StreamBuilder(
                              stream: widget.usersSnapshot,
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if(snapshot.hasData) {
                                  return Container(
                                    height: 72,
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                        name = data['name'];
                                        email = data['email'];
                                        version = document.id;
                                        return eachTile(textSetAccount, name);
                                      }).toList(),
                                    ),
                                  );
                                }
                                return eachTile(textSetAccount, '...');
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
                          onTap: () async {
                            closeDrawerFrom();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShopSettingsSub(homePageLoadingOn: homePageLoadingOn, homePageLoadingOff: homePageLoadingOff, changeShopCallback2: chgShopFromSubSet)),
                            );
                            openDrawerFrom();
                          },
                          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance.collection('shops').doc(shopId == ''? '007': shopId).snapshots(),
                              builder: (BuildContext context, snapshot) {
                                if(snapshot.hasData) {
                                  var output = snapshot.data!.data();
                                  var shopName = output?['shop_name'];
                                  return eachTile(textSetShopSetting, shopName== null? '':shopName);
                                }
                                return eachTile(textSetShopSetting, '...');
                              }
                          ),
                        ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(textDisplay, textScaleFactor: 1, style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 14, color: Colors.grey,
                          ),),
                        ),
                        GestureDetector(
                          onTap: () async {
                            smartKyatFMod(context,'Dark mode is still in progress and will be available soon.', 'w');
                          },
                          child: eachTile('Dark mode', 'Off')
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
                          onTap: () async {
                            closeDrawerFrom();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LanguageSettings(changeShopCallback3: () {  },)),
                            );
                            openDrawerFrom();
                          },
                          child: eachTile(textSetLanguage, languageId.toString()),
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
                          onTap: () async {
                            closeDrawerFrom();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangeCurrency(changeShopCallback3: () {  },)),
                            );
                            openDrawerFrom();
                          },
                          child: eachTile(textSetCur, currencyId.toString()),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        //   child: Container(
                        //     height: 55,
                        //     child: TextDropdownFormField(
                        //       options: ["Male", "Female"],
                        //       decoration: InputDecoration(
                        //           enabledBorder: const OutlineInputBorder(
                        //               borderSide: const BorderSide(
                        //                   color: AppTheme.skBorderColor,
                        //                   width: 2.0),
                        //               borderRadius: BorderRadius.all(
                        //                   Radius.circular(10.0))),
                        //
                        //           focusedBorder: const OutlineInputBorder(
                        //               borderSide: const BorderSide(
                        //                   color: AppTheme.themeColor,
                        //                   width: 2.0),
                        //               borderRadius: BorderRadius.all(
                        //                   Radius.circular(10.0))),
                        //           // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                        //           // isDense: true,
                        //           contentPadding: const EdgeInsets.only(
                        //               left: 15.0,
                        //               right: 15.0,
                        //               top:20,
                        //               bottom: 20),
                        //           suffixStyle: TextStyle(
                        //             color: Colors.grey,
                        //             fontSize: 12,
                        //             fontFamily: 'capsulesans',
                        //           ),
                        //           // errorText: wrongEmail,
                        //           errorStyle: TextStyle(
                        //               backgroundColor: Colors.white,
                        //               fontSize: 12,
                        //               fontFamily: 'capsulesans',
                        //               height: 0.1
                        //           ),
                        //           labelStyle: TextStyle(
                        //             fontWeight: FontWeight.w500,
                        //             color: Colors.black,
                        //           ),
                        //           labelText: 'Email address',
                        //           floatingLabelBehavior:
                        //           FloatingLabelBehavior.auto,
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //           // border: OutlineInputBorder(),
                        //           suffixIcon: Icon(Icons.arrow_drop_down),
                        //           // labelText: "Gender"
                        //       ),
                        //       dropdownHeight: 120,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('OTHERS', textScaleFactor: 1, style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 14, color: Colors.grey,
                          ),),
                        ),
                        GestureDetector(
                          onTap: () async {
                            closeDrawerFrom();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PrintSettingsSub(changeShopCallback3: () {  },)),
                            );
                            openDrawerFrom();
                          },
                          child: eachTile(textSetPrint, paperId.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  final _formKey = GlobalKey<FormState>();
 // final auth = FirebaseAuth.instance;

  addStaffPage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                onPressed: () async {
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
                                    'Information', textScaleFactor: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Switch shop', textScaleFactor: 1,
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
                            child: Text('CURRENT SHOP', textScaleFactor: 1, style: TextStyle(
                              letterSpacing: 2,
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
                                    'New shop', textScaleFactor: 1,
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
            resizeToAvoidBottomInset: false,
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

  Future<void> fetchingOffering() async {
    await PurchaseApi.init();
    final offerings = await PurchaseApi.fetchOffers();

    if (offerings.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('No plan found.')));
    } else {
      final packages = offerings.map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
    }
  }
}



