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
import 'package:smartkyat_pos/fragments/bloc_home_month_dc.dart' as BlocHomeMonthDcImp;
import 'package:smartkyat_pos/fragments/bloc_home_week.dart';
import 'package:smartkyat_pos/fragments/bloc_home_year.dart' as BlocHomeYearImp;
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
    required this.isEnglish,
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
  final bool isEnglish;
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
  String textSetBuys = 'Refunds';
  String textSetLoss = 'Loss';
  String textSetToday = 'Daily';
  String textSetLastWeek = 'Weekly';
  String textSetLastMonth = 'Monthly';
  String textSetLastYear = 'Yearly';
  String textSetLast7Days = 'Last 7 Days';
  String textSetLast28D = 'LAST 28 DAYS';
  String textSetLast12M = 'LAST 12 MONTHS';
  String textSetSearch = 'Search';

  String currencyUnit = 'MMK';

  slidingSearchCont() {

    if(slidingSearch == 0) {
      // debugPrint('gg0');
      subTabController.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 1) {
      // debugPrint('gg1');
      subTabController.animateTo(1, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 2) {
      // debugPrint('gg2');
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

  // getLangId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getString('lang') == null) {
  //     return 'english';
  //   }
  //   return prefs.getString('lang');
  // }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  DateTime lossDayStartByDate(DateTime date) {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    String endDateOfMonth = '31';
    if(date.month.toString() == '9' || date.month.toString() == '4' || date.month.toString() == '6' || date.month.toString() == '11') {
      endDateOfMonth = '30';
    } else if(date.month.toString() == '2') {
      endDateOfMonth = '29';
    } else {
      endDateOfMonth = '31';
    }
    DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.year.toString() + '-' + zeroToTen(date.month.toString()) + '-' + endDateOfMonth + ' 23:59:59');
    debugPrint('DDDD ' + yearStart.toString());
    return yearStart;
  }

  DateTime lossDayEndByDate(DateTime date) {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime notTday = date;
    notTday = date;
    int month = notTday.month;
    int ayinMonth = 0;
    if(month == 1) {
      ayinMonth = 12;
    } else {
      ayinMonth = month - 1;
    }
    DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(ayinMonth.toString()) + '-00 00:00:00');
    debugPrint('DDDD ' + yearStart.toString());
    return yearStart;
  }

  @override
  initState() {
    _dateTime = DateTime.now();
    debugPrint('Timestamp ' + DateTime.now().toString() + ' --> ' + Timestamp.fromMillisecondsSinceEpoch(1599573193925).toString());
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

    if(widget.isEnglish == true)
    {
      setState(() {
        textSetTotalSales = 'TOTAL SALES';
        textSetTodaySoFar = 'TODAY SO FAR';
        textSetStockCosts = 'Stock costs';
        textSetUnpaid = 'Unpaid';
        textSetBuys = 'Refunds';
        textSetLoss = 'Loss';
        textSetToday = 'Daily';
        textSetLastWeek = 'Weekly';
        textSetLastMonth = 'Monthly';
        textSetLastYear = 'Yearly';
        textSetLast7Days = 'Last 7 Days';
        textSetLast28D = 'LAST 28 DAYS';
        textSetLast12M = 'LAST 12 MONTHS';
        textSetSearch = 'Search';

      });
    }
    else
    {
      setState(() {
        textSetTotalSales = 'စုစုပေါင်း အသားတင် ရောင်းရငွေ';
        textSetTodaySoFar = 'ဒီနေ့အတွင်း';
        textSetStockCosts = 'ဝယ်ယူစရိတ်';
        textSetUnpaid = 'အကြွေးရရန်';
        textSetBuys = 'ပြန်ပေးငွေ';
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
    }


    // fetchOrders();
    super.initState();
  }

  void _showDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        confirm: Text('Done', textScaleFactor: 1, style: TextStyle(color: Colors.Colors.blue)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      // maxDateTime: DateTime.parse('2021-11-25'),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
      initialDateTime: today,
      dateFormat: _format,
      locale: DateTimePickerLocale.en_us,
      onClose: () {
        setState((){
          _dateTime = _dateTime;
          today = today;
          // DateTime td = DateTime.now();
          debugPrint('closed 1 ' + today.toString());
          // debugPrint('closed 2 ' + td.toString());
        });
        // fetchOrders();
      },
      onCancel: () => debugPrint('onCancel'),
      onChange: (dateTime, List<int> index) {
        // setState(() {
        today = dateTime;
        _dateTime = dateTime;
        // });


      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          today = dateTime;
          _dateTime = dateTime;
        });
      },
    );
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
    debugPrint(index);
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
      // debugPrint('DOC IIDD ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0.data!.docs[loopOrd].data()! as Map<String, dynamic>;

      DateTime dateTimeOrders = data['date'].toDate();
      String dataDate = dateTimeOrders.year.toString() + zeroToTen(dateTimeOrders.month.toString()) + zeroToTen(dateTimeOrders.day.toString());
      debugPrint('DOC IIDD2 ' + dataDate.toString() + ' ' + dateTimeOrders.toString());

      int week = 0;
      int month = 0;
      int year = 0;
      sevenDaysAgo = today.subtract(const Duration(days: 8));
      monthAgo = today.subtract(const Duration(days: 31));

      while(!(today.year.toString() == sevenDaysAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(sevenDaysAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(sevenDaysAgo.day.toString()))) {
        sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));

        // debugPrint('seven Days Ago ' + sevenDaysAgo.day.toString() + ' ' + week.toString());
        // debugPrint('here shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));


        // debugPrint('shwe shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));

        if(dataDate == sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString())) {
          double total = 0;
          // debugPrint(doc['daily_order'].toString());
          for(String str in data['daily_order']) {
            // debugPrint(double.parse(str));
            total += double.parse(str.split('^')[2]);
            weekCostsTotal += double.parse(str.split('^')[5]);
          }
          thisWeekOrdersChart[week] = total;

        }
        week = week + 1;

      }

      while(!(today.year.toString() == monthAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(monthAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(monthAgo.day.toString()))) {
        monthAgo = monthAgo.add(const Duration(days: 1));

        // debugPrint('month Days Ago ' + monthAgo.day.toString() + ' ' + month.toString());
        // debugPrint('here shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));


        // debugPrint('shwe shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));

        if(dataDate == monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString())) {
          double total = 0;
          // debugPrint(doc['daily_order'].toString());
          for(String str in data['daily_order']) {
            // debugPrint(double.parse(str));
            // debugPrint('testing ' + str.split('^')[2]);
            total += double.parse(str.split('^')[2]);
            monthCostsTotal += double.parse(str.split('^')[5]);
          }
          // debugPrint('tatoos ' + total.toString());
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
            // debugPrint('laos ' + total.toString());
            // debugPrint('World ' +todayOrdersChart.toString());
          }
        }


      }
      if (dataDate.substring(0,4) == today.year.toString()){
        double total = 0;
        for (String str in data['daily_order']) {
          // debugPrint('DATE CHECK  ' + snapshot0.data!.docs[loopOrd].id);
          for(int i=1; i<=12 ; i++ ){
            // debugPrint('helloworld '+i.toString());

            if(str.split('^')[0].substring(0,6) == today.year.toString()+ zeroToTen(i.toString()))
            {
              total += double.parse(str.split('^')[2]);
              yearCostsTotal += double.parse(str.split('^')[5]);
              // setState(() {
              thisYearOrdersChart[i]+=double.parse(str.split('^')[2]);
              // debugPrint('fortune ' +thisYearOrdersChart.toString());
              // });
            }
            //debugPrint('laos ' + total.toString());

          }
        }
      }
    }

    // debugPrint('each ');
    if(snapshot1.data != null) {
      for(int loopOrd = 0; loopOrd < snapshot1.data!.docs.length; loopOrd++) {
        debugPrint('DOC IIDDCost ' + snapshot1.data!.docs[loopOrd].id.toString());
        Map<String, dynamic> data = snapshot1.data!.docs[loopOrd].data()! as Map<String, dynamic>;

        DateTime dateTimeOrders = data['date'].toDate();
        String dataDate = dateTimeOrders.year.toString() + zeroToTen(dateTimeOrders.month.toString()) + zeroToTen(dateTimeOrders.day.toString());
        debugPrint('DOC IIDD2 ' + dataDate.toString() + ' ' + dateTimeOrders.toString());

        int week = 0;
        int month = 0;
        int year = 0;
        sevenDaysAgo = today.subtract(const Duration(days: 8));
        monthAgo = today.subtract(const Duration(days: 31));

        while(!(today.year.toString() == sevenDaysAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(sevenDaysAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(sevenDaysAgo.day.toString()))) {
          sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));

          // debugPrint('seven Days Ago ' + sevenDaysAgo.day.toString() + ' ' + week.toString());
          // debugPrint('here shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));


          // debugPrint('shwe shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));

          if(dataDate == sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString())) {
            double total = 0;
            // debugPrint(doc['daily_order'].toString());
            for(String str in data['daily_order']) {
              // debugPrint(double.parse(str));
              weekCostsTotalR += double.parse(str.split('^')[2]);
            }

          }
          week = week + 1;

        }

        while(!(today.year.toString() == monthAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(monthAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(monthAgo.day.toString()))) {
          monthAgo = monthAgo.add(const Duration(days: 1));

          // debugPrint('month Days Ago ' + monthAgo.day.toString() + ' ' + month.toString());
          // debugPrint('here shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));


          // debugPrint('shwe shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));

          if(dataDate == monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString())) {
            double total = 0;
            // debugPrint(doc['daily_order'].toString());
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
            // debugPrint('DATE CHECK  ' + snapshot0.data!.docs[loopOrd].id);
            for(int i=1; i<=12 ; i++ ) {
              // debugPrint('helloworld '+i.toString());

              if(str.split('^')[0].substring(0,6) == today.year.toString()+ zeroToTen(i.toString()))
              {
                yearCostsTotalR += double.parse(str.split('^')[2]);
                // debugPrint('fortune ' +thisYearOrdersChart.toString());
                // });
              }
              //debugPrint('laos ' + total.toString());

            }
          }
        }

        // setState(() {
        //   // debugPrint('CHECK todayCOSTS ' + todayCostsTotal.toString());
        // });

        // while(!(today.year.toString() == yearAgo.year.toString() && today.month.toString() == yearAgo.month.toString() && today.day.toString() == yearAgo.day.toString())) {
        //   yearAgo = yearAgo.add(const Duration(days: 1));
        //
        //   if(doc['date'] == yearAgo.year.toString() + zeroToTen(yearAgo.month.toString()) + zeroToTen(yearAgo.day.toString())) {
        //     double total = 0;
        //     // debugPrint(doc['daily_order'].toString());
        //     for(String str in doc['daily_order']) {
        //       // debugPrint(double.parse(str));
        //       total += double.parse(str.split('^')[2]);
        //     }
        //     debugPrint('total ' + total.toString());
        //     setState(() {
        //       thisYearOrdersChart[year] = total;
        //     });
        //
        //   }
        //   year = year + 1;
        //
        // }
        // debugPrint('this year' + thisYearOrdersChart.toString());
        // debugPrint('this week ' + thisWeekOrdersChart.toString());
        // for(int j = 20210909; j <= 20210915; j++) {
        //
        //   // debugPrint('seven Days Ago 2 ' + sevenDaysAgo.day.toString() + ' ' + ij.toString());
        //   debugPrint('here shwe 2 ' + j.toString());
        //   // if(doc['date'] == j.toString()) {
        //   //   double total = 0;
        //   //   // debugPrint(doc['daily_order'].toString());
        //   //   for(String str in doc['daily_order']) {
        //   //     // debugPrint(double.parse(str));
        //   //     total += double.parse(str.split('^')[2]);
        //   //   }
        //   //   debugPrint('total ' + total.toString());
        //   //   setState(() {
        //   //     thisWeekOrdersChart[ij] = total;
        //   //   });
        //   //
        //   // }
        //   // ij = ij + 1;
        //   // debugPrint(ij);
        // }


        // debugPrint('this week 2' + thisWeekOrdersChart.toString());

        // debugPrint('each ' + doc.id.toString());
      }
    } else {
      debugPrint('null pix');
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



    debugPrint('docs ' + snapshot0.data!.docs.toString());


    for(int loopOrd = 0; loopOrd < snapshot0.data!.docs.length; loopOrd++) {
      debugPrint('George sai 0 ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0.data!.docs[loopOrd].data()! as Map<String, dynamic>;

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_cust'];
          debugPrint('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_cust'].toString());
        }
      }

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'] != null) {
          // thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          monthCostsTotal2 +=  data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          debugPrint('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'].toString());
        }
      }

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          // thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          monthUnpaidTotal +=  data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'debt_cust'];
          debugPrint('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'debt_cust'].toString());
        }
      }

      for(int i = 0; i< 32; i++) {
        if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          // thisMonthOrdersChart[i] += thisMonthOrdersChart[i] + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'cash_merc'];
          monthRefundTotal +=  data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'refu_cust'];
          debugPrint('George ' + data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(i.toString()) + 'refu_cust'].toString());
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

    debugPrint('docs ' + snapshot0.data!.docs.toString());


    for(int loopOrd = 0; loopOrd < snapshot0.data!.docs.length; loopOrd++) {
      debugPrint('George Y sai 0 ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0.data!.docs[loopOrd].data()! as Map<String, dynamic>;
      for(int i = 0; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          thisYearOrdersChart[i] += thisYearOrdersChart[i] + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'].toString());
        }
      }

      for(int i = 0; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'] != null) {
          yearCostsTotal2 +=  data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'].toString());
        }
      }

      for(int i = 0; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          yearUnpaidTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'].toString());
        }
      }

      for(int i = 0; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          yearRefundTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'].toString());
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
    // debugPrint('clicked testing ');
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSearch = false;
    });
  }
  void unfocusSearch() {
    // debugPrint('clicked testing 2');
    FocusScope.of(context).unfocus();
  }

  searchFocus() {
    setState(() {
      loadingSearch = true;
    });
  }

  LineChartData todayData(DateTime today) {
    String subHours = today.hour.toString();
    List<int> roundToday = [];
    for(double dbl in todayOrdersChart) {
      roundToday.add(dbl.round());
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFd6d8db),
            strokeWidth: 1,
            // dashArray: [0]
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
              color: const Color(0xFFd6d8db),
              strokeWidth: 1,
              dashArray: [5]
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString());
              case 4:
                return _dateTime!.subtract(Duration(hours: (int.parse(subHours)-4))).hour.toString() + ' hr';
              case 8:
                return _dateTime!.subtract(Duration(hours: int.parse(subHours)-8)).hour.toString()+ ' hr';
              case 12:
                return _dateTime!.subtract(Duration(hours: int.parse(subHours)-12)).hour.toString()+ ' hr';
              case 16:
                return _dateTime!.subtract(Duration(hours: int.parse(subHours)-16)).hour.toString()+ ' hr';
              case 20:
                return _dateTime!.subtract(Duration(hours: int.parse(subHours)-20)).hour.toString()+ ' hr';
              case 24:
                return 'Next Day';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          getTitles: (value) {



            chgDeci3Place(findMax(roundToday));
            var unit;
            var quantity;
            if(chgDeci3Place(findMax(roundToday))==100.0) {
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundToday))*10;
            } else if(chgDeci3Place(findMax(roundToday))==1000.0){
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundToday));
            }else if(chgDeci3Place(findMax(roundToday))==10000.0){
              unit='K';
              quantity = chgDeci3Place(findMax(roundToday))/10;
            }else if(chgDeci3Place(findMax(roundToday))==100000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundToday))*10;
            }else if(chgDeci3Place(findMax(roundToday))==1000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundToday));
            }else if(chgDeci3Place(findMax(roundToday))==10000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundToday))/10;
            }else if(chgDeci3Place(findMax(roundToday))==100000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundToday))*10;
            }else if(chgDeci3Place(findMax(roundToday))== 1000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundToday));
            }else if(chgDeci3Place(findMax(roundToday))== 10000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundToday))/10;
            }else {
              unit='';
              quantity = 1;
            }


            if(value.toInt() == 5) {
              return (findMax(roundToday)/quantity).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 3) {
              return ((findMax(roundToday)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 1) {
              return ((findMax(roundToday)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
            }

            return '';
          },
          reservedSize: 35,
          margin: 8,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xFFd6d8db), width: 0)),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, (((todayOrdersChart[0]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[0]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[0]).toString() + '\n(' + today.subtract(Duration(hours: int.parse(subHours))).hour.toString() + ':00, Today' + ')'),
            FlSpot(1, (((todayOrdersChart[1]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[1]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[1]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-1)).hour.toString() + ':00, Today' + ')'),
            FlSpot(2, (((todayOrdersChart[2]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[2]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[2]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-2)).hour.toString() + ':00, Today' + ')'),
            FlSpot(3, (((todayOrdersChart[3]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[3]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[3]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-3)).hour.toString() + ':00, Today' + ')'),
            FlSpot(4, (((todayOrdersChart[4]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[4]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[4]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-4)).hour.toString() + ':00, Today' + ')'),
            FlSpot(5, (((todayOrdersChart[5]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[5]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[5]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-5)).hour.toString() + ':00, Today' + ')'),
            FlSpot(6, (((todayOrdersChart[6]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[6]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[6]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-6)).hour.toString() + ':00, Today' + ')'),
            FlSpot(7, (((todayOrdersChart[7]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[7]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[7]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-7)).hour.toString() + ':00, Today' + ')'),
            FlSpot(8, (((todayOrdersChart[8]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[8]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[8]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-8)).hour.toString() + ':00, Today' + ')'),
            FlSpot(9, (((todayOrdersChart[9]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[9]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[9]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-9)).hour.toString() + ':00, Today' + ')'),
            FlSpot(10, (((todayOrdersChart[10]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[10]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[10]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-10)).hour.toString()+ ':00, Today' + ')'),
            FlSpot(11, (((todayOrdersChart[11]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[11]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[11]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-11)).hour.toString() + ':00, Today' + ')'),
            FlSpot(12, (((todayOrdersChart[12]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[12]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[12]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-12)).hour.toString() + ':00, Today' + ')'),
            FlSpot(13, (((todayOrdersChart[13]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[13]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[13]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-13)).hour.toString() + ':00, Today' + ')'),
            FlSpot(14, (((todayOrdersChart[14]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[14]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[14]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-14)).hour.toString() + ':00, Today' + ')'),
            FlSpot(15, (((todayOrdersChart[15]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[15]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[15]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-15)).hour.toString() + ':00, Today' + ')'),
            FlSpot(16, (((todayOrdersChart[16]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[16]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[16]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-16)).hour.toString() + ':00, Today' + ')'),
            FlSpot(17, (((todayOrdersChart[17]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[17]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[17]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-17)).hour.toString() + ':00, Today' + ')'),
            FlSpot(18, (((todayOrdersChart[18]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[18]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[18]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-18)).hour.toString() + ':00, Today' + ')'),
            FlSpot(19, (((todayOrdersChart[19]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[19]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[19]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-19)).hour.toString() + ':00, Today' + ')'),
            FlSpot(20, (((todayOrdersChart[20]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[20]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[20]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-20)).hour.toString() + ':00, Today' + ')'),
            FlSpot(21, (((todayOrdersChart[21]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[21]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[21]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-21)).hour.toString() + ':00, Today' + ')'),
            FlSpot(22, (((todayOrdersChart[22]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[22]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[22]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-22)).hour.toString() + ':00, Today' + ')'),
            FlSpot(23, (((todayOrdersChart[23]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[23]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[23]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-23)).hour.toString() + ':00, Today' + ')'),
            FlSpot(24, (((todayOrdersChart[24]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[24]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[24]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-24)).hour.toString() + ':00, Today' + ')'),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],

    );
  }

  int findMax(List<int> numbers) {
    return numbers.reduce(max);
  }

  LineChartData monthlyData(DateTime today) {
    List<int> roundMonth = [];
    for(double dbl in thisMonthOrdersChart) {
      roundMonth.add(dbl.round());
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFd6d8db),
            strokeWidth: 1,
            // dashArray: [0]
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
              color: const Color(0xFFd6d8db),
              strokeWidth: 1,
              dashArray: [5]
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          getTitles: (value) {
            // DateTime day = DateTime.now().add(Duration(days: 1));
            // for(int i = 0; i<7; i++) {
            //   today = today.subtract(Duration(days: 1));
            //   return today.day.toString();
            //
            // }
            // return '';
            // DateTime today = DateTime.now();
            // today.day.toString()



            // switch (value.toInt()) {
            //   case 0:
            //     return _dateTime!.subtract(Duration(days: 30)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 29)).month.toString());
            //   case 5:
            //     return _dateTime!.subtract(Duration(days: 25)).day.toString();
            //   case 10:
            //     return _dateTime!.subtract(Duration(days: 20)).day.toString();
            //   case 15:
            //     return _dateTime!.subtract(Duration(days: 15)).day.toString();
            //   case 20:
            //     return _dateTime!.subtract(Duration(days: 10)).day.toString();
            //   case 25:
            //     return _dateTime!.subtract(Duration(days: 5)).day.toString();
            //   case 30:
            //     return _dateTime!.subtract(Duration(days: 0)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString());
            // // return today.day.toString() + ', ' + changeMonth2String(today.month.toString());
            // }
            // return '';


            if(value.toInt() == (DateTime(_dateTime!.year, _dateTime!.month + 1, 0).day+1) - 1) {
              return ((DateTime(_dateTime!.year, _dateTime!.month + 1, 0).day+1) - 1).toString() + ', ' + changeMonth2String(_dateTime!.month.toString());
            }
            switch (value.toInt()) {
              case 1:
                return '1, ' + changeMonth2String(_dateTime!.month.toString());
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
              case 25:
                return '25';
            // case 30:
            //   return '30, ' + changeMonth2String(_dateTime!.month.toString());
            // return today.day.toString() + ', ' + changeMonth2String(today.month.toString());
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          getTitles: (value) {
            // switch (value.toInt()) {
            //   case 1:
            //     return '10k';
            //   case 3:
            //     return '30k';
            //   case 5:
            //     return (findMax(roundWeek)/1000000).round().toString() + 'M';
            // }
            // return '';

            chgDeci3Place(findMax(roundMonth));
            var unit;
            var quantity;
            if(chgDeci3Place(findMax(roundMonth))==100.0) {
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundMonth))*10;
            } else if(chgDeci3Place(findMax(roundMonth))==1000.0){
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundMonth));
            }else if(chgDeci3Place(findMax(roundMonth))==10000.0){
              unit='K';
              quantity = chgDeci3Place(findMax(roundMonth))/10;
            }else if(chgDeci3Place(findMax(roundMonth))==100000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundMonth))*10;
            }else if(chgDeci3Place(findMax(roundMonth))==1000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundMonth));
            }else if(chgDeci3Place(findMax(roundMonth))==10000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundMonth))/10;
            }else if(chgDeci3Place(findMax(roundMonth))==100000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundMonth))*10;
            }else if(chgDeci3Place(findMax(roundMonth))== 1000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundMonth));
            }else if(chgDeci3Place(findMax(roundMonth))== 10000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundMonth))/10;
            }else {
              unit='';
              quantity = 1;
            }

            if(value.toInt() == 5) {
              return (findMax(roundMonth)/quantity).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 3) {
              return ((findMax(roundMonth)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 1) {
              return ((findMax(roundMonth)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
            }



            // debugPrint('value ' + findMax(roundMonth).toString());
            return '';
          },
          reservedSize: 42,
          margin: 6,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFFd6d8db), width: 0))),
      minX: 1,
      // maxX: 30,
      maxX: (DateTime(_dateTime!.year, _dateTime!.month + 1, 0).day+1).toDouble() - 1,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for(int i = 1; i < DateTime(_dateTime!.year, _dateTime!.month + 1, 0).day + 1; i++)
              FlSpot(i.toDouble(), (((thisMonthOrdersChart[i]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[i]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[i]).toString()  + '\n(' + i.toString() + ', ' + changeMonth2String(_dateTime!.month.toString()) + ')'),
            // FlSpot(i.toDouble(), (((thisMonthOrdersChart[i]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[i]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[i]).toString()  + '\n(' + today.subtract(Duration(days: DateTime(today.year, today.month + 1, 0).day - i)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: DateTime(today.year, today.month + 1, 0).day - i)).month.toString()) + ')'),
            // double.parse(((thisWeekOrdersChart[5]/1000000)).toString())

            // FlSpot(1, (((thisMonthOrdersChart[1]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[1]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[1]).toString() + '\n(' + today.subtract(Duration(days: 29)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 29)).month.toString()) + ')'),
            // FlSpot(2, (((thisMonthOrdersChart[2]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[2]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[2]).toString() + '\n(' + today.subtract(Duration(days: 28)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 28)).month.toString()) + ')'),
            // FlSpot(3, (((thisMonthOrdersChart[3]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[3]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[3]).toString() + '\n(' + today.subtract(Duration(days: 27)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 27)).month.toString()) + ')'),
            // // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // // (thisWeekOrdersChart[4]/1000000) * 3.260
            // FlSpot(4, (((thisMonthOrdersChart[4]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[4]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[4]).toString() + '\n(' + today.subtract(Duration(days: 26)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 26)).month.toString()) + ')'),
            // FlSpot(5, (((thisMonthOrdersChart[5]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[5]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[5]).toString() + '\n(' + today.subtract(Duration(days: 25)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 25)).month.toString()) + ')'),
            // FlSpot(6, (((thisMonthOrdersChart[6]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[6]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[6]).toString() + '\n(' + today.subtract(Duration(days: 24)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 24)).month.toString()) + ')'),
            //
            // FlSpot(7, (((thisMonthOrdersChart[7]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[7]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[7]).toString() + '\n(' + today.subtract(Duration(days: 23)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 23)).month.toString()) + ')'),
            // FlSpot(8, (((thisMonthOrdersChart[8]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[8]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[8]).toString() + '\n(' + today.subtract(Duration(days: 22)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 22)).month.toString()) + ')'),
            // FlSpot(9, (((thisMonthOrdersChart[9]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[9]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[9]).toString() + '\n(' + today.subtract(Duration(days: 21)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 21)).month.toString()) + ')'),
            // FlSpot(10, (((thisMonthOrdersChart[10]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[10]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[10]).toString() + '\n(' + today.subtract(Duration(days: 20)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 20)).month.toString()) + ')'),
            // // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // // (thisWeekOrdersChart[4]/1000000) * 3.260
            // FlSpot(11, (((thisMonthOrdersChart[11]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[11]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[11]).toString() + '\n(' + today.subtract(Duration(days: 19)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 19)).month.toString()) + ')'),
            // FlSpot(12, (((thisMonthOrdersChart[12]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[12]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[12]).toString() + '\n(' + today.subtract(Duration(days: 18)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 18)).month.toString()) + ')'),
            // FlSpot(13, (((thisMonthOrdersChart[13]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[13]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[13]).toString() + '\n(' + today.subtract(Duration(days: 17)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 17)).month.toString()) + ')'),
            //
            // FlSpot(14, (((thisMonthOrdersChart[14]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[14]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[14]).toString() + '\n(' + today.subtract(Duration(days: 16)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 16)).month.toString()) + ')'),
            // FlSpot(15, (((thisMonthOrdersChart[15]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[15]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[15]).toString() + '\n(' + today.subtract(Duration(days: 15)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 15)).month.toString()) + ')'),
            // FlSpot(16, (((thisMonthOrdersChart[16]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[16]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[16]).toString() + '\n(' + today.subtract(Duration(days: 14)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 14)).month.toString()) + ')'),
            // FlSpot(17,(((thisMonthOrdersChart[17]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[17]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[17]).toString() + '\n(' + today.subtract(Duration(days: 13)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 13)).month.toString()) + ')'),
            // // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // // (thisWeekOrdersChart[4]/1000000) * 3.260
            // FlSpot(18, (((thisMonthOrdersChart[18]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[18]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[18]).toString() + '\n(' + today.subtract(Duration(days: 12)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 12)).month.toString()) + ')'),
            // FlSpot(19, (((thisMonthOrdersChart[19]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[19]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[19]).toString() + '\n(' + today.subtract(Duration(days: 11)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 11)).month.toString()) + ')'),
            // FlSpot(20, (((thisMonthOrdersChart[20]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[20]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[20]).toString() + '\n(' + today.subtract(Duration(days: 10)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 10)).month.toString()) + ')'),
            //
            // FlSpot(21,(((thisMonthOrdersChart[21]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[21]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[21]).toString() + '\n(' + today.subtract(Duration(days: 9)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 9)).month.toString()) + ')'),
            // FlSpot(22, (((thisMonthOrdersChart[22]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[22]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[22]).toString() + '\n(' + today.subtract(Duration(days: 8)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 8)).month.toString()) + ')'),
            // FlSpot(23, (((thisMonthOrdersChart[23]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[23]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[23]).toString() + '\n(' + today.subtract(Duration(days: 7)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 7)).month.toString()) + ')'),
            // FlSpot(24, (((thisMonthOrdersChart[24]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[24]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[24]).toString() + '\n(' + today.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 6)).month.toString()) + ')'),
            // // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // // (thisWeekOrdersChart[4]/1000000) * 3.260
            // FlSpot(25, (((thisMonthOrdersChart[25]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[25]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[25]).toString() + '\n(' + today.subtract(Duration(days: 5)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 5)).month.toString()) + ')'),
            // FlSpot(26, (((thisMonthOrdersChart[26]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[26]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[26]).toString() + '\n(' + today.subtract(Duration(days: 4)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 4)).month.toString()) + ')'),
            // FlSpot(27, (((thisMonthOrdersChart[27]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[27]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[27]).toString() + '\n(' + today.subtract(Duration(days: 3)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 3)).month.toString()) + ')'),
            //
            // FlSpot(28, (((thisMonthOrdersChart[28]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[28]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[28]).toString() + '\n(' + today.subtract(Duration(days: 2)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 2)).month.toString()) + ')'),
            // FlSpot(29, (((thisMonthOrdersChart[29]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[29]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[29]).toString() + '\n(' + today.subtract(Duration(days: 1)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 1)).month.toString()) + ')'),
            // FlSpot(30, (((thisMonthOrdersChart[30]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[30]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[30]).toString() + '\n(' + today.day.toString() + ', ' + changeMonth2String(today.month.toString()) + ')'),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData weeklyData(DateTime today) {
    List<int> roundWeek = [];
    for(double dbl in thisWeekOrdersChart) {
      roundWeek.add(dbl.round());
    }
    int five = 5;
    // debugPrint(roundWeek.toString);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFd6d8db),
            strokeWidth: 1,
            // dashArray: [0]
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
              color: const Color(0xFFd6d8db),
              strokeWidth: 1,
              dashArray: [5]
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          getTitles: (value) {
            // DateTime day = DateTime.now().add(Duration(days: 1));
            // for(int i = 0; i<7; i++) {
            //   today = today.subtract(Duration(days: 1));
            //   return today.day.toString();
            //
            // }
            // return '';
            // DateTime today = DateTime.now();
            // today.day.toString()
            switch (value.toInt()) {
              case 0:
                return _dateTime!.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 6)).month.toString());
              case 1:
                return _dateTime!.subtract(Duration(days: 5)).day.toString();
              case 2:
                return _dateTime!.subtract(Duration(days: 4)).day.toString();
              case 3:
                return _dateTime!.subtract(Duration(days: 3)).day.toString();
              case 4:
                return _dateTime!.subtract(Duration(days: 2)).day.toString();
              case 5:
                return _dateTime!.subtract(Duration(days: 1)).day.toString();
              case 6:
                return _dateTime!.subtract(Duration(days: 0)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString());
            // return today.day.toString() + ', ' + changeMonth2String(today.month.toString());

            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          getTitles: (value) {
            // switch (value.toInt()) {
            //   case 1:
            //     return '10k';
            //   case 3:
            //     return '30k';
            //   case 5:
            //     return (findMax(roundWeek)/1000000).round().toString() + 'M';
            // }
            // return '';

            chgDeci3Place(findMax(roundWeek));

            var unit;
            var quantity;
            if(chgDeci3Place(findMax(roundWeek))==100.0) {
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundWeek))*10;
            } else if(chgDeci3Place(findMax(roundWeek))==1000.0){
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundWeek));
            }else if(chgDeci3Place(findMax(roundWeek))==10000.0){
              unit='K';
              quantity = chgDeci3Place(findMax(roundWeek))/10;
            }else if(chgDeci3Place(findMax(roundWeek))==100000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundWeek))*10;
            }else if(chgDeci3Place(findMax(roundWeek))==1000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundWeek));
            }else if(chgDeci3Place(findMax(roundWeek))==10000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundWeek))/10;
            }else if(chgDeci3Place(findMax(roundWeek))==100000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundWeek))*10;
            }else if(chgDeci3Place(findMax(roundWeek))== 1000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundWeek));
            }else if(chgDeci3Place(findMax(roundWeek))== 10000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundWeek))/10;
            }else {
              unit='';
              quantity = 1;
            }

            if(value.toInt() == 5) {
              return (findMax(roundWeek)/quantity).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 3) {
              return ((findMax(roundWeek)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 1) {
              return ((findMax(roundWeek)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
            }



            // debugPrint('value ' + findMax(roundWeek).toString());
            return '';
          },
          reservedSize: 42,
          margin: 6,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFFd6d8db), width: 0))),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            // double.parse(((thisWeekOrdersChart[5]/1000000)).toString())
            FlSpot(0, (((thisWeekOrdersChart[1]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[1]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[1]).toString() + '\n(' + today.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 6)).month.toString()) + ')'),
            FlSpot(1, (((thisWeekOrdersChart[2]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[2]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[2]).toString() + '\n(' + today.subtract(Duration(days: 5)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 5)).month.toString()) + ')'),
            FlSpot(2, (((thisWeekOrdersChart[3]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[3]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[3]).toString() + '\n(' + today.subtract(Duration(days: 4)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 4)).month.toString()) + ')'),
            FlSpot(3, (((thisWeekOrdersChart[4]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[4]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[4]).toString() + '\n(' + today.subtract(Duration(days: 3)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 3)).month.toString()) + ')'),
            // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // (thisWeekOrdersChart[4]/1000000) * 3.260
            FlSpot(4, (((thisWeekOrdersChart[5]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[5]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[5]).toString() + '\n(' + today.subtract(Duration(days: 2)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 2)).month.toString()) + ')'),
            FlSpot(5, (((thisWeekOrdersChart[6]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[6]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[6]).toString() + '\n(' + today.subtract(Duration(days: 1)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 1)).month.toString()) + ')'),
            FlSpot(6, (((thisWeekOrdersChart[7]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[7]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[7]).toString() + '\n(' + today.subtract(Duration(days: 0)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 0)).month.toString()) + ')'),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData yearlyData(DateTime today) {
    List<int> roundYear = [];
    String subMonths = today.month.toString();
    for(double dbl in thisYearOrdersChart) {
      roundYear.add(dbl.round());
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFd6d8db),
            strokeWidth: 1,
            // dashArray: [0]
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
              color: const Color(0xFFd6d8db),
              strokeWidth: 1,
              dashArray: [5]
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
            // case 0:
            //   return (int.parse(today.month.toString()) - int.parse(subMonths)).toString();
              case 0:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+1).toString();
                return 'Jan';
              case 1:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+2).toString();
                return '2';
              case 2:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+3).toString();
                return '3';
              case 3:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+4).toString();
                return '4';
              case 4:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+5).toString();
                return '5';
              case 5:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+6).toString();
                return '6';
              case 6:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+7).toString();
                return '7';
              case 7:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+8).toString();
                return '8';
              case 8:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+9).toString();
                return '9';
              case 9:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+10).toString();
                return '10';
              case 10:
              // return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+11).toString();
                return '11';
              case 11:
              // return _dateTime!.year.toString();
                return 'Dec';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          getTitles: (value) {

            chgDeci3Place(findMax(roundYear));

            var unit;
            var quantity;
            if(chgDeci3Place(findMax(roundYear))==100.0) {
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundYear))*10;
            } else if(chgDeci3Place(findMax(roundYear))==1000.0){
              unit = 'K';
              quantity = chgDeci3Place(findMax(roundYear));
            }else if(chgDeci3Place(findMax(roundYear))==10000.0){
              unit='K';
              quantity = chgDeci3Place(findMax(roundYear))/10;
            }else if(chgDeci3Place(findMax(roundYear))==100000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundYear))*10;
            }else if(chgDeci3Place(findMax(roundYear))==1000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundYear));
            }else if(chgDeci3Place(findMax(roundYear))==10000000.0){
              unit='M';
              quantity = chgDeci3Place(findMax(roundYear))/10;
            }else if(chgDeci3Place(findMax(roundYear))==100000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundYear))*10;
            }else if(chgDeci3Place(findMax(roundYear))== 1000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundYear));
            }else if(chgDeci3Place(findMax(roundYear))== 10000000000.0){
              unit='B';
              quantity = chgDeci3Place(findMax(roundYear))/10;
            }else {
              unit='';
              quantity = 1;
            }

            if(value.toInt() == 5) {
              return   (findMax(roundYear)/quantity).toStringAsFixed(1) + ' $unit';
            }else if(value.toInt() == 3) {
              return ((findMax(roundYear)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
            } else if(value.toInt() == 1) {
              return ((findMax(roundYear)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
            }



            // debugPrint('value ' + findMax(roundYear).toString());
            return '';
          },
          reservedSize: 35,
          margin: 8,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xFFd6d8db), width: 0)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0,(((thisYearOrdersChart[1]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[1]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[1]).toString() + '\n(January)'),
            FlSpot(1,(((thisYearOrdersChart[2]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[2]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[2]).toString() + '\n(February)'),
            FlSpot(2,(((thisYearOrdersChart[3]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[3]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[3]).toString() + '\n(March)'),
            FlSpot(3,(((thisYearOrdersChart[4]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[4]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[4]).toString() + '\n(April)'),
            FlSpot(4,(((thisYearOrdersChart[5]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[5]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[5]).toString() + '\n(May)'),
            FlSpot(5,(((thisYearOrdersChart[6]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[6]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[6]).toString() + '\n(June)'),
            FlSpot(6,(((thisYearOrdersChart[7]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[7]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[7]).toString() + '\n(July)'),
            FlSpot(7,(((thisYearOrdersChart[8]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[8]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[8]).toString() + '\n(August)'),
            FlSpot(8,(((thisYearOrdersChart[9]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[9]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[9]).toString() + '\n(September)'),
            FlSpot(9,(((thisYearOrdersChart[10]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[10]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[10]).toString() + '\n(October)'),
            FlSpot(10,(((thisYearOrdersChart[11]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[11]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[11]).toString() + '\n(November)'),
            FlSpot(11,(((thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[12]).toString() + '\n(December)'),
            //FlSpot(12,((thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))).toString()),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
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
    // debugPrint(findMax(roundWeek));
    max = max/chgDeci3Place(max);
    // debugPrint('gg ' + (5.0 - max).toString());
    return 5.0 - max;
  }

  double chgDeci3Place(max) {
    double ten = 10.0;
    for(int i = 0; i<max.toString().length - 2; i++) {
      ten = ten * 10;
    }
    return ten;
    // debugPrint('length ' + ten.toString().toString());
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
    setState(() {
      searchOpening = index;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        searchOpeningR = index;
      });
    });
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
        child: Container(
          color: Colors.Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Container(
              // width: MediaQuery.of(context).size.width > 900
              //     ? MediaQuery.of(context).size.width * (2 / 3.5)
              //     : MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  if(!searchOpening)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 81.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              100,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, left: 0.0, right: 0.0),

                            child: cateScIndex == 0 || cateScIndex == 1?
                            BlocHomeWeek(
                              isEnglish: widget.isEnglish,
                              dateTime: today,
                              key: valueKeyTog(),
                              shopId: widget.shopId,
                              query: ordersQuery(),
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
                              PaginateBuilderType.listView,
                              isLive: true,
                            ):
                            cateScIndex == 3?
                            BlocHomeYearImp.BlocHomeYear(
                              isEnglish: widget.isEnglish,
                              dateTime: today,
                              key: valueKeyTog(),
                              shopId: widget.shopId,
                              query: ordersQueryYear(),
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
                              BlocHomeYearImp.PaginateBuilderType.listView,
                              isLive: true,
                            ):
                            BlocHomeMonthDcImp.BlocHomeMonthDC(
                              dateTime: today,
                              isEnglish: widget.isEnglish,
                              key: valueKeyTog(),
                              shopId: widget.shopId,
                              query: ordersQueryMonth(),
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
                              BlocHomeMonthDcImp.PaginateBuilderType.listView,
                              isLive: true,
                            )
                            ,
                          ),
                        ),
                      ),
                    ),
                  if(searchOpeningR)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 15,)),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.Colors.white,
                          border: Border(
                            bottom: BorderSide(
                                color: AppTheme.skBorderColor2,
                                width: 1.0),
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15.0, right: 15.0, bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                            widget._searchBtn();
                            // FocusScope.of(context).requestFocus(nodeFirst);
                            // setState(() {
                            //   loadingSearch = true;
                            // });
                            // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: loadingSearch? Colors.Colors.blue: Colors.Colors.transparent,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              color: AppTheme.secButtonColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 11.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      // if(loadingSearch) {
                                      //   _searchController.clear();
                                      //   FocusScope.of(context).unfocus();
                                      //   setState(() {
                                      //     loadingSearch = false;
                                      //   });
                                      // } else {
                                      //   FocusScope.of(context).requestFocus(nodeFirst);
                                      //   setState(() {
                                      //     loadingSearch = true;
                                      //   });
                                      //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                                      // }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            !loadingSearch? Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Icon(
                                                SmartKyat_POS.search,
                                                size: 17,
                                              ),
                                            ): Padding(
                                              padding: const EdgeInsets.only(left: 2, bottom: 1.0),
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 24,
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: !loadingSearch? 8.0: 4,
                                  //         right: 8.0,
                                  //         top: 0.5),
                                  //     child: Text('Search'),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 13,
                                            bottom: 1.5),
                                        child: Text(
                                          textSetSearch,textScaleFactor: 1,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.Colors.black.withOpacity(0.55)
                                          ),
                                          strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: textSetSearch == 'Search'? 1.6: 1.3
                                          ),
                                        )
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget._barcodeBtn();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15.0,
                                      ),
                                      // child: Icon(
                                      //   SmartKyat_POS.barcode,
                                      //   color: Colors.Colors.black,
                                      //   size: 25,
                                      // ),
                                      child: Container(
                                          child: Image.asset('assets/system/barcode.png', height: 28,)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),                  // _isBannerAdReady? Align(
                  //   alignment: Alignment.topCenter,
                  //   child: Container(
                  //     height: _bannerAd.size.height.toDouble(),
                  //     width: _bannerAd.size.width.toDouble(),
                  //     child: AdWidget(ad: _bannerAd),
                  //   )
                  // ): Container(),
                ],
              ),
            ),
          ),
        ),
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

  lineChartByTab() {
    if(_sliding==0) {
      return LineChart(todayData(DateTime.now()));
    } else if(_sliding==1) {
      return LineChart(weeklyData(DateTime.now()));
    } else if(_sliding==2) {
      return LineChart(monthlyData(DateTime.now()));
    }else if(_sliding==3) {
      return LineChart(yearlyData(DateTime.now()));
    }

    //_sliding == 0 ? mainData(): weeklyData(DateTime.now()),
  }

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList[sectionIndex];
    // if(sectionIndex == 0) {
    //   return Container(
    //     height: 0.1,
    //   );
    // }
    return InkWell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.Colors.white,
                border: Border(
                  bottom: BorderSide(
                      color: AppTheme.skBorderColor2,
                      width: 1.0),
                )
            ),
            alignment: Alignment.centerLeft,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 33,
                child: Padding(
                  // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
                  padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
                  child: Row(
                    children: [
                      Text(
                        // "BUY ORDERS",
                        'PRODUCTS', textScaleFactor: 1,
                        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.Colors.black
                        ),
                      ),

                      Spacer(),
                      searchValue != '' ?
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: section.header != '' ? Text(
                          section.header.split('^')[1], textScaleFactor: 1,
                          // '0',
                          // '#' + sectionList[sectionIndex].items.length.toString(),
                          // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                          style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ): Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
        onTap: () {
          //toggle section expand state
          // setState(() {
          //   section.setSectionExpanded(!section.isSectionExpanded());
          // });
        });
  }

  _animateToIndex(i) {
    // debugPrint((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }

  String selectDaysCast() {
    debugPrint("TTT " + today.year.toString().length.toString());
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
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-00-00 00:00:00');
    debugPrint('DDDD ' + yearStart.toString());
    return yearStart;
  }

  lossDayStart() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59');
    debugPrint('DDDD ' + yearStart.toString());
    return yearStart;
  }

  lossDayEnd() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime notTday = today;
    if(cateScIndex == 0) {
      notTday = today;
      DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-' + zeroToTen(notTday.day.toString()) + ' 00:00:00');
      debugPrint('DDDD ' + yearStart.toString());
      return yearStart;
    } else if(cateScIndex == 1) {
      notTday = today.subtract(Duration(days: 6));
      DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-' + zeroToTen(notTday.day.toString()) + ' 00:00:00');
      debugPrint('DDDD ' + yearStart.toString());
      return yearStart;
    } else if(cateScIndex == 2) {
      notTday = today.subtract(Duration(days: 27));
      DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-' + zeroToTen(notTday.day.toString()) + ' 00:00:00');
      debugPrint('DDDD ' + yearStart.toString());
      return yearStart;
    } else {
      DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-00-00 00:00:00');
      debugPrint('DDDD ' + yearStart.toString());
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
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 13)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 13)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 13)).day.toString()) + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.add(Duration(days: 1)).year.toString() + '-' + zeroToTen((today.add(Duration(days: 1)).month).toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 23:59:59'))
        .orderBy('date', descending: true);
  }

  ordersQueryYear() {
    return FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders_yearly')
        .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse((today.year - 1).toString() + '-01-00' + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString()  + '-12-00 00:00:00'));
  }

  ordersQueryMonth() {
    debugPrint('inside loss lol2 ' + naLaNokY(today.month, today.year).toString() + zeroToTen(naLaNokM(today.month).toString()) + '27');
    debugPrint('wtshit ' + DateTime(today.year, nokLa(today.month), 0).day.toString());
    debugPrint('inside loss leeeee ' + (today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + (zeroToTen(DateTime(today.year, nokLa(today.month), 0).day.toString())).toString() + ' 23:59:59').toString());
    return FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders_daily_cus')
        .where('dstr', isGreaterThanOrEqualTo: int.parse(naLaNokY(today.month, today.year).toString() + zeroToTen(naLaNokM(today.month).toString()) + '27'))
        .where('dstr', isLessThanOrEqualTo: int.parse(nextYear(today.month, today.year).toString() + zeroToTen(nextMonth(today.month).toString()) + '02'))
        .orderBy('dstr')
        .startAt([20220530])
        .endAt([20220701])
        .startAt([20220702])
        .endAt([20220801])
    ;
    // .where('dstr', isEqualTo: );
  }

  naLaNokM(int month) {
    if(month == 1) {
      return 11;
    } else if(month == 2) {
      return 12;
    } else {
      return month - 2;
    }
  }

  naLaNokY(int month, int year) {
    if(month == 1 || month == 2) {
      return year-1;
    } else {
      return year;
    }
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

  ordersMonthAyin(int month) {
    if(month == 1) {
      return 12;
    } else {
      return month - 1;
    }
  }

  nokLa(int month) {
    if(month == 12) {
      return 1;
    } else {
      return month+1;
    }
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


