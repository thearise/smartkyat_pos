import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/widgets_bloc/bloc_day_overview.dart' as BlocDayOverviewImp;
import 'package:smartkyat_pos/fragments/widgets_bloc/bloc_year_overview.dart' as BlocYearOverviewImp;
import 'package:flutter/src/material/colors.dart' as Colors;
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


class OverviewPage extends StatefulWidget {
  final _callback;
  final _callback2;
  final _callback3;
  final _callback4;
  final _barcodeBtn;
  final _searchBtn;
  final _openDrawerBtn;
  final _closeDrawerBtn;
  final _premiumCart;
  final _howToCart;

  OverviewPage({
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
    required void premiumCart(),
    required void howToCart(),
    Key? key,
  }) :  _callback = toggleCoinCallback,
        _callback2 = toggleCoinCallback2 ,
        _callback3 = toggleCoinCallback3,
        _callback4 = toggleCoinCallback4,
        _barcodeBtn = barcodeBtn,
        _searchBtn = searchBtn,
        _premiumCart = premiumCart,
        _howToCart = howToCart,
        _openDrawerBtn = openDrawerBtn,
        _closeDrawerBtn = closeDrawerBtn,
        super(key: key);
  final shopId;
  final ordersSnapshot;
  final buyOrdersSnapshot;
  final lossSnapshot;
  final bool isEnglish;
  @override
  OverviewPageState createState() => OverviewPageState();

// OverviewPage({Key? key, required void toggleCoinCallback()}) : super(key: key);
//
// @override
// _OverviewPageState createState() => _OverviewPageState();
}

class OverviewPageState extends State<OverviewPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<OverviewPage> {
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

  String textSetTotalSales = 'Sale reports';

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
        textSetTotalSales = 'Sale reports';

      });
    }
    else
    {
      setState(() {
        textSetTotalSales = 'အရောင်း အစီအရင်ခံစာ';
      });
    }


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

  int findMax(List<int> numbers) {
    return numbers.reduce(max);
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

  String selectDaysCast() {
    debugPrint("TTT " + today.year.toString().length.toString());
    // if(_sliding==0) {
    // today.year.toString().substring(today.year.toString().length-2, today.year.toString().length
    if(today.month == 9) {
      return today.day.toString() + ' September ' + today.year.toString();
    } else if(today.month == 1) {
      return today.day.toString() + ' January ' + today.year.toString();
    } else if(today.month == 2) {
      return today.day.toString() + ' February ' + today.year.toString();
    } else if(today.month == 3) {
      return today.day.toString() + ' March '  + today.year.toString();
    } else if(today.month == 4) {
      return today.day.toString() + ' April '  + today.year.toString();
    } else if(today.month == 5) {
      return today.day.toString() + ' May '  + today.year.toString();
    } else if(today.month == 6) {
      return today.day.toString() + ' June '  + today.year.toString();
    } else if(today.month == 7) {
      return today.day.toString() + ' July '  + today.year.toString();
    } else if(today.month == 8) {
      return today.day.toString() + ' August ' + today.year.toString();
    } else if(today.month == 10) {
      return today.day.toString() + ' October '  + today.year.toString();
    } else if(today.month == 11) {
      return today.day.toString() + ' November ' + today.year.toString();
    } else if(today.month == 12) {
      return today.day.toString() + ' December '  + today.year.toString();
    } else {
      return '';
    }

  }

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
            bottom: true,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: 81,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.Colors.grey.withOpacity(0.3),
                                width: 1.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      selectDaysCast(), textScaleFactor: 1,
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
                                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                                    child: Text(
                                      widget.isEnglish? "Ongoing sale reports": "လက်ရှိ ရောင်းဝယ် အချုပ်", textScaleFactor: 1,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
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
                            ),
                            // child: Text(textSetTotalSales, textScaleFactor: 1,
                            //   style: TextStyle(
                            //     fontSize: 23,
                            //     fontWeight: FontWeight.w500,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, left:15.0),
                            child: GestureDetector(
                              onTap: () {
                                widget._howToCart();
                              },
                              child: Container(
                                height: 30,
                                width: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    color: Colors.Colors.grey.withOpacity(0.3)),
                                child: Text(widget.isEnglish? 'How to ?': 'လမ်းညွှန်' + ' ?', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13
                                ),textScaleFactor: 1, ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 81.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0),

                        child: cateScIndex == 0 ? BlocDayOverviewImp.BlocDayOverview(
                          isEnglish: widget.isEnglish,
                          dateTime: today,
                          key: valueKeyTog(),
                          shopId: widget.shopId,
                          openDrawer : widget._openDrawerBtn,
                          closeDrawer : widget._closeDrawerBtn,
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
                          BlocDayOverviewImp.PaginateBuilderType.listView,
                          isLive: true,
                        ):
                            cateScIndex == 1 ? Container(
                              child: BlocDayOverviewImp.BlocDayOverview(
                                isEnglish: widget.isEnglish,
                                dateTime: today,
                                key: valueKeyTog(),
                                shopId: widget.shopId,
                                openDrawer : widget._openDrawerBtn,
                                closeDrawer : widget._closeDrawerBtn,
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
                                BlocDayOverviewImp.PaginateBuilderType.listView,
                                isLive: true,
                              ),
                            ):
                        BlocYearOverviewImp.BlocYearOverview(
                          isEnglish: widget.isEnglish,
                          dateTime: today,
                          key: valueKeyTog(),
                          shopId: widget.shopId,
                          openDrawer : widget._openDrawerBtn,
                          closeDrawer : widget._closeDrawerBtn,
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
                          BlocYearOverviewImp.PaginateBuilderType.listView,
                          isLive: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId.toString()).collection('orders_monthly')
        .where('date', isEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString())));
  }

  ordersQueryYear() {
    return FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders_yearly')
        .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse((today.year).toString() + '-01-01' + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString()  + '-12-31 23:59:59'));
  }

  ordersQueryMonth() {
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId.toString()).collection('orders_monthly')
        .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM").parse(today.year.toString() + '-' + zeroToTen(today.month.toString())))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM").parse(today.year.toString() + '-' + zeroToTen(nextMonth(today.month).toString())))
    ;
  }


  ayinMonth(int month) {
    if(month == 1) {
      return 12;
    } else {
      return month - 1;
    }
  }

  ayinYear(int month, int year) {
    if(month == 1) {
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
