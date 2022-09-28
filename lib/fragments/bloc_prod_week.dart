library paginate_firestore;

import 'dart:math';

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
    required this.prodsSnap,
  }) :
        _resetState = resetState,
        _selectedIntVal = selectedIntVal,
        super(key: key);

  final int intValIni;
  final bool isEnglish;
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

  @override
  void initState() {
    debugPrint('loaded in bloc_home_week');
    today = widget.dateTime!;
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
    var todayProds;
    debugPrint('bloc_fire prod week0 ' + today.toString());
    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      debugPrint('bloc_fire prod week1 ' + data['date'].toDate().toString());
      debugPrint('bloc_fire prod week2 ' + data['prods'].toString());
      if(today.day == data['date'].toDate().day) {
        todayProds = data['prods'];
      }
    }
    // debugPrint('bloc_fire prod week3 ' + todayProds.entries.elementAt(0).value.toString());

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
        SliverAppBar(
          // automaticallyImplyLeading: false,
          title: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Text('PRODUCT', textScaleFactor: 1,
                    style: TextStyle(
                      height: 0.9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,color: Colors.grey,
                    ),),
                ),
                Text('TOTAL SALE', textScaleFactor: 1,
                  style: TextStyle(
                    height: 0.9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,color: Colors.grey,
                  ),)
              ],
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
            if(prodsSB.hasData) {

              for(int i =0; i< todayProds.length; i++) {
                stateList.add([false, false, false, false, false]);
              }

              return SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                      (context, index) {
                        // return Container(
                        //   color: Colors.yellow,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text(
                        //       prodsSc[todayProds.entries.elementAt(index).key]['na'].toString()
                        //     ),
                        //   ),
                        // );

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
                                    totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                          turns: stateList[index][0]? 0.250:0,
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
                                            prodsSc[todayProds.entries.elementAt(index).key]['na'].toString(),
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                            totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 27.0),
                                          child: ExpansionTile(
                                            trailing: Text(
                                              totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    turns: stateList[index][1]? 0.250:0,
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Gross profits',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Stock costs',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                        Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 10.0),
                                                            child: Text(
                                                              'Items (main)',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                          ),
                                        )
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 27.0),
                                          child: ExpansionTile(
                                            trailing: Text(
                                              totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    turns: stateList[index][2]? 0.250:0,
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
                                                      'Gross profit',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Gross profits',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Stock costs',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                        Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 10.0),
                                                            child: Text(
                                                              'Items (main)',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                          ),
                                        )
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 27.0),
                                          child: ExpansionTile(
                                            trailing: Text(
                                              totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    turns: stateList[index][3]? 0.250:0,
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
                                                      'Stock cost',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Gross profits',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Stock costs',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                        Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 10.0),
                                                            child: Text(
                                                              'Items (main)',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                          ),
                                        )
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 27.0),
                                          child: ExpansionTile(
                                            trailing: Text(
                                              totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    turns: stateList[index][4]? 0.250:0,
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
                                                      'Quantity',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Gross profits',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        'Stock costs',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                                        Icon(SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 10.0),
                                                            child: Text(
                                                              'Items (main)',
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
                                                      totalSaleCal(todayProds.entries.elementAt(index).value) + ' MMK',
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
                                          ),
                                        )
                                      ],
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
                                                .withOpacity(
                                                0.5),
                                            width: 0.5)
                                    )),
                              ),
                            )
                          ],
                        );
                  },
                  // Builds 1000 ListTiles
                  childCount: todayProds.length,
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
        //       Container(
        //           child: Text(
        //             resProds.length == 0? '': 'End of results',
        //             textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)
        //       ),
        //     ],
        //   ),
        // ),

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
                    // _showDatePicker(OneContext().context);
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
                          'textSetToday', textScaleFactor: 1,
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
                          'textSetLastWeek', textScaleFactor: 1,
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
                          'textSetLastMonth', textScaleFactor: 1,
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
                          'textSetLastYear', textScaleFactor: 1,
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

  bool isExpanded = false;
  List<List<bool>> stateList = [];

  void onStateChanged(index, inner, expanded) {
    if(inner!= 0) {
      setState(() {
        // for(int i = 0; i<stateList.length; i++) {
        //   stateList[i] = false;
        // }
        if(expanded) {
          stateList[index][inner] = true;
        }
        else {
          stateList[index][inner] = false;
        }
      });
    } else {
      setState(() {
        // for(int i = 0; i<stateList.length; i++) {
        //   stateList[i] = false;
        // }
        if(expanded) {
          stateList[index] = [true, false, false, false, false];
        }
        else {
          stateList[index] = [false, false, false, false, false];
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
        stateList[index][i] = true;
      }
      else {
        stateList[index][i] = false;
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
}

enum PaginateBuilderType { listView, gridView, pageView }
