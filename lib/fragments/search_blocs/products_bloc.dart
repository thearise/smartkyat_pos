library paginate_firestore;

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:smartkyat_pos/app_theme.dart';

import '../bloc/pagination_cubit.dart';
import '../bloc/pagination_listeners.dart';
import '../widgets_bloc/bottom_loader.dart';
import '../widgets_bloc/empty_display.dart';
import '../widgets_bloc/empty_separator.dart';
import '../widgets_bloc/error_display.dart';
import '../widgets_bloc/initial_loader.dart';

class ProductsBloc extends StatefulWidget {
  const ProductsBloc({
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
    this.custom,
    this.isLive = false,
    this.includeMetadataChanges = false,
    this.options,
    required this.intValIni,
    required void selectedIntVal(int index),
  }) :
      _selectedIntVal = selectedIntVal,
      super(key: key);

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
  final Widget? custom;
  final _selectedIntVal;
  final int intValIni;

  /// Use this only if `isLive = false`
  final GetOptions? options;

  /// Use this only if `isLive = true`
  final bool includeMetadataChanges;

  @override
  _ProductsBlocState createState() => _ProductsBlocState();

  final Widget Function(Exception)? onError;

  final Widget Function(BuildContext, List<DocumentSnapshot>, int) itemBuilder;

  final void Function(PaginationLoaded)? onReachedEnd;

  final void Function(PaginationLoaded)? onLoaded;

  final void Function(int)? onPageChanged;
}

class _ProductsBlocState extends State<ProductsBloc> {
  PaginationCubit? _cubit;

