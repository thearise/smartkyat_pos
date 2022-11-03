import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:one_context/one_context.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/bloc_home_month.dart' as BlocHomeMonthImp;
import 'package:smartkyat_pos/fragments/bloc_home_year.dart' as BlocHomeYearImp;
import 'package:smartkyat_pos/fragments/bloc_prod_week.dart';
import 'package:smartkyat_pos/fragments/bloc_prod_week_only.dart' as BlocProdWeekWeekImp;
import 'package:smartkyat_pos/fragments/bloc_prod_month.dart' as BlocProdMonthImp;
import 'package:smartkyat_pos/fragments/bloc_prod_year.dart' as BlocProdYearImp;
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/donut.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:smartkyat_pos/fragments/subs/top_sale_detail.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/pie_chart/simple.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:smartkyat_pos/widgets/apply_discount_to_cart.dart';
import 'package:smartkyat_pos/widgets/line_chart_sample2.dart';
import 'package:smartkyat_pos/widgets/overall_search.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:vector_math/vector_math_64.dart';
import '../app_theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../a11y/a11y_gallery.dart' as a11y show buildGallery;
import '../bar_chart/bar_gallery.dart' as bar show buildGallery;
import '../gallery_scaffold.dart';
import '../time_series_chart/time_series_gallery.dart' as time_series
    show buildGallery;
import '../line_chart/line_gallery.dart' as line show buildGallery;
import '../scatter_plot_chart/scatter_plot_gallery.dart' as scatter_plot
    show buildGallery;
import '../combo_chart/combo_gallery.dart' as combo show buildGallery;
import '../pie_chart/pie_gallery.dart' as pie show buildGallery;
import '../axes/axes_gallery.dart' as axes show buildGallery;
import '../behaviors/behaviors_gallery.dart' as behaviors show buildGallery;
import '../i18n/i18n_gallery.dart' as i18n show buildGallery;
import '../legends/legends_gallery.dart' as legends show buildGallery;


class ProdSaleSumHome extends StatefulWidget {
  final _openDrawerBtn;
  final _closeDrawerBtn;

  ProdSaleSumHome({
    required void closeDrawerBtn(String str),
    required void openDrawerBtn(String str),
    required this.shopId,
    required this.isEnglish,
    required this.tab,
    Key? key,
  }) :
        _openDrawerBtn = openDrawerBtn,
        _closeDrawerBtn = closeDrawerBtn;
  final shopId;
  final bool isEnglish;
  final int tab;
  @override
  ProdSaleSumHomeState createState() => ProdSaleSumHomeState();

// ProdSaleSumHome({Key? key, required void toggleCoinCallback()}) : super(key: key);
//
// @override
// _ProdSaleSumHomeState createState() => _ProdSaleSumHomeState();
}

class ProdSaleSumHomeState extends State<ProdSaleSumHome>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProdSaleSumHome> {

  @override
  bool get wantKeepAlive => true;

  var prodsSnap;

  @override
  initState() {
    if(widget.tab == 0) {
      cateScIndex = 0;
    } else if (widget.tab == 1) {
      cateScIndex = 2;
    } else {
      cateScIndex = 3;
    }
    prodsSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr').snapshots();
    // prodSaleData =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodSaleData')
    //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.dateTime!.year.toString() + '-' + zeroToTen(widget.dateTime!.month.toString()) + '-' + zeroToTen(widget.dateTime!.day.toString()) + ' 00:00:00').subtract(Duration(days: 6)))
    //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.dateTime!.year.toString() + '-' + zeroToTen((widget.dateTime!.month).toString()) + '-' + zeroToTen(widget.dateTime!.day.toString()) + ' 23:59:59'))
    //     .orderBy('date', descending: true)
    //     .snapshots();
    super.initState();
  }

