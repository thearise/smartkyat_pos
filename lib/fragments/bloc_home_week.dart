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
    this.shopId,
    this.dateTime,
    required void resetState(DateTime resetD),
  }) : _resetState = resetState, super(key: key);

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
            // return widget.onEmpty;
            return Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  headerAppBar(),
                  Expanded(
                    child: Container(
                      // color: AppTheme.lightBgColor,
                      color: Colors.white,
                      child: Center(child: Text('No data found for selected week', style: TextStyle(fontSize: 15),)),
                    ),
                  )
                ],
              ),
            );
          }
          return widget.itemBuilderType == PaginateBuilderType.listView
              ? _buildListView(loadedState)
              : widget.itemBuilderType == PaginateBuilderType.gridView
              ? _buildListView(loadedState)
              : _buildListView(loadedState);
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
    // DateTime greaterThan = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00');
    // return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
    //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
    //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 00:00:00'))
    //     .orderBy('date', descending: true);
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders');
  }

  Widget _buildListView(PaginationLoaded loadedState) {
    var listView = CustomScrollView(
      reverse: widget.reverse,
      controller: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      slivers: [
        // if (widget.header != null) widget.header!,
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

  headerAppBar() {
    return Container();
  }

}

enum PaginateBuilderType { listView, gridView, pageView }
