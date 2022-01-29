import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/account_setting.dart';
import 'package:smartkyat_pos/fragments/subs/change_currency.dart';
import 'package:smartkyat_pos/fragments/subs/change_password.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/print_settings_sub.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';

import '../app_theme.dart';
import 'subs/shop_setting_sub.dart';
import 'subs/switch_shop_sub.dart';

class SettingsFragment extends StatefulWidget {
  final _chgShopCB;
  final _openDrawerBtn;
  final _closeDrawerBtn;
  final _premiumCart;
  SettingsFragment({required this.usersSnapshot, required void changeShopCallback(), required void closeDrawerBtn(String str),
    required void openDrawerBtn(String str), required void premiumCart(), Key? key,}):
        _chgShopCB = changeShopCallback,_openDrawerBtn = openDrawerBtn,
        _closeDrawerBtn = closeDrawerBtn, _premiumCart = premiumCart, super(key: key);
  final usersSnapshot;

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

  @override
  bool get wantKeepAlive => true;
  @override

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
      return 'Roll-57';
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

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  initState() {
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
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          languageId = 'Burmese';
          textSetTitle = 'အပြင်အဆင်';
          textSetAccount = 'အကောင့်';
          textSetShopSetting = 'ဆိုင်အပြင်အဆင်';
          textSetLanguage = 'ဘာသာစကား';
          textSetPrint = 'ပရင်တာအပြင်အဆင်';
          textInfo = 'သတင်းအချက်အလက်';
          textDisplay = 'DISPLAY';

        });
      } else if(value=='english') {
        setState(() {
          languageId = 'English';
          textSetTitle = 'Settings';
          textSetAccount = 'Account';
          textSetShopSetting = 'Shop setting';
          textSetLanguage = 'Languages';
          textSetPrint = 'Print setting';
          textInfo = 'INFORMATION';
          textDisplay = 'DISPLAY';
        });
      }
    });
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
  //       print('space shi p thar');
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
  //           print('shop already');
  //         } else {
  //           CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(docId).collection('shops');
  //           return shops
  //               .add({
  //             'shop_name': shopName
  //           })
  //               .then((value) {
  //             print('shop added');
  //           });
  //         }
  //       });
  //
  //
  //     } else {
  //       print('space mshi vuu');
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
  //           print('shop added');
  //         });
  //
  //       }).catchError((error) => print("Failed to add shop: $error"));
  //     }
  //   });
  // }
 String name = '';
  String email = '';
  String version = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: const EdgeInsets.only(top: 10.0, left: 15.0 , right: 15),
                  child: Row(
                    children: [
                      Text(textSetTitle,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),),
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
                          child: Text(isPro == 'free'? 'Free Version': 'Pro Version', style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                          ),),
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
                          child: Text(textInfo, style: TextStyle(
                            letterSpacing: 1.5,
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
                          child: Container(
                            height: 72,
                            // decoration: BoxDecoration(
                            //     border: Border(
                            //       bottom: BorderSide(
                            //           color: AppTheme.skBorderColor2,
                            //           width: 1.0),
                            //     )),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                    children: [
                                      Container(
                                        child: Text(textSetAccount,
                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                                      ),
                                      StreamBuilder(
                                          stream: widget.usersSnapshot,
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if(snapshot.hasData) {
                                              return Expanded(
                                                child: ListView(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                                    name = data['name'];
                                                    email = data['email'];
                                                    version = document.id;
                                                    return Padding(
                                                      padding: const EdgeInsets.only(top: 24),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width/2,
                                                        child: Text(data['name'],textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight
                                                                  .w500,
                                                              color: Colors.grey),),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            }
                                            return Container();
                                          }
                                      ),
                                      SizedBox(width: 8,),
                                      Icon(
                                        Icons
                                            .arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ]
                                ),
                              ),
                            ),
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
                              MaterialPageRoute(builder: (context) => ShopSettingsSub(changeShopCallback2: chgShopFromSubSet)),
                            );
                            openDrawerFrom();
                          },
                          child: Container(
                            color: Colors.white,
                            height: 72,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0, left: 15, right: 15),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(textSetShopSetting, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                                  Spacer(),
                                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots(),
                                      builder: (BuildContext context, snapshot) {
                                        if(snapshot.hasData) {
                                          var output = snapshot.data!.data();
                                          var shopName = output?['shop_name'];
                                          return Container(
                                              width: MediaQuery.of(context).size.width/2,
                                              child: Text(shopName ,textAlign: TextAlign.right,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),)
                                          );
                                        }
                                        return Container();
                                      }
                                  ),
                                  SizedBox(width: 8,),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(textDisplay, style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14, color: Colors.grey,
                          ),),
                        ),
                        Container(
                          height: 72,
                          // decoration: BoxDecoration(
                          //     color: AppTheme.white,
                          //     border: Border(
                          //       bottom: BorderSide(
                          //           color: AppTheme.skBorderColor2,
                          //           width: 1.0),
                          //     )),
                          child: Center(
                            child: ListTile(
                              title: Text('Dark mode', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Off' ,style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,color: Colors.grey),),
                                  SizedBox(width: 8,),
                                  Icon(
                                    Icons
                                        .arrow_forward_ios_rounded, size: 16, color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
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
                              MaterialPageRoute(builder: (context) => LanguageSettings(changeShopCallback3: () {  },)),
                            );
                            openDrawerFrom();
                          },
                          child: Container(
                            height: 72,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: ListTile(
                                  title: Text(textSetLanguage, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(languageId.toString() ,style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),),
                                      SizedBox(width: 8,),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,
                                      ),
                                    ],
                                  ),


                                ),
                              ),
                            ),
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
                              MaterialPageRoute(builder: (context) => ChangeCurrency(changeShopCallback3: () {  },)),
                            );
                            openDrawerFrom();
                          },
                          child: Container(
                            height: 72,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: ListTile(
                                  title: Text('Currency', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(currencyId.toString() ,style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),),
                                      SizedBox(width: 8,),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,
                                      ),
                                    ],
                                  ),


                                ),
                              ),
                            ),
                          ),
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
                          child: Text('OTHERS', style: TextStyle(
                            letterSpacing: 1.5,
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
                          child: Container(
                            height: 72,
                            child: Center(
                              child: ListTile(
                                title: Text(textSetPrint, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(paperId.toString() ,style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),),
                                    SizedBox(width: 8,),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,),
                                  ],
                                ),
                              ),
                            ),
                          ),
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


}



