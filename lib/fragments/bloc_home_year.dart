library paginate_firestore;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fragments/bloc_home_year_loss.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import 'bloc/pagination_cubit.dart';
import 'bloc/pagination_listeners.dart';
import 'widgets_bloc/bottom_loader.dart';
import 'widgets_bloc/empty_display.dart';
import 'widgets_bloc/empty_separator.dart';
import 'widgets_bloc/error_display.dart';
import 'widgets_bloc/initial_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExampleSection implements ExpandableListSection<String> {
  //store expand state.
  late bool expanded;

  //return item model list.
  late List<String> items;

  //example header, optional
  late String header;

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}

class BlocHomeYear extends StatefulWidget {

  const BlocHomeYear({
    Key? key,
    required this.itemBuilder,
    required this.query,
    required this.itemBuilderType,
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
    required this.isEnglish,
    required this.intValIni,
    required void resetState(DateTime resetD),
    required void selectedIntVal(int index),
  }) :
        _resetState = resetState,
        _selectedIntVal = selectedIntVal,
        super(key: key);

  final int intValIni;
  final Widget bottomLoader;
  final Widget onEmpty;
  final SliverGridDelegate gridDelegate;
  final Widget initialLoader;
  final PaginateBuilderType itemBuilderType;
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
  _BlocHomeYearState createState() => _BlocHomeYearState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _BlocHomeYearState extends State<BlocHomeYear> {

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
  String textSetToday = 'Daily';
  String textSetLastWeek = 'Weekly';
  String textSetLastMonth = 'Monthly';
  String textSetLastYear = 'Yearly';
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

  @override
  void initState() {
    debugPrint('lengthing year 1 ' + DateFormat("yyyy-MM").parse(widget.dateTime!.year.toString() + '-01').toString());
    debugPrint('lengthing year 2 ' + DateFormat("yyyy-MM-dd").parse(widget.dateTime!.year.toString() + '-12-32').toString());
    prodsSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr').snapshots();
    prodSaleData =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodYearData')
        .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM").parse(widget.dateTime!.year.toString() + '-01'))
        .where('date', isLessThan: DateFormat("yyyy-MM-dd").parse(widget.dateTime!.year.toString() + '-12-32'))
        .orderBy('date', descending: true)
        .snapshots();

    if(widget.isEnglish == true) {
      setState(() {
        textSetReports = 'Reports';
        textSetSaleSummary = 'Sales summary detail';
        textSetStockCosts = 'Stock costs';
        textSetUnpaid = 'Unpaid';
        textSetBuys = 'Refund amount';
        textSetLoss = 'Loss amount';
        textSetToday = 'Daily';
        textSetLastWeek = 'Weekly';
        textSetLastMonth = 'Monthly';
        textSetLastYear = 'Yearly';
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
        textSetInOut = 'အရောင်းအဝယ် စာရင်းများ';
        textSetNetSales = 'အသားတင် ရောင်းရငွေ';
        textSetAvgProf = 'ပျမ်းမျှအမြတ်ငွေ';
        textSetEarn = 'အကြွေးရငွေ';
        textSetCharts = 'အရောင်းစာရင်းပြ ဇယား';
        textSetTotal = 'စုစုပေါင်း အသားတင် ရောင်းရငွေ';
      });
    }

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
      debugPrint('inside loss loss ' + data.toString());
    }

    fetchOrdersYY(loadedState.documentSnapshots);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if(widget.intValIni == 2 || widget.intValIni == 3) {
        debugPrint('animating to ');
        cateScCtler.jumpTo(cateScCtler.position.maxScrollExtent);
      }
    });
    // fetchOrders(widget.sale, widget.buy);
    var listView = CustomScrollView(
      reverse: widget.reverse,
      controller: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      slivers: [
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.white,

          // Provide a standard title.

          // Allows the user to reveal the app bar if they begin scrolling
          // back up the list of items.
          floating: true,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(                       // Add this code
            preferredSize: Size.fromHeight(-2.0),      // Add this code
            child: Container(),                           // Add this code
          ),
          flexibleSpace: headerAppBar(),
          // Display a placeholder widget to visualize the shrinking size.
          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: 20,
        ),
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
                (context, index) {
              if(cateScIndex == 3) {
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
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        textSetInOut,textScaleFactor: 1,
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
                                          animatedPrice(
                                              double.parse(totalBySlide()),
                                              GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),
                                          // Text(
                                          //   totalBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          //   textScaleFactor: 1, textAlign: TextAlign.left,
                                          //   style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           letterSpacing: 1,
                                          //           fontSize: 26,
                                          //           fontWeight: FontWeight.w600,
                                          //           color: Colors.black
                                          //       )
                                          //   ),
                                          // ),
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
                                          growthRateSale(lastYearSale, thisYearOrdersChart) == 1001 || growthRateSale(lastYearSale, thisYearOrdersChart) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateSale(lastYearSale, thisYearOrdersChart).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateSale(lastYearSale, thisYearOrdersChart) == 1001 || growthRateSale(lastYearSale, thisYearOrdersChart) == 1000 ? Colors.blue: growthRateSale(lastYearSale, thisYearOrdersChart) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateSale(lastYearSale, thisYearOrdersChart) == 1001 || growthRateSale(lastYearSale, thisYearOrdersChart) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) : growthRateSale(lastYearSale, thisYearOrdersChart) < 0?
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
                                          animatedPrice(
                                              double.parse(totalStockCostsBySlide()),
                                              GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),
                                          // Text(
                                          //   totalStockCostsBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          //   textScaleFactor: 1, textAlign: TextAlign.left,
                                          //   style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           letterSpacing: 1,
                                          //           fontSize: 26,
                                          //           fontWeight: FontWeight.w600,
                                          //           color: Colors.black
                                          //       )
                                          //   ),
                                          // ),
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
                                          growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) == 1001 || growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) == 1001 || growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) == 1000 ? Colors.blue: growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) == 1001 || growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  growthRateUnpaid(lastYearUnpaid, yearUnpaidTotal) < 0?
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
                                          animatedPrice(
                                              profitByYear(),
                                              GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),
                                          // Text(
                                          //   profitByYear().toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          //   textScaleFactor: 1, textAlign: TextAlign.left,
                                          //   style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           letterSpacing: 1,
                                          //           fontSize: 26,
                                          //           fontWeight: FontWeight.w600,
                                          //           color: Colors.black
                                          //       )
                                          //   ),
                                          // ),
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
                                          growthRateDayProfit(profitByLastYear(), profitByYear()) == 1001 || growthRateDayProfit(profitByLastYear(), profitByYear()) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateDayProfit(profitByLastYear(), profitByYear()).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateDayProfit(profitByLastYear(), profitByYear()) == 1001 || growthRateDayProfit(profitByLastYear(), profitByYear()) == 1000 ? Colors.blue: growthRateDayProfit(profitByLastYear(), profitByYear()) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateDayProfit(profitByLastYear(), profitByYear()) == 1001 || growthRateDayProfit(profitByLastYear(), profitByYear()) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  growthRateDayProfit(profitByLastYear(), profitByYear()) < 0?
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
                                        textSetCharts,textScaleFactor: 1,
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
                                          animatedPrice(
                                              double.parse(totalStockCostsRBySlide()),
                                              GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),
                                          // Text(
                                          //   totalStockCostsRBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          //   textScaleFactor: 1, textAlign: TextAlign.left,
                                          //   style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           letterSpacing: 1,
                                          //           fontSize: 26,
                                          //           fontWeight: FontWeight.w600,
                                          //           color: Colors.black
                                          //       )
                                          //   ),
                                          // ),
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
                                          growthRateCost(lastYearCost, yearCostsTotal2) == 1001 || growthRateCost(lastYearCost, yearCostsTotal2) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateCost(lastYearCost, yearCostsTotal2).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateCost(lastYearCost, yearCostsTotal2) == 1001 || growthRateCost(lastYearCost, yearCostsTotal2) == 1000 ? Colors.blue: growthRateCost(lastYearCost, yearCostsTotal2) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateCost(lastYearCost, yearCostsTotal2) == 1001 || growthRateCost(lastYearCost, yearCostsTotal2) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  growthRateCost(lastYearCost, yearCostsTotal2) < 0?
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
                                          animatedPrice(
                                              yearRefundTotal,
                                              GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),
                                          // Text(
                                          //   yearRefundTotal.toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          //   textScaleFactor: 1, textAlign: TextAlign.left,
                                          //   style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           letterSpacing: 1,
                                          //           fontSize: 26,
                                          //           fontWeight: FontWeight.w600,
                                          //           color: Colors.black
                                          //       )
                                          //   ),
                                          // ),
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
                                          growthRateRefund(lastYearRefund, yearRefundTotal) == 1001 || growthRateRefund(lastYearRefund, yearRefundTotal) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateRefund(lastYearRefund, yearRefundTotal).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateRefund(lastYearRefund, yearRefundTotal) == 1001 || growthRateRefund(lastYearRefund, yearRefundTotal) == 1000 ? Colors.blue: growthRateRefund(lastYearRefund, yearRefundTotal) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateRefund(lastYearRefund, yearRefundTotal) == 1001 || growthRateRefund(lastYearRefund, yearRefundTotal) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  growthRateRefund(lastYearRefund, yearRefundTotal) < 0?
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
                                          animatedPrice(
                                              yearLossTotal,
                                              GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 26,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),
                                          // Text(
                                          //   yearLossTotal.toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          //   textScaleFactor: 1, textAlign: TextAlign.left,
                                          //   style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           letterSpacing: 1,
                                          //           fontSize: 26,
                                          //           fontWeight: FontWeight.w600,
                                          //           color: Colors.black
                                          //       )
                                          //   ),
                                          // ),
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
                                          growthRateLoss(lastYearLoss, yearLossTotal) == 1001 || growthRateLoss(lastYearLoss, yearLossTotal) == 1000 ?
                                          Text('') :
                                          Text(
                                            growthRateLoss(lastYearLoss, yearLossTotal).abs().toString()+ '% ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                              fontSize: 13, height: 1.2,
                                              fontWeight: FontWeight.w500,
                                              color: growthRateLoss(lastYearLoss, yearLossTotal) == 1001 || growthRateLoss(lastYearLoss, yearLossTotal) == 1000 ? Colors.blue: growthRateLoss(lastYearLoss, yearLossTotal) < 0? AppTheme.badgeFgDanger: Colors.green,),
                                          ) ,
                                          growthRateLoss(lastYearLoss, yearLossTotal) == 1001 || growthRateLoss(lastYearLoss, yearLossTotal) == 1000 ? Text(
                                            'same as ',strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          ), textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 13, height: 1.2,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withOpacity(0.6)),
                                          ) :  growthRateLoss(lastYearLoss, yearLossTotal) < 0?
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

                            ],
                          ),
                        ),
                        // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        //     stream: prodsSnap,
                        //     builder: (BuildContext context, prodsSB) {
                        //       if(prodsSB.hasData) {
                        //         var prodsSnapOut = prodsSB.data != null? prodsSB.data!.data(): null;
                        //         var prodsSc = prodsSnapOut?['prods'];
                        //         debugPrint('iphone year test');
                        //
                        //         return StreamBuilder(
                        //             stream: prodSaleData,
                        //             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //               if(snapshot.hasData) {
                        //                 debugPrint('iphone year len ' + snapshot.data!.docs.length.toString());
                        //                 var prodsDoc;
                        //                 if(snapshot.data!.docs.length==0) {
                        //                   return Container();
                        //                 }
                        //                 prodsDoc = snapshot.data!.docs[0].data()! as Map<String, dynamic>;
                        //                 debugPrint('iphone year ' + prodsDoc['date'].toDate().toString());
                        //                 if(prodsDoc != null) {
                        //                   var prods = prodsDoc['prods'];
                        //                   var prodsPrep = {};
                        //
                        //                   for(int i = 0; i < prods.length; i++) {
                        //                     var eachMap = prods.entries.elementAt(i);
                        //                     debugPrint('jisoo ' + prodsSc[eachMap.key].toString());
                        //                     double sort = 0;
                        //                     double main = eachMap.value['im'] == null? 0: eachMap.value['im'];
                        //                     double sub1 = eachMap.value['i1'] == null? 0: eachMap.value['i1'];
                        //                     double sub2 = eachMap.value['i2'] == null? 0: eachMap.value['i2'];
                        //
                        //                     debugPrint('setting 1 ' + prodsSc[eachMap.key].toString());
                        //                     debugPrint('setting 2 ' + main.toString() + ' ' + sub1.toString() + ' ' + sub2.toString());
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
                        //                     debugPrint('sorting ' + sort.toString());
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
                        //               }
                        //               return Container();
                        //             }
                        //         );
                        //       }
                        //       return Container();
                        //     }
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

  int initProdPagi = 0;
  bool firstProdTable = true;
  int ayinProdLeng = 0;
  var dropdownValue;
  int sortType = 0;
  Widget prodsDataTable(prodsPrep) {
    debugPrint('sorting filt ' + sortType.toString());
    if(sortType==3) {
      prodsPrep = sortMapBySub2(prodsPrep);
    } else if(sortType==2) {
      prodsPrep = sortMapBySub1(prodsPrep);
    } else if(sortType==1) {
      prodsPrep = sortMapByMain(prodsPrep);
    } else {
      debugPrint('sorting bef ' + prodsPrep.toString());
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
      print('sps ' + eachMap.toString());
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

  headerAppBar() {
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.calendar_view_day_rounded,
                            size: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.5),
                          child: Text(
                            selectDaysCast(), textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
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

  int _sliding = 0;
  final cateScCtler = ScrollController();
  int cateScIndex = 0;
  final _width = 10.0;

  DateTime today = DateTime.now();
  DateTime? _dateTime;
  String _format = 'yyyy';

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
        confirm: Text('Done',textScaleFactor: 1, style: TextStyle(color: Colors.blue)),
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
        today = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime.year.toString() + '-' + today.month.toString() + '-' + today.day.toString() + ' 00:00:00');
        _dateTime = today;
        // });


      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          today = today;
          _dateTime = today;
        });
      },
    );
  }

  String selectDaysCast() {
    return today.year.toString();
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
  //
  // String titleTextBySlide() {
  //   if(_sliding == 0) {
  //     return textSetTodaySoFar;
  //   } else if(_sliding == 1) {
  //     return textSetLast7Days;
  //   } else if(_sliding == 2) {
  //     // return textSetLast28D;
  //     if(today.month == 1) {
  //       return 'JANUARY ' + today.year.toString();
  //     } else if(today.month == 2) {
  //       return 'FEBRUARY ' + today.year.toString();
  //     } else if(today.month == 3) {
  //       return 'MARCH ' + today.year.toString();
  //     } else if(today.month == 4) {
  //       return 'APRIL ' + today.year.toString();
  //     } else if(today.month == 5) {
  //       return 'MAY ' + today.year.toString();
  //     } else if(today.month == 6) {
  //       return 'JUNE ' + today.year.toString();
  //     } else if(today.month == 7) {
  //       return 'JULY ' + today.year.toString();
  //     } else if(today.month == 8) {
  //       return 'AUGUST ' + today.year.toString();
  //     } else if(today.month == 9) {
  //       return 'SEPTEMBER ' + today.year.toString();
  //     } else if(today.month == 10) {
  //       return 'OCTOBER ' + today.year.toString();
  //     } else if(today.month == 11) {
  //       return 'NOVEMBER ' + today.year.toString();
  //     } else {
  //       return 'DECEMBER ' + today.year.toString();
  //     }
  //   } else {
  //     // return textSetLast12M;
  //     return 'YEAR ' + today.year.toString();
  //   }
  // }

  String totalStockCostsBySlide() {
    if(_sliding == 0) {
      return todayCostsTotal.toString();
    } else if(_sliding == 1) {
      return weekCostsTotal.toString();
    } else if(_sliding == 2) {
      return monthUnpaidTotal.toStringAsFixed(1);
    } else {
      return yearUnpaidTotal.toStringAsFixed(1);
    }
  }

  String totalStockCostsRBySlide() {
    if(_sliding == 0) {
      return todayCostsTotalR.toStringAsFixed(1);
    } else if(_sliding == 1) {
      return weekCostsTotalR.toStringAsFixed(1);
    } else if(_sliding == 2) {
      return monthCostsTotal2.toStringAsFixed(1);
    } else {
      return yearCostsTotal2.toStringAsFixed(1);
    }
  }

  // String totalRefundBySlide() {
  //   if(_sliding == 3) {
  //     return yearRefundTotal.toString();
  //   }
  // }

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
      return todayTotal.toStringAsFixed(1);
    } else if(_sliding == 1) {
      return weeklyTotal.toStringAsFixed(1);
    } else if(_sliding == 2) {
      return monthlyTotal.toStringAsFixed(1);
    } else {
      return yearlyTotal.toStringAsFixed(1);
    }
  }

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
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
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
           TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12/scaleFactor),
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
          getTextStyles: (context, value) => TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.w600,
            fontSize: 13/scaleFactor,
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

  profitByYear() {
    double profit = 0.0;
    // profit = yearSale - (yearCapital + yearLossTotal);
    profit = yearSale - (yearCapital);
    return profit;
  }

  profitByLastYear() {
    double profit = 0.0;
    // profit = lastYearSale - (lastYearCapital + lastYearLoss);
    profit = lastYearSale - (lastYearCapital);
    return profit;
  }

  String yestWeekTitle() {
    String title = '';
    if(_sliding == 3) {
      return title = 'Yearly';
    } else  {return title = 'Yearly';}
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
  double yearLossTotal = 0;

  double yearCapital = 0;
  double yearSale = 0;

  double lastYearSale = 0;
  double lastYearCost = 0;
  double lastYearUnpaid = 0;
  double lastYearRefund = 0;
  double lastYearLoss = 0;
  double lastYearCapital = 0;


  fetchOrdersYY(snapshot0) async {

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
    yearLossTotal = 0;

    yearSale = 0;
    yearCapital = 0;

    lastYearSale = 0;
    lastYearCost = 0;
    lastYearUnpaid = 0;
    lastYearRefund = 0;
    lastYearLoss = 0;
    lastYearCapital = 0;

    debugPrint('docs3 ' + snapshot0.length.toString());


    for(int loopOrd = 0; loopOrd < snapshot0.length; loopOrd++) {
      debugPrint('George Y sai 0 ' + snapshot0[loopOrd].id.toString());
      Map<String, dynamic> data = snapshot0[loopOrd].data()! as Map<String, dynamic>;

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          thisYearOrdersChart[i] += data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'].toString());
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          yearSale += data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'capital'] != null) {
          yearCapital += data[today.year.toString() + zeroToTen(i.toString()) + 'capital'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[(today.year - 1).toString() + zeroToTen(i.toString()) + 'capital'] != null) {
          lastYearCapital += data[(today.year-1).toString() + zeroToTen(i.toString()) + 'capital'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[(today.year - 1).toString() + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          lastYearSale += data[(today.year-1).toString() + zeroToTen(i.toString()) + 'cash_cust'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'] != null) {
          yearCostsTotal2 +=  data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'].toString());
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if (data[(today.year - 1).toString() + zeroToTen(i.toString()) +
            'cash_merc'] != null) {
          lastYearCost +=
          data[(today.year-1).toString() + zeroToTen(i.toString()) + 'cash_merc'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          yearUnpaidTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'];
          debugPrint('George Y ' + data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'].toString());
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[(today.year - 1).toString() + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          lastYearUnpaid +=  data[(today.year-1).toString() + zeroToTen(i.toString()) + 'debt_cust'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          yearRefundTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'];
          debugPrint('George Dollar ' + data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'].toString());
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[(today.year - 1).toString() + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          lastYearRefund +=  data[(today.year-1).toString() + zeroToTen(i.toString()) + 'refu_cust'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'loss_cust'] != null) {
          yearLossTotal +=  data[today.year.toString() + zeroToTen(i.toString()) + 'loss_cust'];
          debugPrint('LossOne ' + yearLossTotal.toString());
        }
      }

      for(int i = 1; i<= 12; i++) {
        debugPrint('looping');
        if(data[(today.year - 1).toString() + zeroToTen(i.toString()) + 'loss_cust'] != null) {
          lastYearLoss +=  data[(today.year-1).toString() + zeroToTen(i.toString()) + 'loss_cust'];
          debugPrint('LossTwo ' + lastYearLoss.toString());
        }
      }

    }
  }

  growthRateSale(double lastYear, List<double> currentYear) {
    double growthRate = 0;
    double todayTotal = 0;
    for (int i = 0; i < currentYear.length; i++){
      todayTotal += currentYear[i];
    }

    growthRate = (todayTotal - lastYear) / lastYear * 100;
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

  growthRateCost(double lastYear, double currentYear) {

    double growthRate = 0;
    double todayTotal = currentYear;

    growthRate = (todayTotal - lastYear) / lastYear * 100;
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

  growthRateUnpaid(double lastYear, double currentYear) {


    double growthRate = 0;
    double todayTotal = currentYear;

    growthRate = (todayTotal - lastYear) / lastYear * 100;
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

  growthRateRefund(double lastYear, double currentYear) {

    double growthRate = 0;
    double todayTotal = currentYear;

    growthRate = (todayTotal - lastYear) / lastYear * 100;
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

  growthRateLoss(double lastYear, double currentYear) {

    double growthRate = 0;
    double todayTotal = currentYear;

    growthRate = (todayTotal - lastYear) / lastYear * 100;
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

  animatedPrice(double price, style) {
    double temp = 0;
    double total =  price;
    return Countup(
      precision: 2,
      begin: temp,
      end: total,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
      separator: ',',
      style: style, textScaleFactor: 1,
    );
  }


}

enum PaginateBuilderType { listView, gridView, pageView }

