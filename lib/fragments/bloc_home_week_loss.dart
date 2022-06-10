library paginate_firestore;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

  String textSetTotalSales = 'TOTAL SALES';
  String textSetTodaySoFar = 'TODAY SO FAR';
  String textSetStockCosts = 'Stock costs';
  String textSetUnpaid = 'Unpaid';
  String textSetBuys = 'Refunds';
  String textSetLoss = 'Loss';
  String textSetToday = 'Day';
  String textSetLastWeek = 'Last week';
  String textSetLastMonth = 'This month';
  String textSetLastYear = 'Last year';
  String textSetLast7Days = 'Last 7 Days';
  String textSetLast28D = 'LAST 28 DAYS';
  String textSetLast12M = 'LAST 12 MONTHS';
  String textSetSearch = 'Search';
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
  void initState() {
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

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetTotalSales = 'စုစုပေါင်း ရောင်းရငွေ';
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
      } else if(value=='english') {
        setState(() {
          textSetTotalSales = 'TOTAL SALES';
          textSetTodaySoFar = 'TODAY SO FAR';
          textSetStockCosts = 'Stock costs';
          textSetUnpaid = 'Unpaid';
          textSetBuys = 'Refunds';
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
    // DateTime greaterThan = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00');
    // return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
    //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
    //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 00:00:00'))
    //     .orderBy('date', descending: true);
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders');
  }

  Widget _buildListView(PaginationLoaded loadedState) {

    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      debugPrint('inside loss loss ' + data.toString());
    }


    for(int i = 0; i < widget.sale.length; i++) {
      Map<String, dynamic> data = widget.sale[i].data() as Map<String, dynamic>;
      debugPrint('inside loss sale ' + data.toString());
    }

    for(int i = 0; i < widget.buy.length; i++) {
      Map<String, dynamic> data = widget.buy[i].data() as Map<String, dynamic>;
      debugPrint('inside loss buy ' + data.toString());
    }

    fetchOrdersMY(loadedState.documentSnapshots);

    fetchOrders(widget.sale, widget.buy);
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
        ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        textSetTotalSales,
                                        style: TextStyle(
                                          height: 0.9,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   titleTextBySlide(),
                                    //   style: TextStyle( height: 0.9,
                                    //     letterSpacing: 2,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 14,color: Colors.grey,
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              SizedBox(height: 6,),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 2.0),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Text(totalBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                letterSpacing: 1,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12.0),
                                        child: Text(' $currencyUnit',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                              )
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color: percentBySale() == 1001 || percentBySale() == 1000 ? Colors.blue: percentBySale() < 0? AppTheme.badgeFgDanger: Colors.green,
                                          ),
                                          // width: 50,
                                          height: 25,
                                          child: Center(
                                            child: Text(' ' + perTSalText(percentBySale()) + ' ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6,),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
                              //   child: Row(
                              //     children: [
                              //       Text('Total sales',
                              //         textAlign: TextAlign.left,
                              //         style: TextStyle(
                              //             fontSize: 15,
                              //             fontWeight: FontWeight.w500,
                              //             color: Colors.black),
                              //       ),
                              //       Expanded(
                              //         child: GestureDetector(
                              //           onTap: () {
                              //             Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail(shopId: shopId.toString(),)),);
                              //           },
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.end,
                              //             // crossAxisAlignment: CrossAxisAlignment.end,
                              //             children: [
                              //               Text('View detail',
                              //                 textAlign: TextAlign.right,
                              //                 style: TextStyle(
                              //                     fontSize: 15,
                              //                     fontWeight: FontWeight.w500,
                              //                     color: Colors.blue),
                              //               ),
                              //               Padding(
                              //                 padding: const EdgeInsets.only(bottom: 4.5),
                              //                 child: Container(
                              //                   width: 25,
                              //                   height: 25,
                              //                   child: IconButton(
                              //                       icon: Icon(
                              //                         Icons.arrow_forward_ios_rounded,
                              //                         size: 13,
                              //                         color: Colors.blue,
                              //                       ),
                              //                       onPressed: () {
                              //                       }),
                              //                 ),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 100,
                                child: ListView(

                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      // width: 100,
                                      height: 108,

                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity, minWidth: 120),
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

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height:26
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:30.0),
                                                  child: Text(totalStockCostsRBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            letterSpacing: 1,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Text('?')
                                            ),
                                            Text(textSetStockCosts,
                                              strutStyle: StrutStyle(
                                                  forceStrutHeight: true,
                                                  height: 1.2
                                              ),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black.withOpacity(0.6)),
                                            ),
                                            Positioned(
                                                right: 0,
                                                bottom: 2,
                                                child: Text(percentByCost().toString() == '1001' ? '-%' : percentByCost().toString() == '1000' ? '-%' : percentByCost().toString() + '%',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: percentByCost().toString() == '1001' || percentByCost().toString() == '1000'? Colors.blue : percentByCost() < 0? AppTheme.badgeFgDanger: Colors.green,
                                                    // color: Colors.blue
                                                  ),
                                                )
                                            ),
                                            Positioned(
                                              left: 0,
                                              bottom: 2,
                                              child: Text(currencyUnit,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black.withOpacity(0.6)),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),

                                    Container(
                                      // width: 100,
                                      height: 108,

                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity, minWidth: 120),
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

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height:26
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:30.0),
                                                  child: Text(totalStockCostsBySlide().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            letterSpacing: 1,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Text('?')
                                            ),
                                            Text(textSetUnpaid,
                                              strutStyle: StrutStyle(
                                                  forceStrutHeight: true,
                                                  height: 1.2
                                              ),
                                              style: TextStyle(
                                                  fontSize: 13, height: 1.2,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black.withOpacity(0.6)),
                                            ),

                                            Positioned(
                                                right: 0,
                                                bottom: 2,
                                                child: Text(percentByUnpaid().toString() == '1001' ? '-%' : percentByUnpaid().toString() == '1000' ? '-%' : percentByUnpaid().toString() + '%',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: percentByUnpaid().toString() == '1001' || percentByUnpaid().toString() == '1000' ? Colors.blue: percentByUnpaid() < 0? AppTheme.badgeFgDanger: Colors.green,
                                                    // color: Colors.blue
                                                  ),
                                                )
                                            ),
                                            Positioned(
                                              left: 0,
                                              bottom: 2,
                                              child: Text(currencyUnit,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black.withOpacity(0.6)),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),

                                    Container(
                                      // width: 100,
                                      height: 108,

                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity, minWidth: 120),
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

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height:26
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:30.0),
                                                  child: Text(totalRefundBySlide().toString(),
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            letterSpacing: 1,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Text('?')
                                            ),
                                            Text(textSetBuys,
                                              strutStyle: StrutStyle(
                                                  forceStrutHeight: true,
                                                  height: 1.2
                                              ),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black.withOpacity(0.6)),
                                            ),

                                            Positioned(
                                                right: 0,
                                                bottom: 2,
                                                child: Text(percentByRefund().toString() == '1001' ? '-%' : percentByRefund().toString() == '1000' ? '-%' : percentByRefund().toString() + '%',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: percentByRefund() == 1001 || percentByRefund() == 1000 ? Colors.blue: percentByRefund() < 0? Colors.green: AppTheme.badgeFgDanger,
                                                    // color: Colors.blue
                                                  ),
                                                )
                                            ),
                                            Positioned(
                                              left: 0,
                                              bottom: 2,
                                              child: Text(currencyUnit,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black.withOpacity(0.6)),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),

                                    Container(
                                      // width: 100,
                                      height: 100,
                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity, minWidth: 120),
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

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height:26
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:30.0),
                                                  child: Text(totalLossBySlide(),
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            letterSpacing: 1,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Text('?')
                                            ),
                                            Text(textSetLoss,
                                              strutStyle: StrutStyle(
                                                  forceStrutHeight: true,
                                                  height: 1.2
                                              ),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black.withOpacity(0.6)),
                                            ),
                                            Positioned(
                                                right: 0,
                                                bottom: 2,
                                                child: Text(percentByLoss().toString() == '1001' ? '-%' : percentByLoss().toString() == '1000' ? '-%' : percentByLoss().toString() + '%',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: percentByLoss() == 1001 || percentByLoss() == 1000 ? Colors.blue: percentByLoss() < 0? Colors.green: AppTheme.badgeFgDanger,
                                                    // color: Colors.blue
                                                  ),
                                                )
                                            ),
                                            Positioned(
                                              left: 0,
                                              bottom: 2,
                                              child: Text(currencyUnit,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black.withOpacity(0.6)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: 15.0
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
                                      'Total sales',
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

                        SizedBox(
                          height: 0,
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
                          height: 20,
                        ),
                        // SizedBox(
                        //   width: 60,
                        //   height: 34,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       setState(() {
                        //         showAvg = !showAvg;
                        //       });
                        //     },
                        //     child: Text(
                        //       'avg',
                        //       style: TextStyle(
                        //           fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
                        //     ),
                        //   ),
                        // ),
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
                          selectDaysCast(),
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
                          textSetToday,
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
                          textSetLastWeek,
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
                          textSetLastMonth,
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
                          textSetLastYear,
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
        confirm: Text('Done', style: TextStyle(color: Colors.blue)),
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

  String titleTextBySlide() {
    if(_sliding == 0) {
      return textSetTodaySoFar;
    } else {
      return textSetLast7Days;
    }
  }

  String totalStockCostsBySlide() {
    debugPrint('todaycoststotal' + todayCostsTotal.toString());
    if(_sliding == 0) {
      return todayCostsTotal.toString();
    } else  {
      return weekCostsTotal.toString();
    }
  }

  String totalStockCostsRBySlide() {
    if(_sliding == 0) {
      return todayCostsTotalR.toString();
    } else {
      return weekCostsTotalR.toString();
    }
  }

  String totalRefundBySlide() {
    if(_sliding == 0) {
      return todayRefundTotal.toString();
    } else {
      return weekRefundTotal.toString();
    }
  }

  String totalLossBySlide() {
    if(_sliding == 0) {
      return todayLossTotal.toString();
    } else  {
      return weekLossTotal.toString();
    }
  }

  percentBySale() {
    var percent = 0;
    if(_sliding == 0) {
      percent = growthRateDaySale(yestOrdersChart, todayOrdersChart);
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
      return todayTotal.toStringAsFixed(2);
    } else {
      return weeklyTotal.toStringAsFixed(2);
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
    weekLossTotal = 0;
    ystRefundTotal=0;
    lastWeekRefund = 0;
    ystLossTotal = 0;
    lastWeekLoss = 0;



    for(int loopOrd = 0; loopOrd < snapshot2.length; loopOrd++) {

      debugPrint('George sai 0 ' + snapshot2[loopOrd].id.toString());
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
        if(data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'loss_cust'] != null) {
          lastWeekLoss +=  data[sevenDayAgo.subtract(Duration(days: i)).year.toString() + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).month.toString()) + zeroToTen(sevenDayAgo.subtract(Duration(days: i)).day.toString()) + 'loss_cust'];
        }
      }

      debugPrint('testing for ' + weekRefundTotal.toString() + ', ' +  lastWeekRefund.toString()+ ', ' +  lastWeekRefund.toString());

    }
  }


  growthRateDaySale(double yestOrdersChart, List<double> todayOrdersChart) {
    double growthRate = 0;
    double todayTotal = 0;
    for (int i = 0; i < todayOrdersChart.length; i++){
      todayTotal += todayOrdersChart[i];
    }

    if(yestOrdersChart == 0 || todayTotal == 0) {
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

  growthRateDayCost(double yestOrdersChart, double todayTotalCost) {

    double growthRate = 0;
    double todayTotal = todayTotalCost;

    if(yestOrdersChart == 0 || todayTotalCost == 0) {
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

    if(yestOrdersChart == 0 || todayTotalCost == 0) {
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

    if(lastWeekOrdersChart == 0 || todayTotal == 0) {
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

  growthRateWeekRefund(double lastWeekRef, double weekTotalRef) {
    double growthRate = 0;
    double todayTotal = weekTotalRef;

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

  String perTSalText(percentBySale) {
    if(percentBySale == 1001) {
      return '-%  ';
    } else if(percentBySale == 1000) {
      return '-%  ';
    } else {
      return percentBySale.toString() + '% ';
    }
  }

}

enum PaginateBuilderType { listView, gridView, pageView }
