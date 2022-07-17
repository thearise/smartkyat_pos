library paginate_firestore;

import 'dart:math';
import 'dart:async';
import 'dart:io';

import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
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
  final _closeCartBtn;
  final _openCartBtn;
  final _printFromOrders;
  final _openDrawerBtn;
  final _closeDrawerBtn;

  BlocFirestore({
    Key? key,
    required void openDrawerBtn(),
    required void closeDrawerBtn(),
    required void closeCartBtn(),
    required void openCartBtn(),
    this.selectedDev,
    required void printFromOrders(File file, var prodListPR),
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
    required void resetState(DateTime resetD),
  }) : _resetState = resetState,
        _closeCartBtn = closeCartBtn,
        _openCartBtn = openCartBtn,
        _printFromOrders = printFromOrders,
        _openDrawerBtn = openDrawerBtn,
        _closeDrawerBtn = closeDrawerBtn,
        super(key: key);

  final bool isEnglish;
  final BlueDevice? selectedDev;
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
  String textSetAll = 'All';
  String textSetTUnpaid = 'Unpaids';
  String textSetTRefunds = 'Refunds';
  String textSetTPaid = 'Paids';

  void printFromOrdersFun(File file, var prodListPR) {
    widget._printFromOrders(file, prodListPR);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationCubit, PaginationState>(
      bloc: _cubit,
      builder: (context, state) {
        debugPrint('shhh');
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
                      child: Center(child: Text('No data found for selected month', textScaleFactor: 1, style: TextStyle(fontSize: 15),)),
                    ),
                  )
                ],
              ),
            );
          }
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

  ScrollController _scrollController = ScrollController();
  int itemPerPage = 10;
  bool endOfResult = false;
  bool noResult = false;
  bool noFind = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        debugPrint('maxxed');
        Future.delayed(const Duration(milliseconds: 500), () {
          itemPerPage = itemPerPage + 10;
          setState(() {});
        });

      }
    });

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

    if(widget.isEnglish == true ) {
      setState(() {
        textSetAll = 'All';
        textSetTUnpaid = 'Unpaids';
        textSetTRefunds = 'Refunds';
        textSetTPaid = 'Paids';
      });
    }
    else  {
      setState(() {
        textSetAll = 'အားလုံး';
        textSetTUnpaid = 'မရှင်းသေး';
        textSetTRefunds = 'ပြန်ပေး';
        textSetTPaid = 'ရှင်းပြီး';
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

  calHourFromTZ(DateTime dateTime) {
    return dateTime.timeZoneOffset.inMinutes;
  }

  var sectionList3;
  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;
  int itemsForPag = 0;

  Map<dynamic, dynamic> countMap = {};
  Widget _buildListView(PaginationLoaded loadedState) {
    endOfResult = false;
    noFind = false;
    debugPrint('whatting???');
    List viewDocList = [];
    int allItems = 0;
    int itemsForEof = 0;

    List<dynamic> modifiedDocs = [];
    int firstDate = 0;
    int ayinDay = -1;
    int iter = -1;
    List<dynamic> dailyOrdPrep = [];


    for(int i = 0; i < 31; i++) {
      dailyOrdPrep.add([]);
    }
    for(int i = 0; i < loadedState.documentSnapshots.length; i++) {
      Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      List<dynamic> dailyOrdTemp = data['daily_order'];
      for(int ii = dailyOrdTemp.length-1; ii >= 0; ii--) {

        String dailyOrdTempDate = dailyOrdTemp[ii].split('^')[0];
        String year = dailyOrdTempDate.substring(0,4);
        String month = dailyOrdTempDate.substring(4,6);
        String day = dailyOrdTempDate.substring(6,8);
        String hour = dailyOrdTempDate.substring(8,10);
        String minute = dailyOrdTempDate.substring(10,12);
        if(i == 0 && ii == 0) {
          firstDate = int.parse(day);
          // ayinDay = firstDate;
        }

        DateTime changeDate = DateFormat("yyyy-MM-dd HH:mm").parse(year + '-' + month + '-' + day + ' ' + hour + ':' + minute);
        debugPrint('ayin ' + changeDate.toString());
        changeDate = changeDate.add(Duration(minutes: calHourFromTZ(changeDate)));
        debugPrint('aguc ' + changeDate.toString());
        String modChgDocStr = changeDate.year.toString() + zeroToTen(changeDate.month.toString()) + zeroToTen(changeDate.day.toString()) + zeroToTen(changeDate.hour.toString()) + zeroToTen(changeDate.minute.toString()) + '^' +
            dailyOrdTemp[ii].split('^')[1] + '^' +
            dailyOrdTemp[ii].split('^')[2] + '^' +
            dailyOrdTemp[ii].split('^')[3] + '^' +
            dailyOrdTemp[ii].split('^')[4] + '^' +
            dailyOrdTemp[ii].split('^')[5] + '^' +
            dailyOrdTemp[ii].split('^')[6];
        debugPrint('dchg ' + modChgDocStr);
        debugPrint('chdy ' + ayinDay.toString() + ' -- ' + changeDate.day.toString());
        dailyOrdPrep[changeDate.day].add(modChgDocStr);
        // if(ayinDay == changeDate.day) {
        //   modifiedDocs[iter]['daily_order'].add(modChgDocStr);
        // } else {
        //   temp['daily_order'] = [modChgDocStr];
        //   temp['date'] = data['date'];
        //   modifiedDocs.add(temp);
        //   iter++;
        // }
        // print('chdy2' + modifiedDocs.toString());
        // ayinDay = changeDate.day;
      }
      // temp['daily_order'] = data['daily_order'];
      // temp['date'] = data['date'];
      // modifiedDocs.add(temp);

      // for(int ii = 0; ii < data['daily_order'].length; ii++) {
      //   modifiedDocs.add(data['daily_order'][ii]);
      // }
    }


    debugPrint('mode ' + dailyOrdPrep.toString());
    for(int i = 0; i < dailyOrdPrep.length; i++) {
      Map<dynamic, dynamic> temp = {};
      if(dailyOrdPrep[i].length > 0) {
        debugPrint('mode2' + dailyOrdPrep[i].toString());
        temp['daily_order'] = dailyOrdPrep[i];
        temp['date'] = Timestamp.fromDate(DateFormat("yyyy-MM-dd").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(i.toString())));
        modifiedDocs.add(temp);
      }
    }

    modifiedDocs = modifiedDocs.reversed.toList();
    debugPrint('modDocs ' + modifiedDocs.toString());

    for(int i = 0; i < modifiedDocs.length; i++) {
      List<dynamic> data = modifiedDocs[i]['daily_order'];
      // Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      for(int ii = 0; ii < data.length; ii++) {
        if(cateScIndex == 2) {
          if(data[ii].split('^')[4] == 'P' || data[ii].split('^')[4] == 'T') {
            itemsForEof++;
          }
        } else if(cateScIndex == 1) {
          if(data[ii].split('^')[5] != '0.0') {
            itemsForEof++;
          }
        } else if(cateScIndex == 3) {
          if(data[ii].split('^')[5] == '0.0') {
            itemsForEof++;
          }
        } else if(cateScIndex == 0) {
          itemsForEof++;
          // itemsForEof++;
        }
      }
    }
    debugPrint('testtt0 ' + itemsForEof.toString());
    if(itemsForEof <= 0) {
      noFind = true;
    }
    outerLoop:
    for(int i = 0; i < modifiedDocs.length; i++) {
      List<dynamic> data = modifiedDocs[i]['daily_order'];
      var dataDate = modifiedDocs[i]['date'];
      // Map<String, dynamic> data = loadedState.documentSnapshots[i].data() as Map<String, dynamic>;
      List sortedDailyOrder = [];
      List filtDailyOrder = [];
      for(int ii = 0; ii < data.length; ii++) {
        if(cateScIndex == 2) {
          if(data[ii].split('^')[4] == 'P' || data[ii].split('^')[4] == 'T') {
            filtDailyOrder.add(data[ii]);
            // itemsForPag++;
          }
        } else if(cateScIndex == 1) {
          if(data[ii].split('^')[5] != '0.0') {
            filtDailyOrder.add(data[ii]);
            // itemsForPag++;
          }
        } else if(cateScIndex == 3) {
          if(data[ii].split('^')[5] == '0.0') {
            filtDailyOrder.add(data[ii]);
            // itemsForPag++;
          }
        } else if(cateScIndex == 0) {
          debugPrint('length checker ' + filtDailyOrder.length.toString() + ' ' + filtDailyOrder.toString());
          // if(dailyOrders.length >= itemPerPage) {
          //   break;
          // }
          filtDailyOrder.add(data[ii]);
          // itemsForPag++;
          // itemsForEof++;
        }

      }

      // if(itemsForPag!=0 && itemsForEof != 0 && itemsForPag > itemsForEof) {
      //   endOfResult = true;
      // }

      countMap[dataDate.toDate().year.toString() + zeroToTen(dataDate.toDate().month.toString()) + zeroToTen(dataDate.toDate().day.toString())]
      = filtDailyOrder.length.toString();

      sortedDailyOrder = sortList(filtDailyOrder);
      List daily = [];
      Map<dynamic, dynamic> temp = {};
      for(int j = 0; j < itemPerPage; j++) {
        if(j>= sortedDailyOrder.length) {
          break;
        }
        allItems++;
        daily.add(sortedDailyOrder[j]);
        debugPrint('testtt1 ' + itemsForEof.toString() + ' ' + allItems.toString());

        if(allItems>=itemPerPage) {
          temp['daily_order'] = daily;
          // itemsForPag += daily.length;
          temp['date'] = dataDate;
          viewDocList.add(temp);
          break outerLoop;
        }
      }
      debugPrint('testing1 ' + itemsForEof.toString() + ' ' + allItems.toString());
      if(allItems >= itemsForEof) {
        endOfResult = true;
        debugPrint('end twr p');
      } else {
        endOfResult = false;
      }
      temp['daily_order'] = daily;
      temp['date'] = dataDate;
      viewDocList.add(temp);
    }
    debugPrint('itemsForEof ' + itemsForEof.toString());
    // debugPrint('bloc_fire data ' + viewDocList.length.toString());
    debugPrint('count map ' + countMap.toString());

    var sections = List<ExampleSection>.empty(growable: true);
    int docInc = 0;
    debugPrint('HHHEEEE' + viewDocList.length.toString() + ' ');
    outerLoop:
    for(int l = 0; l < viewDocList.length; l++) {

      // List<String> dailyOrders = document['daily_order'].cast<String>();
      List<String> dailyOrders = [];

      for(String str in viewDocList[l]['daily_order']) {
        // if(cateScIndex == 2) {
        //   if(str.split('^')[4] == 'P' || str.split('^')[4] == 'T') {
        //     dailyOrders.add(str);
        //   }
        // } else if(cateScIndex == 1) {
        //   if(str.split('^')[5] != '0.0') {
        //     dailyOrders.add(str);
        //   }
        // } else if(cateScIndex == 3) {
        //   if(str.split('^')[5] == '0.0') {
        //     dailyOrders.add(str);
        //   }
        // } else if(cateScIndex == 0) {
        //   debugPrint('length checker ' + dailyOrders.length.toString() + ' ' + dailyOrders.toString());
        //   // if(dailyOrders.length >= itemPerPage) {
        //   //   break;
        //   // }
        //   dailyOrders.add(str);
        // }
        dailyOrders.add(str);
      }
      debugPrint('length checker outer ' + dailyOrders.length.toString() + ' ' + dailyOrders.toString());
      // debugPrint('where is 2 ' + viewDocList[l]['date'].toDate().add(Duration(minutes: calHourFromTZ(viewDocList[l]['date'].toDate()))).year.toString() + zeroToTen(viewDocList[l]['date'].toDate().add(Duration(minutes: calHourFromTZ(viewDocList[l]['date'].toDate()))).month.toString()) + zeroToTen(viewDocList[l]['date'].toDate().add(Duration(minutes: calHourFromTZ(viewDocList[l]['date'].toDate()))).day.toString()));
      debugPrint('where is 2 ' + viewDocList[l]['date'].toDate().year.toString() + zeroToTen(viewDocList[l]['date'].toDate().month.toString()) + zeroToTen(viewDocList[l]['date'].toDate().day.toString()));
      // debugPrint('herre ' + document.id);
      var section = ExampleSection()
        ..header = viewDocList[l]['date'].toDate().year.toString() + zeroToTen(viewDocList[l]['date'].toDate().month.toString()) + zeroToTen(viewDocList[l]['date'].toDate().day.toString()) + zeroToTen(viewDocList[l]['date'].toDate().hour.toString()) + zeroToTen(viewDocList[l]['date'].toDate().minute.toString())
      // ..header = '20220202'


      // ..items = List.generate(int.parse(document['length']), (index) => document.id)
      //   ..items = listCreation(document.id, document['data'], document).cast<String>()

      //   ..items = document['daily_order'].cast<String>()


        ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
      // ..items = orderItems(document.id)
        ..expanded = true;
      sections.add(section);
      // if(docInc>0) {
      //   debugPrint('where is ');
      //   Map<String,dynamic> dataLow = viewDocList[docInc-1].data()! as Map< String, dynamic>;
      //   List<String> dataLowDailyOrder = [];
      //   for(String str in dataLow['daily_order']) {
      //     if(cateScIndex == 2) {
      //       if(str.split('^')[4] == 'P' || str.split('^')[4] == 'T') {
      //         dataLowDailyOrder.add(str);
      //       }
      //     } else if(cateScIndex == 1) {
      //       if(str.split('^')[5] != '0.0') {
      //         dataLowDailyOrder.add(str);
      //       }
      //     } else if(cateScIndex == 3) {
      //       if(str.split('^')[5] == '0.0') {
      //         dataLowDailyOrder.add(str);
      //       }
      //     } else if(cateScIndex == 0) {
      //       dataLowDailyOrder.add(str);
      //     }
      //
      //   }
      //
      //
      //   debugPrint('DATA LOW ' + dataLow['date'].toDate().toString());
      //   if( viewDocList[l]['date'].toDate().year.toString() + viewDocList[l]['date'].toDate().month.toString() + viewDocList[l]['date'].toDate().day.toString()
      //       ==
      //       dataLow['date'].toDate().year.toString() + dataLow['date'].toDate().month.toString() + dataLow['date'].toDate().day.toString()
      //   ) {
      //     var section = ExampleSection()
      //       ..header = viewDocList[l]['date'].toDate().year.toString() + zeroToTen(viewDocList[l]['date'].toDate().month.toString()) + zeroToTen(viewDocList[l]['date'].toDate().day.toString())
      //     // ..items = List.generate(int.parse(document['length']), (index) => document.id)
      //     //   ..items = listCreation(document.id, document['data'], document).cast<String>()
      //
      //     //   ..items = document['daily_order'].cast<String>()
      //
      //
      //     // ..items = sortList(changeData(dataLow['daily_order'].cast<String>(), snapshot2)) + sortList(changeData(document['daily_order'].cast<String>(), snapshot2))
      //       ..items = sortList(changeDataNew(dataLowDailyOrder.cast<String>()) + changeDataNew(dailyOrders.cast<String>()))
      //     // ..items = orderItems(document.id)
      //       ..expanded = true;
      //     // sections.add(section);
      //     sections[sections.length-1] = section;
      //   } else {
      //     // debugPrint('herre ' + document.id);
      //     var section = ExampleSection()
      //       ..header = viewDocList[l]['date'].toDate().year.toString() + zeroToTen(viewDocList[l]['date'].toDate().month.toString()) + zeroToTen(viewDocList[l]['date'].toDate().day.toString())
      //     // ..items = List.generate(int.parse(document['length']), (index) => document.id)
      //     //   ..items = listCreation(document.id, document['data'], document).cast<String>()
      //
      //     //   ..items = document['daily_order'].cast<String>()
      //
      //
      //       ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
      //     // ..items = orderItems(document.id)
      //       ..expanded = true;
      //     sections.add(section);
      //   }
      // } else {
      //   debugPrint('where is 2');
      //   // debugPrint('herre ' + document.id);
      //   var section = ExampleSection()
      //     ..header = viewDocList[l]['date'].toDate().year.toString() + zeroToTen(viewDocList[l]['date'].toDate().month.toString()) + zeroToTen(viewDocList[l]['date'].toDate().day.toString())
      //   // ..items = List.generate(int.parse(document['length']), (index) => document.id)
      //   //   ..items = listCreation(document.id, document['data'], document).cast<String>()
      //
      //   //   ..items = document['daily_order'].cast<String>()
      //
      //
      //     ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
      //   // ..items = orderItems(document.id)
      //     ..expanded = true;
      //   sections.add(section);
      // }
      if(docInc>0) {
        debugPrint('section p p lr 1 ' + sections[1].items.length.toString());
      }
      docInc++;
      debugPrint('section p p lr 0 ' + sections[0].items.length.toString());

    }
    // loadedState.documentSnapshots.map((document) async {
    //
    //   // List<String> dailyOrders = document['daily_order'].cast<String>();
    //   List<String> dailyOrders = [];
    //   for(String str in document['daily_order']) {
    //     if(cateScIndex == 2) {
    //       if(str.split('^')[4] == 'P' || str.split('^')[4] == 'T') {
    //         dailyOrders.add(str);
    //       }
    //     } else if(cateScIndex == 1) {
    //       if(str.split('^')[5] != '0.0') {
    //         dailyOrders.add(str);
    //       }
    //     } else if(cateScIndex == 3) {
    //       if(str.split('^')[5] == '0.0') {
    //         dailyOrders.add(str);
    //       }
    //     } else if(cateScIndex == 0) {
    //       if(dailyOrders.length >= itemPerPage) {
    //         break;
    //       }
    //       dailyOrders.add(str);
    //     }
    //
    //   }
    //   if(docInc>0) {
    //     Map<String,dynamic> dataLow = loadedState.documentSnapshots[docInc-1].data()! as Map< String, dynamic>;
    //     List<String> dataLowDailyOrder = [];
    //     for(String str in dataLow['daily_order']) {
    //       if(cateScIndex == 2) {
    //         if(str.split('^')[4] == 'P' || str.split('^')[4] == 'T') {
    //           dataLowDailyOrder.add(str);
    //         }
    //       } else if(cateScIndex == 1) {
    //         if(str.split('^')[5] != '0.0') {
    //           dataLowDailyOrder.add(str);
    //         }
    //       } else if(cateScIndex == 3) {
    //         if(str.split('^')[5] == '0.0') {
    //           dataLowDailyOrder.add(str);
    //         }
    //       } else if(cateScIndex == 0) {
    //         dataLowDailyOrder.add(str);
    //       }
    //
    //     }
    //
    //
    //     debugPrint('DATA LOW ' + dataLow['date'].toDate().toString());
    //     if( document['date'].toDate().year.toString() + document['date'].toDate().month.toString() + document['date'].toDate().day.toString()
    //         ==
    //         dataLow['date'].toDate().year.toString() + dataLow['date'].toDate().month.toString() + dataLow['date'].toDate().day.toString()
    //     ) {
    //       var section = ExampleSection()
    //         ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
    //       // ..items = List.generate(int.parse(document['length']), (index) => document.id)
    //       //   ..items = listCreation(document.id, document['data'], document).cast<String>()
    //
    //       //   ..items = document['daily_order'].cast<String>()
    //
    //
    //       // ..items = sortList(changeData(dataLow['daily_order'].cast<String>(), snapshot2)) + sortList(changeData(document['daily_order'].cast<String>(), snapshot2))
    //         ..items = sortList(changeDataNew(dataLowDailyOrder.cast<String>()) + changeDataNew(dailyOrders.cast<String>()))
    //       // ..items = orderItems(document.id)
    //         ..expanded = true;
    //       // sections.add(section);
    //       sections[sections.length-1] = section;
    //     } else {
    //       // debugPrint('herre ' + document.id);
    //       var section = ExampleSection()
    //         ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
    //       // ..items = List.generate(int.parse(document['length']), (index) => document.id)
    //       //   ..items = listCreation(document.id, document['data'], document).cast<String>()
    //
    //       //   ..items = document['daily_order'].cast<String>()
    //
    //
    //         ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
    //       // ..items = orderItems(document.id)
    //         ..expanded = true;
    //       sections.add(section);
    //     }
    //   } else {
    //     // debugPrint('herre ' + document.id);
    //     var section = ExampleSection()
    //       ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
    //     // ..items = List.generate(int.parse(document['length']), (index) => document.id)
    //     //   ..items = listCreation(document.id, document['data'], document).cast<String>()
    //
    //     //   ..items = document['daily_order'].cast<String>()
    //
    //
    //       ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
    //     // ..items = orderItems(document.id)
    //       ..expanded = true;
    //     sections.add(section);
    //   }
    //
    //
    //
    //   docInc++;
    // }).toList();
    sectionList3 = sections;

    debugPrint('loaded in bloc_firestore ');
    var listView = CustomScrollView(
      reverse: widget.reverse,
      controller: _scrollController,
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
                    widget._closeDrawerBtn();
                    // debugPrint(item.split('^')[1]);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderInfoSub(isEnglish: widget.isEnglish, fromSearch: false, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, closeCartBtn: widget._closeCartBtn, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), openCartBtn: widget._openCartBtn,)),
                    );
                    widget._openDrawerBtn();
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
                                          Text('#' + item.split('^')[1], textScaleFactor: 1,
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
                                          Padding(
                                            padding: EdgeInsets.only(bottom:  (Platform.isAndroid) ? 2.0 : 0.0),
                                            child: Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                              textScaleFactor: 1, style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
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
                                      Padding(
                                        padding: const EdgeInsets.only(right: 25.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(item.split('^')[3].split('&')[0],  textScaleFactor: 1,style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                                maxLines: 1,
                                                strutStyle: StrutStyle(
                                                  height: 1.3,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),

                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), textScaleFactor: 1, style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              )),
                                            ),

                                          ],
                                        ),
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
                                            padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                            child: Text(widget.isEnglish? 'Paid': 'ရှင်းပြီး',
                                              textScaleFactor: 1, strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                              style: TextStyle(
                                                  fontSize: widget.isEnglish? 13: 12,
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
                                            padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                            child: Text(widget.isEnglish? 'Partially paid': 'တချို့တဝက် ရှင်းပြီး',
                                              textScaleFactor: 1, strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                              style: TextStyle(
                                                  fontSize: widget.isEnglish? 13: 12,
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
                                            padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                            child: Text(widget.isEnglish? 'Unpaid': 'မရှင်းသေး',
                                              textScaleFactor: 1, strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                              style: TextStyle(
                                                  fontSize: widget.isEnglish? 13: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if(item.split('^')[4] == 'T')
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeBgSecond,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                            child: Text(widget.isEnglish? 'Refunded': 'ပြန်ပေး',
                                              textScaleFactor: 1, strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                              style: TextStyle(
                                                  fontSize: widget.isEnglish? 13: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    if(item.split('^')[4] == 'P')
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Container(
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.badgeBgSecondLight,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
                                            child: Text(widget.isEnglish? 'Partially refunded': 'တချို့တဝက် ပြန်ပေး',
                                              textScaleFactor: 1, strutStyle: StrutStyle(
                                                height: 1.25,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                              style: TextStyle(
                                                  fontSize: widget.isEnglish? 13: 12,
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
                              // Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                              //   fontSize: 15,fontWeight: FontWeight.w500,
                              // )),
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
                  widget._closeDrawerBtn();
                  debugPrint('Items'+item);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderInfoSub(isEnglish: widget.isEnglish,fromSearch: false, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, closeCartBtn: widget._closeCartBtn, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), openCartBtn: widget._openCartBtn,)),
                  );
                  widget._openDrawerBtn();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightBgColor,
                        ),
                        child: Column(
                          children: [
                            Padding(
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
                                              textScaleFactor: 1, style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Padding(
                                              padding:  EdgeInsets.only(bottom: 1.0),
                                              child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                                            ),
                                            SizedBox(width: 4),
                                            Padding(
                                              padding: EdgeInsets.only(bottom:  (Platform.isAndroid) ? 2.0 : 0.0),
                                              child: Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                                textScaleFactor: 1, style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 25.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(item.split('^')[3].split('&')[0], textScaleFactor: 1, style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                    overflow: TextOverflow.ellipsis
                                                ),
                                                  maxLines: 1,
                                                  strutStyle: StrutStyle(
                                                    height: 1.3,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),

                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), textScaleFactor: 1, style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                              ),

                                            ],
                                          ),
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
                                              padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                              child: Text(widget.isEnglish? 'Paid': 'ရှင်းပြီး',
                                                textScaleFactor: 1, strutStyle: StrutStyle(
                                                  height: 1.25,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),
                                                style: TextStyle(
                                                    fontSize: widget.isEnglish? 13: 12,
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
                                              padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                              child: Text(widget.isEnglish? 'Partially paid': 'တချို့တဝက် ရှင်းပြီး',
                                                textScaleFactor: 1, strutStyle: StrutStyle(
                                                  height: 1.25,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),
                                                style: TextStyle(
                                                    fontSize: widget.isEnglish? 13: 12,
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
                                              padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                              child: Text(widget.isEnglish? 'Unpaid': 'မရှင်းသေး',
                                                textScaleFactor: 1, strutStyle: StrutStyle(
                                                  height: 1.25,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),
                                                style: TextStyle(
                                                    fontSize: widget.isEnglish? 13: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(item.split('^')[4] == 'T')
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Container(
                                            height: 21,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              color: AppTheme.badgeBgSecond,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                              child: Text(widget.isEnglish? 'Refunded': 'ပြန်ပေး',
                                                textScaleFactor: 1, strutStyle: StrutStyle(
                                                  height: 1.25,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),
                                                style: TextStyle(
                                                    fontSize: widget.isEnglish? 13: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      if(item.split('^')[4] == 'P')
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Container(
                                            height: 21,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              color: AppTheme.badgeBgSecondLight,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                              child: Text(widget.isEnglish? 'Partially refunded': 'တချို့တဝက် ပြန်ပေး',
                                                textScaleFactor: 1, strutStyle: StrutStyle(
                                                  height: 1.25,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),
                                                style: TextStyle(
                                                    fontSize: widget.isEnglish? 13: 12,
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
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: AppTheme.skBorderColor2,
                                          width: 1.0),
                                    )
                                ),
                              ),
                            ),
                          ],
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
                            // Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                            //   fontSize: 15,
                            //   fontWeight: FontWeight.w500,
                            // )),
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
        bottomBox()
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
    // debugPrint('section check '+ sectionList3[sectionIndex].items.length.toString());
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
                        dayShowV2(section.header),
                        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        textScaleFactor: 1, style: TextStyle(
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
                            // '(' + sectionList3[sectionIndex].items.length.toString() + ')',
                            '(' + countMap[section.header.substring(0,8)] + ')',
                            // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                            textScaleFactor: 1, style: TextStyle(
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

    // debugPrint('changeData ' + snpsht.da);
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



  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  // DateTime today = DateTime.now();
  DateTime today = DateTime.now();
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM';

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

  String selectMonthCast() {
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

  _animateToIndex(i) {
    // debugPrint((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

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
                          selectMonthCast(), textScaleFactor: 1,
                          // '(7D)',
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
                      onPressed: () async {
                        _animateToIndex(0);
                        setState(() {
                          cateScIndex = 0;
                          itemPerPage = 10;
                        });
                        // Delay to make sure the frames are rendered properly
                        // await Future.delayed(const Duration(milliseconds: 300));
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          _scrollController.jumpTo(0);
                        });
                      },
                      child: Container(
                        child: Text(
                          textSetAll, textScaleFactor: 1,
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
                        _animateToIndex(5.4);
                        setState(() {
                          cateScIndex = 1;
                          itemPerPage = 10;
                        });
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          _scrollController.jumpTo(0);
                        });
                      },
                      child: Container(
                        child: Text(
                          textSetTUnpaid, textScaleFactor: 1,
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
                        _animateToIndex(16.4);
                        setState(() {
                          cateScIndex = 2;
                          itemPerPage = 10;
                        });
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          _scrollController.jumpTo(0);
                        });
                      },
                      child: Container(
                        child: Text(
                          textSetTRefunds, textScaleFactor: 1,
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
                          itemPerPage = 10;
                        });
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          _scrollController.jumpTo(0);
                        });
                      },
                      child: Container(
                        child: Text(
                          textSetTPaid, textScaleFactor: 1,
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

  bottomBox() {
    if(noFind) {
      return SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
        child: Center(child: Text('No filter found', textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)),
      ));
    } else if (endOfResult) {
      return SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
        child: Center(child: Text('End of results', textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)),
      ));
    } else {
      return SliverAppBar(
        toolbarHeight: 38,
        elevation: 0,
        backgroundColor: Colors.white,
        // Provide a standard title.
        // Allows the user to reveal the app bar if they begin scrolling
        // back up the list of items.
        floating: true,
        flexibleSpace: Container(
          child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
        ),
      );
    }
  }

  String dayShowV2(String header) {
    print('header check ' + header.toString());

    String dailyOrdTempDate = header;
    String year = dailyOrdTempDate.substring(0,4);
    String month = dailyOrdTempDate.substring(4,6);
    String day = dailyOrdTempDate.substring(6,8);
    String hour = dailyOrdTempDate.substring(8,10);
    String minute = dailyOrdTempDate.substring(10,12);

    DateTime changeDate = DateFormat("yyyy-MM-dd hh:mm").parse(year + '-' + month + '-' + day + ' ' + hour + ':' + minute);
    debugPrint('ayinf ' + changeDate.toString());
    // changeDate = changeDate.add(Duration(minutes: calHourFromTZ(changeDate)));

    return changeDate.day.toString();
  }
}

enum PaginateBuilderType { listView, gridView, pageView }
