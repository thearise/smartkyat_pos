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
import 'package:smartkyat_pos/fragments/bloc_home_week.dart';
import 'package:smartkyat_pos/fragments/bloc_home_year.dart' as BlocHomeYearImp;
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/donut.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:smartkyat_pos/fragments/subs/top_sale_detail.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/pie_chart/simple.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:smartkyat_pos/widgets/apply_discount_to_cart.dart';
import 'package:smartkyat_pos/widgets/line_chart_sample2.dart';
import 'package:smartkyat_pos/widgets/overall_search.dart';
import 'package:smartkyat_pos/widgets/product_details_view2.dart';
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
import 'ad_helper.dart';
import 'subs/customer_info.dart';


class HomeFragment extends StatefulWidget {
  final _callback;
  final _callback2;
  final _callback3;
  final _callback4;
  final _barcodeBtn;
  final _searchBtn;
  final _openDrawerBtn;
  final _closeDrawerBtn;

  HomeFragment({
    required void closeDrawerBtn(String str),
    required void openDrawerBtn(String str),
    required this.ordersSnapshot,
    required this.buyOrdersSnapshot,
    required this.lossSnapshot,
    required this.shopId,
    required void toggleCoinCallback(String str),
    required void toggleCoinCallback2(String str),
    required void toggleCoinCallback3(String str),
    required void toggleCoinCallback4(String str) ,
    required void barcodeBtn(),
    required void searchBtn(),
    Key? key,
  }) :  _callback = toggleCoinCallback,
        _callback2 = toggleCoinCallback2 ,
        _callback3 = toggleCoinCallback3,
        _callback4 = toggleCoinCallback4,
        _barcodeBtn = barcodeBtn,
        _searchBtn = searchBtn,
        _openDrawerBtn = openDrawerBtn,
        _closeDrawerBtn = closeDrawerBtn,
        super(key: key);
  final shopId;
  final ordersSnapshot;
  final buyOrdersSnapshot;
  final lossSnapshot;
  @override
  HomeFragmentState createState() => HomeFragmentState();

// HomeFragment({Key? key, required void toggleCoinCallback()}) : super(key: key);
//
// @override
// _HomeFragmentState createState() => _HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeFragment> {
  String? shopId;
  TextEditingController _searchController = TextEditingController();

  bool loadingSearch = false;

  FocusNode nodeFirst = FocusNode();

  String searchProdCount = '0';

  bool buySellerStatus = false;

  DateTime today = DateTime.now();


  void closeDrawerFrom() {
    widget._closeDrawerBtn('home');
  }

  void openDrawerFrom() {
    widget._openDrawerBtn('home');
  }

  @override
  bool get wantKeepAlive => true;

  // final JiggleController controller = JiggleController();


  // void _jiggleStuff() {
  //   controller.toggle();
  // }


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

  String textSetTotalSales = 'TOTAL SALES';
  String textSetTodaySoFar = 'TODAY SO FAR';
  String textSetStockCosts = 'Stock costs';
  String textSetUnpaid = 'Unpaid';
  String textSetBuys = 'Buys';
  String textSetLoss = 'Loss';
  String textSetToday = 'Day';
  String textSetLastWeek = 'Last week';
  String textSetLastMonth = 'This month';
  String textSetLastYear = 'Last year';
  String textSetLast7Days = 'Last 7 Days';
  String textSetLast28D = 'LAST 28 DAYS';
  String textSetLast12M = 'LAST 12 MONTHS';
  String textSetSearch = 'Search';

  String currencyUnit = 'MMK';

