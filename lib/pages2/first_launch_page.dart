import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metooltip/metooltip.dart';

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
    {'no': 1, 'keyword': 'Myanmar Kyat (MMK)'},
    {'no': 2, 'keyword': 'US Dollar (USD)'},
  ];
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedTest;

  bool isEnglish = true;

  @override
  initState() {
    _dropdownTestItems = buildDropdownTestItems(_testList);
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      final dynamic tooltip = tTkey.currentState;
      tooltip.handleLongPress();
    });
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
          child: Text(i['keyword']),
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

    setCurrency(selectedTest['keyword'].toString());
    print(selectedTest['keyword'].toString() + ({'no': 1, 'keyword': 'mmk'}).toString() + selectedTest.toString() + ' ' + selectedTest.runtimeType.toString() + ' __ ' + _selectedTest.runtimeType.toString());
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
                                      child: Text('Cloud sync (offline support)', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Real-time and syncronized data across all over devices with automatically offline-data-restore supported.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Text('Finance reports', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Manage payments across all the staff\'s they sell and generate reports to review your finances including sales, stock costs and unpaid orders.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Image.asset('assets/system/features/inventory_status.png', width: 28,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text('Inventory status', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Use inventory states to track and share the status of your inventory as products are received, sold, or an order is fulfilled.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Text('Unlimited products', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Add multiple sub-items of unlimited products such as dozens, items per package and assign their own price, SKU (Stock keeping units), units per package and inventory.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Text('Barcode scans (camera scanner)', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Assign barcodes to products to keeep track of inventory and speed up checkout.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Image.asset('assets/system/features/staffs.png', width: 25,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text('POS staff roles and permissions', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Assign custom roles to store staff ensuring they have the correct permissions.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Image.asset('assets/system/features/order_refunds.png', width: 29,),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text('Order refunds, discounts and debts', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Return items of past purchases from any devices, and apply discounts and debts to each order.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                                      child: Text('Rich customer profiles', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: -0.3
                                      )),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 6),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text('Keep track of contact information, purchase history, lifetime spend, and debts of each customers.', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14, color: Colors.black,
                                            )),
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
                        child: Text('INFORMATION', style: TextStyle(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,color: Colors.grey,
                        ),),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: DropdownBelow(
                          itemWidth: MediaQuery.of(context).size.width-30,
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
                      //             ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
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
                      //             ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
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
                      //             ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
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
                            Navigator.of(context).pop();
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
                                          'Set as default',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
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
}
