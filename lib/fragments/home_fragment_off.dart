import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fragments/order_data_table.dart';
import 'package:smartkyat_pos/fragments/widgets_bloc/bloc_day_overview.dart' as BlocDayOverviewImp;
import 'package:smartkyat_pos/fragments/widgets_bloc/bloc_day_overview_off.dart';
import 'package:smartkyat_pos/fragments/widgets_bloc/bloc_week_overview_off.dart';
import 'package:smartkyat_pos/fragments/widgets_bloc/bloc_year_overview.dart' as BlocYearOverviewImp;
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:smartkyat_pos/models/order.dart';
import '../a11y/a11y_gallery.dart' as a11y show buildGallery;
import '../bar_chart/bar_gallery.dart' as bar show buildGallery;
import '../gallery_scaffold.dart';
import '../main.dart';
import '../model.dart';
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
import 'package:faker/faker.dart';


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
      setState(() {
        currencyUnit = value.toString();
      });
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

  double tSale = 0;
  double tRef = 0;
  double tLoss = 0;
  double tSaleAmount = 0;
  double tBuyAmount = 0;
  double tDiscount = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 900
        ? MediaQuery.of(context).size.width * (2 / 3.5)
        : MediaQuery.of(context).size.width;
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
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                              elevation: 0,
                              backgroundColor: Colors.Colors.white,

                              // Provide a standard title.

                              // Allows the user to reveal the app bar if they begin scrolling
                              // back up the list of items.
                              floating: true,
                              bottom: PreferredSize(                       // Add this code
                                preferredSize: Size.fromHeight(-2.0),      // Add this code
                                child: Container(),                           // Add this code
                              ),
                              flexibleSpace: headerAppBar(),
                              // Display a placeholder widget to visualize the shrinking size.
                              // Make the initial height of the SliverAppBar larger than normal.
                              expandedHeight: 20,
                              automaticallyImplyLeading: false
                          ),
                          SliverList(
                            // Use a delegate to build items as they're scrolled on screen.
                            delegate: SliverChildBuilderDelegate(
                              // The builder function returns a ListTile with a title that
                              // displays the index of the current item.
                                  (context, index) {
                                if(cateScIndex == 0) {
                                  return BlocDayOverviewOff();
                                  // return Container(
                                  //   // height: MediaQuery.of(context).size.height-353,
                                  //   width: width,
                                  //   color: Colors.Colors.white,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
                                  //     child: Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       children: [
                                  //         SizedBox(height: 10,),
                                  //         Container(
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.all(
                                  //               Radius.circular(10.0),
                                  //             ),
                                  //           ),
                                  //           child:  Column(
                                  //             mainAxisAlignment: MainAxisAlignment.start,
                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                  //             children: [
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(top: 0.0, bottom: 4.0, left: 15.0, right: 15.0),
                                  //                 child: Text('textSetSaleSummary', textScaleFactor: 1,
                                  //                   style: TextStyle(
                                  //                     height: 0.9,
                                  //                     letterSpacing: 2,
                                  //                     fontWeight: FontWeight.bold,
                                  //                     fontSize: 14,color: Colors.Colors.grey,
                                  //                   ),),
                                  //               ),
                                  //               Row(
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Container(
                                  //                     width: width/2,
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //                       child: Column(
                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               animatedPrice(
                                  //                                   doubleRetri(NumberFormat.compactCurrency(
                                  //                                     decimalDigits: 2,
                                  //                                     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                   ).format(100)),
                                  //                                   GoogleFonts.lato(
                                  //                                       textStyle: TextStyle(
                                  //                                           letterSpacing: 1,
                                  //                                           fontSize: 26,
                                  //                                           fontWeight: FontWeight.w500,
                                  //                                           color: Colors.Colors.black
                                  //                                       )
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(
                                  //                                 lastSRetri(NumberFormat.compactCurrency(
                                  //                                   decimalDigits: 2,
                                  //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                 ).format(100))
                                  //                                 ,
                                  //                                 textScaleFactor: 1, textAlign: TextAlign.left,
                                  //                                 style: GoogleFonts.lato(
                                  //                                     textStyle: TextStyle(
                                  //                                         letterSpacing: 1,
                                  //                                         fontSize: 26,
                                  //                                         fontWeight: FontWeight.w500,
                                  //                                         color: Colors.Colors.black
                                  //                                     )
                                  //                                 ),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           Text(
                                  //                             'textSetNetSales ($currencyUnit)',strutStyle: StrutStyle(
                                  //                               forceStrutHeight: true,
                                  //                               height: 1.2
                                  //                           ), textScaleFactor: 1,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 13, height: 1.2,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 color: Colors.Colors.black.withOpacity(0.6)),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   Container(
                                  //                     width: width/2,
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //                       child: Column(
                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               animatedPrice(
                                  //                                   doubleRetri(NumberFormat.compactCurrency(
                                  //                                     decimalDigits: 2,
                                  //                                     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                   ).format(100)),
                                  //                                   GoogleFonts.lato(
                                  //                                       textStyle: TextStyle(
                                  //                                           letterSpacing: 1,
                                  //                                           fontSize: 26,
                                  //                                           fontWeight: FontWeight.w500,
                                  //                                           color: Colors.Colors.black
                                  //                                       )
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(
                                  //                                 lastSRetri(NumberFormat.compactCurrency(
                                  //                                   decimalDigits: 2,
                                  //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                 ).format(100))
                                  //                                 ,
                                  //                                 textScaleFactor: 1, textAlign: TextAlign.left,
                                  //                                 style: GoogleFonts.lato(
                                  //                                     textStyle: TextStyle(
                                  //                                         letterSpacing: 1,
                                  //                                         fontSize: 26,
                                  //                                         fontWeight: FontWeight.w500,
                                  //                                         color: Colors.Colors.black
                                  //                                     )
                                  //                                 ),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           Text(
                                  //                             'textSetProfit ($currencyUnit)',strutStyle: StrutStyle(
                                  //                               forceStrutHeight: true,
                                  //                               height: 1.2
                                  //                           ), textScaleFactor: 1,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 13, height: 1.2,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 color: Colors.Colors.black.withOpacity(0.6)),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                 child: Container(
                                  //                   width: width,
                                  //                   decoration: BoxDecoration(
                                  //                       border: Border(
                                  //                           bottom: BorderSide(
                                  //                               color: Colors.Colors.grey
                                  //                                   .withOpacity(
                                  //                                   0.3),
                                  //                               width: 1.0)
                                  //                       )),
                                  //                 ),
                                  //               ),
                                  //               Row(
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Container(
                                  //                     width: width/2,
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //                       child: Column(
                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               animatedPrice(
                                  //                                   doubleRetri(NumberFormat.compactCurrency(
                                  //                                     decimalDigits: 2,
                                  //                                     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                   ).format(100)),
                                  //                                   GoogleFonts.lato(
                                  //                                       textStyle: TextStyle(
                                  //                                           letterSpacing: 1,
                                  //                                           fontSize: 26,
                                  //                                           fontWeight: FontWeight.w500,
                                  //                                           color: Colors.Colors.black
                                  //                                       )
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(
                                  //                                 lastSRetri(NumberFormat.compactCurrency(
                                  //                                   decimalDigits: 2,
                                  //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                 ).format(100))
                                  //                                 ,
                                  //                                 textScaleFactor: 1, textAlign: TextAlign.left,
                                  //                                 style: GoogleFonts.lato(
                                  //                                     textStyle: TextStyle(
                                  //                                         letterSpacing: 1,
                                  //                                         fontSize: 26,
                                  //                                         fontWeight: FontWeight.w500,
                                  //                                         color: Colors.Colors.black
                                  //                                     )
                                  //                                 ),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           Text(
                                  //                             'textSetStockCosts (' + currencyUnit +')',strutStyle: StrutStyle(
                                  //                               forceStrutHeight: true,
                                  //                               height: 1.2
                                  //                           ), textScaleFactor: 1,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 13, height: 1.2,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 color: Colors.Colors.black.withOpacity(0.6)),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   Container(
                                  //                     width: width/2,
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //                       child: Column(
                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               animatedPrice(
                                  //                                   doubleRetri(NumberFormat.compactCurrency(
                                  //                                     decimalDigits: 2,
                                  //                                     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                   ).format(100)),
                                  //                                   GoogleFonts.lato(
                                  //                                       textStyle: TextStyle(
                                  //                                           letterSpacing: 1,
                                  //                                           fontSize: 26,
                                  //                                           fontWeight: FontWeight.w500,
                                  //                                           color: Colors.Colors.black
                                  //                                       )
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(
                                  //                                 lastSRetri(NumberFormat.compactCurrency(
                                  //                                   decimalDigits: 2,
                                  //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                 ).format(100))
                                  //                                 ,
                                  //                                 textScaleFactor: 1, textAlign: TextAlign.left,
                                  //                                 style: GoogleFonts.lato(
                                  //                                     textStyle: TextStyle(
                                  //                                         letterSpacing: 1,
                                  //                                         fontSize: 26,
                                  //                                         fontWeight: FontWeight.w500,
                                  //                                         color: Colors.Colors.black
                                  //                                     )
                                  //                                 ),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           Text(
                                  //                             'textSetUnpaid ($currencyUnit)',strutStyle: StrutStyle(
                                  //                               forceStrutHeight: true,
                                  //                               height: 1.2
                                  //                           ), textScaleFactor: 1,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 13, height: 1.2,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 color: Colors.Colors.black.withOpacity(0.6)),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                 child: Container(
                                  //                   width: width,
                                  //                   decoration: BoxDecoration(
                                  //                       border: Border(
                                  //                           bottom: BorderSide(
                                  //                               color: Colors.Colors.grey
                                  //                                   .withOpacity(
                                  //                                   0.3),
                                  //                               width: 1.0)
                                  //                       )),
                                  //                 ),
                                  //               ),
                                  //               Row(
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Container(
                                  //                     width: width/2,
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //                       child: Column(
                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               animatedPrice(
                                  //                                   doubleRetri(NumberFormat.compactCurrency(
                                  //                                     decimalDigits: 2,
                                  //                                     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                   ).format(100)),
                                  //                                   GoogleFonts.lato(
                                  //                                       textStyle: TextStyle(
                                  //                                           letterSpacing: 1,
                                  //                                           fontSize: 26,
                                  //                                           fontWeight: FontWeight.w500,
                                  //                                           color: Colors.Colors.black
                                  //                                       )
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(
                                  //                                 lastSRetri(NumberFormat.compactCurrency(
                                  //                                   decimalDigits: 2,
                                  //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                 ).format(100))
                                  //                                 ,
                                  //                                 textScaleFactor: 1, textAlign: TextAlign.left,
                                  //                                 style: GoogleFonts.lato(
                                  //                                     textStyle: TextStyle(
                                  //                                         letterSpacing: 1,
                                  //                                         fontSize: 26,
                                  //                                         fontWeight: FontWeight.w500,
                                  //                                         color: Colors.Colors.black
                                  //                                     )
                                  //                                 ),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           Text(
                                  //                             'textSetRef ($currencyUnit)',strutStyle: StrutStyle(
                                  //                               forceStrutHeight: true,
                                  //                               height: 1.2
                                  //                           ), textScaleFactor: 1,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 13, height: 1.2,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 color: Colors.Colors.black.withOpacity(0.6)),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   Container(
                                  //                     width: width/2,
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //                       child: Column(
                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               animatedPrice(
                                  //                                   doubleRetri(NumberFormat.compactCurrency(
                                  //                                     decimalDigits: 2,
                                  //                                     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                   ).format(100)),
                                  //                                   GoogleFonts.lato(
                                  //                                       textStyle: TextStyle(
                                  //                                           letterSpacing: 1,
                                  //                                           fontSize: 26,
                                  //                                           fontWeight: FontWeight.w500,
                                  //                                           color: Colors.Colors.black
                                  //                                       )
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(
                                  //                                 lastSRetri(NumberFormat.compactCurrency(
                                  //                                   decimalDigits: 2,
                                  //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  //                                 ).format(100))
                                  //                                 ,
                                  //                                 textScaleFactor: 1, textAlign: TextAlign.left,
                                  //                                 style: GoogleFonts.lato(
                                  //                                     textStyle: TextStyle(
                                  //                                         letterSpacing: 1,
                                  //                                         fontSize: 26,
                                  //                                         fontWeight: FontWeight.w500,
                                  //                                         color: Colors.Colors.black
                                  //                                     )
                                  //                                 ),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           Text(
                                  //                             'textSetLoss ($currencyUnit)',strutStyle: StrutStyle(
                                  //                               forceStrutHeight: true,
                                  //                               height: 1.2
                                  //                           ), textScaleFactor: 1,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 13, height: 1.2,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 color: Colors.Colors.black.withOpacity(0.6)),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               // Padding(
                                  //               //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //               //   child: Container(
                                  //               //     width: width,
                                  //               //     decoration: BoxDecoration(
                                  //               //         border: Border(
                                  //               //             bottom: BorderSide(
                                  //               //                 color: Colors.Colors.grey
                                  //               //                     .withOpacity(
                                  //               //                     0.3),
                                  //               //                 width: 1.0)
                                  //               //         )),
                                  //               //   ),
                                  //               // ),
                                  //               // Row(
                                  //               //   children: [
                                  //               //     Container(
                                  //               //       width: width/2,
                                  //               //       child: Padding(
                                  //               //         padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  //               //         child: Column(
                                  //               //           crossAxisAlignment: CrossAxisAlignment.start,
                                  //               //           children: [
                                  //               //             Row(
                                  //               //               children: [
                                  //               //                 Text(
                                  //               //                   '45',
                                  //               //                   textScaleFactor: 1, textAlign: TextAlign.left,
                                  //               //                   style: GoogleFonts.lato(
                                  //               //                       textStyle: TextStyle(
                                  //               //                           letterSpacing: 1,
                                  //               //                           fontSize: 26,
                                  //               //                           fontWeight: FontWeight.w500,
                                  //               //                           color: Colors.Colors.black
                                  //               //                       )
                                  //               //                   ),
                                  //               //                 ),
                                  //               //                 Padding(
                                  //               //                   padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                  //               //                   child: Text(
                                  //               //                     'M',strutStyle: StrutStyle(
                                  //               //                       forceStrutHeight: true,
                                  //               //                       height: 1.2
                                  //               //                   ),
                                  //               //                     style: TextStyle(
                                  //               //                         fontSize: 27, height: 1.2,
                                  //               //                         fontWeight: FontWeight.w500,
                                  //               //                         color: Colors.Colors.black),
                                  //               //                   ),
                                  //               //                 )
                                  //               //               ],
                                  //               //             ),
                                  //               //             Text(
                                  //               //               'Loss amount (MMK)',strutStyle: StrutStyle(
                                  //               //                 forceStrutHeight: true,
                                  //               //                 height: 1.2
                                  //               //             ),
                                  //               //               style: TextStyle(
                                  //               //                   fontSize: 13, height: 1.2,
                                  //               //                   fontWeight: FontWeight.w500,
                                  //               //                   color: Colors.Colors.black.withOpacity(0.6)),
                                  //               //             ),
                                  //               //           ],
                                  //               //         ),
                                  //               //       ),
                                  //               //     ),
                                  //               //
                                  //               //   ],
                                  //               // ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0, top: 4),
                                  //                 child: ButtonTheme(
                                  //                   minWidth: width,
                                  //                   splashColor: Colors.Colors.transparent,
                                  //                   height: 50,
                                  //                   child: FlatButton(
                                  //                     color: AppTheme.buttonColor2,
                                  //                     shape: RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                       BorderRadius.circular(10.0),
                                  //                       side: BorderSide(
                                  //                         color: AppTheme.buttonColor2,
                                  //                       ),
                                  //                     ),
                                  //                     onPressed: () async {
                                  //                       closeDrawerFrom();
                                  //                       // await Navigator.push(
                                  //                       //   context,
                                  //                       //   MaterialPageRoute(
                                  //                       //       builder: (
                                  //                       //           context) =>
                                  //                       //           HomeFragment(
                                  //                       //             shopId: widget.shopId, tab: cateScIndex, openDrawerBtn: widget._openDrawer, closeDrawerBtn: widget._closeDrawer, isEnglish: widget.isEnglish,
                                  //                       //           )),
                                  //                       // );
                                  //                       openDrawerFrom();
                                  //                     },
                                  //                     child: Padding(
                                  //                       padding: const EdgeInsets.only(
                                  //                           left: 5.0,
                                  //                           right: 5.0,
                                  //                           bottom: 2.0),
                                  //                       child: Container(
                                  //                         child: Text(
                                  //                             'textSetMore', textScaleFactor: 1,
                                  //                             textAlign: TextAlign.center,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 18,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 letterSpacing:-0.1
                                  //                             ),
                                  //                             strutStyle: StrutStyle(
                                  //                               height: 1.4,
                                  //                               forceStrutHeight: true,
                                  //                             )
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               Container(
                                  //                 width: width,
                                  //                 decoration: BoxDecoration(
                                  //                     border: Border(
                                  //                         bottom: BorderSide(
                                  //                             color: Colors.Colors.grey
                                  //                                 .withOpacity(
                                  //                                 0.3),
                                  //                             width: 1.0)
                                  //                     )),
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 10.0),
                                  //                 child: Text('textSetProdSale', textScaleFactor: 1,
                                  //                   style: TextStyle(
                                  //                     height: 0.9,
                                  //                     letterSpacing: 2,
                                  //                     fontWeight: FontWeight.bold,
                                  //                     fontSize: 14,color: Colors.Colors.grey,
                                  //                   ),),
                                  //               ),
                                  //               Column(
                                  //                 children: [
                                  //                   Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                         child: Container(
                                  //                           height: 55,
                                  //                           child: Row(
                                  //                             children: [
                                  //                               Text('textSetTSales', textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                               Spacer(),
                                  //                               animatedPrice(
                                  //                                   100,
                                  //                                   TextStyle(
                                  //                                     fontSize: 16,
                                  //                                     fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                                   ),
                                  //                                   0
                                  //                               ),
                                  //                               Text((widget.isEnglish? ' types': ' မျိုး'), textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),
                                  //                               ),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.only(left: 15.0),
                                  //                         child: Container(
                                  //                           decoration: BoxDecoration(
                                  //                               border: Border(
                                  //                                   bottom: BorderSide(
                                  //                                       color: Colors.Colors.grey
                                  //                                           .withOpacity(0.2),
                                  //                                       width: 1.0))),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //
                                  //
                                  //                   Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                         child: Container(
                                  //                           height: 55,
                                  //                           child: Row(
                                  //                             children: [
                                  //                               Text('textSetTLoss', textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                               Spacer(),
                                  //                               animatedPrice(
                                  //                                   100,
                                  //                                   TextStyle(
                                  //                                     fontSize: 16,
                                  //                                     fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                                   ),
                                  //                                   0
                                  //                               ),
                                  //                               Text((widget.isEnglish? ' types': ' မျိုး'), textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.only(left: 15.0),
                                  //                         child: Container(
                                  //                           decoration: BoxDecoration(
                                  //                               border: Border(
                                  //                                   bottom: BorderSide(
                                  //                                       color: Colors.Colors.grey
                                  //                                           .withOpacity(0.2),
                                  //                                       width: 1.0))),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                         child: Container(
                                  //                           height: 55,
                                  //                           child: Row(
                                  //                             children: [
                                  //                               Text('textSetTRef', textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                               Spacer(),
                                  //                               animatedPrice(
                                  //                                   100,
                                  //                                   TextStyle(
                                  //                                     fontSize: 16,
                                  //                                     fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                                   ),
                                  //                                   0
                                  //                               ),
                                  //                               Text((widget.isEnglish? ' types': ' မျိုး'), textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.only(left: 15.0),
                                  //                         child: Container(
                                  //                           decoration: BoxDecoration(
                                  //                               border: Border(
                                  //                                   bottom: BorderSide(
                                  //                                       color: Colors.Colors.grey
                                  //                                           .withOpacity(0.2),
                                  //                                       width: 1.0))),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                         child: Container(
                                  //                           height: 55,
                                  //                           child: Row(
                                  //                             children: [
                                  //                               Text('textSetSaleAmt', textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                               Spacer(),
                                  //                               animatedPrice(
                                  //                                   100,
                                  //                                   TextStyle(
                                  //                                     fontSize: 16,
                                  //                                     fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(' ' +currencyUnit, textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.only(left: 15.0),
                                  //                         child: Container(
                                  //                           decoration: BoxDecoration(
                                  //                               border: Border(
                                  //                                   bottom: BorderSide(
                                  //                                       color: Colors.Colors.grey
                                  //                                           .withOpacity(0.2),
                                  //                                       width: 1.0))),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                         child: Container(
                                  //                           height: 55,
                                  //                           child: Row(
                                  //                             children: [
                                  //                               Text('textSetBuyAmt', textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                               Spacer(),
                                  //                               animatedPrice(
                                  //                                   100,
                                  //                                   TextStyle(
                                  //                                     fontSize: 16,
                                  //                                     fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(' ' +currencyUnit, textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.only(left: 15.0),
                                  //                         child: Container(
                                  //                           decoration: BoxDecoration(
                                  //                               border: Border(
                                  //                                   bottom: BorderSide(
                                  //                                       color: Colors.Colors.grey
                                  //                                           .withOpacity(0.2),
                                  //                                       width: 1.0))),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Column(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                         child: Container(
                                  //                           height: 55,
                                  //                           child: Row(
                                  //                             children: [
                                  //                               Text('textSetDiscount', textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                               Spacer(),
                                  //                               animatedPrice(
                                  //                                   100,
                                  //                                   TextStyle(
                                  //                                     fontSize: 16,
                                  //                                     fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                                   ),
                                  //                                   2
                                  //                               ),
                                  //                               Text(' ' +currencyUnit, textScaleFactor: 1, style:
                                  //                               TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                               ),),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   // Column(
                                  //                   //   children: [
                                  //                   //     Padding(
                                  //                   //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //                   //       child: Container(
                                  //                   //         height: 55,
                                  //                   //         child: Row(
                                  //                   //           children: [
                                  //                   //             Text('Total products', textScaleFactor: 1, style:
                                  //                   //             TextStyle(
                                  //                   //               fontSize: 16,
                                  //                   //               fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                   //             ),),
                                  //                   //             Spacer(),
                                  //                   //             Text('7,3454', textScaleFactor: 1, style:
                                  //                   //             TextStyle(
                                  //                   //               fontSize: 16,
                                  //                   //               fontWeight: FontWeight.w500, color: Colors.Colors.black,
                                  //                   //             ),),
                                  //                   //           ],
                                  //                   //         ),
                                  //                   //       ),
                                  //                   //     ),
                                  //                   //   ],
                                  //                   // ),
                                  //                 ],
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 16.0, top: 10),
                                  //                 child: ButtonTheme(
                                  //                   minWidth: width,
                                  //                   splashColor: Colors.Colors.transparent,
                                  //                   height: 50,
                                  //                   child: FlatButton(
                                  //                     color: AppTheme.buttonColor2,
                                  //                     shape: RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                       BorderRadius.circular(10.0),
                                  //                       side: BorderSide(
                                  //                         color: AppTheme.buttonColor2,
                                  //                       ),
                                  //                     ),
                                  //                     onPressed: () async {
                                  //                       closeDrawerFrom();
                                  //                       // await Navigator.push(
                                  //                       //   context,
                                  //                       //   MaterialPageRoute(
                                  //                       //       builder: (
                                  //                       //           context) =>
                                  //                       //           ProdSaleSumHome(
                                  //                       //             shopId: widget.shopId,  tab: cateScIndex,openDrawerBtn: widget._openDrawer, closeDrawerBtn: widget._closeDrawer, isEnglish: widget.isEnglish,
                                  //                       //           )),
                                  //                       // );
                                  //                       openDrawerFrom();
                                  //                     },
                                  //                     child: Padding(
                                  //                       padding: const EdgeInsets.only(
                                  //                           left: 5.0,
                                  //                           right: 5.0,
                                  //                           bottom: 2.0),
                                  //                       child: Container(
                                  //                         child: Text(
                                  //                             'textSetMore', textScaleFactor: 1,
                                  //                             textAlign: TextAlign.center,
                                  //                             style: TextStyle(
                                  //                                 fontSize: 18,
                                  //                                 fontWeight: FontWeight.w500,
                                  //                                 letterSpacing:-0.1
                                  //                             ),
                                  //                             strutStyle: StrutStyle(
                                  //                               height: 1.4,
                                  //                               forceStrutHeight: true,
                                  //                             )
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //
                                  //
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // );
                                } else if(cateScIndex == 1) {
                                  return BlocWeekOverviewOff();
                                }
                              },
                              // Builds 1000 ListTiles
                              childCount: 1,
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

  final faker = Faker();

  void setNewCustomer() {
    // TODO: Implement properly
    print('Name: ${faker.person.name()}');
  }

  void addFakeOrderForCurrentCustomer() {
    // TODO: Implement properly
    print('Price: ${faker.randomGenerator.integer(500, min: 10)}');
  }

  GestureDetector Function(BuildContext, int) _itemBuilder(List<SaleOrder> saleOrders) =>
          (BuildContext context, int index) => GestureDetector(
        onTap: () => objectbox.noteBox.remove(saleOrders[index].id),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.Colors.black12))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        saleOrders[index].total.toString(),
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                        // Provide a Key for the integration test
                        key: Key('list_item_$index'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Added on ${saleOrders[index].dateFormat}',
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  int segmentedControlGroupValue = 0;
  Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Today", textScaleFactor: 1),
    1: Text("Month", textScaleFactor: 1),
    2: Text("Year", textScaleFactor: 1)
  };

  headerAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0, right: 15.0),
      child: Container(
        height: 32,
        width: MediaQuery.of(context).size.width,
        // color: Colors.yellow,
        child: CupertinoSlidingSegmentedControl(
            groupValue: segmentedControlGroupValue,
            children: myTabs,
            onValueChanged: (i) {
              setState(() {
                cateScIndex = int.parse(i.toString());
                _sliding = int.parse(i.toString());
                segmentedControlGroupValue = int.parse(i.toString());
                // widget._selectedIntVal(i);
              });

              print('catescindex ' + i.toString());
            }),

      ),
    );
  }

  doubleRetri(String format) {
    if(format[format.length-1]!= 'K' && format[format.length-1]!= 'M' && format[format.length-1]!= 'B') {
      return double.parse(format);
    } else {
      return double.parse(format.substring(0, format.length-1));
    }
    // return format[format.length]
  }

  lastSRetri(String format) {
    if(format[format.length-1]!= 'K' && format[format.length-1]!= 'M' && format[format.length-1]!= 'B') {
      return '';
    } else {
      return format[format.length-1];
    }
  }

  animatedPrice(double price, style, precision) {
    double temp = 0;
    double total =  price;
    return Countup(
      precision: precision,
      begin: temp,
      end: total,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
      separator: ',',
      style: style, textScaleFactor: 1,
    );
  }
}
