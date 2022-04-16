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

class BlocHomeWeek extends StatefulWidget {

  const BlocHomeWeek({
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

  /// Use this only if `isLive = false`
  final GetOptions? options;

  /// Use this only if `isLive = true`
  final bool includeMetadataChanges;

  @override
  _BlocHomeWeekState createState() => _BlocHomeWeekState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _BlocHomeWeekState extends State<BlocHomeWeek> {
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
    print('loaded in bloc_home_week');
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

  ordersQuery() {
    print('buyorder query ' + today.toString() + ' ' + widget.shopId.toString());
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId.toString()).collection('buyOrders')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 13)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 13)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 13)).day.toString()) + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59'))
        .orderBy('date', descending: true);
  }

  Widget _buildListView(PaginationLoaded loadedState) {
    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      print('bloc_fire sale 1st data ' + data.toString());
    }

    var listView = Container(
      child: BlocHomeWeekBuy(
        shopId: widget.shopId,
        sale: loadedState.documentSnapshots,
        key: valueKeyTog(),
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
        intValIni: widget.intValIni,
        dateTime: widget.dateTime,
        isLive: true,
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

  int _sliding = 0;
  final cateScCtler = ScrollController();
  int cateScIndex = 0;
  final _width = 10.0;

  DateTime today = DateTime.now();
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM-dd';

  _animateToIndex(i) {
    // print((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }

  String selectDaysCast() {
    print("TTT " + today.year.toString().length.toString());
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
}

enum PaginateBuilderType { listView, gridView, pageView }