  var today = DateTime.now();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        toolbarHeight: 0,
        backgroundColor: Colors.Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.Colors.white,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Container(
              // width: MediaQuery.of(context).size.width > 900
              //     ? MediaQuery.of(context).size.width * (2 / 3.5)
              //     : MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: 81,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.Colors.grey.withOpacity(0.3),
                                width: 1.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                                  color: Colors.Colors.grey.withOpacity(0.3)),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 17,
                                      color: Colors.Colors.black,
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
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    widget.isEnglish? "Reports": 'တင်ပြချက်', textScaleFactor: 1,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis
                                      // height: 1.5
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.4,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 0.0),
                                  child: Text(
                                    widget.isEnglish? "Product sale detail": 'ပစ္စည်းအရောင်းထွက်စာရင်း', textScaleFactor: 1,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      // height: 1.3
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.7,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 81.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            100,
                        child: cateScIndex == 0 ?BlocProdWeek(
                          prodsSnap: prodsSnap,
                          isEnglish: widget.isEnglish,
                          dateTime: today,
                          // key: valueKeyTog(),
                          shopId: widget.shopId,
                          query: prodsQuery(),
                          itemBuilder: (context1, documentSnapshots, index) {
                            Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;

                            String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
                            return Container(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('items ' + item.toString()),
                            ));
                          },
                          resetState: resetState,
                          selectedIntVal: selectedIntVal,
                          intValIni : cateScIndex,
                          sortIndex : sortIndex,
                          initialIndex : sortIndexItem,
                          itemBuilderType:
                          PaginateBuilderType.listView,
                          isLive: true,
                        ): cateScIndex == 1? BlocProdWeekWeekImp.BlocProdWeekWeek(
                          prodsSnap: prodsSnap,
                          isEnglish: widget.isEnglish,
                          dateTime: today,
                          key: valueKeyTog(),
                          shopId: widget.shopId,
                          query: prodsQuery(),
                          itemBuilder: (context1, documentSnapshots, index) {
                            Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;

                            String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
                            return Container(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('items ' + item.toString()),
                            ));
                          },
                          resetState: resetState,
                          selectedIntVal: selectedIntVal,
                          intValIni : cateScIndex,
                          sortIndex : sortIndex,
                          initialIndex : sortIndexItem,
                          itemBuilderType:
                          BlocProdWeekWeekImp.PaginateBuilderType.listView,
                          isLive: true,
                        ): cateScIndex==2? BlocProdMonthImp.BlocProdMonth(
                          prodsSnap: prodsSnap,
                          isEnglish: widget.isEnglish,
                          sortIndex : sortIndex,
                          initialIndex : sortIndexItem,
                          dateTime: today,
                          key: valueKeyTog(),
                          shopId: widget.shopId,
                          query: prodsQueryMonth(),
                          itemBuilder: (context1, documentSnapshots, index) {
                            Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;

                            String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
                            return Container(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('items ' + item.toString()),
                            ));
                          },
                          resetState: resetState,
                          selectedIntVal: selectedIntVal,
                          intValIni : cateScIndex,
                          itemBuilderType:
                          BlocProdMonthImp.PaginateBuilderType.listView,
                          isLive: true,
                        ): BlocProdYearImp.BlocProdYear(
                          prodsSnap: prodsSnap,
                          isEnglish: widget.isEnglish,
                          dateTime: today,
                          key: valueKeyTog(),
                          shopId: widget.shopId,
                          query: prodsQueryYear(),
                          itemBuilder: (context1, documentSnapshots, index) {
                            Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;

                            String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
                            return Container(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('items ' + item.toString()),
                            ));
                          },
                          resetState: resetState,
                          selectedIntVal: selectedIntVal,
                          intValIni : cateScIndex,
                          sortIndex : sortIndex,
                          initialIndex : sortIndexItem,
                          itemBuilderType:
                          BlocProdYearImp.PaginateBuilderType.listView,
                          isLive: true,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  int sortIndexItem = 0;

  sortIndex(int data) {
    setState(() {
      sortIndexItem = data;
    });
  }

  prodsQuery() {
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodSaleData')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 00:00:00').subtract(Duration(days: 6)))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen((today.month).toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59'))
        .orderBy('date', descending: true);
  }

  prodsQueryMonth() {
    debugPrint('start ddd ' + DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-01 00:00:00').toString());
    debugPrint('enddd ddd ' + DateFormat("yyyy-MM-dd HH:mm:ss").parse(nextYear(today.month, today.year).toString() + '-' + zeroToTen((nextMonth(today.month)).toString()) + '-00 23:59:59').toString());

    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodMthData')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-01 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(nextYear(today.month, today.year).toString() + '-' + zeroToTen((nextMonth(today.month)).toString()) + '-00 23:59:59'))
        .orderBy('date', descending: true);
  }

  prodsQueryYear() {
    debugPrint('start dddy ' + DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00').toString());
    debugPrint('enddd dddy ' + DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-12-31 23:59:59').toString());

    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodYearData')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-12-31 23:59:59'))
        .orderBy('date', descending: true);
  }

  nextMonth(int month) {
    if(month == 12) {
      return 1;
    } else {
      return month + 1;
    }
  }

  nextYear(int month, int year) {
    if(month == 12) {
      return year+1;
    } else {
      return year;
    }
  }

  resetState(DateTime resetD) {
    setState(() {
      today = resetD;
    });
  }

  int cateScIndex = 0;

  selectedIntVal(int index) {
    setState(() {
      cateScIndex = index;
    });
  }

  String valKTog = '0';

  valueKeyTog() {
    valKTog = today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString());
    return ValueKey<String>(valKTog.toString());
    // if(valKTog == 0) {
    //   valKTog = 1;
    //   return ValueKey<String>(valKTog.toString());
    // } else {
    //   valKTog = 0;
    //   return ValueKey<String>(valKTog.toString());
    // }

  }
}
