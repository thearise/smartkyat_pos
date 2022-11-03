library paginate_firestore;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:paginate_firestore/bloc/pagination_cubit.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:provider/provider.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fragments/bloc_home_month_loss.dart';
import 'package:smartkyat_pos/fragments/prod_sale_sum_home.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../home_fragment6.dart';
import 'bottom_loader.dart';
import 'empty_display.dart';
import 'empty_separator.dart';
import 'error_display.dart';
import 'initial_loader.dart';

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

class BlocYearOverview extends StatefulWidget {

  const BlocYearOverview({
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
    required this.isEnglish,
    this.includeMetadataChanges = false,
    this.options,
    this.shopId,
    this.dateTime,
    required this.intValIni,
    required void resetState(DateTime resetD),
    required void selectedIntVal(int index),
    required void closeDrawer(String str),
    required void openDrawer(String str),
  }) :
        _resetState = resetState,
        _selectedIntVal = selectedIntVal,
        _openDrawer = openDrawer,
        _closeDrawer = closeDrawer,
        super(key: key);

  final int intValIni;
  final _closeDrawer;
  final _openDrawer;
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
  _BlocYearOverviewState createState() => _BlocYearOverviewState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _BlocYearOverviewState extends State<BlocYearOverview> {
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

  String textSetSaleSummary = 'SALES SUMMARY OVERVIEW';
  String textSetStockCosts = 'Stock costs';
  String textSetNetSales = 'Net sales';
  String textSetUnpaid = 'Unpaid';
  String textSetRef = 'Refunds';
  String textSetLoss = 'Loss amount';
  String textSetToday = 'Today';
  String textSetLastMonth = 'Monthly';
  String textSetLastYear = 'Yearly';
  String textSetProfit = 'Avg profit';
  String textSetMore = 'More detail';
  String textSetProdSale = 'PRODUCT SALE SUMMARY';
  String textSetTSales = 'Total products sold';
  String textSetTLoss = 'Total products loss';
  String textSetTRef = 'Total products refund';
  String textSetSaleAmt = 'Gross sales';
  String textSetBuyAmt = 'Buys';
  String textSetDiscount = 'Discount';


  void closeDrawerFrom() {
    widget._closeDrawer('home');
  }

  void openDrawerFrom() {
    widget._openDrawer('home');
  }

  bool firstTime = true;
  double homeBotPadding = 0;

  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }

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
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? 0 + 20: homeBotPadding),
                  child: _buildListView(loadedState),
                ),
              ),
              Container(
                color: Colors.white,
                // height: MediaQuery.of(context).viewInsets.bottom,
                // height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
              ),
            ],
          );
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


  double tSale = 0;
  double tRef = 0;
  double tLoss = 0;
  double tSaleAmount = 0;
  double tBuyAmount = 0;
  double tDiscount = 0;

  @override
  void initState() {
    myTabs = <int, Widget>{
      0: Text(widget.isEnglish? 'Today':'ယနေ့', textScaleFactor: 1, style: TextStyle(height: widget.isEnglish? 1:2),),
      1: Text(widget.isEnglish? 'Month':'ယခုလ', textScaleFactor: 1, style: TextStyle(height: widget.isEnglish? 1:2),),
      2: Text(widget.isEnglish? 'Year':'ယခုနှစ်', textScaleFactor: 1, style: TextStyle(height: widget.isEnglish? 1:2),)
    };

    if(widget.isEnglish == true) {

      setState(() {
        textSetSaleSummary = 'SALES SUMMARY OVERVIEW';
        textSetStockCosts = 'Stock costs';
        textSetNetSales = 'Net sales';
        textSetUnpaid = 'Unpaid';
        textSetRef = 'Refunds';
        textSetLoss = 'Loss amount';
        textSetToday = 'Today';
        textSetLastMonth = 'Monthly';
        textSetLastYear = 'Yearly';
        textSetProfit = 'Avg profit';
        textSetMore = 'More detail';
        textSetProdSale = 'PRODUCT SALE SUMMARY';
        textSetTSales = 'Total products sold';
        textSetTLoss = 'Total loss';
        textSetTRef = 'Total refunds';
        textSetSaleAmt = 'Gross sales';
        textSetBuyAmt = 'Buys';
        textSetDiscount = 'Discount';
      });
    } else {
      setState(() {
        textSetSaleSummary = 'SALE IN-OUT OVERVIEW';
        textSetStockCosts = 'ဝယ်ယူစရိတ်';
        textSetNetSales = 'အသားတင် ရောင်းရငွေ';
        textSetUnpaid = 'အကြွေးကျန်ငွေ';
        textSetRef = 'ပြန်ပေးငွေ';
        textSetLoss = 'ဆုံးရှုံးငွေ';
        textSetToday = 'Today';
        textSetLastMonth = 'Monthly';
        textSetLastYear = 'Yearly';
        textSetProfit = 'ပျမ်းမျှအမြတ်ငွေ';
        textSetMore = 'အသေးစိတ်ကြည့်ရန်';
        textSetProdSale = 'PRODUCT SALE OVERVIEW';
        textSetTSales = 'ရောင်းပြီးကုန်အမျိုးများ';
        textSetTLoss = 'ဆုံးရှုံးကုန်အမျိုးများ';
        textSetTRef = 'ပြန်ပေးကုန်အမျိုးများ';
        textSetSaleAmt = 'စုစုပေါင်းရောင်းငွေ';
        textSetBuyAmt = 'ရောင်းပြီးကုန်များ ဝယ်စျေး';
        textSetDiscount = 'အရောင်းအာလုံး လျှော့ငွေ';
      });
    }

    debugPrint('inside loss leeeee ' + widget.intValIni.toString());
    cateScIndex = widget.intValIni;
    segmentedControlGroupValue = widget.intValIni;
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

  Widget _buildListView(PaginationLoaded loadedState) {
    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      debugPrint('inside loss loss ' + data.toString());
    }

    fetchOrdersMY(loadedState.documentSnapshots);
    double width = MediaQuery.of(context).size.width > 900
        ? MediaQuery.of(context).size.width * (2 / 3.5)
        : MediaQuery.of(context).size.width;

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
              if(cateScIndex == 2) {
                return Container(
                  // height: MediaQuery.of(context).size.height-353,
                  width: width,
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
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0, bottom: 4.0, left: 15.0, right: 15.0),
                                child: Text(textSetSaleSummary, textScaleFactor: 1,
                                  style: TextStyle(
                                    height: 0.9,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,color: Colors.grey,
                                  ),),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width/2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              animatedPrice(
                                                  doubleRetri(NumberFormat.compactCurrency(
                                                    decimalDigits: 2,
                                                    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(totalBySlide())),
                                                  GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black
                                                      )
                                                  ),
                                                  2
                                              ),
                                              Text(
                                                lastSRetri(NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(totalBySlide()))
                                                ,
                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '$textSetNetSales ($currencyUnit)',strutStyle: StrutStyle(
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
                                    ),
                                  ),
                                  Container(
                                    width: width/2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              animatedPrice(
                                                  doubleRetri(NumberFormat.compactCurrency(
                                                    decimalDigits: 2,
                                                    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(profitBySlide())),
                                                  GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black
                                                      )
                                                  ),
                                                  2
                                              ),
                                              Text(
                                                lastSRetri(NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(profitBySlide()))
                                                ,
                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '$textSetProfit ($currencyUnit)',strutStyle: StrutStyle(
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
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: width,
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width/2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              animatedPrice(
                                                  doubleRetri(NumberFormat.compactCurrency(
                                                    decimalDigits: 2,
                                                    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(totalStockCostsBySlide())),
                                                  GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black
                                                      )
                                                  ),
                                                  2
                                              ),
                                              Text(
                                                lastSRetri(NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(totalStockCostsBySlide()))
                                                ,
                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '$textSetStockCosts (' + currencyUnit +')',strutStyle: StrutStyle(
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
                                    ),
                                  ),
                                  Container(
                                    width: width/2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              animatedPrice(
                                                  doubleRetri(NumberFormat.compactCurrency(
                                                    decimalDigits: 2,
                                                    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(totalUnpaidBySlide())),
                                                  GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black
                                                      )
                                                  ),
                                                  2
                                              ),
                                              Text(
                                                lastSRetri(NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(totalUnpaidBySlide()))
                                                ,
                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '$textSetUnpaid ($currencyUnit)',strutStyle: StrutStyle(
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
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  width: width,
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width/2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              animatedPrice(
                                                  doubleRetri(NumberFormat.compactCurrency(
                                                    decimalDigits: 2,
                                                    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(totalRefundBySlide())),
                                                  GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black
                                                      )
                                                  ),
                                                  2
                                              ),
                                              Text(
                                                lastSRetri(NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(totalRefundBySlide()))
                                                ,
                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '$textSetRef ($currencyUnit)',strutStyle: StrutStyle(
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
                                    ),
                                  ),
                                  Container(
                                    width: width/2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              animatedPrice(
                                                  doubleRetri(NumberFormat.compactCurrency(
                                                    decimalDigits: 2,
                                                    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(totalLossBySlide())),
                                                  GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black
                                                      )
                                                  ),
                                                  2
                                              ),
                                              Text(
                                                lastSRetri(NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(totalLossBySlide()))
                                                ,
                                                textScaleFactor: 1, textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        letterSpacing: 1,
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            '$textSetLoss ($currencyUnit)',strutStyle: StrutStyle(
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
                                    ),
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              //   child: Container(
                              //     width: width,
                              //     decoration: BoxDecoration(
                              //         border: Border(
                              //             bottom: BorderSide(
                              //                 color: Colors.grey
                              //                     .withOpacity(
                              //                     0.3),
                              //                 width: 1.0)
                              //         )),
                              //   ),
                              // ),
                              // Row(
                              //   children: [
                              //     Container(
                              //       width: width/2,
                              //       child: Padding(
                              //         padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
                              //         child: Column(
                              //           crossAxisAlignment: CrossAxisAlignment.start,
                              //           children: [
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   '45',
                              //                   textScaleFactor: 1, textAlign: TextAlign.left,
                              //                   style: GoogleFonts.lato(
                              //                       textStyle: TextStyle(
                              //                           letterSpacing: 1,
                              //                           fontSize: 26,
                              //                           fontWeight: FontWeight.w500,
                              //                           color: Colors.black
                              //                       )
                              //                   ),
                              //                 ),
                              //                 Padding(
                              //                   padding: const EdgeInsets.only(left: 5.0, top: 13.0),
                              //                   child: Text(
                              //                     'M',strutStyle: StrutStyle(
                              //                       forceStrutHeight: true,
                              //                       height: 1.2
                              //                   ),
                              //                     style: TextStyle(
                              //                         fontSize: 27, height: 1.2,
                              //                         fontWeight: FontWeight.w500,
                              //                         color: Colors.black),
                              //                   ),
                              //                 )
                              //               ],
                              //             ),
                              //             Text(
                              //               'Loss amount (MMK)',strutStyle: StrutStyle(
                              //                 forceStrutHeight: true,
                              //                 height: 1.2
                              //             ),
                              //               style: TextStyle(
                              //                   fontSize: 13, height: 1.2,
                              //                   fontWeight: FontWeight.w500,
                              //                   color: Colors.black.withOpacity(0.6)),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //
                              //   ],
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0, top: 4),
                                child: ButtonTheme(
                                  minWidth: width,
                                  splashColor: Colors.transparent,
                                  height: 50,
                                  child: FlatButton(
                                    color: AppTheme.buttonColor2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: AppTheme.buttonColor2,
                                      ),
                                    ),
                                    onPressed: () async {
                                      closeDrawerFrom();
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (
                                                context) =>
                                                HomeFragment(
                                                  shopId: widget.shopId, tab: cateScIndex, openDrawerBtn: widget._openDrawer, closeDrawerBtn: widget._closeDrawer, isEnglish: widget.isEnglish,
                                                )),
                                      );
                                      openDrawerFrom();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 2.0),
                                      child: Container(
                                        child: Text(
                                            textSetMore, textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing:-0.1
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.4,
                                              forceStrutHeight: true,
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
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
                                padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 10.0),
                                child: Text(textSetProdSale, textScaleFactor: 1,
                                  style: TextStyle(
                                    height: 0.9,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,color: Colors.grey,
                                  ),),
                              ),
                              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                  stream:
                                  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodYearData').doc(DateTime.now().year.toString()).snapshots(),
                                  builder: (BuildContext context, prodsSB) {
                                    var prods;
                                    tSale = 0;
                                    tRef = 0;
                                    tLoss = 0;
                                    tSaleAmount = 0;
                                    tBuyAmount = 0;
                                    tDiscount = 0;
                                    double mainSale = 0;
                                    double sub1Sale = 0;
                                    double sub2Sale = 0;
                                    double mainBuy = 0;
                                    double sub1Buy = 0;
                                    double sub2Buy = 0;
                                    double mainDis = 0;
                                    double sub1Dis = 0;
                                    double sub2Dis = 0;
                                    if(prodsSB.hasData) {
                                      var prodsSnapOut = prodsSB.data != null? prodsSB.data!.data(): null;
                                      prods = prodsSnapOut?['prods'];
                                      if(prods != null && prods.length > 0) {
                                        for(int i = 0; i <  prods.length; i++) {
                                          var eachMap = prods.entries.elementAt(i);

                                          if(eachMap.value['im'] != 0 && eachMap.value['im'] != null
                                              || eachMap.value['i1'] != 0 && eachMap.value['i1'] != null
                                              || eachMap.value['i2'] != 0 && eachMap.value['i2'] != null) {
                                            tSale++;
                                          }
                                          if(eachMap.value['rm'] != 0 && eachMap.value['rm'] != null
                                              || eachMap.value['r1'] != 0 && eachMap.value['r1'] != null
                                              || eachMap.value['r2'] != 0 && eachMap.value['r2'] != null) {
                                            tRef++;
                                          }
                                          if(eachMap.value['lm'] != 0 && eachMap.value['lm'] != null
                                              || eachMap.value['l1'] != 0 && eachMap.value['l1'] != null
                                              || eachMap.value['l2'] != 0 && eachMap.value['l2'] != null) {
                                            tLoss++;
                                          }
                                          if(eachMap.value['sm'] != null) {
                                            mainSale =  eachMap.value['sm'];
                                          } else {
                                            mainSale = 0;
                                          }
                                          if(eachMap.value['s1'] != null) {
                                            sub1Sale =  eachMap.value['s1'];
                                          } else {
                                            sub1Sale = 0;
                                          }
                                          if(eachMap.value['s2'] != null) {
                                            sub2Sale =  eachMap.value['s2'];
                                          } else {
                                            sub2Sale = 0;
                                          }
                                          tSaleAmount = tSaleAmount + (mainSale + sub1Sale + sub2Sale);

                                          if(eachMap.value['bm'] != null) {
                                            mainBuy =  eachMap.value['bm'];
                                          } else {
                                            mainBuy = 0;
                                          }
                                          if(eachMap.value['b1'] != null) {
                                            sub1Buy =  eachMap.value['b1'];
                                          } else {
                                            sub1Buy = 0;
                                          }
                                          if(eachMap.value['b2'] != null) {
                                            sub2Buy = eachMap.value['b2'];
                                          } else {
                                            sub2Buy = 0;
                                          }
                                          tBuyAmount = tBuyAmount + (mainBuy + sub1Buy + sub2Buy);

                                          if(eachMap.value['dm'] != 0 && eachMap.value['dm'] != null) {
                                            mainDis =  eachMap.value['dm'];
                                          } else {
                                            mainDis = 0;
                                          }
                                          if(eachMap.value['d1'] != 0 && eachMap.value['d1'] != null) {
                                            sub1Dis =  eachMap.value['d1'];
                                          } else {
                                            sub1Dis = 0;
                                          }
                                          if(eachMap.value['d2'] != 0 && eachMap.value['d2'] != null) {
                                            sub2Dis =  eachMap.value['d2'];
                                          } else {
                                            sub2Dis = 0;
                                          }
                                          tDiscount = tDiscount + (mainDis + sub1Dis + sub2Dis);
                                        }

                                      }
                                    }
                                    return Column(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Text(textSetTSales, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                    Spacer(),
                                                    animatedPrice(
                                                        tSale,
                                                        TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500, color: Colors.black,
                                                        ),
                                                        0
                                                    ),
                                                    Text((widget.isEnglish? ' types': ' မျိုး'), textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(0.2),
                                                            width: 1.0))),
                                              ),
                                            ),
                                          ],
                                        ),


                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Text(textSetTLoss, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                    Spacer(),
                                                    animatedPrice(
                                                        tLoss,
                                                        TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500, color: Colors.black,
                                                        ),
                                                        0
                                                    ),
                                                    Text((widget.isEnglish? ' types': ' မျိုး'), textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(0.2),
                                                            width: 1.0))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Text(textSetTRef, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                    Spacer(),
                                                    animatedPrice(
                                                        tRef,
                                                        TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500, color: Colors.black,
                                                        ),
                                                        0
                                                    ),
                                                    Text((widget.isEnglish? ' types': ' မျိုး'), textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(0.2),
                                                            width: 1.0))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Text(textSetSaleAmt, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                    Spacer(),
                                                    animatedPrice(
                                                        tSaleAmount,
                                                        TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500, color: Colors.black,
                                                        ),
                                                        2
                                                    ),
                                                    Text(' ' +currencyUnit, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(0.2),
                                                            width: 1.0))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Text(textSetBuyAmt, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                    Spacer(),
                                                    animatedPrice(
                                                        tBuyAmount,
                                                        TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500, color: Colors.black,
                                                        ),
                                                        2
                                                    ),
                                                    Text(' ' +currencyUnit, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(0.2),
                                                            width: 1.0))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Text(textSetDiscount, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                    Spacer(),
                                                    animatedPrice(
                                                        tDiscount,
                                                        TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500, color: Colors.black,
                                                        ),
                                                        2
                                                    ),
                                                    Text(' ' +currencyUnit, textScaleFactor: 1, style:
                                                    TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500, color: Colors.black,
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Column(
                                        //   children: [
                                        //     Padding(
                                        //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        //       child: Container(
                                        //         height: 55,
                                        //         child: Row(
                                        //           children: [
                                        //             Text('Total products', textScaleFactor: 1, style:
                                        //             TextStyle(
                                        //               fontSize: 16,
                                        //               fontWeight: FontWeight.w500, color: Colors.black,
                                        //             ),),
                                        //             Spacer(),
                                        //             Text('7,3454', textScaleFactor: 1, style:
                                        //             TextStyle(
                                        //               fontSize: 16,
                                        //               fontWeight: FontWeight.w500, color: Colors.black,
                                        //             ),),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    );
                                  }
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 17.0, top: 10),
                                child: ButtonTheme(
                                  minWidth: width,
                                  splashColor: Colors.transparent,
                                  height: 50,
                                  child: FlatButton(
                                    color: AppTheme.buttonColor2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: AppTheme.buttonColor2,
                                      ),
                                    ),
                                    onPressed: () async {
                                      closeDrawerFrom();
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (
                                                context) =>
                                                ProdSaleSumHome(
                                                  shopId: widget.shopId, tab: cateScIndex,  openDrawerBtn: widget._openDrawer, closeDrawerBtn: widget._closeDrawer, isEnglish: widget.isEnglish,
                                                )),
                                      );
                                      openDrawerFrom();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 2.0),
                                      child: Container(
                                        child: Text(
                                            textSetMore, textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing:-0.1
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.4,
                                              forceStrutHeight: true,
                                            )
                                        ),
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

  int segmentedControlGroupValue = 0;
  Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Today", textScaleFactor: 1,),
    1: Text("Month", textScaleFactor: 1),
    2: Text("Year", textScaleFactor: 1,),
  };

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
              });
              widget._selectedIntVal(i);
              print('catescindex ' + i.toString());
            }),

      ),
    );
  }

  int _sliding = 0;
  final cateScCtler = ScrollController();
  int cateScIndex = 0;
  final _width = 10.0;

  DateTime today = DateTime.now();
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM';

  FlashController? _previousController;

  Future smartKyatFMod<T>(BuildContext context, String message, String type) async {
    if(_previousController != null) {
      if (_previousController!.isDisposed == false) _previousController!.dismiss();
    }

    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }

    _previousController = FlashController<T>(
      context,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(message, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
        );
        // return Flash.dialog(
        //   controller: controller,
        //   alignment: const Alignment(0, 0.5),
        //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        //   backgroundColor: Colors.black87,
        //   child: DefaultTextStyle(
        //     style: const TextStyle(fontSize: 16.0, color: Colors.white),
        //     child: Padding(
        //       padding:
        //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //       child: Text(message),
        //     ),
        //   ),
        // );
      },
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
    );
    return _previousController!.show();
  }

  String selectDaysCast() {
    debugPrint("TTT " + today.year.toString().length.toString());
    // if(_sliding==0) {
    // today.year.toString().substring(today.year.toString().length-2, today.year.toString().length
    if(today.month == 9) {
      return 'Sep, ' + today.year.toString();
    } else if(today.month == 1) {
      return 'Jan, ' + today.year.toString();
    } else if(today.month == 2) {
      return 'Feb, ' + today.year.toString();
    } else if(today.month == 3) {
      return 'Mar, ' + today.year.toString();
    } else if(today.month == 4) {
      return 'Apr, ' + today.year.toString();
    } else if(today.month == 5) {
      return 'May, ' + today.year.toString();
    } else if(today.month == 6) {
      return 'Jun, ' + today.year.toString();
    } else if(today.month == 7) {
      return 'Jul, ' + today.year.toString();
    } else if(today.month == 8) {
      return 'Aug, ' + today.year.toString();
    } else if(today.month == 10) {
      return 'Oct, ' + today.year.toString();
    } else if(today.month == 11) {
      return 'Nov, ' + today.year.toString();
    } else if(today.month == 12) {
      return 'Dec, ' + today.year.toString();
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

  double totalStockCostsBySlide() {
    if(_sliding == 0) {
      return monthCostsTotal2;
    } else {
      return realYearCost;
    }
  }

  double totalUnpaidBySlide() {
    if(_sliding == 0) {
      return monthUnpaidTotal;
    } else {
      return realYearUnpaid;
    }
  }

  double totalRefundBySlide() {
    if(_sliding == 0) {
      return monthRefundTotal;
    }else {
      return realYearRefund;
    }
  }

  double totalLossBySlide() {
    if(_sliding == 0) {
      return monthLossTotal;
    }else {
      return realYearLoss;
    }
  }


  double totalBySlide() {
    if(_sliding == 0) {
      return monthSale;
    } else if(_sliding == 1) {
      return realYearSale;
    } else {
      return realYearSale;
    }
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

  growthRateSale(double lastMonth, List<double> currentMonth) {
    double growthRate = 0;
    double todayTotal = 0;
    for (int i = 0; i < currentMonth.length; i++){
      todayTotal += currentMonth[i];
    }

    growthRate = (todayTotal - lastMonth) / lastMonth * 100;
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

  growthRateCost(double lastMonth, double currentMonth) {

    double growthRate = 0;
    double todayTotal = currentMonth;

    growthRate = (todayTotal - lastMonth) / lastMonth * 100;
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

  growthRateUnpaid(double lastMonth, double currentMonth) {

    double growthRate = 0;
    double todayTotal = currentMonth;

    growthRate = (todayTotal - lastMonth) / lastMonth * 100;
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

  growthRateRefund(double lastMonth, double currentMonth) {

    double growthRate = 0;
    double todayTotal = currentMonth;

    growthRate = (todayTotal - lastMonth) / lastMonth * 100;
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

  growthRateLoss(double lastMonth, double currentMonth) {

    double growthRate = 0;
    double todayTotal = currentMonth;

    growthRate = (todayTotal - lastMonth) / lastMonth * 100;
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
              TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
            fontWeight: FontWeight.w500,
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
  double monthLossTotal = 0;

  double realYearSale = 0;
  double realYearUnpaid = 0;
  double realYearRefund = 0;
  double realYearCost = 0;
  double realYearLoss = 0;
  double realYearCapital = 0;

  double monthCapital = 0;
  double monthSale = 0;

  double profitBySlide() {
    double profit = 0.0;
    if(_sliding == 0) {
      // profit = monthSale - (monthCapital + monthLossTotal);
      profit = monthSale - (monthCapital);
    } else {
      // profit = realYearSale - (realYearCapital + realYearLoss);
      profit = realYearSale - (realYearCapital);
    }

    return profit;
  }


  String yestWeekTitle() {
    String title = '';
    if(_sliding == 2) {
      return title = 'last month';
    } else  {return title = 'Yearly';}
  }
  

  fetchOrdersMY(snapshot0) async {

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
    monthLossTotal = 0;
    realYearSale = 0;
    realYearUnpaid = 0;
    realYearRefund = 0;
    realYearCost = 0;
    realYearLoss = 0;
    monthSale = 0;
    monthCapital = 0;
    realYearCapital = 0;


    for(int loopOrd = 0; loopOrd < snapshot0.length; loopOrd++) {

      Map<String, dynamic> data = snapshot0[loopOrd].data()! as Map<String, dynamic>;


      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'] != null) {
          realYearSale += data[today.year.toString() + zeroToTen(i.toString()) + 'cash_cust'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() +  zeroToTen(i.toString()) + 'capital'] != null) {
          realYearCapital += data[today.year.toString() + zeroToTen(i.toString()) + 'capital'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'] != null) {
          realYearCost +=  data[today.year.toString() + zeroToTen(i.toString()) + 'cash_merc'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'] != null) {
          realYearUnpaid +=  data[today.year.toString() + zeroToTen(i.toString()) + 'debt_cust'];
        }
      }

      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'] != null) {
          realYearRefund +=  data[today.year.toString() + zeroToTen(i.toString()) + 'refu_cust'];
        }
      }


      for(int i = 1; i<= 12; i++) {
        if(data[today.year.toString() + zeroToTen(i.toString()) + 'loss_cust'] != null) {
          realYearLoss +=  data[today.year.toString() + zeroToTen(i.toString()) + 'loss_cust'];
        }
      }

    }
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

enum PaginateBuilderType { listView, gridView, pageView }
