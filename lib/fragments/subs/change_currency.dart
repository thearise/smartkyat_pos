import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:extended_image/extended_image.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import '../app_theme.dart';

class ChangeCurrency extends StatefulWidget {
  final _chgShopCB3;

  ChangeCurrency({required void changeShopCallback3()}) :
        _chgShopCB3 = changeShopCallback3;

  @override
  ChangeCurrencyState createState() => ChangeCurrencyState();
}

class ChangeCurrencyState extends State<ChangeCurrency>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ChangeCurrency>{
  String currencyType = 'Myanmar Kyat (MMK)';

  @override
  bool get wantKeepAlive => true;

  var _result;
  var _shop ;
  bool firstTime = true;

  List _testList = [
    {
      'code':'AED',
      'description':'United Arab Emirates Dirham'
    },
    {
      'code':'AFN',
      'description':'Afghan Afghani**'
    },
    {
      'code':'ALL',
      'description':'Albanian Lek'
    },
    {
      'code':'AMD',
      'description':'Armenian Dram'
    },
    {
      'code':'ANG',
      'description':'Netherlands Antillean Gulden'
    },
    {
      'code':'AOA',
      'description':'Angolan Kwanza**'
    },
    {
      'code':'ARS',
      'description':'Argentine Peso**'
    },
    {
      'code':'AUD',
      'description':'Australian Dollar'
    },
    {
      'code':'AWG',
      'description':'Aruban Florin'
    },
    {
      'code':'AZN',
      'description':'Azerbaijani Manat'
    },
    {
      'code':'BAM',
      'description':'Bosnia & Herzegovina Convertible Mark'
    },
    {
      'code':'BBD',
      'description':'Barbadian Dollar'
    },
    {
      'code':'BDT',
      'description':'Bangladeshi Taka'
    },
    {
      'code':'BGN',
      'description':'Bulgarian Lev'
    },
    {
      'code':'BIF',
      'description':'Burundian Franc'
    },
    {
      'code':'BMD',
      'description':'Bermudian Dollar'
    },
    {
      'code':'BND',
      'description':'Brunei Dollar'
    },
    {
      'code':'BOB',
      'description':'Bolivian Boliviano**'
    },
    {
      'code':'BRL',
      'description':'Brazilian Real**'
    },
    {
      'code':'BSD',
      'description':'Bahamian Dollar'
    },
    {
      'code':'BWP',
      'description':'Botswana Pula'
    },
    {
      'code':'BZD',
      'description':'Belize Dollar'
    },
    {
      'code':'CAD',
      'description':'Canadian Dollar'
    },
    {
      'code':'CDF',
      'description':'Congolese Franc'
    },
    {
      'code':'CHF',
      'description':'Swiss Franc'
    },
    {
      'code':'CLP',
      'description':'Chilean Peso**'
    },
    {
      'code':'CNY',
      'description':'Chinese Renminbi Yuan'
    },
    {
      'code':'COP',
      'description':'Colombian Peso**'
    },
    {
      'code':'CRC',
      'description':'Costa Rican Colón**'
    },
    {
      'code':'CVE',
      'description':'Cape Verdean Escudo**'
    },
    {
      'code':'CZK',
      'description':'Czech Koruna**'
    },
    {
      'code':'DJF',
      'description':'Djiboutian Franc**'
    },
    {
      'code':'DKK',
      'description':'Danish Krone'
    },
    {
      'code':'DOP',
      'description':'Dominican Peso'
    },
    {
      'code':'DZD',
      'description':'Algerian Dinar'
    },
    {
      'code':'EGP',
      'description':'Egyptian Pound'
    },
    {
      'code':'ETB',
      'description':'Ethiopian Birr'
    },
    {
      'code':'EUR',
      'description':'Euro'
    },
    {
      'code':'FJD',
      'description':'Fijian Dollar'
    },
    {
      'code':'FKP',
      'description':'Falkland Islands Pound**'
    },
    {
      'code':'GBP',
      'description':'British Pound'
    },
    {
      'code':'GEL',
      'description':'Georgian Lari'
    },
    {
      'code':'GIP',
      'description':'Gibraltar Pound'
    },
    {
      'code':'GMD',
      'description':'Gambian Dalasi'
    },
    {
      'code':'GNF',
      'description':'Guinean Franc**'
    },
    {
      'code':'GTQ',
      'description':'Guatemalan Quetzal**'
    },
    {
      'code':'GYD',
      'description':'Guyanese Dollar'
    },
    {
      'code':'HKD',
      'description':'Hong Kong Dollar'
    },
    {
      'code':'HNL',
      'description':'Honduran Lempira**'
    },
    {
      'code':'HRK',
      'description':'Croatian Kuna'
    },
    {
      'code':'HTG',
      'description':'Haitian Gourde'
    },
    {
      'code':'HUF',
      'description':'Hungarian Forint**'
    },
    {
      'code':'IDR',
      'description':'Indonesian Rupiah'
    },
    {
      'code':'ILS',
      'description':'Israeli New Sheqel'
    },
    {
      'code':'INR',
      'description':'Indian Rupee**'
    },
    {
      'code':'ISK',
      'description':'Icelandic Króna'
    },
    {
      'code':'JMD',
      'description':'Jamaican Dollar'
    },
    {
      'code':'JPY',
      'description':'Japanese Yen'
    },
    {
      'code':'KES',
      'description':'Kenyan Shilling'
    },
    {
      'code':'KGS',
      'description':'Kyrgyzstani Som'
    },
    {
      'code':'KHR',
      'description':'Cambodian Riel'
    },
    {
      'code':'KMF',
      'description':'Comorian Franc'
    },
    {
      'code':'KRW',
      'description':'South Korean Won'
    },
    {
      'code':'KYD',
      'description':'Cayman Islands Dollar'
    },
    {
      'code':'KZT',
      'description':'Kazakhstani Tenge'
    },
    {
      'code':'LAK',
      'description':'Lao Kip**'
    },
    {
      'code':'LBP',
      'description':'Lebanese Pound'
    },
    {
      'code':'LKR',
      'description':'Sri Lankan Rupee'
    },
    {
      'code':'LRD',
      'description':'Liberian Dollar'
    },
    {
      'code':'LSL',
      'description':'Lesotho Loti'
    },
    {
      'code':'MAD',
      'description':'Moroccan Dirham'
    },
    {
      'code':'MDL',
      'description':'Moldovan Leu'
    },
    {
      'code':'MGA',
      'description':'Malagasy Ariary'
    },
    {
      'code':'MKD',
      'description':'Macedonian Denar'
    },
    {
      'code':'MNT',
      'description':'Mongolian Tögrög'
    },
    {
      'code':'MMK',
      'description':'Myanmar Kyat'
    },
    {
      'code':'MOP',
      'description':'Macanese Pataca'
    },
    {
      'code':'MRO',
      'description':'Mauritanian Ouguiya'
    },
    {
      'code':'MUR',
      'description':'Mauritian Rupee**'
    },
    {
      'code':'MVR',
      'description':'Maldivian Rufiyaa'
    },
    {
      'code':'MWK',
      'description':'Malawian Kwacha'
    },
    {
      'code':'MXN',
      'description':'Mexican Peso**'
    },
    {
      'code':'MYR',
      'description':'Malaysian Ringgit'
    },
    {
      'code':'MZN',
      'description':'Mozambican Metical'
    },
    {
      'code':'NAD',
      'description':'Namibian Dollar'
    },
    {
      'code':'NGN',
      'description':'Nigerian Naira'
    },
    {
      'code':'NIO',
      'description':'Nicaraguan Córdoba**'
    },
    {
      'code':'NOK',
      'description':'Norwegian Krone'
    },
    {
      'code':'NPR',
      'description':'Nepalese Rupee'
    },
    {
      'code':'NZD',
      'description':'New Zealand Dollar'
    },
    {
      'code':'PAB',
      'description':'Panamanian Balboa**'
    },
    {
      'code':'PEN',
      'description':'Peruvian Nuevo Sol**'
    },
    {
      'code':'PGK',
      'description':'Papua New Guinean Kina'
    },
    {
      'code':'PHP',
      'description':'Philippine Peso'
    },
    {
      'code':'PKR',
      'description':'Pakistani Rupee'
    },
    {
      'code':'PLN',
      'description':'Polish Złoty'
    },
    {
      'code':'PYG',
      'description':'Paraguayan Guaraní**'
    },
    {
      'code':'QAR',
      'description':'Qatari Riyal'
    },
    {
      'code':'RON',
      'description':'Romanian Leu'
    },
    {
      'code':'RSD',
      'description':'Serbian Dinar'
    },
    {
      'code':'RUB',
      'description':'Russian Ruble'
    },
    {
      'code':'RWF',
      'description':'Rwandan Franc'
    },
    {
      'code':'SAR',
      'description':'Saudi Riyal'
    },
    {
      'code':'SBD',
      'description':'Solomon Islands Dollar'
    },
    {
      'code':'SCR',
      'description':'Seychellois Rupee'
    },
    {
      'code':'SEK',
      'description':'Swedish Krona'
    },
    {
      'code':'SGD',
      'description':'Singapore Dollar'
    },
    {
      'code':'SHP',
      'description':'Saint Helenian Pound**'
    },
    {
      'code':'SLL',
      'description':'Sierra Leonean Leone'
    },
    {
      'code':'SOS',
      'description':'Somali Shilling'
    },
    {
      'code':'SRD',
      'description':'Surinamese Dollar**'
    },
    {
      'code':'STD',
      'description':'São Tomé and Príncipe Dobra'
    },
    {
      'code':'SVC',
      'description':'Salvadoran Colón**'
    },
    {
      'code':'SZL',
      'description':'Swazi Lilangeni'
    },
    {
      'code':'THB',
      'description':'Thai Baht'
    },
    {
      'code':'TJS',
      'description':'Tajikistani Somoni'
    },
    {
      'code':'TOP',
      'description':'Tongan Paʻanga'
    },
    {
      'code':'TRY',
      'description':'Turkish Lira'
    },
    {
      'code':'TTD',
      'description':'Trinidad and Tobago Dollar'
    },
    {
      'code':'TWD',
      'description':'New Taiwan Dollar'
    },
    {
      'code':'TZS',
      'description':'Tanzanian Shilling'
    },
    {
      'code':'UAH',
      'description':'Ukrainian Hryvnia'
    },
    {
      'code':'UGX',
      'description':'Ugandan Shilling'
    },
    {
      'code':'USD',
      'description':'United States Dollar'
    },
    {
      'code':'UYU',
      'description':'Uruguayan Peso**'
    },
    {
      'code':'UZS',
      'description':'Uzbekistani Som'
    },
    {
      'code':'VND',
      'description':'Vietnamese Đồng'
    },
    {
      'code':'VUV',
      'description':'Vanuatu Vatu'
    },
    {
      'code':'WST',
      'description':'Samoan Tala'
    },
    {
      'code':'XAF',
      'description':'Central African Cfa Franc'
    },
    {
      'code':'XCD',
      'description':'East Caribbean Dollar'
    },
    {
      'code':'XOF',
      'description':'West African Cfa Franc**'
    },
    {
      'code':'XPF',
      'description':'Cfp Franc**'
    },
    {
      'code':'YER',
      'description':'Yemeni Rial'
    },
    {
      'code':'ZAR',
      'description':'South African Rand'
    },
    {
      'code':'ZMW',
      'description':'Zambian Kwacha'
    }
  ];
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedTest;

