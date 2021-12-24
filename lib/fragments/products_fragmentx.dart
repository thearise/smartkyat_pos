import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
// import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/pages2/multi_assets_page.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';
import 'package:smartkyat_pos/widgets/add_new_category_button.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets/fill_product.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:smartkyat_pos/widgets/version_detatils_view.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:smartkyat_pos/widgets/product_versions_view.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'ad_helper.dart';
import 'banner_full.dart';
import 'banner_leader.dart';
import 'subs/customer_info.dart';

import '../app_theme.dart';
import 'subs/product_info.dart';

// class ProductsFragment extends StatefulWidget {
//   final _callback;
//   final _callback2;
//   final _callback3;
//   final _callback4;
//   final _callback5;
//   final _barcodeBtn;
//
//   ProductsFragment(
//       {
//         required this.productsSnapshot,
//         required this.shopId,
//         required void toggleCoinCallback(),
//         required void toggleCoinCallback2(String str),
//         required void toggleCoinCallback3(String str),
//         required void toggleCoinCallback4(String str),
//         required void toggleCoinCallback5(String str),
//         required void barcodeBtn(),
//         Key? key,
//       })
//       : _callback = toggleCoinCallback,
//         _callback2 = toggleCoinCallback2,
//         _callback3 = toggleCoinCallback3,
//         _callback4 = toggleCoinCallback4,
//         _callback5 = toggleCoinCallback5,
//         _barcodeBtn = barcodeBtn,
//         super(key: key);
//   final String shopId;
//   final productsSnapshot;
//   @override
//   ProductsFragmentState createState() => ProductsFragmentState();
// }

class ProductsFragmentX extends StatelessWidget{

  TextEditingController _searchController = TextEditingController();
  bool loadingSearch = false;

  FocusNode nodeFirst = FocusNode();

  String searchProdCount = '0';

  bool buySellerStatus = false;


  var sectionList;
  var sectionList1;
  var sectionList2;
  var sectionListNo;
  String searchValue = '';
  int slidingSearch = 0;
  bool noSearchData = false;
  bool searchingOverAll = false;
  late TabController _controller;
  late TabController tabController, subTabController;
  String slidedText = 'Products^0';
  String gloSearchText = '';
  int gloSeaProLeng = 0;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(),
    );
  }

}

class SubUnit extends StatefulWidget {
  @override
  State<SubUnit> createState() => _SubUnitState();
}

class _SubUnitState extends State<SubUnit> {
  final List<String> prodFieldsValue = [];

  var nameTECs = <TextEditingController>[];

  var ageTECs = <TextEditingController>[];

  var jobTECs = <TextEditingController>[];

  var cards = <Padding>[];

  Padding createCard() {
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();
    nameTECs.add(nameController);
    ageTECs.add(ageController);
    jobTECs.add(jobController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "#${cards.length + 1} SUB UNIT QUANTITY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      cards.length--;
                      cards.remove(cards);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 30) / 1.74,
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    prodFieldsValue.add(value);
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(
                            color: AppTheme.skBorderColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),

                    focusedBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(
                            color: AppTheme.skThemeColor2, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Units / main unit',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: (MediaQuery.of(context).size.width - 30) / 2.9,
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    prodFieldsValue.add(value);
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(
                            color: AppTheme.skBorderColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),

                    focusedBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(
                            color: AppTheme.skThemeColor2, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Unit name',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              prodFieldsValue.add(value);
              return null;
            },
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(
                      color: AppTheme.skBorderColor, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),

              focusedBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(
                      color: AppTheme.skThemeColor2, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
              suffixText: 'MMK',
              suffixStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
                //fontFamily: 'capsulesans',
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              // errorText: 'Error message',
              labelText: 'Sale price',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              //filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ButtonTheme(
            splashColor: AppTheme.buttonColor2,
            minWidth: MediaQuery.of(context).size.width,
            height: 61,
            child: RaisedButton(
              color: AppTheme.buttonColor2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  side: BorderSide(
                    color: AppTheme.buttonColor2,
                  )),
              onPressed: () {
                if (cards.length == 3) {
                  print('Cards limit reached');
                } else
                  setState(() => cards.add(createCard()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New sub unit?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.add_box_rounded),
                ],
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            return cards[index];
          },
        ),
      ],
    );
  }
}