  slidingSearchCont() {

    if(slidingSearch == 0) {
      // print('gg0');
      subTabController.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 1) {
      // print('gg1');
      subTabController.animateTo(1, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 2) {
      // print('gg2');
      subTabController.animateTo(2, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    }
  }

  final cateScCtler = ScrollController();
  int cateScIndex = 0;
  final _width = 10.0;

  DateTime? _dateTime;
  String _format = 'yyyy-MMMM-dd';


  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }


  @override
  initState() {
    _dateTime = DateTime.now();
    print('Timestamp ' + DateTime.now().toString() + ' --> ' + Timestamp.fromMillisecondsSinceEpoch(1599573193925).toString());
    getStoreId().then((value) {
      setState(() {
        shopId = value;
      });
    });



    nodeFirst.addListener(() {
      if(nodeFirst.hasFocus) {
        setState(() {
          loadingSearch = true;
        });
      }
    });

    getCurrency().then((value){
      if(value == 'US Dollar (USD)') {
        setState(() {
          currencyUnit = 'USD';
        });
      } else if(value == 'Myanmar Kyat (MMK)') {
        setState(() {
          currencyUnit = 'MMK';
        });
      }
    });

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetTotalSales = 'စုစုပေါင်း ရောင်းရငွေ';
          textSetTodaySoFar = 'ဒီနေ့အတွင်း';
          textSetStockCosts = 'ဝယ်ယူစရိတ်';
          textSetUnpaid = 'အကြွေးရရန်';
          textSetBuys = 'ဝယ်ယူစရိတ်';
          textSetLoss = 'ဆုံးရှုံး';
          textSetToday = 'နေ့စဉ်';
          textSetLastWeek = 'အပတ်စဉ်';
          textSetLastMonth = 'လစဉ်';
          textSetLastYear = 'နှစ်စဉ်';
          textSetLast7Days = '၇ရက်အတွင်း';
          textSetLast28D = '၂၈ရက်အတွင်း';
          textSetLast12M = '၁၂လအတွင်း';
          textSetSearch = 'ရှာဖွေရန်';
        });
      } else if(value=='english') {
        setState(() {
          textSetTotalSales = 'TOTAL SALES';
          textSetTodaySoFar = 'TODAY SO FAR';
          textSetStockCosts = 'Stock costs';
          textSetUnpaid = 'Unpaid';
          textSetBuys = 'Buys';
          textSetLoss = 'Loss';
          textSetToday = 'Day';
          textSetLastWeek = 'Last week';
          textSetLastMonth = 'This month';
          textSetLastYear = 'This year';
          textSetLast7Days = 'Last 7 Days';
          textSetLast28D = 'LAST 28 DAYS';
          textSetLast12M = 'LAST 12 MONTHS';
          textSetSearch = 'Search';

        });
      }
    });

    // fetchOrders();
    super.initState();
  }

  chgShopIdFrmHomePage() {
    setState(() {
      getStoreId().then((value) => shopId = value);
    });
  }

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

  addProduct1(data) {
    widget._callback3(data);
  }

  addCustomer2Cart1(data) {
    widget._callback2(data);
  }
  addMerchant2Cart(data) {
    widget._callback(data);
  }
  addProduct3(data) {
    widget._callback4(data);
  }

  List<double> thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

  double todayCostsTotal = 0;
  double weekCostsTotal = 0;
  double monthCostsTotal = 0;
  double yearCostsTotal = 0;

  double monthCostsTotal2 = 0;
  double yearCostsTotal2 = 0;
  double monthUnpaidTotal = 0;
  double yearUnpaidTotal = 0;
  double monthRefundTotal = 0;
  double yearRefundTotal = 0;
  double todayRefundTotal = 0;
  double weekRefundTotal = 0;

  double todayCostsTotalR = 0;
  double weekCostsTotalR = 0;
  double monthCostsTotalR = 0;
  double yearCostsTotalR = 0;

  fetchOrders(snapshot0, snapshot1) async {
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 8));
    DateTime monthAgo = today.subtract(const Duration(days: 31));

    thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

    todayCostsTotal = 0;
    weekCostsTotal = 0;
    monthCostsTotal = 0;
    yearCostsTotal = 0;

    todayCostsTotalR = 0;
    weekCostsTotalR = 0;
    monthCostsTotalR = 0;
    yearCostsTotalR = 0;
    todayRefundTotal = 0;
    weekRefundTotal = 0;


    for(int loopOrd = 0; loopOrd < snapshot0.data!.docs.length; loopOrd++) {
      // print('DOC IIDD ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0.data!.docs[loopOrd].data()! as Map<String, dynamic>;

      DateTime dateTimeOrders = data['date'].toDate();
      String dataDate = dateTimeOrders.year.toString() + zeroToTen(dateTimeOrders.month.toString()) + zeroToTen(dateTimeOrders.day.toString());
      print('DOC IIDD2 ' + dataDate.toString() + ' ' + dateTimeOrders.toString());

      int week = 0;
      int month = 0;
      int year = 0;
      sevenDaysAgo = today.subtract(const Duration(days: 8));
      monthAgo = today.subtract(const Duration(days: 31));

      while(!(today.year.toString() == sevenDaysAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(sevenDaysAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(sevenDaysAgo.day.toString()))) {
        sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));

        // print('seven Days Ago ' + sevenDaysAgo.day.toString() + ' ' + week.toString());
        // print('here shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));


        // print('shwe shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));

        if(dataDate == sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString())) {
          double total = 0;
          // print(doc['daily_order'].toString());
          for(String str in data['daily_order']) {
            // print(double.parse(str));
            total += double.parse(str.split('^')[2]);
            weekCostsTotal += double.parse(str.split('^')[5]);
          }
          thisWeekOrdersChart[week] = total;

        }
        week = week + 1;

      }

      while(!(today.year.toString() == monthAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(monthAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(monthAgo.day.toString()))) {
        monthAgo = monthAgo.add(const Duration(days: 1));

        // print('month Days Ago ' + monthAgo.day.toString() + ' ' + month.toString());
        // print('here shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));


        // print('shwe shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));

        if(dataDate == monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString())) {
          double total = 0;
          // print(doc['daily_order'].toString());
          for(String str in data['daily_order']) {
            // print(double.parse(str));
            // print('testing ' + str.split('^')[2]);
            total += double.parse(str.split('^')[2]);
            monthCostsTotal += double.parse(str.split('^')[5]);
          }
          // print('tatoos ' + total.toString());
          // setState(() {
          thisMonthOrdersChart[month] = total;

          // });

        }
        month = month + 1;
      }
      if (dataDate.substring(0,8) == today.year.toString() +
          zeroToTen(today.month.toString()) +
          zeroToTen(today.day.toString())) {
        double total = 0;
        for (String str in data['daily_order']) {
          for(int i=0; i<=24 ; i++ ){
            if(str.split('^')[0].substring(0, 10) == today.year.toString() +
                zeroToTen(today.month.toString()) +
                zeroToTen(today.day.toString()) +
                zeroToTen(i.toString()))
            {
              total += double.parse(str.split('^')[2]);
              todayCostsTotal += double.parse(str.split('^')[5]);
              // setState(() {
              todayOrdersChart[i]+=double.parse(str.split('^')[2]);
              // });
            }
            // print('laos ' + total.toString());
            // print('World ' +todayOrdersChart.toString());
          }
        }


      }
      if (dataDate.substring(0,4) == today.year.toString()){
        double total = 0;
        for (String str in data['daily_order']) {
          // print('DATE CHECK  ' + snapshot0.data!.docs[loopOrd].id);
          for(int i=1; i<=12 ; i++ ){
            // print('helloworld '+i.toString());

            if(str.split('^')[0].substring(0,6) == today.year.toString()+ zeroToTen(i.toString()))
            {
              total += double.parse(str.split('^')[2]);
              yearCostsTotal += double.parse(str.split('^')[5]);
              // setState(() {
              thisYearOrdersChart[i]+=double.parse(str.split('^')[2]);
              // print('fortune ' +thisYearOrdersChart.toString());
              // });
            }
            //print('laos ' + total.toString());

          }
        }
      }
    }

    // print('each ');
    if(snapshot1.data != null) {
      for(int loopOrd = 0; loopOrd < snapshot1.data!.docs.length; loopOrd++) {
        print('DOC IIDDCost ' + snapshot1.data!.docs[loopOrd].id.toString());
        Map<String, dynamic> data = snapshot1.data!.docs[loopOrd].data()! as Map<String, dynamic>;

        DateTime dateTimeOrders = data['date'].toDate();
        String dataDate = dateTimeOrders.year.toString() + zeroToTen(dateTimeOrders.month.toString()) + zeroToTen(dateTimeOrders.day.toString());
        print('DOC IIDD2 ' + dataDate.toString() + ' ' + dateTimeOrders.toString());

        int week = 0;
        int month = 0;
        int year = 0;
        sevenDaysAgo = today.subtract(const Duration(days: 8));
        monthAgo = today.subtract(const Duration(days: 31));

        while(!(today.year.toString() == sevenDaysAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(sevenDaysAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(sevenDaysAgo.day.toString()))) {
          sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));

          // print('seven Days Ago ' + sevenDaysAgo.day.toString() + ' ' + week.toString());
          // print('here shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));


          // print('shwe shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));

          if(dataDate == sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString())) {
            double total = 0;
            // print(doc['daily_order'].toString());
            for(String str in data['daily_order']) {
              // print(double.parse(str));
              weekCostsTotalR += double.parse(str.split('^')[2]);
            }

          }
          week = week + 1;

        }

        while(!(today.year.toString() == monthAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(monthAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(monthAgo.day.toString()))) {
          monthAgo = monthAgo.add(const Duration(days: 1));

          // print('month Days Ago ' + monthAgo.day.toString() + ' ' + month.toString());
          // print('here shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));


          // print('shwe shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));

          if(dataDate == monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString())) {
            double total = 0;
            // print(doc['daily_order'].toString());
            for(String str in data['daily_order']) {
              monthCostsTotalR += double.parse(str.split('^')[2]);
            }

          }
          month = month + 1;
        }
        if (dataDate.substring(0,8) == today.year.toString() +
            zeroToTen(today.month.toString()) +
            zeroToTen(today.day.toString())) {
          double total = 0;
          for (String str in data['daily_order']) {
            for(int i=0; i<=24 ; i++ ){
              if(str.split('^')[0].substring(0, 10) == today.year.toString() +
                  zeroToTen(today.month.toString()) +
                  zeroToTen(today.day.toString()) +
                  zeroToTen(i.toString()))
              {
                todayCostsTotalR += double.parse(str.split('^')[2]);
              }
            }
          }


        }
        if (dataDate.substring(0,4) == today.year.toString()){
          double total = 0;
          for (String str in data['daily_order']) {
            // print('DATE CHECK  ' + snapshot0.data!.docs[loopOrd].id);
            for(int i=1; i<=12 ; i++ ) {
              // print('helloworld '+i.toString());

              if(str.split('^')[0].substring(0,6) == today.year.toString()+ zeroToTen(i.toString()))
              {
                yearCostsTotalR += double.parse(str.split('^')[2]);
                // print('fortune ' +thisYearOrdersChart.toString());
                // });
              }
              //print('laos ' + total.toString());

            }
          }
        }

        // setState(() {
        //   // print('CHECK todayCOSTS ' + todayCostsTotal.toString());
        // });

        // while(!(today.year.toString() == yearAgo.year.toString() && today.month.toString() == yearAgo.month.toString() && today.day.toString() == yearAgo.day.toString())) {
        //   yearAgo = yearAgo.add(const Duration(days: 1));
        //
        //   if(doc['date'] == yearAgo.year.toString() + zeroToTen(yearAgo.month.toString()) + zeroToTen(yearAgo.day.toString())) {
        //     double total = 0;
        //     // print(doc['daily_order'].toString());
        //     for(String str in doc['daily_order']) {
        //       // print(double.parse(str));
        //       total += double.parse(str.split('^')[2]);
        //     }
        //     print('total ' + total.toString());
        //     setState(() {
        //       thisYearOrdersChart[year] = total;
        //     });
        //
        //   }
        //   year = year + 1;
        //
        // }
        // print('this year' + thisYearOrdersChart.toString());
        // print('this week ' + thisWeekOrdersChart.toString());
        // for(int j = 20210909; j <= 20210915; j++) {
        //
        //   // print('seven Days Ago 2 ' + sevenDaysAgo.day.toString() + ' ' + ij.toString());
        //   print('here shwe 2 ' + j.toString());
        //   // if(doc['date'] == j.toString()) {
        //   //   double total = 0;
        //   //   // print(doc['daily_order'].toString());
        //   //   for(String str in doc['daily_order']) {
        //   //     // print(double.parse(str));
        //   //     total += double.parse(str.split('^')[2]);
        //   //   }
        //   //   print('total ' + total.toString());
        //   //   setState(() {
        //   //     thisWeekOrdersChart[ij] = total;
        //   //   });
        //   //
        //   // }
        //   // ij = ij + 1;
        //   // print(ij);
        // }


        // print('this week 2' + thisWeekOrdersChart.toString());

        // print('each ' + doc.id.toString());
      }
    } else {
      print('null pix');
    }

  }

  fetchOrdersMY(snapshot0, snapshot1) async {
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 8));
    DateTime monthAgo = today.subtract(const Duration(days: 31));

    thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

    monthCostsTotal2 = 0;
    yearCostsTotal2 = 0;
    monthUnpaidTotal = 0;
    yearUnpaidTotal = 0;
    monthRefundTotal = 0;
    yearRefundTotal = 0;



    print('docs ' + snapshot0.data!.docs.toString());


    for(int loopOrd = 0; loopOrd < snapshot0.data!.docs.length; loopOrd++) {
      print('George sai 0 ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0.data!.docs[loopOrd].data()! as Map<String, dynamic>;

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_cust'];
          print('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_cust'].toString());
        }
      }

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'] != null) {
          // thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          monthCostsTotal2 +=  data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          print('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'].toString());
        }
      }

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          // thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          monthUnpaidTotal +=  data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'debt_cust'];
          print('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'debt_cust'].toString());
        }
      }

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          // thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          monthRefundTotal +=  data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'refu_cust'];
          print('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'refu_cust'].toString());
        }
      }
    }



  }

  fetchOrdersYY(snapshot0, snapshot1) async {
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 8));
    DateTime monthAgo = today.subtract(const Duration(days: 31));

    thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

    //monthCostsTotal2 = 0;
    yearCostsTotal2 = 0;
    // monthUnpaidTotal = 0;
    yearUnpaidTotal = 0;
    // monthRefundTotal = 0;
    yearRefundTotal = 0;

    print('docs ' + snapshot0.data!.docs.toString());


    for(int loopOrd = 0; loopOrd < snapshot0.data!.docs.length; loopOrd++) {
      print('George Y sai 0 ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0.data!.docs[loopOrd].data()! as Map<String, dynamic>;
      for(int i = 0; i<= 12; i++) {
        print('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          thisYearOrdersChart[i] += thisYearOrdersChart[i] + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'];
          print('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'].toString());
        }
      }

      for(int i = 0; i<= 12; i++) {
        print('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'] != null) {
          yearCostsTotal2 +=  data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'];
          print('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'].toString());
        }
      }

      for(int i = 0; i<= 12; i++) {
        print('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          yearUnpaidTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'];
          print('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'].toString());
        }
      }

      for(int i = 0; i<= 12; i++) {
        print('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          yearRefundTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'];
          print('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'].toString());
        }
      }

    }



  }

  zeroToTen(String string) {
    if(int.parse(string) > 9) {
      return string;
    } else {
      return '0'+string;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  int _counter = 0;


  List<Color> gradientColors = [
    // AppTheme.badgeFgSecond
    Colors.Colors.blue
    // const Color(0xff23b6e6),
    // const Color(0xff02d39a),
  ];

  bool showAvg = false;

  void closeSearch() {
    _searchController.clear();
    // print('clicked testing ');
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSearch = false;
    });
  }
  void unfocusSearch() {
    // print('clicked testing 2');
    FocusScope.of(context).unfocus();
  }

  searchFocus() {
    setState(() {
      loadingSearch = true;
    });
  }



  int findMax(List<int> numbers) {
    return numbers.reduce(max);
  }

  String changeMonth2String(String str) {
    if(str == '1') {
      return 'Jan';
    } else if(str == '2') {
      return 'Feb';
    } else if(str == '3') {
      return 'Mar';
    } else if(str == '4') {
      return 'Apr';
    } else if(str == '5') {
      return 'May';
    } else if(str == '6') {
      return 'Jun';
    } else if(str == '7') {
      return 'Jul';
    } else if(str == '8') {
      return 'Aug';
    } else if(str == '9') {
      return 'Sep';
    } else if(str == '10') {
      return 'Oct';
    } else if(str == '11') {
      return 'Nov';
    } else if(str == '12') {
      return 'Dec';
    } else {
      return '';
    }
  }

  double funChange(max) {
    // print(findMax(roundWeek));
    max = max/chgDeci3Place(max);
    // print('gg ' + (5.0 - max).toString());
    return 5.0 - max;
  }

  double chgDeci3Place(max) {
    double ten = 10.0;
    for(int i = 0; i<max.toString().length - 2; i++) {
      ten = ten * 10;
    }
    return ten;
    // print('length ' + ten.toString().toString());
  }

  int _sliding = 0;


  late final bool showPerformanceOverlay;
  late final ValueChanged<bool> onShowPerformanceOverlayChanged;
  late final a11yGalleries = a11y.buildGallery();
  late final barGalleries = bar.buildGallery();
  late final timeSeriesGalleries = time_series.buildGallery();
  late final lineGalleries = line.buildGallery();
  late final scatterPlotGalleries = scatter_plot.buildGallery();
  late final comboGalleries = combo.buildGallery();
  late final pieGalleries = pie.buildGallery();
  late final axesGalleries = axes.buildGallery();
  late final behaviorsGalleries = behaviors.buildGallery();
  late final i18nGalleries = i18n.buildGallery();
  late final legendsGalleries = legends.buildGallery();

  bool searchOpening = false;

  bool searchOpeningR = false;

  changeSearchOpening(bool index) {
    // setState(() {
    //   searchOpening = index;
    // });
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   setState(() {
    //     searchOpeningR = index;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var galleries = <Widget>[];

    galleries.addAll(
        a11yGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example bar charts.
    galleries.addAll(
        barGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example time series charts.
    galleries.addAll(timeSeriesGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example line charts.
    galleries.addAll(
        lineGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example scatter plot charts.
    galleries.addAll(scatterPlotGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example pie charts.
    galleries.addAll(
        comboGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example pie charts.
    galleries.addAll(
        pieGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example custom axis.
    galleries.addAll(
        axesGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    galleries.addAll(behaviorsGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add legends examples
    galleries.addAll(legendsGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add examples for i18n.
    galleries.addAll(
        i18nGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    _setupPerformance();

    List<int> roundToday = [];
    for(double dbl in todayOrdersChart) {
      roundToday.add(dbl.round());
    }


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
        child: Container()
        // child: Container(
        //   color: Colors.Colors.white,
        //   child: SafeArea(
        //     top: true,
        //     bottom: true,
        //     child: Container(
        //       // width: MediaQuery.of(context).size.width > 900
        //       //     ? MediaQuery.of(context).size.width * (2 / 3.5)
        //       //     : MediaQuery.of(context).size.width,
        //       child: Stack(
        //         children: [
        //           if(!searchOpening)
        //             Align(
        //               alignment: Alignment.centerLeft,
        //               child: Padding(
        //                 padding: const EdgeInsets.only(top: 81.0),
        //                 child: Container(
        //                   height: MediaQuery.of(context).size.height -
        //                       MediaQuery.of(context).padding.top -
        //                       MediaQuery.of(context).padding.bottom -
        //                       100,
        //                   width: MediaQuery.of(context).size.width,
        //                   color: Colors.Colors.white,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(
        //                         top: 0.0, left: 0.0, right: 0.0),
        //
        //                     child: cateScIndex == 0 || cateScIndex == 1?
        //                     BlocHomeWeek(
        //                       dateTime: today,
        //                       key: valueKeyTog(),
        //                       shopId: widget.shopId,
        //                       query: ordersQuery(),
        //                       itemBuilder: (context1, documentSnapshots, index) {
        //                         Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;
        //
        //                         String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
        //                         return Container(child: Padding(
        //                           padding: const EdgeInsets.all(20.0),
        //                           child: Text('items ' + item.toString()),
        //                         ));
        //                       },
        //                       resetState: resetState,
        //                       selectedIntVal: selectedIntVal,
        //                       intValIni : cateScIndex,
        //                       itemBuilderType:
        //                       PaginateBuilderType.listView,
        //                       isLive: true,
        //                     ):
        //                     cateScIndex == 3?
        //                     BlocHomeYearImp.BlocHomeYear(
        //                       dateTime: today,
        //                       key: valueKeyTog(),
        //                       shopId: widget.shopId,
        //                       query: ordersQueryYear(),
        //                       itemBuilder: (context1, documentSnapshots, index) {
        //                         Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;
        //
        //                         String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
        //                         return Container(child: Padding(
        //                           padding: const EdgeInsets.all(20.0),
        //                           child: Text('items ' + item.toString()),
        //                         ));
        //                       },
        //                       resetState: resetState,
        //                       selectedIntVal: selectedIntVal,
        //                       intValIni : cateScIndex,
        //                       itemBuilderType:
        //                       BlocHomeYearImp.PaginateBuilderType.listView,
        //                       isLive: true,
        //                     ):
        //                     BlocHomeMonthImp.BlocHomeMonth(
        //                       dateTime: today,
        //                       key: valueKeyTog(),
        //                       shopId: widget.shopId,
        //                       query: ordersQueryMonth(),
        //                       itemBuilder: (context1, documentSnapshots, index) {
        //                         Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;
        //
        //                         String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
        //                         return Container(child: Padding(
        //                           padding: const EdgeInsets.all(20.0),
        //                           child: Text('items ' + item.toString()),
        //                         ));
        //                       },
        //                       resetState: resetState,
        //                       selectedIntVal: selectedIntVal,
        //                       intValIni : cateScIndex,
        //                       itemBuilderType:
        //                       BlocHomeMonthImp.PaginateBuilderType.listView,
        //                       isLive: true,
        //                     )
        //                     ,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           if(searchOpeningR)
        //             Container(
        //               height: MediaQuery.of(context).size.height,
        //               color: Colors.Colors.white,
        //               child: Center(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(top: 30.0),
        //                   child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
        //                       child: CupertinoActivityIndicator(radius: 15,)),
        //                 ),
        //               ),
        //             ),
        //           Align(
        //             alignment: Alignment.topCenter,
        //             child: Container(
        //               decoration: BoxDecoration(
        //                   color: Colors.Colors.white,
        //                   border: Border(
        //                     bottom: BorderSide(
        //                         color: AppTheme.skBorderColor2,
        //                         width: 1.0),
        //                   )
        //               ),
        //               child: Padding(
        //                 padding: const EdgeInsets.only(
        //                     top: 15.0, left: 15.0, right: 15.0, bottom: 15),
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     widget._searchBtn();
        //                     // FocusScope.of(context).requestFocus(nodeFirst);
        //                     // setState(() {
        //                     //   loadingSearch = true;
        //                     // });
        //                     // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        //                   },
        //                   child: Container(
        //                     decoration: BoxDecoration(
        //                       border: Border.all(
        //                         color: loadingSearch? Colors.Colors.blue: Colors.Colors.transparent,
        //                         style: BorderStyle.solid,
        //                         width: 1.0,
        //                       ),
        //                       color: AppTheme.secButtonColor,
        //                       borderRadius: BorderRadius.circular(10.0),
        //                     ),
        //                     height: 50,
        //                     child: Padding(
        //                       padding: const EdgeInsets.only(
        //                           top: 10.0, bottom: 11.0),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           GestureDetector(
        //                             onTap: () {
        //
        //                               // if(loadingSearch) {
        //                               //   _searchController.clear();
        //                               //   FocusScope.of(context).unfocus();
        //                               //   setState(() {
        //                               //     loadingSearch = false;
        //                               //   });
        //                               // } else {
        //                               //   FocusScope.of(context).requestFocus(nodeFirst);
        //                               //   setState(() {
        //                               //     loadingSearch = true;
        //                               //   });
        //                               //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        //                               // }
        //                             },
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(left: 12.0),
        //                               child: Container(
        //                                 child: Stack(
        //                                   children: [
        //                                     !loadingSearch? Padding(
        //                                       padding: const EdgeInsets.only(left: 5.0),
        //                                       child: Icon(
        //                                         SmartKyat_POS.search,
        //                                         size: 17,
        //                                       ),
        //                                     ): Padding(
        //                                       padding: const EdgeInsets.only(left: 2, bottom: 1.0),
        //                                       child: Icon(
        //                                         Icons.close_rounded,
        //                                         size: 24,
        //                                       ),
        //                                     )
        //
        //                                   ],
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                           // Expanded(
        //                           //   child: Padding(
        //                           //     padding: EdgeInsets.only(
        //                           //         left: !loadingSearch? 8.0: 4,
        //                           //         right: 8.0,
        //                           //         top: 0.5),
        //                           //     child: Text('Search'),
        //                           //   ),
        //                           // ),
        //                           Expanded(
        //                             child: Padding(
        //                                 padding: EdgeInsets.only(
        //                                     left: 13,
        //                                     bottom: 1.5),
        //                                 child: Text(
        //                                   textSetSearch,
        //                                   style: TextStyle(
        //                                       fontSize: 18,
        //                                       fontWeight: FontWeight.w500,
        //                                       color: Colors.Colors.black.withOpacity(0.55)
        //                                   ),
        //                                   strutStyle: StrutStyle(
        //                                       forceStrutHeight: true,
        //                                       height: textSetSearch == 'Search'? 1.6: 1.3
        //                                   ),
        //                                 )
        //                             ),
        //                           ),
        //                           GestureDetector(
        //                             onTap: () {
        //                               widget._barcodeBtn();
        //                             },
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                 right: 15.0,
        //                               ),
        //                               // child: Icon(
        //                               //   SmartKyat_POS.barcode,
        //                               //   color: Colors.Colors.black,
        //                               //   size: 25,
        //                               // ),
        //                               child: Container(
        //                                   child: Image.asset('assets/system/barcode.png', height: 28,)
        //                               ),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),                  // _isBannerAdReady? Align(
        //           //   alignment: Alignment.topCenter,
        //           //   child: Container(
        //           //     height: _bannerAd.size.height.toDouble(),
        //           //     width: _bannerAd.size.width.toDouble(),
        //           //     child: AdWidget(ad: _bannerAd),
        //           //   )
        //           // ): Container(),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  void _setupPerformance() {
    // Change [printPerformance] to true and set the app to release mode to
    // print performance numbers to console. By default, Flutter builds in debug
    // mode and this mode is slow. To build in release mode, specify the flag
    // blaze-run flag "--define flutter_build_mode=release".
    // The build target must also be an actual device and not the emulator.
    charts.Performance.time = (String tag) => Timeline.startSync(tag);
    charts.Performance.timeEnd = (_) => Timeline.finishSync();
  }

  String titleTextBySlide() {
    if(_sliding == 0) {
      return textSetTodaySoFar;
    } else if(_sliding == 1) {
      return textSetLast7Days;
    } else if(_sliding == 2) {
      // return textSetLast28D;
      if(today.month == 1) {
        return 'JANUARY ' + today.year.toString();
      } else if(today.month == 2) {
        return 'FEBRUARY ' + today.year.toString();
      } else if(today.month == 3) {
        return 'MARCH ' + today.year.toString();
      } else if(today.month == 4) {
        return 'APRIL ' + today.year.toString();
      } else if(today.month == 5) {
        return 'MAY ' + today.year.toString();
      } else if(today.month == 6) {
        return 'JUNE ' + today.year.toString();
      } else if(today.month == 7) {
        return 'JULY ' + today.year.toString();
      } else if(today.month == 8) {
        return 'AUGUST ' + today.year.toString();
      } else if(today.month == 9) {
        return 'SEPTEMBER ' + today.year.toString();
      } else if(today.month == 10) {
        return 'OCTOBER ' + today.year.toString();
      } else if(today.month == 11) {
        return 'NOVEMBER ' + today.year.toString();
      } else {
        return 'DECEMBER ' + today.year.toString();
      }
    } else {
      // return textSetLast12M;
      return 'YEAR ' + today.year.toString();
    }
  }

  String totalStockCostsBySlide() {
    if(_sliding == 0) {
      return todayCostsTotal.toString();
    } else if(_sliding == 1) {
      return weekCostsTotal.toString();
    } else if(_sliding == 2) {
      return monthUnpaidTotal.toString();
    } else {
      return yearUnpaidTotal.toString();
    }
  }

  String totalStockCostsRBySlide() {
    if(_sliding == 0) {
      return todayCostsTotalR.toString();
    } else if(_sliding == 1) {
      return weekCostsTotalR.toString();
    } else if(_sliding == 2) {
      return monthCostsTotal2.toString();
    } else {
      return yearCostsTotal2.toString();
    }
  }

  String totalRefundBySlide() {
    if(_sliding == 0) {
      return todayRefundTotal.toString();
    } else if(_sliding == 1) {
      return weekRefundTotal.toString();
    } else if(_sliding == 2) {
      return monthRefundTotal.toString();
    } else {
      return yearRefundTotal.toString();
    }
  }

  String totalBySlide() {
    double todayTotal=0.0;
    for (int i = 0; i < todayOrdersChart.length; i++){
      todayTotal += todayOrdersChart[i];
    }

    double monthlyTotal=0.0;
    for (int i = 0; i < thisMonthOrdersChart.length; i++){
      monthlyTotal += thisMonthOrdersChart[i];
    }

    double weeklyTotal=0.0;
    for (int i = 0; i < thisWeekOrdersChart.length; i++){
      weeklyTotal += thisWeekOrdersChart[i];
    }

    double yearlyTotal=0.0;
    for (int i = 0; i < thisYearOrdersChart.length; i++){
      yearlyTotal += thisYearOrdersChart[i];
    }
    if(_sliding == 0) {
      return todayTotal.toStringAsFixed(2);
    } else if(_sliding == 1) {
      return weeklyTotal.toStringAsFixed(2);
    } else if(_sliding == 2) {
      return monthlyTotal.toStringAsFixed(2);
    } else {
      return yearlyTotal.toStringAsFixed(2);
    }
  }

  // String totalCostsBySlide() {
  //   double todayTotal=0.0;
  //   for (int i = 0; i < todayOrdersChart.length; i++){
  //     todayTotal += todayOrdersChart[i];
  //   }
  //
  //   double monthlyTotal=0.0;
  //   for (int i = 0; i < thisMonthOrdersChart.length; i++){
  //     monthlyTotal += thisMonthOrdersChart[i];
  //   }
  //
  //   double weeklyTotal=0.0;
  //   for (int i = 0; i < thisWeekOrdersChart.length; i++){
  //     weeklyTotal += thisWeekOrdersChart[i];
  //   }
  //
  //   double yearlyTotal=0.0;
  //   for (int i = 0; i < thisYearOrdersChart.length; i++){
  //     yearlyTotal += thisYearOrdersChart[i];
  //   }
  //   if(_sliding == 0) {
  //     return todayTotal.toStringAsFixed(2);
  //   } else if(_sliding == 1) {
  //     return weeklyTotal.toStringAsFixed(2);
  //   } else if(_sliding == 2) {
  //     return monthlyTotal.toStringAsFixed(2);
  //   } else {
  //     return yearlyTotal.toStringAsFixed(2);
  //   }
  // }

  String selectDaysCast() {
    print("TTT " + today.year.toString().length.toString());
    // if(_sliding==0) {
    // today.year.toString().substring(today.year.toString().length-2, today.year.toString().length
    if(today.month == 9) {
      return 'Sep ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 1) {
      return 'Jan ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 2) {
      return 'Feb ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 3) {
      return 'Mar ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 4) {
      return 'Apr ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 5) {
      return 'May ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 6) {
      return 'Jun ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 7) {
      return 'Jul ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 8) {
      return 'Aug ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 10) {
      return 'Oct ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 11) {
      return 'Nov ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 12) {
      return 'Dec ' + today.day.toString() + ', ' + today.year.toString();
    } else {
      return '';
    }

  }

  todayToYearStart() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-00-00 00:00:00');
    print('DDDD ' + yearStart.toString());
    return yearStart;
  }

  lossDayStart() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59');
    print('DDDD ' + yearStart.toString());
    return yearStart;
  }

  lossDayEnd() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime notTday = today;
    if(cateScIndex == 0) {
      notTday = today;
      DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-' + zeroToTen(notTday.day.toString()) + ' 00:00:00');
      print('DDDD ' + yearStart.toString());
      return yearStart;
    } else if(cateScIndex == 1) {
      notTday = today.subtract(Duration(days: 6));
      DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-' + zeroToTen(notTday.day.toString()) + ' 00:00:00');
      print('DDDD ' + yearStart.toString());
      return yearStart;
    } else if(cateScIndex == 2) {
      notTday = today.subtract(Duration(days: 27));
      DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-' + zeroToTen(notTday.day.toString()) + ' 00:00:00');
      print('DDDD ' + yearStart.toString());
      return yearStart;
    } else {
      DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-00-00 00:00:00');
      print('DDDD ' + yearStart.toString());
      return yearStart;
    }

  }

  calMonth(month) {
    var calMonth = 0;
    if(month == 1) {
      calMonth = 12;
    }
    else
    calMonth = month - 1;

    return calMonth;

  }

  calYear(month, year) {
    var  calYear = 0;
    if(month == 1) {
      calYear = year -1;
    }
    else
      calYear = year;

    return calYear;
  }

  ordersQuery() {
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId.toString()).collection('orders')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 14)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 14)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 14)).day.toString()) + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen((today.month).toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59'))
        .orderBy('date', descending: true);
  }

  ordersQueryYear() {
    return FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders_yearly')
        .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse((today.year - 1).toString() + '-01-01' + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString()  + '-12-31 23:59:59'));
  }

  ordersQueryMonth() {
    return FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders_monthly')
        .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse( calYear(today.month, today.year).toString() + '-' + zeroToTen( calMonth(today.month).toString()) + '-01' + ' 00:00:00'))
        .where('date', isLessThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + ((DateTime(_dateTime!.year, _dateTime!.month + 1, 0).day+1).toInt() - 2).toString() + ' 23:59:59'));
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

  resetState(DateTime resetD) {
    setState(() {
      today = resetD;
    });
  }

  selectedIntVal(int index) {
    setState(() {
      cateScIndex = index;
    });
  }
}


