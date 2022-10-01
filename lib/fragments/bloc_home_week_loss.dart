library paginate_firestore;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import 'bloc/pagination_cubit.dart';
import 'bloc/pagination_listeners.dart';
import 'widgets_bloc/bottom_loader.dart';
import 'widgets_bloc/empty_display.dart';
import 'widgets_bloc/empty_separator.dart';
import 'widgets_bloc/error_display.dart';
import 'widgets_bloc/initial_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocHomeWeekLoss extends StatefulWidget {

  const BlocHomeWeekLoss({
    Key? key,
    required this.itemBuilder,
    required this.query,
    // required this.itemBuilderType,
    this.gridDelegate =
    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    this.startAfterDocument,
    this.itemsPerPage = 15,
    this.onError,
    this.onReachedEnd,
    this.onLoaded,
    this.onEmpty = const EmptyDisplay(),
    this.separator = const EmptySeparator(),
    this.initialLoader = const InitialLoader(),
    this.bottomLoader = const BottomLoader(),
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.all(0),
    this.physics,
    this.listeners,
    this.scrollController,
    this.allowImplicitScrolling = false,
    this.pageController,
    this.onPageChanged,
    this.header,
    this.footer,
    this.isLive = false,
    this.includeMetadataChanges = false,
    this.options,
    this.shopId,
    this.dateTime,
    required this.intValIni,
    required void resetState(DateTime resetD),
    required void selectedIntVal(int index),
    required this.sale, required this.buy,
    required this.isEnglish,
  }) :
        _resetState = resetState,
        _selectedIntVal = selectedIntVal,
        super(key: key);

  final int intValIni;
  final List<DocumentSnapshot<Object?>> sale;
  final List<DocumentSnapshot<Object?>> buy;
  final Widget bottomLoader;
  final Widget onEmpty;
  final SliverGridDelegate gridDelegate;
  final Widget initialLoader;
  // final PaginateBuilderType itemBuilderType;
  final int itemsPerPage;
  final List<ChangeNotifier>? listeners;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final Query query;
  final bool reverse;
  final bool allowImplicitScrolling;
  final ScrollController? scrollController;
  final PageController? pageController;
  final Axis scrollDirection;
  final Widget separator;
  final bool shrinkWrap;
  final bool isLive;
  final DocumentSnapshot? startAfterDocument;
  final Widget? header;
  final Widget? footer;
  final String? shopId;
  final DateTime? dateTime;
  final _resetState;
  final _selectedIntVal;
  final bool isEnglish;

  /// Use this only if `isLive = false`
  final GetOptions? options;

  /// Use this only if `isLive = true`
  final bool includeMetadataChanges;

  @override
  _BlocHomeWeekLossState createState() => _BlocHomeWeekLossState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _BlocHomeWeekLossState extends State<BlocHomeWeekLoss> {
  PaginationCubit? _cubit;
  String currencyUnit = 'MMK';
  String searchValue = '';
  int slidingSearch = 0;
  bool noSearchData = false;
  bool searchingOverAll = false;
  late TabController _controller;
  late TabController tabController, subTabController;
  String slidedText = 'Products^0';
  String gloSearchText = '';
  int gloSeaProLeng = 0;

  String textSetReports = 'Reports';
  String textSetSaleSummary = 'Sales summary detail';
  String textSetStockCosts = 'Stock costs';
  String textSetUnpaid = 'Unpaid';
  String textSetBuys = 'Refund amount';
  String textSetLoss = 'Loss amount';
  String textSetToday = 'Day';
  String textSetLastWeek = 'Last week';
  String textSetLastMonth = 'This month';
  String textSetLastYear = 'Last year';
  String textSetInOut = 'SALES IN-OUT SUMMARY';
  String textSetNetSales = 'Net sales';
  String textSetAvgProf = 'Avg profit';
  String textSetEarn = 'Debt to income';
  String textSetCharts = 'SALES SUMMARY CHARTS';
  String textSetTotal = 'Total sales';

  var prodsSnap;
  var prodSaleData;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationCubit, PaginationState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is PaginationInitial) {
          return widget.initialLoader;
        } else if (state is PaginationError) {
          return (widget.onError != null)
              ? widget.onError!(state.error)
              : ErrorDisplay(exception: state.error);
        } else {
          final loadedState = state as PaginationLoaded;
          if (widget.onLoaded != null) {
            widget.onLoaded!(loadedState);
          }
          if (loadedState.hasReachedEnd && widget.onReachedEnd != null) {
            widget.onReachedEnd!(loadedState);
          }

          // if (loadedState.documentSnapshots.isEmpty) {
          //   // return widget.onEmpty;
          //   return Align(
          //     alignment: Alignment.topCenter,
          //     child: Column(
          //       children: [
          //         headerAppBar(),
          //         Expanded(
          //           child: Container(
          //             // color: AppTheme.lightBgColor,
          //             color: Colors.white,
          //             child: Center(child: Text('No data found for selected week', style: TextStyle(fontSize: 15),)),
          //           ),
          //         )
          //       ],
          //     ),
          //   );
          // }
          return _buildListView(loadedState);
        }
      },
    );
  }

  @override
  void dispose() {
    widget.scrollController?.dispose();
    _cubit?.dispose();
    super.dispose();
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  String paperType = 'Roll-80';
  var _selectedTest;
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];

  List _testList = [
    {'no': 1, 'keyword': 'Roll-80'},
    {'no': 2, 'keyword': 'Roll-57'},
    {'no': 3, 'keyword': 'Legal'},
    {'no': 4, 'keyword': 'A4'}
  ];

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword'], textScaleFactor: 1,),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    setState(() {
      _selectedTest = selectedTest;
    });
  }

  var dropdownValue;
  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Today"),
    2: Text("This month"),
    3: Text("This year")
  };

  @override
  void initState() {
    // debugPrint('iphone 3 ' + DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.dateTime!.year.toString() + '-' + zeroToTen(widget.dateTime!.month.toString()) + '-' + zeroToTen(widget.dateTime!.day.toString()) + ' 00:00:00').subtract(Duration(days: 6)).toString());
    prodsSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr').snapshots();
    prodSaleData =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodSaleData')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.dateTime!.year.toString() + '-' + zeroToTen(widget.dateTime!.month.toString()) + '-' + zeroToTen(widget.dateTime!.day.toString()) + ' 00:00:00').subtract(Duration(days: 6)))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.dateTime!.year.toString() + '-' + zeroToTen((widget.dateTime!.month).toString()) + '-' + zeroToTen(widget.dateTime!.day.toString()) + ' 23:59:59'))
        .orderBy('date', descending: true)
        .snapshots();

    _dropdownTestItems = buildDropdownTestItems(_testList);
    // getStoreId().then((value) {
    //   setState(() {
    //     _result = value.toString();
    //   });
    // });

    cateScIndex = widget.intValIni;
    _sliding = widget.intValIni;
    today = widget.dateTime!;
    _dateTime = today;
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

    if(widget.isEnglish == true) {

      setState(() {
         textSetReports = 'Reports';
         textSetSaleSummary = 'Sales summary detail';
         textSetStockCosts = 'Stock costs';
         textSetUnpaid = 'Unpaid';
         textSetBuys = 'Refund amount';
         textSetLoss = 'Loss amount';
         textSetToday = 'Day';
         textSetLastWeek = 'Last week';
         textSetLastMonth = 'This month';
         textSetLastYear = 'Last year';
         textSetInOut = 'SALES IN-OUT SUMMARY';
         textSetNetSales = 'Net sales';
         textSetAvgProf = 'Avg profit';
         textSetEarn = 'Debt to income';
         textSetCharts = 'SALES SUMMARY CHARTS';
         textSetTotal = 'Total sales';
      });
    } else {
      setState(() {
         textSetReports = 'အစီအရင်ခံစာ';
         textSetSaleSummary = 'Sales summary detail';
         textSetStockCosts = 'ဝယ်ယူစရိတ်';
         textSetUnpaid = 'အကြွေးကျန်ငွေ';
         textSetBuys = 'ပြန်ပေးငွေ';
         textSetLoss = 'ဆုံးရှုံးငွေ';
         textSetToday = 'နေ့စဉ်';
         textSetLastWeek = 'အပတ်စဉ်';
         textSetLastMonth = 'လစဉ်';
         textSetLastYear = 'နှစ်စဉ်';
         textSetInOut = 'SALES IN-OUT SUMMARY';
         textSetNetSales = 'ရောင်းရငွေ';
         textSetAvgProf = 'ပျမ်းမျှအမြတ်ငွေ';
         textSetEarn = 'အကြွေးရငွေ';
         textSetCharts = 'SALES SUMMARY CHARTS';
         textSetTotal = 'စုစုပေါင်း ရောင်းရငွေ';
      });
    }

    if (widget.listeners != null) {
      for (var listener in widget.listeners!) {
        if (listener is PaginateRefreshedChangeListener) {
          listener.addListener(() {
            if (listener.refreshed) {
              _cubit!.refreshPaginatedList();
            }
          });
        } else if (listener is PaginateFilterChangeListener) {
          listener.addListener(() {
            if (listener.searchTerm.isNotEmpty) {
              _cubit!.filterPaginatedList(listener.searchTerm);
            }
          });
        }
      }
    }



    _cubit = PaginationCubit(
      widget.query,
      widget.itemsPerPage,
      widget.startAfterDocument,
      isLive: widget.isLive,
    )..fetchPaginatedList();
    // _cubit = PaginationCubit(
    //   ordersQuery(),
    //   widget.itemsPerPage,
    //   widget.startAfterDocument,
    //   isLive: widget.isLive,
    // )..fetchPaginatedList();
    super.initState();
  }

  ordersQuery() {
    // DateTime greaterThan = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00');
    // return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
    //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
    //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 00:00:00'))
    //     .orderBy('date', descending: true);
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders');
  }

  Widget _buildListView(PaginationLoaded loadedState) {

    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
     // debugPrint('inside loss loss ' + data.toString());
    }


    for(int i = 0; i < widget.sale.length; i++) {
      Map<String, dynamic> data = widget.sale[i].data() as Map<String, dynamic>;
      // debugPrint('inside loss sale ' + data.toString());
    }

    for(int i = 0; i < widget.buy.length; i++) {
      Map<String, dynamic> data = widget.buy[i].data() as Map<String, dynamic>;
      //debugPrint('inside loss buy ' + data.toString());
    }

    fetchOrdersMY(loadedState.documentSnapshots);

    fetchOrders(widget.sale, widget.buy);

    var listView = CustomScrollView(
      reverse: widget.reverse,
      controller: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      physics:
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // CupertinoSliverRefreshControl(
        //
        //   onRefresh: () async {
        //     await Future.delayed(Duration(seconds: 2));
        //   },
        // ),
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.white,
           automaticallyImplyLeading: false,
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
        ),
        // SliverAppBar(
        //   // automaticallyImplyLeading: false,
        //   title: Text('2'),
        //   backgroundColor: Colors.white,
        //   // floating: true,
        //   pinned: true,
        //   elevation: 1,
        // ),
        // SliverAppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //
        //   // Provide a standard title.
        //
        //   // Allows the user to reveal the app bar if they begin scrolling
        //   // back up the list of items.
        //   floating: true,
        //   bottom: PreferredSize(                       // Add this code
        //     preferredSize: Size.fromHeight(-2.0),      // Add this code
        //     child: Container(),                           // Add this code
        //   ),
        //   flexibleSpace: headerAppBar2(),
        //   // Display a placeholder widget to visualize the shrinking size.
        //   // Make the initial height of the SliverAppBar larger than normal.
        //   expandedHeight: 20,
        //   pinned: true,
        // ),

        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
                (context, index) {
              if(cateScIndex == 0 || cateScIndex == 1) {
                return Container(
                  // height: MediaQuery.of(context).size.height-353,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                              //   child: Container(
                              //     height: 1,
                              //     color: AppTheme.skBorderColor2,
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'SALES IN-OUT SUMMARY',textScaleFactor: 1,
                                        style: TextStyle(
                                          height: 0.9,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            totalBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                            child: Text(
                                              currencyUnit, textScaleFactor: 1,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black
                                                    )
                                          ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textSetNetSales + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          percentBySale() == 1001 || percentBySale() == 1000 ?
                                          Text('') :
                                          Text(
                                            percentBySale().abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                              color: percentBySale() == 1001 || percentBySale() == 1000 ? Colors.blue: percentBySale() < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          percentBySale() == 1001 || percentBySale() == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  percentBySale() < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            profitBySlide().toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                              child: Text(
                                                  currencyUnit, textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black
                                                      )
                                                  ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textSetAvgProf + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          growthRateDayProfit(lastProfitBySlide(), profitBySlide()) == 1001 || growthRateDayProfit(lastProfitBySlide(), profitBySlide()) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateDayProfit(lastProfitBySlide(), profitBySlide()).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateDayProfit(lastProfitBySlide(), profitBySlide()) == 1001 || growthRateDayProfit(lastProfitBySlide(), profitBySlide()) == 1000 ? Colors.blue: growthRateDayProfit(lastProfitBySlide(), profitBySlide()) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateDayProfit(lastProfitBySlide(), profitBySlide()) == 1001 || growthRateDayProfit(lastProfitBySlide(), profitBySlide()) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  growthRateDayProfit(lastProfitBySlide(), profitBySlide()) < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')', strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            totalEarnBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                              child: Text(
                                                  currencyUnit, textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black
                                                      )
                                                  ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textSetEarn + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          percentByEarn() == 1001 || percentByEarn() == 1000 ?
                                          Text('') :
                                          Text(
                                            percentByEarn().abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: percentByEarn() == 1001 || percentByEarn() == 1000 ? Colors.blue: percentByEarn() < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          percentByEarn() == 1001 || percentByEarn() == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  percentByEarn() < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            totalStockCostsBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                              child: Text(
                                                  currencyUnit, textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black
                                                      )
                                                  ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textSetUnpaid + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          percentByUnpaid() == 1001 || percentByUnpaid() == 1000 ?
                                          Text('') :
                                          Text(
                                            percentByUnpaid().abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: percentByUnpaid() == 1001 || percentByUnpaid() == 1000 ? Colors.blue: percentByUnpaid() < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          percentByUnpaid() == 1001 || percentByUnpaid() == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  percentByUnpaid() < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey
                                                .withOpacity(
                                                0.3),
                                            width: 1.0)
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0 ,bottom: 25.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'SALES SUMMARY CHARTS',textScaleFactor: 1,
                                        style: TextStyle(
                                          height: 0.9,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  children: [
                                    // Expanded(
                                    //   child: Text(
                                    //     'CHART DATA',
                                    //     style: TextStyle(
                                    //       letterSpacing: 2,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 14,color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),

                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 1.0),
                                      child: Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                            color: Colors.blue
                                        ),

                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      textSetTotal, textScaleFactor: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,color: Colors.grey,
                                          letterSpacing: 0.6
                                      ),
                                    ),
                                    SizedBox(width: 0),

                                  ],
                                ),
                              ),
                              Stack(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: AspectRatio(
                                      aspectRatio: MediaQuery.of(context).size.width > 700? 2.0: 1.5,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          // color: Color(0xffFFFFFF)),
                                          // color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 18.0, left: 8.0, top: 10, bottom: 10),
                                          child: lineChartByTab(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //     width: double.infinity,
                                  //     height: 15,
                                  //     color: AppTheme.skBorderColor
                                  // ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            totalStockCostsRBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                              child: Text(
                                                  currencyUnit, textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black
                                                      )
                                                  ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textSetStockCosts + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          percentByCost() == 1001 || percentByCost() == 1000 ?
                                          Text('') :
                                          Text(
                                            percentByCost().abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: percentByCost() == 1001 || percentByCost() == 1000 ? Colors.blue: percentByCost() < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          percentByCost() == 1001 || percentByCost() == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  percentByCost() < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            totalRefundBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                              child: Text(
                                                  currencyUnit, textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black
                                                      )
                                                  ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                           textSetBuys + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          percentByRefund() == 1001 || percentByRefund() == 1000 ?
                                          Text('') :
                                          Text(
                                            percentByRefund().abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: percentByRefund() == 1001 || percentByRefund() == 1000 ? Colors.blue: percentByRefund() < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          percentByRefund() == 1001 || percentByRefund() == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  percentByRefund() < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            totalLossBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textScaleFactor: 1, textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                )
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                                              child: Text(
                                                  currencyUnit, textScaleFactor: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black
                                                      )
                                                  ) ) ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textSetLoss + ' (',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          percentByLoss() == 1001 || percentByLoss() == 1000 ?
                                          Text('') :
                                          Text(
                                            percentByLoss().abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: percentByLoss() == 1001 || percentByLoss() == 1000 ? Colors.blue: percentByLoss() < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          percentByLoss() == 1001 || percentByLoss() == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  percentByLoss() < 0?
                                          Text(
                                            'lower than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :
                                          Text(
                                            'higher than ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            yestWeekTitle().toString() + ')',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 15.0, right: 15.0),
                              //   child: Container(
                              //     height: 2,
                              //     color: Colors.grey.withOpacity(0.1),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(10.0),
                        //         ),
                        //         border: Border(
                        //           bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                        //           top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                        //           left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                        //           right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                        //         ),
                        //         color: AppTheme.lightBgColor
                        //     ),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        //           child: Row(
                        //             children: [
                        //               Text('Top sale categories',
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w500,
                        //                     color: Colors.black),
                        //               ),
                        //               Expanded(
                        //                 child: GestureDetector(
                        //                   onTap: () {
                        //                     Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail(shopId: shopId.toString(),)),);
                        //                   },
                        //                   child: Text('Detail',
                        //                     textAlign: TextAlign.right,
                        //                     style: TextStyle(
                        //                         fontSize: 15,
                        //                         fontWeight: FontWeight.w500,
                        //                         color: Colors.blue),
                        //                   ),
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 15.0),
                        //           child: Container(
                        //             height: 1,
                        //             color: AppTheme.skBorderColor2,
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                        //           child: Container(
                        //             width: double.infinity,
                        //             height: 150,
                        //             child: Container(
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(0.0),
                        //                 child: new SimplePieChart.withRandomData(),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        //   stream: prodsSnap,
                        //   builder: (BuildContext context, prodsSB) {
                        //     if(prodsSB.hasData) {
                        //       var prodsSnapOut = prodsSB.data != null? prodsSB.data!.data(): null;
                        //       var prodsSc = prodsSnapOut?['prods'];
                        //       return StreamBuilder(
                        //           stream: prodSaleData,
                        //           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //             if(snapshot.hasData) {
                        //               //debugPrint('snapshot len ' + snapshot.data!.docs.length.toString());
                        //               if(cateScIndex == 0) {
                        //                 var prodsDoc;
                        //                 // Map<String, dynamic>
                        //                 for(int i=0; i<snapshot.data!.docs.length; i++) {
                        //                   Map<String, dynamic> eachDoc = snapshot.data!.docs[i].data()! as Map<String, dynamic>;
                        //                   DateTime docDate = eachDoc['date'].toDate();
                        //                   if(today.day == docDate.day) {
                        //                     prodsDoc = snapshot.data!.docs[i].data()! as Map<String, dynamic>;
                        //                   }
                        //                  // debugPrint('iphone ' + eachDoc['date'].toDate().toString());
                        //                 }
                        //                 if(prodsDoc != null) {
                        //                   var prods = prodsDoc['prods'];
                        //                   var prodsPrep = {};
                        //
                        //                   for(int i = 0; i < prods.length; i++) {
                        //                     var eachMap = prods.entries.elementAt(i);
                        //                    // debugPrint('jisoo ' + prodsSc[eachMap.key].toString());
                        //                     double sort = 0;
                        //                     double main = eachMap.value['im'] == null? 0: eachMap.value['im'];
                        //                     double sub1 = eachMap.value['i1'] == null? 0: eachMap.value['i1'];
                        //                     double sub2 = eachMap.value['i2'] == null? 0: eachMap.value['i2'];
                        //
                        //                 //    debugPrint('setting 1 ' + prodsSc[eachMap.key].toString());
                        //                   //  debugPrint('setting 2 ' + main.toString() + ' ' + sub1.toString() + ' ' + sub2.toString());
                        //                     if(eachMap.value['im']!=0 && eachMap.value['im']!=null) {
                        //                       sort += eachMap.value['im'];
                        //                     }
                        //                     if(prodsSc[eachMap.key]['c1'] != 0 && eachMap.value['i1']!=null) {
                        //                       sort += sub1/prodsSc[eachMap.key]['c1'];
                        //                     }
                        //                     if(prodsSc[eachMap.key]['c2'] != 0 && prodsSc[eachMap.key]['c1'] != 0 && eachMap.value['i2']!=null) {
                        //                      // debugPrint('going?');
                        //                       sort += (sub2/prodsSc[eachMap.key]['c2'])/prodsSc[eachMap.key]['c1'];
                        //                     }
                        //
                        //              //       debugPrint('sorting ' + sort.toString());
                        //                     var assign = {
                        //                       'name': prodsSc[eachMap.key]['na'],
                        //                       'main': main.toInt(),
                        //                       'sub1': sub1.toInt(),
                        //                       'sub2': sub2.toInt(),
                        //                       'sort': sort.isNaN?0:sort,
                        //                       'mana': prodsSc[eachMap.key]['nm'],
                        //                       's1na': prodsSc[eachMap.key]['n1'],
                        //                       's2na': prodsSc[eachMap.key]['n2']
                        //                     };
                        //                     prodsPrep.addAll({eachMap.key.toString(): assign});
                        //                   }
                        //                   return prodsDataTable(prodsPrep);
                        //                 }
                        //                 return Container();
                        //               } else {
                        //                 debugPrint('docs snap len ' + snapshot.data!.docs.length.toString());
                        //                 var prodsDoc;
                        //                 var prodsPrep = {};
                        //                 for(int j=0; j<snapshot.data!.docs.length; j++) {
                        //                   debugPrint('looping ');
                        //                   Map<String, dynamic> eachDoc = snapshot.data!.docs[j].data()! as Map<String, dynamic>;
                        //                   DateTime docDate = eachDoc['date'].toDate();
                        //                   var prods = eachDoc['prods'];
                        //                   //debugPrint('eachDoc ' + prods.toString());
                        //
                        //                   for(int i = 0; i < prods.length; i++) {
                        //                     var eachMap = prods.entries.elementAt(i);
                        //                     //debugPrint('jisoo ' + prodsSc[eachMap.key].toString());
                        //                     double sort = 0;
                        //                     double main = eachMap.value['im'] == null? 0: eachMap.value['im'];
                        //                     double sub1 = eachMap.value['i1'] == null? 0: eachMap.value['i1'];
                        //                     double sub2 = eachMap.value['i2'] == null? 0: eachMap.value['i2'];
                        //
                        //                    // debugPrint('setting 1 ' + prodsSc[eachMap.key].toString());
                        //                    // debugPrint('setting 2 ' + main.toString() + ' ' + sub1.toString() + ' ' + sub2.toString());
                        //                     if(eachMap.value['im']!=0 && eachMap.value['im']!=null) {
                        //                       sort += eachMap.value['im'];
                        //                     }
                        //                     if(prodsSc[eachMap.key]['c1'] != 0 && eachMap.value['i1']!=null) {
                        //                       sort += sub1/prodsSc[eachMap.key]['c1'];
                        //                     }
                        //                     if(prodsSc[eachMap.key]['c2'] != 0 && prodsSc[eachMap.key]['c1'] != 0 && eachMap.value['i2']!=null) {
                        //                       debugPrint('going?');
                        //                       sort += (sub2/prodsSc[eachMap.key]['c2'])/prodsSc[eachMap.key]['c1'];
                        //                     }
                        //
                        //                   //  debugPrint('sorting ' + sort.toString());
                        //
                        //                     var assign = {
                        //                       'name': prodsSc[eachMap.key]['na'],
                        //                       'main': main.toInt(),
                        //                       'sub1': sub1.toInt(),
                        //                       'sub2': sub2.toInt(),
                        //                       'sort': sort.isNaN?0:sort,
                        //                       'mana': prodsSc[eachMap.key]['nm'],
                        //                       's1na': prodsSc[eachMap.key]['n1'],
                        //                       's2na': prodsSc[eachMap.key]['n2']
                        //                     };
                        //                     if(prodsPrep.containsKey(eachMap.key)) {
                        //                     //  debugPrint('prodsPrep ' + prodsPrep[eachMap.key].toString());
                        //                       assign['main'] = assign['main'] + prodsPrep[eachMap.key]['main'];
                        //                       assign['sub1'] = assign['sub1'] + prodsPrep[eachMap.key]['sub1'];
                        //                       assign['sub2'] = assign['sub2'] + prodsPrep[eachMap.key]['sub2'];
                        //                       assign['sort'] = assign['sort'] + prodsPrep[eachMap.key]['sort'];
                        //                       prodsPrep[eachMap.key] = assign;
                        //                     } else {
                        //                       prodsPrep[eachMap.key] = assign;
                        //                     }
                        //                     // prodsPrep.addAll({eachMap.key.toString(): assign});
                        //                   }
                        //
                        //
                        //
                        //                 }
                        //
                        //              //   debugPrint('iphone2 ' + prodsPrep.toString());
                        //                 if(prodsPrep.length == 0) {
                        //                   return Container();
                        //                 }
                        //                 prodsPrep = sortMapByAvg(prodsPrep);
                        //                 return prodsDataTable(prodsPrep);
                        //               }
                        //
                        //             }
                        //             return Container();
                        //           }
                        //       );
                        //     }
                        //     return Container();
                        //   }
                        // )
                      ],
                    ),
                  ),
                );
              }
            },
            // Builds 1000 ListTiles
            childCount: 1,
          ),
        ),

      ],
    );
    // var listView = CustomScrollView(
    //   reverse: widget.reverse,
    //   controller: widget.scrollController,
    //   shrinkWrap: widget.shrinkWrap,
    //   scrollDirection: widget.scrollDirection,
    //   physics: widget.physics,
    //   slivers: [
    //     // if (widget.header != null) widget.header!,
    //     SliverAppBar(
    //       elevation: 0,
    //       backgroundColor: Colors.white,
    //
    //       // Provide a standard title.
    //
    //       // Allows the user to reveal the app bar if they begin scrolling
    //       // back up the list of items.
    //       floating: true,
    //       bottom: PreferredSize(                       // Add this code
    //         preferredSize: Size.fromHeight(-2.0),      // Add this code
    //         child: Container(),                           // Add this code
    //       ),
    //       flexibleSpace: headerAppBar(),
    //       // Display a placeholder widget to visualize the shrinking size.
    //       // Make the initial height of the SliverAppBar larger than normal.
    //       expandedHeight: 20,
    //     ),
    //     if (widget.footer != null) widget.footer!,
    //   ],
    // );

    if (widget.listeners != null && widget.listeners!.isNotEmpty) {
      return MultiProvider(
        providers: widget.listeners!
            .map((_listener) => ChangeNotifierProvider(
          create: (context) => _listener,
        ))
            .toList(),
        child: listView,
      );
    }

    return listView;
  }

  headerAppBar() {
    // return Padding(
    //   padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0, right: 15.0),
    //   child: Container(
    //     height: 32,
    //     width: MediaQuery.of(context).size.width,
    //     // color: Colors.yellow,
    //     child: CupertinoSlidingSegmentedControl(
    //         groupValue: segmentedControlGroupValue,
    //         children: myTabs,
    //         onValueChanged: (i) {
    //           // setState(() {
    //           //   segmentedControlGroupValue = i;
    //           // });
    //         }),
    //
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0),
      child: Container(
        height: 32,
        width: MediaQuery.of(context).size.width,
        // color: Colors.yellow,
        child: Row(
          children: [
            Row(
              children: [
                FlatButton(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  color: AppTheme.secButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: AppTheme.skBorderColor2,
                    ),
                  ),
                  onPressed: () {
                    // widget._callback();
                    _showDatePicker(OneContext().context);
                  },
                  child: Container(
                    child: Row(
                      // mainAxisAlignment: Main,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: Icon(
                            Icons.calendar_view_day_rounded,
                            size: 18,
                          ),
                        ),
                        Text(
                          selectDaysCast(), textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.5,
                  height: 30,
                )
              ],
            ),
            Expanded(
              child: ListView(
                controller: cateScCtler,
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppTheme.skBorderColor2,
                        ),
                      ),
                      onPressed: () {
                        _animateToIndex(0);
                        setState(() {
                          cateScIndex = 0;
                          _sliding = 0;
                        });
                        widget._selectedIntVal(0);
                      },
                      child: Container(
                        child: Text(
                          textSetToday, textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                    child: FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppTheme.skBorderColor2,
                        ),
                      ),
                      onPressed: () {
                        _animateToIndex(5.9);
                        setState(() {
                          cateScIndex = 1;
                          _sliding = 1;
                        });
                        widget._selectedIntVal(1);
                      },
                      child: Container(
                        child: Text(
                          textSetLastWeek, textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                    child: FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppTheme.skBorderColor2,
                        ),
                      ),
                      onPressed: () {
                        _animateToIndex(15.5);
                        setState(() {
                          cateScIndex = 2;
                          _sliding = 2;
                        });
                        widget._selectedIntVal(2);
                      },
                      child: Container(
                        child: Text(
                          textSetLastMonth, textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppTheme.skBorderColor2,
                        ),
                      ),
                      onPressed: () {
                        _animateToIndex(20);
                        setState(() {
                          cateScIndex = 3;
                          _sliding = 3;
                        });
                        widget._selectedIntVal(3);
                      },
                      child: Container(
                        child: Text(
                          textSetLastYear, textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 11,
                  )
                ],
              ),
            )
          ],
        ),

      ),
    );
  }

  headerAppBar2() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0, right: 15.0),
      child: Container(
        height: 32,
        width: MediaQuery.of(context).size.width,
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0),
    //   child: Container(
    //     height: 32,
    //     width: MediaQuery.of(context).size.width,
    //     // color: Colors.yellow,
    //     child: Row(
    //       children: [
    //         Row(
    //           children: [
    //             FlatButton(
    //               padding: EdgeInsets.only(left: 10, right: 10),
    //               color: AppTheme.secButtonColor,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8.0),
    //                 side: BorderSide(
    //                   color: AppTheme.skBorderColor2,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 // widget._callback();
    //                 _showDatePicker(OneContext().context);
    //               },
    //               child: Container(
    //                 child: Row(
    //                   // mainAxisAlignment: Main,
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.only(right: 3.0),
    //                       child: Icon(
    //                         Icons.calendar_view_day_rounded,
    //                         size: 18,
    //                       ),
    //                     ),
    //                     Text(
    //                       selectDaysCast(), textScaleFactor: 1,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.black),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             SizedBox(width: 12),
    //             Container(
    //               color: Colors.grey.withOpacity(0.2),
    //               width: 1.5,
    //               height: 30,
    //             )
    //           ],
    //         ),
    //         Expanded(
    //           child: ListView(
    //             controller: cateScCtler,
    //             scrollDirection: Axis.horizontal,
    //             children: [
    //               SizedBox(
    //                 width: 4,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
    //                 child: FlatButton(
    //                   minWidth: 0,
    //                   padding: EdgeInsets.only(left: 12, right: 12),
    //                   color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(20.0),
    //                     side: BorderSide(
    //                       color: AppTheme.skBorderColor2,
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     _animateToIndex(0);
    //                     setState(() {
    //                       cateScIndex = 0;
    //                       _sliding = 0;
    //                     });
    //                     widget._selectedIntVal(0);
    //                   },
    //                   child: Container(
    //                     child: Text(
    //                       textSetToday, textScaleFactor: 1,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.black),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 4.0, right: 6.0),
    //                 child: FlatButton(
    //                   minWidth: 0,
    //                   padding: EdgeInsets.only(left: 12, right: 12),
    //                   color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(20.0),
    //                     side: BorderSide(
    //                       color: AppTheme.skBorderColor2,
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     _animateToIndex(5.9);
    //                     setState(() {
    //                       cateScIndex = 1;
    //                       _sliding = 1;
    //                     });
    //                     widget._selectedIntVal(1);
    //                   },
    //                   child: Container(
    //                     child: Text(
    //                       textSetLastWeek, textScaleFactor: 1,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.black),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 4.0, right: 6.0),
    //                 child: FlatButton(
    //                   minWidth: 0,
    //                   padding: EdgeInsets.only(left: 12, right: 12),
    //                   color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(20.0),
    //                     side: BorderSide(
    //                       color: AppTheme.skBorderColor2,
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     _animateToIndex(15.5);
    //                     setState(() {
    //                       cateScIndex = 2;
    //                       _sliding = 2;
    //                     });
    //                     widget._selectedIntVal(2);
    //                   },
    //                   child: Container(
    //                     child: Text(
    //                       textSetLastMonth, textScaleFactor: 1,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.black),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
    //                 child: FlatButton(
    //                   minWidth: 0,
    //                   padding: EdgeInsets.only(left: 12, right: 12),
    //                   color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(20.0),
    //                     side: BorderSide(
    //                       color: AppTheme.skBorderColor2,
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     _animateToIndex(20);
    //                     setState(() {
    //                       cateScIndex = 3;
    //                       _sliding = 3;
    //                     });
    //                     widget._selectedIntVal(3);
    //                   },
    //                   child: Container(
    //                     child: Text(
    //                       textSetLastYear, textScaleFactor: 1,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.black),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 11,
    //               )
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //
    //   ),
    // );
  }

  int _sliding = 0;
  final cateScCtler = ScrollController();
  int cateScIndex = 0;
  final _width = 10.0;

  DateTime today = DateTime.now();
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM-dd';

  _animateToIndex(i) {
    // debugPrint((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }

  void _showDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        confirm: Text('Done', textScaleFactor: 1, style: TextStyle(color: Colors.blue)),
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
        widget._resetState(today);
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

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }


  String totalStockCostsBySlide() {
    debugPrint('todaycoststotal' + todayCostsTotal.toString());
    if(_sliding == 0) {
      return todayCostsTotal.toStringAsFixed(1);
    } else  {
      return weekCostsTotal.toStringAsFixed(1);
    }
  }

  String totalStockCostsRBySlide() {
    if(_sliding == 0) {
      return todayCostsTotalR.toStringAsFixed(1);
    } else {
      return weekCostsTotalR.toStringAsFixed(1);
    }
  }

  String totalRefundBySlide() {
    if(_sliding == 0) {
      return todayRefundTotal.toStringAsFixed(1);
    } else {
      return weekRefundTotal.toStringAsFixed(1);
    }
  }

  String totalLossBySlide() {
    if(_sliding == 0) {
      return todayLossTotal.toStringAsFixed(1);
    } else  {
      return weekLossTotal.toStringAsFixed(1);
    }
  }

  String totalEarnBySlide() {
    if(_sliding == 0) {
      return todayEarnTotal.toStringAsFixed(1);
    } else  {
      return weekEarnTotal.toStringAsFixed(1);
    }
  }

  percentBySale() {
    var percent = 0;
    double todayTotal = 0;
    if(_sliding == 0) {
      for (int i = 0; i < todayOrdersChart.length; i++){
        todayTotal += todayOrdersChart[i];
      }
      percent = growthRateDaySale(yestOrdersChart, todayTotal);
    } else percent = growthRateWeekSale(lastWeekOrderChart, thisWeekOrdersChart);
    return percent;
  }

  percentByUnpaid() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDayUnpaid(yestUnpaidChart, todayCostsTotal);
    } else percent = growthRateWeekUnpaid(lastWeekUnpaid, weekCostsTotal);
    return percent;
  }

  percentByRefunds() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDayUnpaid(yestUnpaidChart, todayCostsTotal);
    } else percent = growthRateWeekUnpaid(lastWeekUnpaid, weekCostsTotal);
    return percent;
  }

  percentByCost() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDayCost(yestCostsTotalR, todayCostsTotalR);
    } else percent = growthRateWeekCost(lastWeekCost, weekCostsTotalR);
    return percent;
  }

  percentByRefund() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDayRefund(ystRefundTotal, todayRefundTotal);
    } else percent = growthRateWeekRefund(lastWeekRefund, weekRefundTotal);
    return percent;
  }

  percentByLoss() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDayLoss(ystLossTotal, todayLossTotal);

    } else percent = growthRateWeekLoss(lastWeekLoss, weekLossTotal);
    return percent;
  }

  percentByEarn() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDayEarn(ystEarnTotal, todayEarnTotal);
    } else percent = growthRateWeekEarn(lastWeekEarn, weekEarnTotal);
    return percent;
  }

  String yestWeekTitle() {
    String title = '';
    if(_sliding == 0) {
      return title = 'yesterday';
    } else  {return title = 'last week';}
  }

  String totalBySlide() {
    double todayTotal=0.0;
    for (int i = 0; i < todayOrdersChart.length; i++){
      todayTotal += todayOrdersChart[i];
    }
    double weeklyTotal=0.0;
    for (int i = 0; i < thisWeekOrdersChart.length; i++){
      weeklyTotal += thisWeekOrdersChart[i];
    }
    if(_sliding == 0) {
      return todayTotal.toStringAsFixed(1);
    } else {
      return weeklyTotal.toStringAsFixed(1);
    }
  }

  lineChartByTab() {
    if(_sliding==0) {
      return LineChart(todayData(DateTime.now()));
    } else if(_sliding==1) {
      return LineChart(weeklyData(DateTime.now()));
    }
  }

  LineChartData todayData(DateTime today) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;

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
              TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12/scaleFactor),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return _dateTime!.day.toString() + ', '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString());
              case 5:
                return '5 AM';
              case 10:
                return '10 AM';
            // case 12:
            //   return '1 PM';
              case 15:
                return '3 PM';
              case 20:
                return '8 PM';
              case 24:
                return 'Next';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) =>  TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13 / scaleFactor,
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
            FlSpot(0, (((todayOrdersChart[0]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[0]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[0]).toString() + '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours))).hour).toString() + ':00 AM, Today' + ')'),
            FlSpot(1, (((todayOrdersChart[1]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[1]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[1]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-1)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(2, (((todayOrdersChart[2]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[2]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[2]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-2)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(3, (((todayOrdersChart[3]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[3]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[3]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-3)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(4, (((todayOrdersChart[4]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[4]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[4]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-4)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(5, (((todayOrdersChart[5]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[5]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[5]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-5)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(6, (((todayOrdersChart[6]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[6]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[6]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-6)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(7, (((todayOrdersChart[7]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[7]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[7]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-7)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(8, (((todayOrdersChart[8]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[8]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[8]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-8)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(9, (((todayOrdersChart[9]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[9]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[9]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-9)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(10, (((todayOrdersChart[10]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[10]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[10]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-10)).hour.toString()+ ':00 AM, Today' + ')'),
            FlSpot(11, (((todayOrdersChart[11]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[11]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[11]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-11)).hour.toString() + ':00 AM, Today' + ')'),
            FlSpot(12, (((todayOrdersChart[12]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[12]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[12]).toString()+ '\n(' + today.subtract(Duration(hours: int.parse(subHours)-12)).hour.toString() + ':00 PM, Today' + ')'),
            FlSpot(13, (((todayOrdersChart[13]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[13]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[13]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-13)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(14, (((todayOrdersChart[14]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[14]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[14]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-14)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(15, (((todayOrdersChart[15]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[15]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[15]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-15)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(16, (((todayOrdersChart[16]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[16]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[16]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-16)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(17, (((todayOrdersChart[17]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[17]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[17]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-17)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(18, (((todayOrdersChart[18]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[18]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[18]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-18)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(19, (((todayOrdersChart[19]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[19]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[19]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-19)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(20, (((todayOrdersChart[20]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[20]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[20]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-20)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(21, (((todayOrdersChart[21]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[21]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[21]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-21)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(22, (((todayOrdersChart[22]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[22]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[22]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-22)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(23, (((todayOrdersChart[23]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[23]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[23]).toString()+ '\n(' + turn24ToPM(today.subtract(Duration(hours: int.parse(subHours)-23)).hour).toString() + ':00 PM, Today' + ')'),
            FlSpot(24, (((todayOrdersChart[24]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[24]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[24]).toString()+ '\n(' + 'Next day' + ')'),
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

  turn24ToPM(int time) {
    if(time >= 13) {
      return (time - 12).toString();
    } else {
      return time.toString();
    }
  }

  int findMax(List<int> numbers) {
    return numbers.reduce(max);
  }

  LineChartData weeklyData(DateTime today) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
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
              TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12/scaleFactor),
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
          getTextStyles: (context, value) =>  TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13/scaleFactor,
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
            FlSpot(0, (((thisWeekOrdersChart[0]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[0]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[0]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 6)).month.toString()) + ')'),
            FlSpot(1, (((thisWeekOrdersChart[1]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[1]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[1]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 5)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 5)).month.toString()) + ')'),
            FlSpot(2, (((thisWeekOrdersChart[2]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[2]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[2]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 4)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 4)).month.toString()) + ')'),
            FlSpot(3, (((thisWeekOrdersChart[3]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[3]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[3]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 3)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 3)).month.toString()) + ')'),
            // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // (thisWeekOrdersChart[4]/1000000) * 3.260
            FlSpot(4, (((thisWeekOrdersChart[4]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[4]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[4]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 2)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 2)).month.toString()) + ')'),
            FlSpot(5, (((thisWeekOrdersChart[5]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[5]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[5]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 1)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 1)).month.toString()) + ')'),
            FlSpot(6, (((thisWeekOrdersChart[6]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[6]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[6]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 0)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) + ')'),
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

  List<Color> gradientColors = [
    // AppTheme.badgeFgSecond
    Colors.blue
    // const Color(0xff23b6e6),
    // const Color(0xff02d39a),
  ];

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

  List<double> thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

  double todayCostsTotal = 0;
  double todayRefundsTotal = 0;
  double weekCostsTotal = 0;
  double monthCostsTotal = 0;
  double yearCostsTotal = 0;

  double monthCostsTotal2 = 0;
  double yearCostsTotal2 = 0;
  double monthUnpaidTotal = 0;
  double yearUnpaidTotal = 0;
  double monthRefundTotal = 0;
  double yearRefundTotal = 0;


  double todayCostsTotalR = 0;
  double weekCostsTotalR = 0;
  double monthCostsTotalR = 0;
  double yearCostsTotalR = 0;

  double yestOrdersChart = 0;
  double yestCostsTotalR = 0;
  double yestUnpaidChart = 0;
  double lastWeekOrderChart = 0;
  double lastWeekCost = 0;
  double lastWeekUnpaid = 0;

  double todayRefundTotal = 0;
  double weekRefundTotal = 0;
  double todayLossTotal= 0;
  double weekLossTotal = 0;
  double ystRefundTotal=0;
  double lastWeekRefund = 0;
  double ystLossTotal = 0;
  double lastWeekLoss = 0;
  double todayEarnTotal = 0;
  double ystEarnTotal = 0;
  double weekEarnTotal = 0;
  double lastWeekEarn = 0;

  double todayCapital = 0 ;
  double weekCapital = 0;
  double ystCapital = 0 ;
  double lastWeekCapital = 0;


  profitBySlide() {
    double profit = 0.0;
    double weeklyTotal=0.0;
    double todayTotal = 0.0;
    if(_sliding == 0) {
      for (int i = 0; i < todayOrdersChart.length; i++){
        todayTotal += todayOrdersChart[i];
      }
      profit = todayTotal - (todayCapital + todayLossTotal);
    } else {
      for (int i = 0; i < thisWeekOrdersChart.length; i++){
        weeklyTotal += thisWeekOrdersChart[i];
      }
      profit = weeklyTotal - (weekCapital + weekLossTotal);
    }
    return profit;
  }

  lastProfitBySlide() {
    double profit = 0.0;
    if(_sliding == 0) {
      profit = yestOrdersChart - (ystCapital + ystLossTotal);
    } else {
      profit = lastWeekOrderChart - (lastWeekCapital + lastWeekLoss);
    }
    return profit;
  }

  fetchOrders(snapshot0, snapshot1) async {
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 7));
    DateTime twoWeeksAgo = today.subtract(const Duration(days: 14));

    thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

    todayCostsTotal = 0;
    weekCostsTotal = 0;
    monthCostsTotal = 0;
    yearCostsTotal = 0;

    todayRefundsTotal = 0;

    todayCostsTotalR = 0;
    weekCostsTotalR = 0;
    monthCostsTotalR = 0;
    yearCostsTotalR = 0;


    yestCostsTotalR = 0;
    yestUnpaidChart = 0;
    lastWeekOrderChart = 0;
    lastWeekCost = 0;
    lastWeekUnpaid = 0;



    for(int loopOrd = 0; loopOrd < snapshot0.length; loopOrd++) {
      // debugPrint('DOC IIDD ' + snapshot0.data!.docs[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0[loopOrd].data()! as Map<String, dynamic>;

      DateTime dateTimeOrders = data['date'].toDate();
      String dataDate = dateTimeOrders.year.toString() + zeroToTen(dateTimeOrders.month.toString()) + zeroToTen(dateTimeOrders.day.toString());
      debugPrint('DOC IIDD2 ' + dataDate.toString() + ' ' + dateTimeOrders.toString());

      int week = 0;
      int month = 0;
      int year = 0;
      sevenDaysAgo = today.subtract(const Duration(days: 7));
      twoWeeksAgo = today.subtract(const Duration(days: 14));

      while(!(today.year.toString() == sevenDaysAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(sevenDaysAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(sevenDaysAgo.day.toString()))) {
        sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));
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


      while(!(today.subtract(const Duration(days: 7)).year.toString() == twoWeeksAgo.year.toString() && zeroToTen(today.subtract(const Duration(days: 7)).month.toString()) == zeroToTen(twoWeeksAgo.month.toString()) && zeroToTen(today.subtract(const Duration(days: 7)).day.toString()) == zeroToTen(twoWeeksAgo.day.toString()))) {
        twoWeeksAgo = twoWeeksAgo.add(const Duration(days: 1));
        debugPrint('youare ' + twoWeeksAgo.toString());
        if(dataDate == twoWeeksAgo.year.toString() + zeroToTen(twoWeeksAgo.month.toString()) + zeroToTen(twoWeeksAgo.day.toString())) {

          for(String str in data['daily_order']) {
            debugPrint('1369' + '1');
            lastWeekOrderChart  += double.parse(str.split('^')[2]);
            lastWeekUnpaid  += double.parse(str.split('^')[5]);
          }
        }
      }
      debugPrint('thousand '+ lastWeekOrderChart.toString());




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
              debugPrint('string check ' + str);
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



      if (dataDate.substring(0,8) == today.subtract(Duration(days: 1)).year.toString() +
          zeroToTen(today.subtract(Duration(days: 1)).month.toString()) +
          zeroToTen(today.subtract(Duration(days: 1)).day.toString())) {

        yestOrdersChart = 0;

        for (String str in data['daily_order']) {
          yestOrdersChart += double.parse(str.split('^')[2]);
          yestUnpaidChart += double.parse(str.split('^')[5]);
        }
      }

    }
    debugPrint('yestorders ' + yestOrdersChart.toString());
    // debugPrint('each ');
    if(snapshot1 != null) {
      for(int loopOrd = 0; loopOrd < snapshot1.length; loopOrd++) {
        debugPrint('DOC IIDDCost ' + snapshot1[loopOrd].id.toString());
        Map<String, dynamic> data = snapshot1[loopOrd].data()! as Map<String, dynamic>;

        DateTime dateTimeOrders = data['date'].toDate();
        String dataDate = dateTimeOrders.year.toString() + zeroToTen(dateTimeOrders.month.toString()) + zeroToTen(dateTimeOrders.day.toString());
        debugPrint('DOC IIDD2 ' + dataDate.toString() + ' ' + dateTimeOrders.toString());

        int week = 0;
        int month = 0;
        int year = 0;
        sevenDaysAgo = today.subtract(const Duration(days: 7));
        twoWeeksAgo = today.subtract(const Duration(days: 14));


        while(!(today.year.toString() == sevenDaysAgo.year.toString() && zeroToTen(today.month.toString()) == zeroToTen(sevenDaysAgo.month.toString()) && zeroToTen(today.day.toString()) == zeroToTen(sevenDaysAgo.day.toString()))) {
          sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));

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

        while(!(today.subtract(const Duration(days: 7)).year.toString() == twoWeeksAgo.year.toString() && zeroToTen(today.subtract(const Duration(days: 7)).month.toString()) == zeroToTen(twoWeeksAgo.month.toString()) && zeroToTen(today.subtract(const Duration(days: 7)).day.toString()) == zeroToTen(twoWeeksAgo.day.toString()))) {
          twoWeeksAgo = twoWeeksAgo.add(const Duration(days: 1));

          if(dataDate == twoWeeksAgo.year.toString() + zeroToTen(twoWeeksAgo.month.toString()) + zeroToTen(twoWeeksAgo.day.toString())) {
            for(String str in data['daily_order']) {
              lastWeekCost += double.parse(str.split('^')[2]);
            }
          }
        }
        debugPrint('yest ton ka2 ' + lastWeekCost.toString() + ' ' + weekCostsTotalR.toString());

        if (dataDate.substring(0,8) == today.year.toString() +
            zeroToTen(today.month.toString()) +
            zeroToTen(today.day.toString())) {
          double total = 0;
          for (String str in data['daily_order']) {
            for(int i=0; i<=24 ; i++ ) {
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

        if (dataDate.substring(0,8) == today.subtract(Duration(days: 1)).year.toString() +
            zeroToTen(today.subtract(Duration(days: 1)).month.toString()) +
            zeroToTen(today.subtract(Duration(days: 1)).day.toString())) {
          for (String str in data['daily_order']) {
            yestCostsTotalR += double.parse(str.split('^')[2]);
          }
        }
      }
    } else {
      debugPrint('null pix');
    }
  }



  fetchOrdersMY(snapshot2) async {

    DateTime sevenDayAgo = today.subtract(const Duration(days: 7));


    todayRefundTotal = 0;
    weekRefundTotal = 0;
    todayLossTotal= 0;
    todayEarnTotal = 0;
    weekLossTotal = 0;
    ystRefundTotal=0;
    lastWeekRefund = 0;
    ystLossTotal = 0;
    ystEarnTotal = 0;
    lastWeekLoss = 0;
    weekEarnTotal = 0;
    lastWeekEarn = 0;
    todayCapital = 0;
    ystCapital = 0;
    lastWeekCapital = 0;
    weekCapital = 0;


    debugPrint('what now nigga? ' + snapshot2.toString());
    for(int loopOrd = 0; loopOrd < snapshot2.length; loopOrd++) {

      debugPrint('George sai 09 ' + snapshot2[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot2[loopOrd].data()! as Map<String, dynamic>;

      sevenDayAgo = today.subtract(const Duration(days: 7));

      if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'refu_cust'] != null) {
        todayRefundTotal += data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'refu_cust'];
      }

      if(data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'refu_cust'] != null) {
        ystRefundTotal += data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'refu_cust'];
      }

      if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'loss_cust'] != null) {
        todayLossTotal += data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'loss_cust'];
      }

      if(data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'loss_cust'] != null) {
        ystLossTotal += data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'loss_cust'];
      }

      if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'capital'] != null) {
        todayCapital += data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'capital'];
      }

      if(data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'capital'] != null) {
        ystCapital += data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'capital'];
      }

      if(data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'paid_cust'] != null) {
        todayEarnTotal += data[today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString()) + 'paid_cust'];
      }

      if(data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'paid_cust'] != null) {
        ystEarnTotal += data[today.subtract(Duration(days: 1)).year.toString() + zeroToTen(today.subtract(Duration(days: 1)).month.toString()) + zeroToTen(today.subtract(Duration(days: 1)).day.toString()) + 'paid_cust'];
      }

      for(int i = 0; i < 7; i++) {
        if(data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'refu_cust'] != null) {
          weekRefundTotal +=  data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'refu_cust'];
        }
      }

      for(int i = 0; i < 7; i++) {
        if(data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'refu_cust'] != null) {
          lastWeekRefund +=  data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'refu_cust'];
          debugPrint('Europe ' +  data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'refu_cust'].toString());
        }
        debugPrint('Asia ' + lastWeekRefund.toString());
      }

      for(int i = 0; i < 7; i++) {
        if(data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'loss_cust'] != null) {
          weekLossTotal +=  data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'loss_cust'];
        }
      }

      for(int i = 0; i < 7; i++) {
        if(data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'capital'] != null) {
          weekCapital +=  data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'capital'];
        }
      }

      for(int i = 0; i < 7; i++) {
        if(data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'capital'] != null) {
          lastWeekCapital +=  data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'capital'];
        }
      }

      for(int i = 0; i < 7; i++) {
        if(data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'paid_cust'] != null) {
          weekEarnTotal +=  data[today.subtract(Duration(days: i)).year.toString() + zeroToTen(today.subtract(Duration(days: i)).month.toString()) + zeroToTen(today.subtract(Duration(days: i)).day.toString()) + 'paid_cust'];
        }
      }

      for(int i = 0; i < 7; i++) {
        if(data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'loss_cust'] != null) {
          lastWeekLoss +=  data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'loss_cust'];
        }
      }

      for(int i = 0; i < 7; i++) {
        if(data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'paid_cust'] != null) {
          lastWeekEarn +=  data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'paid_cust'];
        }
      }

      debugPrint('testing for ' + weekRefundTotal.toString() + ', ' +  lastWeekRefund.toString()+ ', ' +  lastWeekRefund.toString());

    }
  }

  growthRateDaySale(double yestOrdersChart, double todayOrders) {
    double growthRate = 0;

    if(yestOrdersChart == 0 && todayOrders == 0) {
      return 1001;
    }

    growthRate = (todayOrders - yestOrdersChart) / yestOrdersChart * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateDayCost(double yestOrdersChart, double todayTotalCost) {

    double growthRate = 0;
    double todayTotal = todayTotalCost;

    if(yestOrdersChart == 0 && todayTotalCost == 0) {
      return 1001;
    }

    growthRate = (todayTotal - yestOrdersChart) / yestOrdersChart * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateDayUnpaid(double yestOrdersChart, double todayTotalCost) {

    double growthRate = 0;
    double todayTotal = todayTotalCost;

    if(yestOrdersChart == 0 && todayTotalCost == 0) {
      return 1001;
    }

    growthRate = (todayTotal - yestOrdersChart) / yestOrdersChart * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateWeekSale(double lastWeekOrdersChart, List<double> weekOrdersChart) {
    double growthRate = 0;
    double todayTotal = 0;
    for (int i = 0; i < weekOrdersChart.length; i++){
      todayTotal += weekOrdersChart[i];
    }

    if(lastWeekOrdersChart == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastWeekOrdersChart) / lastWeekOrdersChart * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateWeekUnpaid(double lastWeekUnpaid, double weekTotalUnpaid) {

    double growthRate = 0;
    double todayTotal = weekTotalUnpaid;

    if(lastWeekUnpaid == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastWeekUnpaid) / lastWeekUnpaid * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateWeekCost(double lastWeekCostTotal, double weekTotalCost) {

    double growthRate = 0;
    double todayTotal = weekTotalCost;

    if(lastWeekCostTotal == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastWeekCostTotal) / lastWeekCostTotal * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateDayRefund(double lastDayRefund, double totalRefund) {
    double growthRate = 0;
    double todayTotal = totalRefund;

    if(lastDayRefund == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastDayRefund) / lastDayRefund * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateDayLoss(double lastDayLoss, double totalLoss) {
    double growthRate = 0;
    double todayTotal = totalLoss;

    if(lastDayLoss == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastDayLoss) / lastDayLoss * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateDayEarn(double lastDayEarn, double totalEarn) {
    double growthRate = 0;
    double todayTotal = totalEarn;

    if(lastDayEarn == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastDayEarn) / lastDayEarn * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateDayProfit(double lastDayProfit, double totalProfit) {
    double growthRate = 0;
    double todayTotal = totalProfit;

    if(lastDayProfit == 0 && todayTotal == 0) {
      return 1001;
    }
    growthRate = (todayTotal - lastDayProfit) / lastDayProfit * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateWeekRefund(double lastWeekRef, double weekTotalRef) {
    double growthRate = 0;
    double todayTotal = weekTotalRef;

    if(lastWeekRef == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastWeekRef) / lastWeekRef * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateWeekLoss(double lastWeekLoss, double weekTotalLoss) {
    double growthRate = 0;
    double todayTotal = weekTotalLoss;

    if(lastWeekLoss == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastWeekLoss) / lastWeekLoss * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  growthRateWeekEarn(double lastWeekEar, double weekTotalEarn) {
    double growthRate = 0;
    double todayTotal = weekTotalEarn;

    if(lastWeekEar == 0 && todayTotal == 0) {
      return 1001;
    }

    growthRate = (todayTotal - lastWeekEar) / lastWeekEar * 100;
    if(growthRate >= 999) {
      growthRate = 999;
    } else if(growthRate < -999) {
      growthRate = -999;
    }
    if(growthRate.isNaN) {
      return 1000;
    }
    return growthRate.toInt();
  }

  String perTSalText(percentBySale) {
    if(percentBySale == 1001) {
      return '-%  ';
    } else if(percentBySale == 1000) {
      return '-%  ';
    } else {
      return percentBySale.toString() + '% ';
    }
  }

  int initProdPagi = 0;
  bool firstProdTable = true;
  int ayinProdLeng = 0;
  int sortType = 0;
  Widget prodsDataTable(prodsPrep) {
   //debugPrint('sorting filt ' + sortType.toString());
    if(sortType==3) {
      prodsPrep = sortMapBySub2(prodsPrep);
    } else if(sortType==2) {
      prodsPrep = sortMapBySub1(prodsPrep);
    } else if(sortType==1) {
      prodsPrep = sortMapByMain(prodsPrep);
    } else {
     // debugPrint('sorting bef ' + prodsPrep.toString());
      prodsPrep = sortMapByAvg(prodsPrep);
    }
    int length = prodsPrep.length;
    // int length = 101;
    List<String> list = <String>[];
    for(int i=0; i<(length/10); i++) {
      String last = '';
      if(i==0 && length>10) {
        last = '10';
      } else if(i==0 && length<=10) {
        last = length.toString();
      } else if(i+1>(length/10)) {
        last = length.toString();
      } else {
        last = ((i*10)+10).toString();
      }
      list.add(((i*10)+1).toString() + '-' + last);
    }

    if(ayinProdLeng!= length) {
      firstProdTable = true;
      ayinProdLeng = length;
    }

    if(firstProdTable) {
      dropdownValue = list.first;
      firstProdTable = false;
    }

    var prodsPrepMod = {};
    for(int i=int.parse(dropdownValue.split('-')[0]); i <= int.parse(dropdownValue.split('-')[1]); i++) {
      var eachMap = prodsPrep.entries.elementAt(i-1);
    //  print('sps ' + eachMap.toString());
      prodsPrepMod.addAll({eachMap.key.toString(): eachMap.value});
    }
    String type = 'type';
    if(length>1) {
      type = 'types';
    }

    double width = MediaQuery.of(context).size.width > 900
        ? MediaQuery.of(context).size.width * (2 / 3.5)
        : MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 22, bottom: 15.0, left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRODUCT SALE RECORD',
                            textScaleFactor: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: 0.9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Text(
                              length.toString() + ' product ' + type + ' sold',
                              textScaleFactor: 1,
                              style: TextStyle(
                                height: 0.9,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                            top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                            left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                            right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                          ),
                          color: AppTheme.secButtonColor,
                        ),
                        height: 32,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              menuMaxHeight: 500,
                              value: dropdownValue,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.black,
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                    top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                    left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                    right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                  ),
                  color: AppTheme.lightBgColor
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      // scrollDirection: Axis.horizontal,
                      child: DataTable(
                        // columnSpacing: ((MediaQuery.of(context).size.width) / 10) * 0.5,
                        columnSpacing: 10,
                        horizontalMargin: 15,
                        dataRowHeight: 50,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Container(
                              width: ((width-30) / 10) * 5.5,
                              child: Text(
                                'Product',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: ((width-30) / 10) * 1.5,
                              child: Text(
                                'Main',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16
                                ),
                                // style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),

                          ),
                          DataColumn(
                            label: Container(
                              width: ((width-30) / 10) * 1.5,
                              child: Text(
                                'Sub1',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16
                                ),
                                // style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: ((width-30) / 10) * 1.5,
                              child: Text(
                                'Sub2',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16
                                ),
                                // style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: [
                          for(int i=0; i<prodsPrepMod.length; i++)
                            DataRow(
                              color: i%2==0?MaterialStateProperty.all<Color>(Colors.white):MaterialStateProperty.all<Color>(AppTheme.lightBgColorCell),
                              cells: <DataCell>[
                                DataCell(
                                    Container(
                                        width: ((width-30) / 10) * 5.5,
                                        child: Text(
                                          prodsPrepMod.entries.elementAt(i).value['name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16
                                          ),
                                        )
                                    )
                                ),
                                DataCell(
                                    Container(
                                        width: ((width-30) / 10) * 1.5,
                                        child: Text(
                                          prodsPrepMod.entries.elementAt(i).value['main'].toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        )
                                    )
                                ),
                                DataCell(
                                    Container(
                                        width: ((width-30) / 10) * 1.5,
                                        child: Text(
                                          prodsPrepMod.entries.elementAt(i).value['sub1'].toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        )
                                    )
                                ),
                                DataCell(
                                    Container(
                                        width: ((width-30) / 10) * 1.5,
                                        child: Text(
                                          prodsPrepMod.entries.elementAt(i).value['sub2'].toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Map sortMapByAvg(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['sort'].compareTo(map[k1]['sort']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByMain(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['main'].compareTo(map[k1]['main']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapBySub1(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['sub1'].compareTo(map[k1]['sub1']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapBySub2(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['sub2'].compareTo(map[k1]['sub2']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

}

enum PaginateBuilderType { listView, gridView, pageView }