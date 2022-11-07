import 'dart:async';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metooltip/metooltip.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FirstLaunchPage extends StatefulWidget {
  const FirstLaunchPage({Key? key}) : super(key: key);

  @override
  FirstLaunchPageState createState() => FirstLaunchPageState();
}

class FirstLaunchPageState extends State<FirstLaunchPage>
    with TickerProviderStateMixin<FirstLaunchPage>{

  String currencyType = 'Myanmar Kyat (MMK)';
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

  bool isEnglish = false;

  int priProgVal = 5000;

  String lang = 'english';

  @override
  initState() {
    _dropdownTestItems = buildDropdownTestItems(_testList);
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      final dynamic tooltip = tTkey.currentState;
      // tooltip.handleLongPress();
    });
    setLanguage("burmese");

    getLangId().then((val) {
      setState(() {
        lang = val;
        if(lang == 'english') {
          isEnglish = true;
        } else {
          isEnglish = false;
        }
      });
    });

    // startPrintAni();
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //
    //   // lang = await getLangId();
    //
    //   setState(() {
    //     debugPrint('setting state ' + lang.toString());
    //   });
    //
    // });

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

  disLoading() {
    Navigator.pop(context);
  }

  final tTkey = new GlobalKey();

  onChangeDropdownTests(selectedTest) {
    // String gg = '';
    //
    // gg = selectedTest;
    setState(() {
      _selectedTest = selectedTest;
    });

    setCurrency(selectedTest['code'].toString());
  }

  setCurrency(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('currency', id);
  }

  setLanguage(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 900? MediaQuery.of(context).size.width/4:0.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 200.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.transparent,
                            width: 1.0),
                      )),
                  child: Column(
                    children: [
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.transparent, Colors.transparent, Colors.purple],
                              stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: ListView(
                            children: [
                              // LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                              // Center(
                              //     child: FAProgressBar(
                              //       currentValue: priProgVal,
                              //       displayText: '%',
                              //       animatedDuration: Duration(milliseconds: 4000),
                              //     )),
                              // new LinearPercentIndicator(
                              //   // width: 140.0,
                              //   width: MediaQuery.of(context).size.width - 30,
                              //   animationDuration: priProgVal,
                              //   animation: true,
                              //   lineHeight: 14.0,
                              //   percent: 1,
                              //   backgroundColor: Colors.grey,
                              //   progressColor: Colors.blue,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 23.0),
                                child: Container(
                                    child: Image.asset('assets/system/smartkyat.png', height: 63, width: 63,)
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isEnglish = true;
                                      });
                                      setLanguage("english");
                                    },
                                    child: Text(
                                      'ENGLISH',
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isEnglish?Colors.black:Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  MeTooltip(
                                    key: tTkey,
                                    message: "မြန်မာစာ ပြောင်းရန်",
                                    preferOri: PreferOrientation.down,
                                    isShow: false,
                                    child: TextButton(

                                      onPressed: () {
                                        setState(() {
                                          isEnglish = false;
                                        });
                                        setLanguage("burmese");
                                      },
                                      child: Text(
                                        'MYANMAR',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                          color: isEnglish?Colors.black.withOpacity(0.3):Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 12.0),
                              //   child: Center(
                              //     child: Text(
                              //       'မြန်မာစာ ပြောင်းရန်', style: TextStyle(fontSize: 13), textScaleFactor: 1,
                              //     ),
                              //   ),
                              // ),

                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              //   child: Container(
                              //     alignment: Alignment.centerLeft,
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //       BorderRadius.circular(10.0),
                              //       color: AppTheme.lightBgColor,
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //               'A single back office', style: TextStyle(
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //           SizedBox(
                              //             height: 5,
                              //           ),
                              //           Text(
                              //             'Manage products, payments, and customers across all the places you sell, in store and online.', style: TextStyle(
                              //             fontWeight: FontWeight.w400,
                              //             fontSize: 15,
                              //           ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              //   child: Container(
                              //     alignment: Alignment.centerLeft,
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //       BorderRadius.circular(10.0),
                              //       color: AppTheme.lightBgColor,
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             'Unlimited products', style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 16,
                              //           ),
                              //           ),
                              //           SizedBox(
                              //             height: 5,
                              //           ),
                              //           Text(
                              //             'Add multiple variations to products such as size, color, or materials and assign their own price, SKU, weight, and inventory.', style: TextStyle(
                              //             fontWeight: FontWeight.w400,
                              //             fontSize: 15,
                              //           ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              //   child: Container(
                              //     alignment: Alignment.centerLeft,
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //       BorderRadius.circular(10.0),
                              //       color: AppTheme.lightBgColor,
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             'Barcode labels', style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 16,
                              //           ),
                              //           ),
                              //           SizedBox(
                              //             height: 5,
                              //           ),
                              //           Text(
                              //             'Assign existing barcodes to products or create new ones to keep track of inventory and speed up checkout.', style: TextStyle(
                              //             fontWeight: FontWeight.w400,
                              //             fontSize: 15,
                              //           ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              //   child: Container(
                              //     alignment: Alignment.centerLeft,
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //       BorderRadius.circular(10.0),
                              //       color: AppTheme.lightBgColor,
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             'Inventory status', style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 16,
                              //           ),
                              //           ),
                              //           SizedBox(
                              //             height: 5,
                              //           ),
                              //           Text(
                              //             'Use inventory states to track and share the status of your inventory as products are received, transferred, or an order is fulfilled.', style: TextStyle(
                              //             fontWeight: FontWeight.w400,
                              //             fontSize: 15,
                              //           ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:4.5, top: 3.0),
                                      child: Image.asset('assets/system/features/cloud_sync.png', width: 26.5,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Cloud sync (offline support)': 'Cloud sync (offline support)', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.3,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish?
                                            'Real-time and syncronized data across all over devices with automatically offline-data-restore supported.':
                                            'ဆိုင်ရှိ devices များမှ ရောင်းရသော အချက်အလက်များကို တစ်စုတစည်းတည်း အလိုအလျှောက် စစ်ဆေးကြည့်ရှူနိုင်သည်။ Offline ဖြစ်နေစဉ် မှတ်သားထားသော အချက်အလက်များကိုလည်း online ဖြစ်သည်နှင့် devices အားလုံးတွင် အလိုအလျှောက် update ဖြစ်စေရန် ဆောင်ရွက်ပေးထားသည်။'
                                              , textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:5.0, top: 2.0),
                                      child: Image.asset('assets/system/features/finance_reports.png', width: 27,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Finance reports': 'ငွေစာရင်း reports',textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish?
                                            'Manage payments across all the staff\'s they sell and generate reports to review your finances including sales, stock costs and unpaid orders.':
                                            'ဝန်ထမ်းများ ရောင်းချထားသော အရောင်းစာရင်းများ၏ ငွေပေးချေမှုများကို စီမံခန့်ခွဲနိုင်သည်။ အရောင်းစာရင်း၊ အဝယ်စာရင်း၊ အကြွေးစာရင်းများ အပါအဝင် ငွေကြေးဆိုင်ရာ အချက်အလက်များကို ရက်၊လ၊နှစ်အလိုက် အစီအရင်ခံပေးထားသည်။'
                                              ,textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:5.5, top: 4.0),
                                      child: Image.asset('assets/system/features/inventory_status.png', width: 26.5,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Inventory status': 'ကုန်ပစ္စည်း အဝင်အထွက် စာရင်း', textScaleFactor: 1,style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish?
                                            'Use inventory states to track and share the status of your inventory as products are received, sold, or an order is fulfilled.':
                                            'မှာယူမှု ပြီးဆုံးခြင်း သို့မဟုတ် ရောင်းချခြင်း နှင့် ထုတ်ကုန်များ လက်ခံရရှိခြင်း ကဲ့သို့သော အချက်အလက်များကို ခြေရာခံ ကြည့်ရှုနိုင်သည်။', textScaleFactor: 1,style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:4.0, top: 2.0),
                                      child: Image.asset('assets/system/features/unlimited_products.png', width: 29,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Unlimited products': 'အကန့်အသတ်မရှိ ကုန်ပစ္စည်းများ', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish? 'Add multiple sub-items of unlimited products such as dozens, items per package and assign their own price, SKU (Stock keeping units), units per package and inventory.':
                                              'တစ်ထုပ်လျှင် ဒါဇင်၊ ခု အစရှိသော ကုန်ပစ္စည်းတစ်ခု ၏ ပစ္စည်းအခွဲ များထည့်ထားပြီး အခွဲများအလိုက် စျေးအမျိုးမျိုး၊ ယူနစ်အမျိုးမျိုး သတ်မှတ်နိုင်သည်။', textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:6.0, top: 1.5),
                                      child: Image.asset('assets/system/features/barcode_scans.png', width: 28,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Barcode scans (camera scanner)': 'Barcode scans (camera scanner)', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish?
                                            'Assign barcodes to products to keeep track of inventory and speed up checkout.':
                                            'ရောင်းချမှု မြန်ဆန်စေရန် ကုန်ပစ္စည်းများကို Barcode အသုံးပြုပြီး ရောင်းချနိုင်သည်။'
                                              , textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:4.5, top: 3),
                                      child: Image.asset('assets/system/features/printer_color.png', width: 25,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Print an invoice (PNG receipt supported)': 'ဘောင်ချာထုတ် service (ပုံနှင့်ရော, printer ပါ)', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish? 'Instant printing service after each sale or by selecting an order from order lists with minimized waiting time.':
                                                'Printer စောင့်ဆိုင်းချိန် အနည်းဆုံးဖြင့် အရောင်းအဝယ် တခါပြီးတိုင်း အလွယ်တကူ တန်းထုတ်နိုင်သလို, ရောင်းပြီးသား စာရင်းများမှလည်း ဝင်ရောက်ထုတ်နိုင်ပါသည်။'
                                              ,textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:6.0, top: 3.0),
                                      child: Image.asset('assets/system/features/staffs.png', width: 24,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'POS staff roles and permissions': 'POS ဝန်းထမ်း roles and permissions', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish? 'Assign custom roles to store staff ensuring they have the correct permissions.': 'ဝန်ထမ်းများကို ရာထူးအလိုက် လုပ်ဆောင်နိုင်ခွင့်များ သတ်မှတ်ပေးနိုင်သည်။',textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                      child: Image.asset('assets/system/features/order_refunds.png', width: 27,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Order refunds, discounts and debts': 'ပစ္စည်းပြန်လဲခြင်း, စျေးလျော့ခြင်း နှင့် အကြွေးဝယ်ခြင်း', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish?
                                              'Return items of past purchases from any devices, and apply discounts and debts to each order.':
                                              'အရောင်းစာရင်း တစ်ခုခြင်းစီတွင် စိတ်ကြိုက် လျှော့စျေးများနှင့် အကြွေးပမာဏများ ထည့်သွင်းထားနိုင်သည်။  ရောင်းပြီး စာရင်း များမှ ကုန်ပစ္စည်းတစ်ခုချင်းစီ ကိုလဲ ပြန်ပေးစာရင်းများ ပြုလုပ်နိုင်သည်။',textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: AppTheme.lightBgColor,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left:4.5, top: 3),
                                      child: Image.asset('assets/system/features/customer_profile.png', width: 28,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(isEnglish? 'Rich customer profiles': 'Rich customer profiles',textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(isEnglish?
                                            'Keep track of contact information, purchase history, lifetime spend, and debts of each customers.':
                                            'ဖောက်သည်များ၏ လိပ်စာ၊ ဝယ်ယူမှုမှတ်တမ်းများ နှင့် အကြွေးစာရင်းများကို ခြေရာခံ ကြည့်ရှုနိုင်သည်။'
                                              , textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            ),
                                              strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 20,)
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
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Colors.transparent,
                            width: 1.0),
                      )),
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('INFORMATION', textScaleFactor: 1, style: TextStyle(
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
                              ? MediaQuery.of(context).size.width / 2
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
                          hint: Text(currencyType),
                          value: _selectedTest,
                          items: _dropdownTestItems,
                          onChanged: onChangeDropdownTests,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      //   child: RichText(
                      //     text: new TextSpan(
                      //       children: [
                      //         new TextSpan(
                      //           text: 'By signing up, you agree to our ',
                      //           style: new TextStyle(
                      //               fontSize: 12.5,
                      //               color: Colors.grey,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //         ),
                      //         new TextSpan(
                      //           text: 'Terms',
                      //           style: new TextStyle(
                      //               fontSize: 12.5,
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //           recognizer: new TapGestureRecognizer()
                      //             ..onTap = () { launch('https://smartkyatpos.com/privacy.html');
                      //             },
                      //         ),
                      //         new TextSpan(
                      //           text: ', ',
                      //           style: new TextStyle(
                      //               fontSize: 12.5,
                      //               color: Colors.grey,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //         ),
                      //         new TextSpan(
                      //           text: 'Privacy Policy',
                      //           style: new TextStyle(
                      //               fontSize: 12.5,
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //           recognizer: new TapGestureRecognizer()
                      //             ..onTap = () { launch('https://smartkyatpos.com/privacy.html');
                      //             },
                      //         ),
                      //         new TextSpan(
                      //           text: ', and ',
                      //           style: new TextStyle(
                      //               fontSize: 12.5,
                      //               color: Colors.grey,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //         ),
                      //         new TextSpan(
                      //           text: 'Cookie Use.',
                      //           style: new TextStyle(
                      //               fontSize: 12.5,
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //           recognizer: new TapGestureRecognizer()
                      //             ..onTap = () { launch('https://smartkyatpos.com/privacy.html');
                      //             },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 15.0, right: 15.0, bottom: 27.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                                FadeRoute(page: Welcome(),)
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10.0),
                                color: AppTheme.themeColor),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                    child: Container(
                                        child: Text(
                                          isEnglish? 'Set as default': 'Default ထားမည််',textScaleFactor: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1.3,
                                              fontSize: 17.5,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                          ),
                                          strutStyle: StrutStyle(
                                            height: 1.3,
                                            // fontSize:,
                                            forceStrutHeight: true,
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: isLoading,
              //   child: Container(
              //     color: Colors.white,
              //     child: Column(
              //       children: [
              //         Expanded(
              //           child: Center(
              //             child: Padding(
              //               padding: const EdgeInsets.only(bottom: 15.0),
              //               child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
              //                   child: CupertinoActivityIndicator(radius: 15,)),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void startPrintAni() {
    const oneSec = Duration(milliseconds:1000);

    Timer.periodic(oneSec, (Timer t) {
      debugPrint('testted');
      setState(() {
        priProgVal = ((10000 - priProgVal) / 2).round();
      });
    });

    // Future.delayed(const Duration(milliseconds: 2500), () {
    //
    // });
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }
}