  String textSetDisplay = 'Display';
  String textSetCurrency = 'Currency';
  String textSetChgCurrency = 'CHANGE CURRENCY';
  String textSetInfo = 'The currency will be applied to your all financial amount display.';

  @override
  initState() {

    getLangId().then((value) {
    if(value=='burmese') {
    setState(() {
      textSetDisplay = 'Display';
      textSetCurrency = 'ငွေကြေးအမျိုးအမည်';
      textSetChgCurrency = 'CHANGE CURRENCY';
      textSetInfo = 'ဤငွေကြေးယူနစ်ကို သင်၏ဘဏ္ဍာရေးဆိုင်ရာ ပမာဏအားလုံးကို ဖော်ပြခြင်းတွင် အသုံးပြုပါမည်။';
    });
    } else if(value=='english') {
    setState(() {
      textSetDisplay = 'Display';
      textSetCurrency = 'Currency';
      textSetChgCurrency = 'CHANGE CURRENCY';
      textSetInfo = 'This currency unit will be applied to your all financial amount display.';
    });
    }

    });

    getCurrency().then((value) {
      setState(() {
        currencyType = value;
      });
    });
    _dropdownTestItems = buildDropdownTestItems(_testList);
    super.initState();
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
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

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['description'] + ' (' + i['code'] + ')', textScaleFactor: 1,),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    showOkCancelAlertDialog(
      context: context,
      title: 'Are you sure you want to change to ' + selectedTest['code'].toString() +'?',
      message: 'This action will restart the application',
      defaultType: OkCancelAlertDefaultType.cancel,
    ).then((result) async {
      if(result == OkCancelResult.ok) {
        setState(() {
          _selectedTest = selectedTest;
        });
        debugPrint('currr ' + selectedTest['code'].toString());
        setCurrency(selectedTest['code'].toString()).then((_) {
          // widget._chgShopCB3();
          showOkAlertDialog(
              context: context,
              title: 'Restart required',
              message: 'Currency changed successfully at your current shop.'
          ).then((result) async {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          });
          // if (Platform.isAndroid) {
          //   SystemNavigator.pop();
          // } else if (Platform.isIOS) {
          //   exit(0);
          // }
        });

      }
    });
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
                              textSetDisplay,  textScaleFactor: 1,
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
                              textSetCurrency,  textScaleFactor: 1,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
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
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(textSetChgCurrency,   textScaleFactor: 1, style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,color: Colors.grey,
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: DropdownBelow(
                            itemWidth: (MediaQuery.of(context).size.width > 900
                                ? MediaQuery.of(context).size.width * (2 / 3.5)
                                : MediaQuery.of(context).size.width)-30,
                            itemTextstyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                            boxTextstyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                            boxPadding: EdgeInsets.fromLTRB(15, 12, 13, 12),
                            boxWidth: double.infinity,
                            boxHeight: 50,
                            boxDecoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10.0),
                                color: AppTheme.buttonColor2,
                                border: Border.all(width: 1, color: Colors.transparent)),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black,
                            ),
                            hint: Text(currencyType, textScaleFactor: 1,),
                            value: _selectedTest,
                            items: _dropdownTestItems,
                            onChanged: onChangeDropdownTests,
                          ),
                        ),
                        SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          // child: Text('Choose the text box to customize your account name, and can save it.'),
                          child: RichText(
                            strutStyle: StrutStyle(
                              height: 1,
                              // fontSize:,
                              forceStrutHeight: true,
                            ),
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                  text: textSetInfo,
                                  style: new TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  // final _formKey = GlobalKey<FormState>();
  // // final auth = FirebaseAuth.instance;
  // final _accountName = TextEditingController();
  // final _email = TextEditingController();
  // final _shopName = TextEditingController();
  // final _address = TextEditingController();
  // final _phone = TextEditingController();

//   accountSetting(priContext) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         bottom: true,
//         top: true,
//         child: Form(
//           key: _formKey,
//           child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
//               // mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: 80,
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Colors.grey.withOpacity(0.3),
//                               width: 1.0))),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 16),
//                           child: Container(
//                             width: 37,
//                             height: 37,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(35.0),
//                                 ),
//                                 color: Colors.grey.withOpacity(0.3)),
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 3.0),
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back_ios_rounded,
//                                     size: 17,
//                                     color: Colors.black,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   }),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 16.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       'Information',
//                                       textAlign: TextAlign.right,
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500,color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   'Account settings',
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15,),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15.0,),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('INFORMATION', style: TextStyle(
//                               letterSpacing: 1.5,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,color: Colors.grey,
//                             ),),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 20.0),
//                               child: TextFormField(
//                                 //obscureText: _obscureText,
//                                 controller: _accountName,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return ' This field is required ';
//                                   }
//                                   return null;
//                                 },
//                                 style: TextStyle(
//                                   height: 0.95,
//                                 ),
//                                 decoration: InputDecoration(
//                                   enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.skBorderColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//
//                                   focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.themeColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 15.0,
//                                       right: 15.0,
//                                       top: 20.0,
//                                       bottom: 20.0),
//                                   suffixText: 'Required' ,
//                                   suffixStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                     fontFamily: 'capsulesans',
//                                   ),
//                                   // errorText: wrongPassword,
//                                   errorStyle: TextStyle(
//                                       backgroundColor: Colors.white,
//                                       fontSize: 12,
//                                       fontFamily: 'capsulesans',
//                                       height: 0.1
//                                   ),
//                                   labelStyle: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
// // errorText: 'Error message',
//                                   labelText: 'Account name',
//                                   floatingLabelBehavior:
//                                   FloatingLabelBehavior.auto,
// //filled: true,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 20.0),
//                               child: TextFormField(
//                                 //obscureText: _obscureText,
//                                 controller: _email,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return ' This field is required ';
//                                   }
//                                   return null;
//                                 },
//                                 style: TextStyle(
//                                   height: 0.95,
//                                 ),
//                                 decoration: InputDecoration(
//                                   enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.skBorderColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//
//                                   focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.themeColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 15.0,
//                                       right: 15.0,
//                                       top: 20.0,
//                                       bottom: 20.0),
//                                   suffixText: 'Required' ,
//                                   suffixStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                     fontFamily: 'capsulesans',
//                                   ),
//                                   //errorText: wrongPassword,
//                                   errorStyle: TextStyle(
//                                       backgroundColor: Colors.white,
//                                       fontSize: 12,
//                                       fontFamily: 'capsulesans',
//                                       height: 0.1
//                                   ),
//                                   labelStyle: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
// // errorText: 'Error message',
//                                   labelText: 'Email address',
//                                   floatingLabelBehavior:
//                                   FloatingLabelBehavior.auto,
// //filled: true,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 30,),
//                             ButtonTheme(
//                               minWidth: MediaQuery.of(context).size.width,
//                               splashColor: Colors.transparent,
//                               height: 50,
//                               child: FlatButton(
//                                 color: AppTheme.themeColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(10.0),
//                                   side: BorderSide(
//                                     color: AppTheme.themeColor,
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (_formKey.currentState!.validate()) {
//
//
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 5.0,
//                                       right: 5.0,
//                                       bottom: 2.0),
//                                   child: Container(
//                                     child: Text(
//                                       'Save and exit',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w500,
//                                           letterSpacing:-0.1
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ]
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//   addStaffPage() {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: true,
//         top: true,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
//             // mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: 80,
//                 decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             color: Colors.grey.withOpacity(0.3),
//                             width: 1.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 18.0, right: 15.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16),
//                         child: Container(
//                           width: 37,
//                           height: 37,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(35.0),
//                               ),
//                               color: Colors.grey.withOpacity(0.3)),
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 3.0),
//                             child: IconButton(
//                                 icon: Icon(
//                                   Icons.arrow_back_ios_rounded,
//                                   size: 17,
//                                   color: Colors.black,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 }),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 16.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     'Information',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w500,color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 'Switch shop',
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15.0),
//                             child: Text('CURRENT SHOP', style: TextStyle(
//                               letterSpacing: 1.5,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,color: Colors.grey,
//                             ),),
//                           ),
//                           SizedBox(height: 30,),
//                           ButtonTheme(
//                             minWidth: MediaQuery.of(context).size.width,
//                             splashColor: Colors.transparent,
//                             height: 50,
//                             child: FlatButton(
//                               color: AppTheme.buttonColor2,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(10.0),
//                                 side: BorderSide(
//                                   color: AppTheme.buttonColor2,
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//
//
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 5.0,
//                                     right: 5.0,
//                                     bottom: 2.0),
//                                 child: Container(
//                                   child: Text(
//                                     'New shop',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         letterSpacing:-0.1
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]
//         ),
//       ),
//     );
//   }
//
//   addDailyExp(priContext) {
//     // myController.clear();
//     showModalBottomSheet(
//         enableDrag:false,
//         isScrollControlled:true,
//         context: context,
//         builder: (BuildContext context) {
//           return Scaffold(
//             body: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               // mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: MediaQuery.of(priContext).padding.top,
//                 ),
//                 Expanded(
//                   child: Container(
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 6,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(25.0),
//                               ),
//                               color: Colors.white.withOpacity(0.5)
//                           ),
//                         ),
//                         SizedBox(
//                           height: 14,
//                         ),
//                         Container(
//                           // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15.0),
//                               topRight: Radius.circular(15.0),
//                             ),
//                             color: Colors.white,
//                           ),
//
//                           child: Container(
//                             width: 150,
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(15.0),
//                                       topRight: Radius.circular(15.0),
//                                     ),
//                                     color: Colors.grey.withOpacity(0.1),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.close,
//                                           size: 20,
//                                           color: Colors.transparent,
//                                         ),
//                                         onPressed: () {
//                                         },
//
//                                       ),
//                                       Text(
//                                         "New Expense",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 17,
//                                             fontFamily: 'capsulesans',
//                                             fontWeight: FontWeight.w600
//                                         ),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.close,
//                                           size: 20,
//                                           color: Colors.black,
//                                         ),
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                           debugPrint('clicked');
//                                         },
//
//                                       )
//
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     color: Colors.yellow,
//                     height: 100,
//                   ),
//                 )
//               ],
//             ),
//           );
//
//         });
//   }

  setCurrency(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('currency', id);
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }


}



