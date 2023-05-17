library paginate_firestore;

import 'dart:math';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/bloc_home_week_buy.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';
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

class BlocProdWeek extends StatefulWidget {

  const BlocProdWeek({
    Key? key,
    required this.isEnglish,
    required this.itemBuilder,
    required this.query,
    required this.initialIndex,
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
    required this.intValIni,
    required void resetState(DateTime resetD),
    required void selectedIntVal(int index),
    required void sortIndex(int data),
    required this.prodsSnap,
  }) :
        _resetState = resetState,
        _selectedIntVal = selectedIntVal,
         _sortIndex = sortIndex,
        super(key: key);

  final int intValIni;
  final bool isEnglish;
  final int initialIndex;
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
  final _sortIndex;
  final prodsSnap;

  /// Use this only if `isLive = false`
  final GetOptions? options;

  /// Use this only if `isLive = true`
  final bool includeMetadataChanges;

  @override
  _BlocProdWeekState createState() => _BlocProdWeekState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _BlocProdWeekState extends State<BlocProdWeek> {
  PaginationCubit? _cubit;
  String currencyUnit = 'MMK';

  bool endOfResult = false;

  List<Text> sortingList = [
    Text("Total sale",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 1.7),),
    Text("Total profit",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 1.7),),
    Text("Total costs",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 1.7),),
    Text("Total quantity",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 1.7),),
  ];

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

  int defaultItems = 12;

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
  String textSetEarn = 'Debt-to-income';
  String textSetProfit = 'Average profit';

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels && !endOfResult) {
        debugPrint('maxxed ');
        Future.delayed(const Duration(milliseconds: 500), () {
          itemPerPage = itemPerPage + defaultItems;
          setState(() {});
        });

      }
    });

    debugPrint('loaded in bloc_home_week');

    cateScIndex = widget.intValIni;
    _sliding = widget.intValIni;
    today = widget.dateTime!;
    _dateTime = today;
    initIndex = widget.initialIndex;
    getCurrency().then((value){
      setState(() {
        currencyUnit = value.toString();
      });
    });

    if(widget.isEnglish == true) {

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
        textSetEarn = 'Debt-to-income';
        textSetProfit = 'Average profit';

      });
    } else {
      setState(() {
        textSetTotalSales = 'စုစုပေါင်း အသားတင် ရောင်းရငွေ';
        textSetTodaySoFar = 'ဒီနေ့အတွင်း';
        textSetStockCosts = 'ဝယ်ယူစရိတ်';
        textSetUnpaid = 'အကြွေးကျန်ငွေ';
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
        textSetEarn = 'အကြွေးရငွေ';
        textSetProfit = 'ပျမ်းမျှအမြတ်ငွေ';
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

  int itemPerPage = 12;
  ScrollController _scrollController = ScrollController();

  Map sortMapByTtlSS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k2]['st'].compareTo(map[k1]['st'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlSR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k1]['st'].compareTo(map[k2]['st'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlPS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k2]['pt'].compareTo(map[k1]['pt'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlPR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k1]['pt'].compareTo(map[k2]['pt'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlBS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k2]['bt'].compareTo(map[k1]['bt'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlBR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k1]['bt'].compareTo(map[k2]['bt'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlQS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k2]['it'].compareTo(map[k1]['it'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByTtlQR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => (map[k1]['it'].compareTo(map[k2]['it'])));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  bool straight = true;
  int ayinSlide = 0;
  double tSale = 0;

  bool firstTime = true;
  double homeBotPadding = 0;

  Widget _buildListView(PaginationLoaded loadedState) {
    var todayProds = {};
    var initProds;

    if(_sliding == 0) {
      if(ayinSlide!=_sliding) {
        ayinList = [];
      }
      ayinSlide = 0;
      for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
        Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;

        if(today.day == data['date'].toDate().day) {
          initProds = data['prods'];
          tSale = 0;

          if(initProds != null && initProds.length > 0) {
            for(int i = 0; i <  initProds.length; i++) {
              var eachMap = initProds.entries.elementAt(i);

              if(eachMap.value['im'] != 0 && eachMap.value['im'] != null
                  || eachMap.value['i1'] != 0 && eachMap.value['i1'] != null
                  || eachMap.value['i2'] != 0 && eachMap.value['i2'] != null) {
                tSale++;
              }
            }

          }
        }
      }
    }

    sortingList = [
      Text(widget.isEnglish? "Total sale": "ရောင်းရငွေ",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 2.2),),
      Text(widget.isEnglish? "Total profit": "အမြတ်ငွေ",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 2.2),),
      Text(widget.isEnglish? "Total costs": "ကုန်ကျငွေ",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 2.2),),
      Text(widget.isEnglish? "Total quantity": "အရေအတွက်",  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 2.2),),
    ];

    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }

    // debugPrint('bloc_fire prod week3 ' + todayProds.entries.elementAt(0).value.toString());
    var listView = SafeArea(
      top: true,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              reverse: widget.reverse,
              controller: _scrollController,
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
                SliverAppBar(
                  // automaticallyImplyLeading: false,
                  title: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(straight) {
                          straight = false;
                        } else {
                          straight = true;
                        }

                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          initProds==null?
                          Expanded(
                            child: Text((widget.isEnglish? 'PRODUCT ': 'ကုန်ပစ္စည်း'), textScaleFactor: 1,
                              style: TextStyle(
                                height: 0.9,
                                letterSpacing: 2,
                                fontWeight: widget.isEnglish? FontWeight.w700: FontWeight.w500,
                                fontSize: 14,color: Colors.grey,
                              ),),
                          ):
                          Expanded(
                            child: Text((widget.isEnglish? 'PRODUCT ': 'ကုန်ပစ္စည်း') + ' (' + tSale.round().toString() + ')', textScaleFactor: 1,
                              style: TextStyle(
                                height: 0.9,
                                letterSpacing: 2,
                                fontWeight: widget.isEnglish? FontWeight.w700: FontWeight.w500,
                                fontSize: 14,color: Colors.grey,
                              ),),
                          ),
                          Text(titleBarText(), textScaleFactor: 1,
                            style: TextStyle(
                              height: 0.9,
                              letterSpacing: 2,
                              fontWeight: widget.isEnglish? FontWeight.w700: FontWeight.w500,
                              fontSize: 14,color: Colors.grey,
                            ),)
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  // floating: true,
                  pinned: true,
                  elevation: 0.5,
                  expandedHeight: 15,
                  bottom: PreferredSize(                       // Add this code
                    preferredSize: Size.fromHeight(-24.0),      // Add this code
                    child: Container(),                           // Add this code
                  ),
                ),
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
                todayProds == null? SliverFillRemaining (
                  child: Center(
                    child: Text('No item found', textScaleFactor: 1, style: TextStyle(fontSize: 15),),
                  ),
                ):
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: widget.prodsSnap,
                    builder: (BuildContext context, prodsSB) {
                      var prodsSnapOut = prodsSB.data != null? prodsSB.data!.data(): null;
                      var prodsSc = prodsSnapOut?['prods'];
                      if(prodsSB.hasData && initProds!=null) {
                        for(int i = 0; i<initProds.length; i++ ) {
                          double ttlM = initProds.entries.elementAt(i).value['sm'] == null? 0: initProds.entries.elementAt(i).value['sm'];
                          double ttl1 = initProds.entries.elementAt(i).value['s1'] == null? 0: initProds.entries.elementAt(i).value['s1'];
                          double ttl2 = initProds.entries.elementAt(i).value['s2'] == null? 0: initProds.entries.elementAt(i).value['s2'];

                          double btlM = initProds.entries.elementAt(i).value['bm'] == null? 0: initProds.entries.elementAt(i).value['bm'];
                          double btl1 = initProds.entries.elementAt(i).value['b1'] == null? 0: initProds.entries.elementAt(i).value['b1'];
                          double btl2 = initProds.entries.elementAt(i).value['b2'] == null? 0: initProds.entries.elementAt(i).value['b2'];

                          double dtlM = initProds.entries.elementAt(i).value['dm'] == null? 0: initProds.entries.elementAt(i).value['dm'].toDouble();
                          double dtl1 = initProds.entries.elementAt(i).value['d1'] == null? 0: initProds.entries.elementAt(i).value['d1'].toDouble();
                          double dtl2 = initProds.entries.elementAt(i).value['d2'] == null? 0: initProds.entries.elementAt(i).value['d2'].toDouble();

                          initProds.entries.elementAt(i).value['st'] = ttlM + ttl1 + ttl2;
                          initProds.entries.elementAt(i).value['bt'] = btlM + btl1 + btl2;
                          initProds.entries.elementAt(i).value['pt'] = (ttlM + ttl1 + ttl2) - (btlM + btl1 + btl2) - (dtlM + dtl1 + dtl2);
                          initProds.entries.elementAt(i).value['it'] = double.parse(totalQtyCal(initProds.entries.elementAt(i).value, prodsSc[initProds.entries.elementAt(i).key]));
                        }

                        if(initIndex == 0) {
                          if(straight) {
                            initProds = sortMapByTtlSS(initProds);
                          } else {
                            initProds = sortMapByTtlSR(initProds);
                          }

                        } else if(initIndex == 1) {
                          if(straight) {
                            initProds = sortMapByTtlPS(initProds);
                          } else {
                            initProds = sortMapByTtlPR(initProds);
                          }
                        } else if(initIndex == 2) {
                          if(straight) {
                            initProds = sortMapByTtlBS(initProds);
                          } else {
                            initProds = sortMapByTtlBR(initProds);
                          }
                        } else {
                          if(straight) {
                            initProds = sortMapByTtlQS(initProds);
                          } else {
                            initProds = sortMapByTtlQR(initProds);
                          }
                        }

                        debugPrint('iteeee ' + itemPerPage.toString() + '  ' + initProds.length.toString());
                        if(itemPerPage >= initProds.length) {
                          endOfResult = true;
                        }

                        for(int i = 0; i<itemPerPage; i++) {
                          if (i >= initProds.length) {
                            break;
                          }
                          todayProds[initProds.entries.elementAt(i).key] = initProds.entries.elementAt(i).value;
                          if(todayProds[initProds.entries.elementAt(i).key]['sm']==null) {
                            todayProds[initProds.entries.elementAt(i).key]['sm'] = 0.0;
                          }
                          if(todayProds[initProds.entries.elementAt(i).key]['s1']==null) {
                            todayProds[initProds.entries.elementAt(i).key]['s1'] = 0.0;
                          }
                          if(todayProds[initProds.entries.elementAt(i).key]['s2']==null) {
                            todayProds[initProds.entries.elementAt(i).key]['s2'] = 0.0;
                          }
                          // if(todayProds[initProds.entries.elementAt(i).key]['sm']==null) {
                          //   todayProds[initProds.entries.elementAt(i).key]['sm'] = 0;
                          // }
                        }

                        stateList = [];
                        if(ayinList.length==0) {
                          for(int i =0; i< initProds.length; i++) {
                            stateList.add([false, false, false, false, false]);
                          }
                          ayinList=stateList;
                        } else {
                          for(int i =0; i< initProds.length-ayinList.length; i++) {
                            ayinList.add([false, false, false, false, false]);
                          }
                        }


                        return SliverList(
                          // Use a delegate to build items as they're scrolled on screen.
                          delegate: SliverChildBuilderDelegate(
                            // The builder function returns a ListTile with a title that
                            // displays the index of the current item.
                                (context, index) {
                              if(index == todayProds.length) {
                                return Padding(
                                    padding: const EdgeInsets.only(bottom: 26.0),
                                    child: !endOfResult?
                                    Container(
                                      child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                                    ):
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Container(
                                              child: Text(
                                                'End of results',
                                                textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)
                                          ),
                                        ),
                                      ],
                                    )
                                );
                              }

                              double turns = 0.0;
                              return Column(
                                children: [
                                  Theme(
                                    data: ThemeData().copyWith(dividerColor: Colors.transparent),
                                    child: ListTileTheme(
                                      contentPadding: EdgeInsets.all(0),
                                      dense: true,
                                      horizontalTitleGap: 0.0,
                                      minLeadingWidth: 0,
                                      child: ExpansionTile(
                                        trailing: Text(
                                          titleSortText(todayProds.entries.elementAt(index).value, prodsSc[todayProds.entries.elementAt(index).key], double.parse(totalDiscCal(todayProds.entries.elementAt(index).value))),
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                          ),
                                          strutStyle: StrutStyle(
                                            height: 1,
                                            // fontSize:,
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 0.0, right: 15.0),
                                        childrenPadding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0.0),
                                        // collapsedBackgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                        // backgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                        onExpansionChanged: (bool expanded) {
                                          onStateChanged(index, 0, expanded);
                                        },
                                        title: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 3.0, right: 10.0),
                                              child: AnimatedRotation(
                                                turns: ayinList[index][0]? 0.250:0,
                                                duration: const Duration(milliseconds: 200),
                                                child: Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  size: 17,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10.0),
                                                child: Text(
                                                  prodsSc[todayProds.entries.elementAt(index).key]==null?'No item': prodsSc[todayProds.entries.elementAt(index).key]['na'].toString(),
                                                  textScaleFactor: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: prodsSc[todayProds.entries.elementAt(index).key]==null?Colors.grey: Colors.black,
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    height: 1.2,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // controlAffinity: ListTileControlAffinity.leading,
                                        children: <Widget>[
                                          prodsSc[todayProds.entries.elementAt(index).key]==null? Container(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Item infromation is missing.',
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ): Column(
                                            children: [
                                              prodsSc[todayProds.entries.elementAt(index).key]['c1']!=0?
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 27.0),
                                                    child: ExpansionTile(
                                                      trailing: Text(
                                                        double.parse(totalSaleCal(todayProds.entries.elementAt(index).value)).toStringAsFixed(2) + ' ' + currencyUnit,
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      tilePadding: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 0.0, right: 15.0),
                                                      childrenPadding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0.0),
                                                      // collapsedBackgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      // backgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      onExpansionChanged: (bool expanded) {
                                                        onStateChanged(index, 1, expanded);
                                                      },
                                                      title: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 3.0, right: 10.0),
                                                            child: AnimatedRotation(
                                                              turns: ayinList[index][1]? 0.250:0,
                                                              duration: const Duration(milliseconds: 200),
                                                              child: Icon(
                                                                Icons.arrow_forward_ios_rounded,
                                                                size: 17,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 10.0),
                                                              child: Text(
                                                                'Total sale',
                                                                textScaleFactor: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // controlAffinity: ListTileControlAffinity.leading,
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Main (' + prodsSc[todayProds.entries.elementAt(index).key]['nm'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['sm']==null?0:todayProds.entries.elementAt(index).value['sm']).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub1 (' + prodsSc[todayProds.entries.elementAt(index).key]['n1'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['s1']==null?0:todayProds.entries.elementAt(index).value['s1']).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        prodsSc[todayProds.entries.elementAt(index).key]['c2']!=0?
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub2 (' + prodsSc[todayProds.entries.elementAt(index).key]['n2'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['s2']==null?0:todayProds.entries.elementAt(index).value['s2']).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):Container(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ):
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Total sale',
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      double.parse(totalSaleCal(todayProds.entries.elementAt(index).value)).toStringAsFixed(2) + ' ' + currencyUnit,
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              double.parse(totalDiscCal(todayProds.entries.elementAt(index).value))!=0 || prodsSc[todayProds.entries.elementAt(index).key]['c1']!=0?
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 27.0),
                                                    child: ExpansionTile(
                                                      trailing: Text(
                                                        double.parse(totalProfitCal(todayProds.entries.elementAt(index).value, double.parse(totalDiscCal(todayProds.entries.elementAt(index).value)))).toStringAsFixed(2) + ' ' + currencyUnit,
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      tilePadding: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 0.0, right: 15.0),
                                                      childrenPadding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0.0),
                                                      // collapsedBackgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      // backgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      onExpansionChanged: (bool expanded) {
                                                        onStateChanged(index, 2, expanded);
                                                      },
                                                      title: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 3.0, right: 10.0),
                                                            child: AnimatedRotation(
                                                              turns: ayinList[index][2]? 0.250:0,
                                                              duration: const Duration(milliseconds: 200),
                                                              child: Icon(
                                                                Icons.arrow_forward_ios_rounded,
                                                                size: 17,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 10.0),
                                                              child: Text(
                                                                'Total profit',
                                                                textScaleFactor: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // controlAffinity: ListTileControlAffinity.leading,
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Main (' + prodsSc[todayProds.entries.elementAt(index).key]['nm'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                // 'MMSP ' + todayProds.entries.elementAt(index).value['sm'].toDouble().toString(),
                                                                ((todayProds.entries.elementAt(index).value['sm']==null?0:todayProds.entries.elementAt(index).value['sm'].toDouble()) - (todayProds.entries.elementAt(index).value['bm']==null?0:todayProds.entries.elementAt(index).value['bm'].toDouble())).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        prodsSc[todayProds.entries.elementAt(index).key]['c1']!=0?
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub1 (' + prodsSc[todayProds.entries.elementAt(index).key]['n1'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                ((todayProds.entries.elementAt(index).value["s1"]==null? 0: todayProds.entries.elementAt(index).value["s1"]) - (todayProds.entries.elementAt(index).value["b1"]==null? 0:todayProds.entries.elementAt(index).value["b1"])).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):Container(),
                                                        prodsSc[todayProds.entries.elementAt(index).key]['c2']!=0?
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub2 (' + prodsSc[todayProds.entries.elementAt(index).key]['n2'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                ((todayProds.entries.elementAt(index).value['s2']==null? 0:todayProds.entries.elementAt(index).value['s2']) - (todayProds.entries.elementAt(index).value['b2']==null?0:todayProds.entries.elementAt(index).value['b2'])).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):Container(),
                                                        double.parse(totalDiscCal(todayProds.entries.elementAt(index).value))!=0?
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Padding(
                                                                padding: const EdgeInsets.only(right: 10.0),
                                                                child: Text(
                                                                  'Discounts',
                                                                  textScaleFactor: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    color: Colors.black,
                                                                  ),
                                                                  strutStyle: StrutStyle(
                                                                    height: 1,
                                                                    // fontSize:,
                                                                    forceStrutHeight: true,
                                                                  ),
                                                                ),
                                                              ),
                                                              trailing: Text(
                                                                '- ' + double.parse(totalDiscCal(todayProds.entries.elementAt(index).value)).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):Container(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ):
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Total profit',
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      double.parse(totalProfitCal(todayProds.entries.elementAt(index).value, double.parse(totalDiscCal(todayProds.entries.elementAt(index).value)))).toStringAsFixed(2) + ' ' + currencyUnit,
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              prodsSc[todayProds.entries.elementAt(index).key]['c1']!=0?
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 27.0),
                                                    child: ExpansionTile(
                                                      trailing: Text(
                                                        double.parse(totalBuyCal(todayProds.entries.elementAt(index).value)).toStringAsFixed(2) + ' ' + currencyUnit,
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      tilePadding: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 0.0, right: 15.0),
                                                      childrenPadding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0.0),
                                                      // collapsedBackgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      // backgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      onExpansionChanged: (bool expanded) {
                                                        onStateChanged(index, 3, expanded);
                                                      },
                                                      title: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 3.0, right: 10.0),
                                                            child: AnimatedRotation(
                                                              turns: ayinList[index][3]? 0.250:0,
                                                              duration: const Duration(milliseconds: 200),
                                                              child: Icon(
                                                                Icons.arrow_forward_ios_rounded,
                                                                size: 17,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 10.0),
                                                              child: Text(
                                                                'Total costs',
                                                                textScaleFactor: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // controlAffinity: ListTileControlAffinity.leading,
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Main (' + prodsSc[todayProds.entries.elementAt(index).key]['nm'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['bm']==null?0:todayProds.entries.elementAt(index).value['bm']).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub1 (' + prodsSc[todayProds.entries.elementAt(index).key]['n1'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['b1']==null? 0: todayProds.entries.elementAt(index).value['b1']).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        prodsSc[todayProds.entries.elementAt(index).key]['c2']!=0?
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub2 (' + prodsSc[todayProds.entries.elementAt(index).key]['n2'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['b2']==null?0:todayProds.entries.elementAt(index).value['b2']).toStringAsFixed(2) + ' ' + currencyUnit,
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):Container(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ):
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Total costs',
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      double.parse(totalBuyCal(todayProds.entries.elementAt(index).value)).toStringAsFixed(2) + ' ' + currencyUnit,
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              prodsSc[todayProds.entries.elementAt(index).key]['c1']!=0?
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 27.0),
                                                    child: ExpansionTile(
                                                      trailing: Text(
                                                        totalQtyCal(todayProds.entries.elementAt(index).value, prodsSc[todayProds.entries.elementAt(index).key]) + ' ' + prodsSc[todayProds.entries.elementAt(index).key]['nm'],
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      tilePadding: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 0.0, right: 15.0),
                                                      childrenPadding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0.0),
                                                      // collapsedBackgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      // backgroundColor: index%2 == 1? Colors.grey.withOpacity(0.1): Colors.white,
                                                      onExpansionChanged: (bool expanded) {
                                                        onStateChanged(index, 4, expanded);
                                                      },
                                                      title: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 3.0, right: 10.0),
                                                            child: AnimatedRotation(
                                                              turns: ayinList[index][4]? 0.250:0,
                                                              duration: const Duration(milliseconds: 200),
                                                              child: Icon(
                                                                Icons.arrow_forward_ios_rounded,
                                                                size: 17,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 10.0),
                                                              child: Text(
                                                                'Total quantity',
                                                                textScaleFactor: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // controlAffinity: ListTileControlAffinity.leading,
                                                      children: <Widget>[
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Main (' + prodsSc[todayProds.entries.elementAt(index).key]['nm'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['im']==null?0:todayProds.entries.elementAt(index).value['im']).toInt().toString() + ' ' + prodsSc[todayProds.entries.elementAt(index).key]['nm'],
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub1 (' + prodsSc[todayProds.entries.elementAt(index).key]['n1'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['i1'] == null? 0: todayProds.entries.elementAt(index).value['i1']).toInt().toString() + ' ' + prodsSc[todayProds.entries.elementAt(index).key]['n1'],
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        prodsSc[todayProds.entries.elementAt(index).key]['c2']!=0?
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 42.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(
                                                                                0.6),
                                                                            width: 0.5)
                                                                    )),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                              title: Row(
                                                                children: [
                                                                  Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                                      child: Text(
                                                                        'Sub2 (' + prodsSc[todayProds.entries.elementAt(index).key]['n2'] + ')',
                                                                        textScaleFactor: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          color: Colors.black,
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Text(
                                                                (todayProds.entries.elementAt(index).value['i2']==null?0:todayProds.entries.elementAt(index).value['i2']).toInt().toString() + ' ' + prodsSc[todayProds.entries.elementAt(index).key]['n2'],
                                                                textScaleFactor: 1,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  color: Colors.black,
                                                                ),
                                                                strutStyle: StrutStyle(
                                                                  height: 1,
                                                                  // fontSize:,
                                                                  forceStrutHeight: true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):Container(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ):
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 42.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(
                                                                      0.6),
                                                                  width: 0.5)
                                                          )),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding: EdgeInsets.only(left: 42, right: 15),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Total quantity',
                                                        textScaleFactor: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: 1,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      double.parse(totalQtyCal(todayProds.entries.elementAt(index).value, prodsSc[todayProds.entries.elementAt(index).key])).toInt().toString() + ' ' + prodsSc[todayProds.entries.elementAt(index).key]['nm'],
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )

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
                                                  color: initProds.length-1 == index? Colors.transparent: Colors.grey.withOpacity(0.5),
                                                  width: 0.5)
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            },
                            // Builds 1000 ListTiles
                            childCount: todayProds.length + 1,
                          ),
                        );
                      }
                      return SliverFillRemaining (
                        child: Center(
                          child: Text('No item found', textScaleFactor: 1, style: TextStyle(fontSize: 15),),
                        ),
                      );
                    }
                ),
                // SliverAppBar(
                //   toolbarHeight: 30,
                //   elevation: 0,
                //   backgroundColor: Colors.white,
                //   // Provide a standard title.
                //   // Allows the user to reveal the app bar if they begin scrolling
                //   // back up the list of items.
                //   floating: true,
                //   flexibleSpace: !endOfResult?
                //   Container(
                //     child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                //   ):
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(top: 5.0),
                //         child: Container(
                //             child: Text(
                //               'End of results',
                //               textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? 0 + 20: homeBotPadding),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                  ),

                  height: 81,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ButtonTheme(
                                  splashColor: Colors.transparent,
                                  height: 50,
                                  child: CustomFlatButton(
                                    color: AppTheme.buttonColor2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: AppTheme.buttonColor2,
                                      ),
                                    ),
                                    onPressed: () async {
                                      _openSimpleItemPicker(OneContext().context, sortingList);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 3.0),
                                      child: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Icon(
                                                  Icons.sort_rounded,
                                                  size: 24,
                                                ),
                                              ),
                                              Text(
                                                  sortBtnText(), textScaleFactor: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing:-0.1
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    height: widget.isEnglish? 1.4: 1.6,
                                                    forceStrutHeight: true,
                                                  )

                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ),
          Container(
            color: Colors.white,
            // height: MediaQuery.of(context).viewInsets.bottom,
            // height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
            height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
          ),
        ],
      ),
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

  List<List<bool>> ayinList = [];

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

  int initIndex = 0;

  _openSimpleItemPicker(context, List<Text> items) {
    BottomPicker(
      // displayButtonIcon: false,
      buttonText: !widget.isEnglish? 'စဉ်ပါ': 'Done',
      displayButtonIcon: false,
      buttonSingleColor: Colors.grey,
      dismissable: true,
      items: items,
      title: widget.isEnglish? 'Sort items by': 'ကုန်ပစ္စည်း စဉ်ရန်',
      selectedItemIndex: initIndex,
      buttonTextStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 15),
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      onSubmit: (index) {
        debugPrint('onSubmit id -> ' + index.toString());
        setState(() {
          initIndex = index;
          straight = true;
        });
        widget._sortIndex(index);
      },
      onChange: (index) {
        debugPrint('changing id -> ' + index.toString());
      },
    ).show(context);
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
    return ValueKey<String>(valKTog.toString() + 'b');
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


  resetState(DateTime resetD) {
    widget._resetState(resetD);
  }
  
  sortIndex(int data) {
    widget._sortIndex(data);
  }

  selectedIntVal(int index) {
    widget._selectedIntVal(index);
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
                CustomFlatButton(
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
                    child: CustomFlatButton(
                      // minWidth: 0,
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
                    child: CustomFlatButton(
                      // minWidth: 0,
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
                    child: CustomFlatButton(
                      // minWidth: 0,
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
                    child: CustomFlatButton(
                      // minWidth: 0,
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
    //             CustomFlatButton(
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
    //                 child: CustomFlatButton(
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
    //                 child: CustomFlatButton(
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
    //                 child: CustomFlatButton(
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
    //                 child: CustomFlatButton(
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

  bool isExpanded = false;
  List<List<bool>> stateList = [];

  void onStateChanged(index, inner, expanded) {
    debugPrint('stating ' + ayinList.toString());
    if(inner!= 0) {
      setState(() {
        // for(int i = 0; i<stateList.length; i++) {
        //   stateList[i] = false;
        // }
        if(expanded) {
          ayinList[index][inner] = true;
        }
        else {
          ayinList[index][inner] = false;
        }
      });
    } else {
      setState(() {
        // for(int i = 0; i<stateList.length; i++) {
        //   stateList[i] = false;
        // }
        if(expanded) {
          ayinList[index] = [true, false, false, false, false];
        }
        else {
          ayinList[index] = [false, false, false, false, false];
        }
      });

    }
  }

  void onStateChangedInner(int index, int i, bool expanded) {
    setState(() {
      // for(int i = 0; i<stateList.length; i++) {
      //   stateList[i] = false;
      // }
      if(expanded) {
        ayinList[index][i] = true;
      }
      else {
        ayinList[index][i] = false;
      }
    });
  }

  String totalSaleCal(value) {
    debugPrint("vvvv " + value.toString());
    double salem = 0;
    double sale1 = 0;
    double sale2 = 0;
    if(value['sm']==null) {
      salem = 0;
    } else {
      salem = value['sm'];
    }
    if(value['s1']==null) {
      sale1 = 0;
    } else {
      sale1 = value['s1'];
    }
    if(value['s2']==null) {
      sale2 = 0;
    } else {
      sale2 = value['s2'];
    }
    return (salem + sale1 + sale2).toString();
  }

  totalProfitCal(value, ttlDisc) {
    debugPrint("vvvv " + value.toString());
    double salem = 0;
    double sale1 = 0;
    double sale2 = 0;
    double buym = 0;
    double buy1 = 0;
    double buy2 = 0;
    if(value['sm']==null) {
      salem = 0;
    } else {
      salem = value['sm'];
    }
    if(value['s1']==null) {
      sale1 = 0;
    } else {
      sale1 = value['s1'];
    }
    if(value['s2']==null) {
      sale2 = 0;
    } else {
      sale2 = value['s2'];
    }


    if(value['bm']==null) {
      buym = 0;
    } else {
      buym = value['bm'];
    }
    if(value['b1']==null) {
      buy1 = 0;
    } else {
      buy1 = value['b1'];
    }
    if(value['b2']==null) {
      buy2 = 0;
    } else {
      buy2 = value['b2'];
    }
    return (((salem-buym) + (sale1-buy1) + (sale2-buy2)) - ttlDisc).toString();
  }

  totalBuyCal(value) {
    debugPrint("vvvv " + value.toString());
    double salem = 0;
    double sale1 = 0;
    double sale2 = 0;
    if(value['bm']==null) {
      salem = 0;
    } else {
      salem = value['bm'];
    }
    if(value['b1']==null) {
      sale1 = 0;
    } else {
      sale1 = value['b1'];
    }
    if(value['b2']==null) {
      sale2 = 0;
    } else {
      sale2 = value['b2'];
    }
    return (salem + sale1 + sale2).toString();
  }

  totalDiscCal(value) {
    debugPrint("vvvv " + value.toString());
    double salem = 0;
    double sale1 = 0;
    double sale2 = 0;
    if(value['dm']==null) {
      salem = 0;
    } else {
      salem = value['dm'].toDouble();
    }
    if(value['d1']==null) {
      sale1 = 0;
    } else {
      sale1 = value['d1'].toDouble();
    }
    if(value['d2']==null) {
      sale2 = 0;
    } else {
      sale2 = value['d2'].toDouble();
    }
    return (salem + sale1 + sale2).toString();
  }

  totalQtyCal(value, prodsSc) {
    double salem = 0;
    double sale1 = 0;
    double sale2 = 0;
    // debugPrint(prodsSc['na'] + ' ' + value['im'].toString() + ' ' + value['i1'].toString() + ' ' + value['i2'].toString() + ' ' + prodsSc['c1'].toString() + ' ' + prodsSc['c2'].toString());
    if(prodsSc == null) {
      return value['im']!=null? value['im'].toString():'0';
    }
    if(value['im']==null) {
      salem = 0;
    } else {
      salem = value['im'];
    }
    if(value['i1']==null || prodsSc['c1']==null || prodsSc['c1']==0) {
      sale1 = 0;
    } else {
      sale1 = value['i1']/prodsSc['c1'];
    }
    if(value['i2']==null || prodsSc['c1']==null || prodsSc['c2']==null || prodsSc['c1']==0 || prodsSc['c2']==0) {
      sale2 = 0;
    } else {
      sale2 = (value['i2']/prodsSc['c2'])/prodsSc['c1'];
    }
    return (salem + sale1 + sale2).toString();
  }

  String titleSortText(value, prodsSc, ttlDisc) {
    if(initIndex == 0) {
      return double.parse(totalSaleCal(value)).toStringAsFixed(2) + ' ' + currencyUnit;
    } else if(initIndex == 1) {
      return double.parse(totalProfitCal(value, ttlDisc)).toStringAsFixed(2) + ' ' + currencyUnit;
    } else if(initIndex == 2) {
      return double.parse(totalBuyCal(value)).toStringAsFixed(2) + ' ' + currencyUnit;
    } else {
      double ttlQty = double.parse(totalQtyCal(value, prodsSc));
      if(isInteger(ttlQty)) {
        return ttlQty.toInt().toString() + ' ' + prodsSc['nm'];
      } else {
        return ttlQty.toStringAsFixed(2) + ' ' + prodsSc['nm'];
      }

    }

  }

  String sortBtnText() {
    if(initIndex == 0) {
      if(!widget.isEnglish) {
        return 'ရောင်းရငွေဖြင့် စဉ်ပါ';
      }
      return 'sort by total sale';
    } else if(initIndex == 1) {
      if(!widget.isEnglish) {
        return 'အမြတ်ငွေဖြင့် စဉ်ပါ';
      }
      return 'Sort by total profit';
    } else if(initIndex == 2) {
      if(!widget.isEnglish) {
        return 'ကုန်ကျငွေဖြင့် စဉ်ပါ';
      }
      return 'Sort by total cost';
    } else {
      if(!widget.isEnglish) {
        return 'အရေတွက်ဖြင့် စဉ်ပါ';
      }
      return 'Sort by total quantity';
    }
  }

  String titleBarText() {
    if(initIndex == 0) {
      if(!widget.isEnglish) {
        return 'စုစုပေါင်း ရောင်းရငွေ';
      }
      return 'TOTAL SALE';
    } else if(initIndex == 1) {
      if(!widget.isEnglish) {
        return 'စုစုပေါင်း အမြတ်ငွေ';
      }
      return 'TOTAL PROFIT';
    } else if(initIndex == 2) {
      if(!widget.isEnglish) {
        return 'စုစုပေါင်း ကုန်ကျငွေ';
      }
      return 'TOTAL COST';
    } else {
      if(!widget.isEnglish) {
        return 'စုစုပေါင်း အရေတွက်';
      }
      return 'TOTAL QTY';
    }
  }

  bool isInteger(num value) =>
      value is int || value == value.roundToDouble();

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

}

enum PaginateBuilderType { listView, gridView, pageView }
