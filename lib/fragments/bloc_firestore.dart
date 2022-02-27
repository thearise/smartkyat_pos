library paginate_firestore;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class BlocFirestore extends StatefulWidget {
  const BlocFirestore({
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
  }) : super(key: key);

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

  /// Use this only if `isLive = false`
  final GetOptions? options;

  /// Use this only if `isLive = true`
  final bool includeMetadataChanges;

  @override
  _BlocFirestoreState createState() => _BlocFirestoreState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _BlocFirestoreState extends State<BlocFirestore> {
  PaginationCubit? _cubit;
  String currencyUnit = 'MMK';
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

          if (loadedState.documentSnapshots.isEmpty) {
            return widget.onEmpty;
          }
          return widget.itemBuilderType == PaginateBuilderType.listView
              ? _buildListView(loadedState)
              : widget.itemBuilderType == PaginateBuilderType.gridView
                  ? _buildGridView(loadedState)
                  : _buildShweView(loadedState);
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

  @override
  void initState() {
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
    super.initState();
  }

  Widget _buildGridView(PaginationLoaded loadedState) {
    var gridView = CustomScrollView(
      reverse: widget.reverse,
      controller: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      slivers: [
        if (widget.header != null) widget.header!,
        SliverPadding(
          padding: widget.padding,
          sliver: SliverGrid(
            gridDelegate: widget.gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= loadedState.documentSnapshots.length) {
                  _cubit!.fetchPaginatedList();
                  return widget.bottomLoader;
                }
                return widget.itemBuilder(
                  context,
                  loadedState.documentSnapshots,
                  index,
                );
              },
              childCount: loadedState.hasReachedEnd
                  ? loadedState.documentSnapshots.length
                  : loadedState.documentSnapshots.length + 1,
            ),
          ),
        ),
        if (widget.footer != null) widget.footer!,
      ],
    );

    if (widget.listeners != null && widget.listeners!.isNotEmpty) {
      return MultiProvider(
        providers: widget.listeners!
            .map((_listener) => ChangeNotifierProvider(
                  create: (context) => _listener,
                ))
            .toList(),
        child: gridView,
      );
    }

    return gridView;
  }

  var sectionList3;

  Widget _buildListView(PaginationLoaded loadedState) {
    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      // print('bloc_fire data ' + data.toString());
    }

    int cateScIndex = 0;

    var sections = List<ExampleSection>.empty(growable: true);
    int docInc = 0;
    print('HHHEEEE' + loadedState.documentSnapshots.length.toString() + ' ');
    loadedState.documentSnapshots.map((document) async {

      // List<String> dailyOrders = document['daily_order'].cast<String>();
      List<String> dailyOrders = [];
      for(String str in document['daily_order']) {
        if(cateScIndex == 2) {
          if(str.split('^')[4] == 'PART' || str.split('^')[4] == 'TRUE') {
            dailyOrders.add(str);
          }
        } else if(cateScIndex == 1) {
          if(str.split('^')[5] != '0.0') {
            dailyOrders.add(str);
          }
        } else if(cateScIndex == 3) {
          if(str.split('^')[5] == '0.0') {
            dailyOrders.add(str);
          }
        } else if(cateScIndex == 0) {
          dailyOrders.add(str);
        }

      }
      if(docInc>0) {
        Map<String,dynamic> dataLow = loadedState.documentSnapshots[docInc-1].data()! as Map< String, dynamic>;
        List<String> dataLowDailyOrder = [];
        for(String str in dataLow['daily_order']) {
          if(cateScIndex == 2) {
            if(str.split('^')[4] == 'PART' || str.split('^')[4] == 'TRUE') {
              dataLowDailyOrder.add(str);
            }
          } else if(cateScIndex == 1) {
            if(str.split('^')[5] != '0.0') {
              dataLowDailyOrder.add(str);
            }
          } else if(cateScIndex == 3) {
            if(str.split('^')[5] == '0.0') {
              dataLowDailyOrder.add(str);
            }
          } else if(cateScIndex == 0) {
            dataLowDailyOrder.add(str);
          }

        }


        print('DATA LOW ' + dataLow['date'].toDate().toString());
        if( document['date'].toDate().year.toString() + document['date'].toDate().month.toString() + document['date'].toDate().day.toString()
            ==
            dataLow['date'].toDate().year.toString() + dataLow['date'].toDate().month.toString() + dataLow['date'].toDate().day.toString()
        ) {
          var section = ExampleSection()
            ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
          // ..items = List.generate(int.parse(document['length']), (index) => document.id)
          //   ..items = listCreation(document.id, document['data'], document).cast<String>()

          //   ..items = document['daily_order'].cast<String>()


          // ..items = sortList(changeData(dataLow['daily_order'].cast<String>(), snapshot2)) + sortList(changeData(document['daily_order'].cast<String>(), snapshot2))
            ..items = sortList(changeDataNew(dataLowDailyOrder.cast<String>()) + changeDataNew(dailyOrders.cast<String>()))
          // ..items = orderItems(document.id)
            ..expanded = true;
          // sections.add(section);
          sections[sections.length-1] = section;
        } else {
          // print('herre ' + document.id);
          var section = ExampleSection()
            ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
          // ..items = List.generate(int.parse(document['length']), (index) => document.id)
          //   ..items = listCreation(document.id, document['data'], document).cast<String>()

          //   ..items = document['daily_order'].cast<String>()


            ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
          // ..items = orderItems(document.id)
            ..expanded = true;
          sections.add(section);
        }
      } else {
        // print('herre ' + document.id);
        var section = ExampleSection()
          ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
        // ..items = List.generate(int.parse(document['length']), (index) => document.id)
        //   ..items = listCreation(document.id, document['data'], document).cast<String>()

        //   ..items = document['daily_order'].cast<String>()


          ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
        // ..items = orderItems(document.id)
          ..expanded = true;
        sections.add(section);
      }



      docInc++;
    }).toList();
    sectionList3 = sections;

    var listView = CustomScrollView(
      reverse: widget.reverse,
      controller: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      slivers: [
        if (widget.header != null) widget.header!,
        SliverExpandableList(
          builder: SliverExpandableChildDelegate(
            sectionList: sectionList3,
            headerBuilder: _buildHeader,
            itemBuilder: (context, sectionIndex, itemIndex, index) {
              String item = sectionList3[sectionIndex].items[itemIndex];
              int length = sectionList3[sectionIndex].items.length;

              if(itemIndex == length-1) {
                return GestureDetector(
                  onTap: () async {
                    // closeDrawerFrom();
                    // // print(item.split('^')[1]);
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => OrderInfoSub(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, closeCartBtn: closeCartFrom, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), openCartBtn: openCartFrom,)),
                    // );
                    // openDrawerFrom();
                  },
                  child: Stack(
                    alignment: Alignment.center,

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.lightBgColor,
                              border: Border(
                                bottom: BorderSide(
                                    color: AppTheme.skBorderColor2,
                                    width: 1.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('#' + item.split('^')[1],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 1.0),
                                            child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                                          ),
                                          SizedBox(width: 4),
                                          Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
                                      //   child: Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2)),
                                      // ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Text(item.split('^')[3].split('&')[0],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.3,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    if(item.split('^')[5] == '0.0')
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeBgSuccess,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                            child: Text('Paid',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeFgDangerLight,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                            child: Text('Partially paid',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppTheme.badgeFgDanger
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeFgDanger,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                            child: Text('Unpaid',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if(item.split('^')[4] == 'TRUE')
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeBgSecond,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                            child: Text('Refunded',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    if(item.split('^')[4] == 'PART')
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeBgSecondLight,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                            child: Text('Partially refunded',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppTheme.badgeBgSecond
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                                fontSize: 15,fontWeight: FontWeight.w500,
                              )),
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors
                                      .blueGrey
                                      .withOpacity(
                                      0.8),
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
              return GestureDetector(
                onTap: () async {
                  // closeDrawerFrom();
                  // print('Items'+item);
                  // await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => OrderInfoSub(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, closeCartBtn: closeCartFrom, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), openCartBtn: openCartFrom,)),
                  // );
                  // openDrawerFrom();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppTheme.lightBgColor,
                            border: Border(
                              bottom: BorderSide(
                                  color: AppTheme.skBorderColor2,
                                  width: 1.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('#' + item.split('^')[1],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 1.0),
                                          child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                                        ),
                                        SizedBox(width: 4),
                                        Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Text(item.split('^')[3].split('&')[0], style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                          strutStyle: StrutStyle(
                                            height: 1.3,
                                            // fontSize:,
                                            forceStrutHeight: true,
                                          ),

                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  if(item.split('^')[5] == '0.0')
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Container(
                                        height: 21,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: AppTheme.badgeBgSuccess,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                          child: Text('Paid',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Container(
                                        height: 21,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: AppTheme.badgeFgDangerLight,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                          child: Text('Partially paid',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.badgeFgDanger
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Container(
                                        height: 21,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: AppTheme.badgeFgDanger,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                          child: Text('Unpaid',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(item.split('^')[4] == 'TRUE')
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 21,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: AppTheme.badgeBgSecond,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                          child: Text('Refunded',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  if(item.split('^')[4] == 'PART')
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 21,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: AppTheme.badgeBgSecondLight,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                          child: Text('Partially refunded',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.badgeBgSecond
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Icon(
                                Icons
                                    .arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors
                                    .blueGrey
                                    .withOpacity(
                                    0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );

              // return Container(
              //   child: Text(item)
              // );
            },
          ),
        ),
        // SliverPadding(
        //   padding: widget.padding,
        //   sliver: SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //       (context, index) {
        //         final itemIndex = index ~/ 2;
        //         if (index.isEven) {
        //           if (itemIndex >= loadedState.documentSnapshots.length) {
        //             _cubit!.fetchPaginatedList();
        //             return widget.bottomLoader;
        //           }
        //           return widget.itemBuilder(
        //             context,
        //             loadedState.documentSnapshots,
        //             itemIndex,
        //           );
        //         }
        //         return widget.separator;
        //       },
        //       semanticIndexCallback: (widget, localIndex) {
        //         if (localIndex.isEven) {
        //           return localIndex ~/ 2;
        //         }
        //         // ignore: avoid_returning_null
        //         return null;
        //       },
        //       childCount: max(
        //           0,
        //           (loadedState.hasReachedEnd
        //                       ? loadedState.documentSnapshots.length
        //                       : loadedState.documentSnapshots.length + 1) *
        //                   2 -
        //               1),
        //     ),
        //   ),
        // ),
        if (widget.footer != null) widget.footer!,
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

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList3[sectionIndex];
    // print('section check '+ sectionList3[sectionIndex].items.length.toString());
    if(sectionList3[sectionIndex].items.length == 0) {
      return Container();
    }
    return InkWell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
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
                        // "TODAY",
                        // checkTest(section.header),
                        covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            // "#30",
                            '#' + sectionList3[sectionIndex].items.length.toString(),
                            // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                            style: TextStyle(
                              height: 0.8,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
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

  covertToDayNum(String input) {
    if(input[0]=='0') {
      return input[1];
    } else {
      return input;
    }
  }

  convertToHour(String input){
    switch (input.substring(8,10)) {
      case '00':
        return '12';
        break;
      case '01':
        return '1';
        break;
      case '02':
        return '2';
        break;
      case '03':
        return '3';
        break;
      case '04':
        return '4';
        break;
      case '05':
        return '5';
        break;
      case '06':
        return '6';
        break;
      case '07':
        return '7';
        break;
      case '08':
        return '8';
        break;
      case '09':
        return '9';
        break;
      case '10':
        return '10';
        break;
      case '11':
        return '11';
        break;
      case '12':
        return '12';
        break;
      case '13':
        return '1';
        break;
      case '14':
        return '2';
        break;
      case '15':
        return '3';
        break;
      case '16':
        return '4';
        break;
      case '17':
        return '5';
        break;
      case '18':
        return '6';
        break;
      case '19':
        return '7';
        break;
      case '20':
        return '8';
        break;
      case '21':
        return '9';
        break;
      case '22':
        return '10';
        break;
      case '23':
        return '11';
        break;
    }
  }

  convertToDate(String input) {
    switch (input.substring(4,6)) {
      case '01':
        return 'JANUARY';
        break;
      case '02':
        return 'FEBRUARY';
        break;
      case '03':
        return 'MARCH';
        break;
      case '04':
        return 'APRIL';
        break;
      case '05':
        return 'MAY';
        break;
      case '06':
        return 'JUN';
        break;
      case '07':
        return 'JULY';
        break;
      case '08':
        return 'AUGUST';
        break;
      case '09':
        return 'SEPTEMBER';
        break;
      case '10':
        return 'OCTOBER';
        break;
      case '11':
        return 'NOVEMBER';
        break;
      case '12':
        return 'DECEMBER';
        break;
    }
  }

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  sortList(list) {
    var dlist = list;
    dlist.sort();
    var newList = List.from(dlist.reversed);
    // dlist.sort((a, b) => b.compareTo(a));
    return newList.cast<String>();
    // list.sort(alphabetic('name'));
  }

  changeDataNew(list) {
    for (var i = 0; i < list.length; i++) {
      if(list[i].split('^')[3].contains('<>')) {
        if(list[i].split('^')[3].split('<>')[1] == 'name') {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              'No customer' +
              '&' +
              list[i].split('^')[3].split('<>')[0] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6]
          ;
        } else {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              list[i].split('^')[3].split('<>')[1] +
              '&' +
              list[i].split('^')[3].split('<>')[0] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6]
          ;
        }

      } else {
        list[i] = list[i].split('^')[0] +
            '^' +
            list[i].split('^')[1] +
            '^' +
            list[i].split('^')[2] +
            '^' +
            'Check in new version' +
            '&' +
            list[i].split('^')[3] +
            '^' +
            list[i].split('^')[4] +
            '^' +
            list[i].split('^')[5] +
            '^' +
            list[i].split('^')[6]
        ;
      }

    }

    // print('changeData ' + snpsht.da);
    return list;
  }

  convertToAMPM(String input){
    switch (input.substring(8,10)) {
      case '00':
        return 'AM';
        break;
      case '01':
        return 'AM';
        break;
      case '02':
        return 'AM';
        break;
      case '03':
        return 'AM';
        break;
      case '04':
        return 'AM';
        break;
      case '05':
        return 'AM';
        break;
      case '06':
        return 'AM';
        break;
      case '07':
        return 'AM';
        break;
      case '08':
        return 'AM';
        break;
      case '09':
        return 'AM';
        break;
      case '10':
        return 'AM';
        break;
      case '11':
        return 'AM';
        break;
      case '12':
        return 'PM';
        break;
      case '13':
        return 'PM';
        break;
      case '14':
        return 'PM';
        break;
      case '15':
        return 'PM';
        break;
      case '16':
        return 'PM';
        break;
      case '17':
        return 'PM';
        break;
      case '18':
        return 'PM';
        break;
      case '19':
        return 'PM';
        break;
      case '20':
        return 'PM';
        break;
      case '21':
        return 'PM';
        break;
      case '22':
        return 'PM';
        break;
      case '23':
        return 'PM';
        break;
    }
  }

  Widget _buildShweView(PaginationLoaded loadedState) {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      scrollDirection: Axis.vertical,
      itemCount: max(
          0,
          (loadedState.hasReachedEnd
              ? loadedState.documentSnapshots.length
              : loadedState.documentSnapshots.length + 1) *
              2 -
              1),
      itemBuilder: (context, index) {
        final itemIndex = index ~/ 2;
        if (index.isEven) {
          if (itemIndex >= loadedState.documentSnapshots.length) {
            _cubit!.fetchPaginatedList();
            return widget.bottomLoader;
          }
          return widget.itemBuilder(
            context,
            loadedState.documentSnapshots,
            itemIndex,
          );
        }
        return widget.separator;
      },
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

  Widget _buildPageView(PaginationLoaded loadedState) {
    var pageView = Padding(
      padding: widget.padding,
      child: PageView.custom(
        reverse: widget.reverse,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        controller: widget.pageController,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        onPageChanged: widget.onPageChanged,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= loadedState.documentSnapshots.length) {
              _cubit!.fetchPaginatedList();
              return widget.bottomLoader;
            }
            return widget.itemBuilder(
              context,
              loadedState.documentSnapshots,
              index,
            );
          },
          childCount: loadedState.hasReachedEnd
              ? loadedState.documentSnapshots.length
              : loadedState.documentSnapshots.length + 1,
        ),
      ),
    );

    if (widget.listeners != null && widget.listeners!.isNotEmpty) {
      return MultiProvider(
        providers: widget.listeners!
            .map((_listener) => ChangeNotifierProvider(
                  create: (context) => _listener,
                ))
            .toList(),
        child: pageView,
      );
    }

    return pageView;
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }
}

enum PaginateBuilderType { listView, gridView, pageView }