  final _width = 10.0;

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
            WidgetsBinding.instance!.addPostFrameCallback((_) async {
              print('widget.intValIni ' + widget.intValIni.toString());
              if(widget.intValIni == 1) {
                cateScCtlerE.jumpTo(9.2 * 10 > cateScCtlerE.position.maxScrollExtent? cateScCtlerE.position.maxScrollExtent: 9.2 * 10);
              } else if(widget.intValIni == 2) {
                cateScCtlerE.jumpTo(19.9 * 10 > cateScCtlerE.position.maxScrollExtent? cateScCtlerE.position.maxScrollExtent: 19.9 * 10);
              } else if(widget.intValIni == 3) {
                cateScCtlerE.jumpTo(30.1 * 10 > cateScCtlerE.position.maxScrollExtent? cateScCtlerE.position.maxScrollExtent: 30.1 * 10);
              } else if(widget.intValIni == 4) {
                cateScCtlerE.jumpTo(41 * 10 > cateScCtlerE.position.maxScrollExtent? cateScCtlerE.position.maxScrollExtent: 41 * 10);
              } else {
                cateScCtlerE.jumpTo(0);
              }
            });
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
                  child: Container(
                    height: 32,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.yellow,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: cateScCtlerE,
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 11,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                child: FlatButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  color: widget.intValIni == 0 ? AppTheme.secButtonColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: AppTheme.skBorderColor2,
                                    ),
                                  ),
                                  onPressed: () {
                                    // _animateToIndex(0);
                                    widget._selectedIntVal(0);
                                  },
                                  child: Container(
                                    child: Text(
                                      'Products',
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
                                  color: widget.intValIni == 1 ? AppTheme.secButtonColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: AppTheme.skBorderColor2,
                                    ),
                                  ),
                                  onPressed: () {
                                    // _animateToIndex(5.4);
                                    widget._selectedIntVal(1);
                                  },
                                  child: Container(
                                    child: Text(
                                      'Customers',
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
                                  color: widget.intValIni == 2 ? AppTheme.secButtonColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: AppTheme.skBorderColor2,
                                    ),
                                  ),
                                  onPressed: () {
                                    // _animateToIndex(2);
                                    widget._selectedIntVal(2);
                                  },
                                  child: Container(
                                    child: Text(
                                      'Merchants',
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
                                  color: widget.intValIni == 3 ? AppTheme.secButtonColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: AppTheme.skBorderColor2,
                                    ),
                                  ),
                                  onPressed: () {
                                    // _animateToIndex(0);
                                    widget._selectedIntVal(3);
                                  },
                                  child: Container(
                                    child: Text(
                                      'Sale orders',
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
                                  color: widget.intValIni == 4 ? AppTheme.secButtonColor:Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: AppTheme.skBorderColor2,
                                    ),
                                  ),
                                  onPressed: () {
                                    // _animateToIndex(0);
                                    widget._selectedIntVal(4);
                                  },
                                  child: Container(
                                    child: Text(
                                      'Buy orders',
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
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                  ),
                ),
                Expanded(
                  child: Container(
                    // color: AppTheme.lightBgColor,
                    color: Colors.white,
                    child: Center(child: Text('No data found', style: TextStyle(fontSize: 15),)),
                  ),
                )
              ],
            );
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

  _animateToIndex(i) {
    // print((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }

  @override
  void initState() {
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
        if (widget.custom != null) widget.custom!,
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
  
  final cateScCtler = ScrollController();
  final cateScCtlerE = ScrollController();

  Widget _buildListView(PaginationLoaded loadedState) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      print('widget.intValIni ' + widget.intValIni.toString());
      if(widget.intValIni == 1) {
        cateScCtler.jumpTo(9.2 * 10 > cateScCtler.position.maxScrollExtent? cateScCtler.position.maxScrollExtent: 9.2 * 10);
      } else if(widget.intValIni == 2) {
        cateScCtler.jumpTo(19.9 * 10 > cateScCtler.position.maxScrollExtent? cateScCtler.position.maxScrollExtent: 19.9 * 10);
      } else if(widget.intValIni == 3) {
        cateScCtler.jumpTo(30.1 * 10 > cateScCtler.position.maxScrollExtent? cateScCtler.position.maxScrollExtent: 30.1 * 10);
      } else if(widget.intValIni == 4) {
        cateScCtler.jumpTo(41 * 10 > cateScCtler.position.maxScrollExtent? cateScCtler.position.maxScrollExtent: 41 * 10);
      } else {
        cateScCtler.jumpTo(0);
      }
    });
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
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
            child: Container(
              height: 32,
              width: MediaQuery.of(context).size.width,
              // color: Colors.yellow,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      controller: cateScCtler,
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 11,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: FlatButton(
                            minWidth: 0,
                            padding: EdgeInsets.only(left: 12, right: 12),
                            color: widget.intValIni == 0 ? AppTheme.secButtonColor:Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: AppTheme.skBorderColor2,
                              ),
                            ),
                            onPressed: () {
                              // _animateToIndex(0);
                              widget._selectedIntVal(0);
                            },
                            child: Container(
                              child: Text(
                                'Products',
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
                            color: widget.intValIni == 1 ? AppTheme.secButtonColor:Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: AppTheme.skBorderColor2,
                              ),
                            ),
                            onPressed: () {
                              // _animateToIndex(5.4);
                              widget._selectedIntVal(1);
                            },
                            child: Container(
                              child: Text(
                                'Customers',
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
                            color: widget.intValIni == 2 ? AppTheme.secButtonColor:Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: AppTheme.skBorderColor2,
                              ),
                            ),
                            onPressed: () {
                              // _animateToIndex(2);
                              widget._selectedIntVal(2);
                            },
                            child: Container(
                              child: Text(
                                'Merchants',
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
                            color: widget.intValIni == 3 ? AppTheme.secButtonColor:Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: AppTheme.skBorderColor2,
                              ),
                            ),
                            onPressed: () {
                              // _animateToIndex(0);
                              widget._selectedIntVal(3);
                            },
                            child: Container(
                              child: Text(
                                'Sale orders',
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
                            color: widget.intValIni == 4 ? AppTheme.secButtonColor:Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: AppTheme.skBorderColor2,
                              ),
                            ),
                            onPressed: () {
                              // _animateToIndex(0);
                              widget._selectedIntVal(4);
                            },
                            child: Container(
                              child: Text(
                                'Buy orders',
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
                        ),
                      ],
                    ),
                  )
                ],
              ),

            ),
          ),),
        if (widget.custom != null) widget.custom!,
        SliverPadding(
          padding: widget.padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
              semanticIndexCallback: (widget, localIndex) {
                if (localIndex.isEven) {
                  return localIndex ~/ 2;
                }
                // ignore: avoid_returning_null
                return null;
              },
              childCount: max(
                  0,
                  (loadedState.hasReachedEnd
                      ? loadedState.documentSnapshots.length
                      : loadedState.documentSnapshots.length + 1) *
                      2 -
                      1),
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
        child: listView,
      );
    }

    return listView;
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

  void selectedIntVal(int i) {

  }
}

enum PaginateBuilderType { listView, gridView, pageView }
