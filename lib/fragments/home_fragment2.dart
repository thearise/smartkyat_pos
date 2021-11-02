import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/donut.dart';
import 'package:smartkyat_pos/fragments/subs/top_sale_detail.dart';
import 'package:smartkyat_pos/pie_chart/simple.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:smartkyat_pos/widgets/apply_discount_to_cart.dart';
import 'package:smartkyat_pos/widgets/line_chart_sample2.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:vector_math/vector_math_64.dart';
import '../app_theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../a11y/a11y_gallery.dart' as a11y show buildGallery;
import '../bar_chart/bar_gallery.dart' as bar show buildGallery;
import '../gallery_scaffold.dart';
import '../time_series_chart/time_series_gallery.dart' as time_series
    show buildGallery;
import '../line_chart/line_gallery.dart' as line show buildGallery;
import '../scatter_plot_chart/scatter_plot_gallery.dart' as scatter_plot
    show buildGallery;
import '../combo_chart/combo_gallery.dart' as combo show buildGallery;
import '../pie_chart/pie_gallery.dart' as pie show buildGallery;
import '../axes/axes_gallery.dart' as axes show buildGallery;
import '../behaviors/behaviors_gallery.dart' as behaviors show buildGallery;
import '../i18n/i18n_gallery.dart' as i18n show buildGallery;
import '../legends/legends_gallery.dart' as legends show buildGallery;
import 'subs/customer_info.dart';


class HomeFragment extends StatefulWidget {
  final _callback;

  HomeFragment({required void toggleCoinCallback(), required Key key})
      : _callback = toggleCoinCallback, super(key: key);
  @override
  HomeFragmentState createState() => HomeFragmentState();

// HomeFragment({Key? key, required void toggleCoinCallback()}) : super(key: key);
//
// @override
// _HomeFragmentState createState() => _HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeFragment> {
  TextEditingController _searchController = TextEditingController();

  bool loadingSearch = false;

  FocusNode nodeFirst = FocusNode();





  @override
  bool get wantKeepAlive => true;

  final JiggleController controller = JiggleController();


  void _jiggleStuff() {
    controller.toggle();
  }

  var sectionList;
  var sectionListNo;
  String searchValue = '';
  int slidingSearch = 0;
  bool noSearchData = false;


  @override
  initState() {
    var sections = List<ExampleSection>.empty(growable: true);
    var section = ExampleSection()
      ..header = ''
    // ..items = List.generate(int.parse(document['length']), (index) => document.id)
    //   ..items = listCreation(document.id, document['data'], document).cast<String>()

    //   ..items = document['daily_order'].cast<String>()


      ..items = ['']
    // ..items = orderItems(document.id)
      ..expanded = true;
    sections.add(section);
    sectionList = sections;
    sectionListNo = sections;


    nodeFirst.addListener(() {
      if(nodeFirst.hasFocus) {
        setState(() {
          loadingSearch = true;
        });
      }
    });
    fetchOrders();
    super.initState();
  }

  addCustomer2Cart1(data) {
    // widget._callback2(data);
  }

  List<double> thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

  zeroToTen(String string) {
    if(int.parse(string) > 9) {
      return string;
    } else {
      return '0'+string;
    }
  }

  fetchOrders() async {
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 8));
    DateTime monthAgo = today.subtract(const Duration(days: 31));

    // print('each ');
    CollectionReference orders = FirebaseFirestore
        .instance
        .collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders');

    orders.get().then((QuerySnapshot
    querySnapshot) async {
      // print(DateTime.now().subtract(duration))
      //today = today.add(const Duration(hours: 1));
      sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));
      monthAgo = monthAgo.add(const Duration(days: 1));
      querySnapshot.docs
          .forEach((doc) {
        int week = 0;
        int month = 0;
        int year = 0;
        sevenDaysAgo = today.subtract(const Duration(days: 8));
        monthAgo = today.subtract(const Duration(days: 31));

        while(!(today.year.toString() == sevenDaysAgo.year.toString() && today.month.toString() == sevenDaysAgo.month.toString() && today.day.toString() == sevenDaysAgo.day.toString())) {
          sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));

          print('seven Days Ago ' + sevenDaysAgo.day.toString() + ' ' + week.toString());
          print('here shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));


          print('shwe shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));

          if(doc['date'] == sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString())) {
            double total = 0;
            // print(doc['daily_order'].toString());
            for(String str in doc['daily_order']) {
              // print(double.parse(str));
              total += double.parse(str.split('^')[2]);
            }
            print('total ' + total.toString());
            setState(() {
              thisWeekOrdersChart[week] = total;
            });

          }
          week = week + 1;

        }

        while(!(today.year.toString() == monthAgo.year.toString() && today.month.toString() == monthAgo.month.toString() && today.day.toString() == monthAgo.day.toString())) {
          monthAgo = monthAgo.add(const Duration(days: 1));

          print('month Days Ago ' + monthAgo.day.toString() + ' ' + month.toString());
          print('here shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));


          print('shwe shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));

          if(doc['date'] == monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString())) {
            double total = 0;
            // print(doc['daily_order'].toString());
            for(String str in doc['daily_order']) {
              // print(double.parse(str));
              print('testing ' + str.split('^')[2]);
              total += double.parse(str.split('^')[2]);
            }
            print('tatoos ' + total.toString());
            setState(() {
              thisMonthOrdersChart[month] = total;
            });

          }
          month = month + 1;

        }
        if (doc['date'].substring(0,8) == today.year.toString() +
            zeroToTen(today.month.toString()) +
            zeroToTen(today.day.toString())) {
          double total = 0;
          for (String str in doc['daily_order']) {
            for(int i=0; i<=24 ; i++ ){

              if(str.split('^')[0].substring(0, 10) == today.year.toString() +
                  zeroToTen(today.month.toString()) +
                  zeroToTen(today.day.toString()) +
                  zeroToTen(i.toString()))
              {
                total += double.parse(str.split('^')[2]);
                setState(() {
                  todayOrdersChart[i]+=double.parse(str.split('^')[2]);
                });
              }
              // print('laos ' + total.toString());
              print('World ' +todayOrdersChart.toString());
            }
          }
        }
        if (doc['date'].substring(0,4) == today.year.toString()){
          double total = 0;
          for (String str in doc['daily_order']) {
            for(int i=1; i<=12 ; i++ ){
              // print('helloworld '+i.toString());

              if(str.split('^')[0].substring(0,6) == today.year.toString()+ zeroToTen(i.toString()))
              {
                total += double.parse(str.split('^')[2]);
                setState(() {
                  thisYearOrdersChart[i]+=double.parse(str.split('^')[2]);
                  print('fortune ' +thisYearOrdersChart.toString()); });
              }
              //print('laos ' + total.toString());

            }
          }
        }

        // while(!(today.year.toString() == yearAgo.year.toString() && today.month.toString() == yearAgo.month.toString() && today.day.toString() == yearAgo.day.toString())) {
        //   yearAgo = yearAgo.add(const Duration(days: 1));
        //
        //   if(doc['date'] == yearAgo.year.toString() + zeroToTen(yearAgo.month.toString()) + zeroToTen(yearAgo.day.toString())) {
        //     double total = 0;
        //     // print(doc['daily_order'].toString());
        //     for(String str in doc['daily_order']) {
        //       // print(double.parse(str));
        //       total += double.parse(str.split('^')[2]);
        //     }
        //     print('total ' + total.toString());
        //     setState(() {
        //       thisYearOrdersChart[year] = total;
        //     });
        //
        //   }
        //   year = year + 1;
        //
        // }
        print('this year' + thisYearOrdersChart.toString());
        print('this week ' + thisWeekOrdersChart.toString());
        // for(int j = 20210909; j <= 20210915; j++) {
        //
        //   // print('seven Days Ago 2 ' + sevenDaysAgo.day.toString() + ' ' + ij.toString());
        //   print('here shwe 2 ' + j.toString());
        //   // if(doc['date'] == j.toString()) {
        //   //   double total = 0;
        //   //   // print(doc['daily_order'].toString());
        //   //   for(String str in doc['daily_order']) {
        //   //     // print(double.parse(str));
        //   //     total += double.parse(str.split('^')[2]);
        //   //   }
        //   //   print('total ' + total.toString());
        //   //   setState(() {
        //   //     thisWeekOrdersChart[ij] = total;
        //   //   });
        //   //
        //   // }
        //   // ij = ij + 1;
        //   // print(ij);
        // }


        // print('this week 2' + thisWeekOrdersChart.toString());

        // print('each ' + doc.id.toString());
      });
      print('this month ' + thisMonthOrdersChart.toString());
      // setState(() {
      //   thisWeekOrdersChart
      // });
    });

    // CollectionReference col1 = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders');
    // final snapshots = col1.snapshots().map((snapshot) => snapshot.docs.where((doc) => doc['date'] == "20210914" || doc['date'] == "20210913"));
    //
    // print((await snapshots.first).toList());
  }

  void _incrementCounter() {
    setState(() => _counter++);
    _shakeController.shake();
  }

  @override
  void dispose() {
    super.dispose();
  }


  int _counter = 0;
  late ShakeController _shakeController;


  List<Color> gradientColors = [
    // AppTheme.badgeFgSecond
    Colors.Colors.blue
    // const Color(0xff23b6e6),
    // const Color(0xff02d39a),
  ];

  bool showAvg = false;

  void closeSearch() {
    print('clicked testing ');
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSearch = false;
    });
  }
  void unfocusSearch() {
    print('clicked testing 2');
    FocusScope.of(context).unfocus();
  }

  searchFocus() {

    setState(() {
      loadingSearch = true;
    });
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
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return today.subtract(Duration(hours: int.parse(subHours))).hour.toString()+ ' hr';
              case 4:
                return today.subtract(Duration(hours: (int.parse(subHours)-4))).hour.toString()+ ' hr';
              case 8:
                return today.subtract(Duration(hours: int.parse(subHours)-8)).hour.toString()+ ' hr';
              case 12:
                return today.subtract(Duration(hours: int.parse(subHours)-12)).hour.toString()+ ' hr';
              case 16:
                return today.subtract(Duration(hours: int.parse(subHours)-16)).hour.toString()+ ' hr';
              case 20:
                return today.subtract(Duration(hours: int.parse(subHours)-20)).hour.toString()+ ' hr';
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
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
                return today.subtract(Duration(days: 30)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 29)).month.toString());
              case 5:
                return today.subtract(Duration(days: 25)).day.toString();
              case 10:
                return today.subtract(Duration(days: 20)).day.toString();
              case 15:
                return today.subtract(Duration(days: 15)).day.toString();
              case 20:
                return today.subtract(Duration(days: 10)).day.toString();
              case 25:
                return today.subtract(Duration(days: 5)).day.toString();
              case 30:
                return 'Today';
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



            print('value ' + findMax(roundMonth).toString());
            return '';
          },
          reservedSize: 42,
          margin: 6,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFFd6d8db), width: 0))),
      minX: 0,
      maxX: 30,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            // double.parse(((thisWeekOrdersChart[5]/1000000)).toString())
            FlSpot(0, (((thisMonthOrdersChart[0]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[0]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[0]).toString()  + '\n(' + today.subtract(Duration(days: 30)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 30)).month.toString()) + ')'),
            FlSpot(1, (((thisMonthOrdersChart[1]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[1]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[1]).toString() + '\n(' + today.subtract(Duration(days: 29)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 29)).month.toString()) + ')'),
            FlSpot(2, (((thisMonthOrdersChart[2]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[2]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[2]).toString() + '\n(' + today.subtract(Duration(days: 28)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 28)).month.toString()) + ')'),
            FlSpot(3, (((thisMonthOrdersChart[3]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[3]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[3]).toString() + '\n(' + today.subtract(Duration(days: 27)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 27)).month.toString()) + ')'),
            // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // (thisWeekOrdersChart[4]/1000000) * 3.260
            FlSpot(4, (((thisMonthOrdersChart[4]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[4]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[4]).toString() + '\n(' + today.subtract(Duration(days: 26)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 26)).month.toString()) + ')'),
            FlSpot(5, (((thisMonthOrdersChart[5]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[5]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[5]).toString() + '\n(' + today.subtract(Duration(days: 25)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 25)).month.toString()) + ')'),
            FlSpot(6, (((thisMonthOrdersChart[6]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[6]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[6]).toString() + '\n(' + today.subtract(Duration(days: 24)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 24)).month.toString()) + ')'),

            FlSpot(7, (((thisMonthOrdersChart[7]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[7]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[7]).toString() + '\n(' + today.subtract(Duration(days: 23)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 23)).month.toString()) + ')'),
            FlSpot(8, (((thisMonthOrdersChart[8]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[8]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[8]).toString() + '\n(' + today.subtract(Duration(days: 22)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 22)).month.toString()) + ')'),
            FlSpot(9, (((thisMonthOrdersChart[9]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[9]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[9]).toString() + '\n(' + today.subtract(Duration(days: 21)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 21)).month.toString()) + ')'),
            FlSpot(10, (((thisMonthOrdersChart[10]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[10]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[10]).toString() + '\n(' + today.subtract(Duration(days: 20)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 20)).month.toString()) + ')'),
            // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // (thisWeekOrdersChart[4]/1000000) * 3.260
            FlSpot(11, (((thisMonthOrdersChart[11]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[11]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[11]).toString() + '\n(' + today.subtract(Duration(days: 19)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 19)).month.toString()) + ')'),
            FlSpot(12, (((thisMonthOrdersChart[12]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[12]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[12]).toString() + '\n(' + today.subtract(Duration(days: 18)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 18)).month.toString()) + ')'),
            FlSpot(13, (((thisMonthOrdersChart[13]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[13]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[13]).toString() + '\n(' + today.subtract(Duration(days: 17)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 17)).month.toString()) + ')'),

            FlSpot(14, (((thisMonthOrdersChart[14]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[14]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[14]).toString() + '\n(' + today.subtract(Duration(days: 16)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 16)).month.toString()) + ')'),
            FlSpot(15, (((thisMonthOrdersChart[15]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[15]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[15]).toString() + '\n(' + today.subtract(Duration(days: 15)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 15)).month.toString()) + ')'),
            FlSpot(16, (((thisMonthOrdersChart[16]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[16]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[16]).toString() + '\n(' + today.subtract(Duration(days: 14)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 14)).month.toString()) + ')'),
            FlSpot(17,(((thisMonthOrdersChart[17]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[17]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[17]).toString() + '\n(' + today.subtract(Duration(days: 13)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 13)).month.toString()) + ')'),
            // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // (thisWeekOrdersChart[4]/1000000) * 3.260
            FlSpot(18, (((thisMonthOrdersChart[18]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[18]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[18]).toString() + '\n(' + today.subtract(Duration(days: 12)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 12)).month.toString()) + ')'),
            FlSpot(19, (((thisMonthOrdersChart[19]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[19]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[19]).toString() + '\n(' + today.subtract(Duration(days: 11)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 11)).month.toString()) + ')'),
            FlSpot(20, (((thisMonthOrdersChart[20]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[20]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[20]).toString() + '\n(' + today.subtract(Duration(days: 10)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 10)).month.toString()) + ')'),

            FlSpot(21,(((thisMonthOrdersChart[21]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[21]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[21]).toString() + '\n(' + today.subtract(Duration(days: 9)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 9)).month.toString()) + ')'),
            FlSpot(22, (((thisMonthOrdersChart[22]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[22]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[22]).toString() + '\n(' + today.subtract(Duration(days: 8)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 8)).month.toString()) + ')'),
            FlSpot(23, (((thisMonthOrdersChart[23]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[23]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[23]).toString() + '\n(' + today.subtract(Duration(days: 7)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 7)).month.toString()) + ')'),
            FlSpot(24, (((thisMonthOrdersChart[24]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[24]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[24]).toString() + '\n(' + today.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 6)).month.toString()) + ')'),
            // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
            // (thisWeekOrdersChart[4]/1000000) * 3.260
            FlSpot(25, (((thisMonthOrdersChart[25]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[25]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[25]).toString() + '\n(' + today.subtract(Duration(days: 5)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 5)).month.toString()) + ')'),
            FlSpot(26, (((thisMonthOrdersChart[26]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[26]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[26]).toString() + '\n(' + today.subtract(Duration(days: 4)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 4)).month.toString()) + ')'),
            FlSpot(27, (((thisMonthOrdersChart[27]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[27]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[27]).toString() + '\n(' + today.subtract(Duration(days: 3)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 3)).month.toString()) + ')'),

            FlSpot(28, (((thisMonthOrdersChart[28]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[28]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[28]).toString() + '\n(' + today.subtract(Duration(days: 2)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 2)).month.toString()) + ')'),
            FlSpot(29, (((thisMonthOrdersChart[29]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[29]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[29]).toString() + '\n(' + today.subtract(Duration(days: 1)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 1)).month.toString()) + ')'),
            FlSpot(30, (((thisMonthOrdersChart[30]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[30]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[30]).toString() + '\n(' + today.day.toString() + ', ' + changeMonth2String(today.month.toString()) + ')'),
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
    // print(roundWeek.toString);
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
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
                return today.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(today.subtract(Duration(days: 6)).month.toString());
              case 1:
                return today.subtract(Duration(days: 5)).day.toString();
              case 2:
                return today.subtract(Duration(days: 4)).day.toString();
              case 3:
                return today.subtract(Duration(days: 3)).day.toString();
              case 4:
                return today.subtract(Duration(days: 2)).day.toString();
              case 5:
                return today.subtract(Duration(days: 1)).day.toString();
              case 6:
                return 'Today';
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



            print('value ' + findMax(roundWeek).toString());
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
          const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
            // case 0:
            //   return (int.parse(today.month.toString()) - int.parse(subMonths)).toString();
              case 0:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+1).toString();
              case 1:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+2).toString();
              case 2:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+3).toString();
              case 3:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+4).toString();
              case 4:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+5).toString();
              case 5:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+6).toString();
              case 6:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+7).toString();
              case 7:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+8).toString();
              case 8:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+9).toString();
              case 9:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+10).toString();
              case 10:
                return (int.parse(today.month.toString()) - int.parse(subMonths)+11).toString();
              case 11:
                return today.year.toString();
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



            print('value ' + findMax(roundYear).toString());
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
    // print(findMax(roundWeek));
    max = max/chgDeci3Place(max);
    print('gg ' + (5.0 - max).toString());
    return 5.0 - max;
  }

  double chgDeci3Place(max) {
    double ten = 10.0;
    for(int i = 0; i<max.toString().length - 2; i++) {
      ten = ten * 10;
    }
    return ten;
    // print('length ' + ten.toString().toString());
  }

  int _sliding = 0;


  late final bool showPerformanceOverlay;
  late final ValueChanged<bool> onShowPerformanceOverlayChanged;
  late final a11yGalleries = a11y.buildGallery();
  late final barGalleries = bar.buildGallery();
  late final timeSeriesGalleries = time_series.buildGallery();
  late final lineGalleries = line.buildGallery();
  late final scatterPlotGalleries = scatter_plot.buildGallery();
  late final comboGalleries = combo.buildGallery();
  late final pieGalleries = pie.buildGallery();
  late final axesGalleries = axes.buildGallery();
  late final behaviorsGalleries = behaviors.buildGallery();
  late final i18nGalleries = i18n.buildGallery();
  late final legendsGalleries = legends.buildGallery();

  @override
  Widget build(BuildContext context) {
    var galleries = <Widget>[];

    galleries.addAll(
        a11yGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example bar charts.
    galleries.addAll(
        barGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example time series charts.
    galleries.addAll(timeSeriesGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example line charts.
    galleries.addAll(
        lineGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example scatter plot charts.
    galleries.addAll(scatterPlotGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example pie charts.
    galleries.addAll(
        comboGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example pie charts.
    galleries.addAll(
        pieGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    // Add example custom axis.
    galleries.addAll(
        axesGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    galleries.addAll(behaviorsGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add legends examples
    galleries.addAll(legendsGalleries
        .map((gallery) => gallery.buildGalleryListTile(context)));

    // Add examples for i18n.
    galleries.addAll(
        i18nGalleries.map((gallery) => gallery.buildGalleryListTile(context)));

    _setupPerformance();

    List<int> roundToday = [];
    for(double dbl in todayOrdersChart) {
      roundToday.add(dbl.round());
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        toolbarHeight: 0,
        backgroundColor: Colors.Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width > 900
                      ? MediaQuery.of(context).size.width * (2 / 3.5)
                      : MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 81.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom -
                                100,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 0.0, right: 0.0),


                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('space')
                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                      .collection('shops')
                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                      .collection('products')
                                      .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if(snapshot.hasData) {
                                      return CustomScrollView(
                                        slivers: [

                                          // Add the app bar to the CustomScrollView.
                                          SliverAppBar(
                                            elevation: 0,
                                            backgroundColor: Colors.Colors.white,
                                            bottom: PreferredSize(                       // Add this code
                                              preferredSize: Size.fromHeight(3.0),      // Add this code
                                              child: Container(),                           // Add this code
                                            ),
                                            // Provide a standard title.

                                            // Allows the user to reveal the app bar if they begin scrolling
                                            // back up the list of items.
                                            floating: true,
                                            flexibleSpace: Padding(
                                              padding: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0),
                                              child: Container(
                                                height: 58,
                                                width: MediaQuery.of(context).size.width,
                                                // color: Colors.yellow,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.Colors.white,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          // color: AppTheme.skBorderColor2,
                                                            color: Colors.Colors.white,
                                                            width: 1.0),
                                                      )),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.Colors.white,
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            // color: AppTheme.skBorderColor2,
                                                              color: Colors.Colors.white,
                                                              width: 1.0),
                                                        )),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 12.0, bottom: 11.0, left: 15.0, right: 15.0),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: CupertinoSlidingSegmentedControl(
                                                            children: {
                                                              0: Text('Today'),
                                                              1: Text('Week'),
                                                              2: Text('Month'),
                                                              3: Text('Year'),
                                                            },
                                                            groupValue: _sliding,
                                                            onValueChanged: (newValue) {
                                                              setState(() {
                                                                _sliding = int.parse(newValue.toString());
                                                              });
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ),
                                            ),
                                            // Display a placeholder widget to visualize the shrinking size.
                                            // Make the initial height of the SliverAppBar larger than normal.
                                            expandedHeight: 25,
                                          ),
                                          // Next, create a SliverList

                                          SliverList(
                                            // Use a delegate to build items as they're scrolled on screen.
                                            delegate: SliverChildBuilderDelegate(
                                              // The builder function returns a ListTile with a title that
                                              // displays the index of the current item.
                                                  (context, index) {
                                                    return Container(
                                                      // height: MediaQuery.of(context).size.height-353,
                                                      width: MediaQuery.of(context).size.width,
                                                      color: Colors.Colors.white,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 10,),


                                                            // Jiggle(
                                                            //   jiggleController: controller,
                                                            //   useGestures: true,
                                                            //   extent: 3,
                                                            //   child: Container(
                                                            //     height: 200,
                                                            //     margin: EdgeInsets.all(20),
                                                            //     decoration: BoxDecoration(
                                                            //         color: Colors.Colors.blueAccent,
                                                            //         borderRadius: BorderRadius.circular(20)),
                                                            //   ),
                                                            // ),




                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                              child: Text(
                                                                titleTextBySlide(),
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 13,
                                                                  letterSpacing: 2,
                                                                  color: Colors.Colors.grey,
                                                                ),
                                                              ),
                                                            ),


                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(
                                                            //       left: 7.5, right: 7.5),
                                                            //   child: Row(
                                                            //     children: [
                                                            //       Padding(
                                                            //         padding: const EdgeInsets.only(left: 7.5, right: 7.5),
                                                            //         child: GestureDetector(
                                                            //           onTap: () {
                                                            //             widget._callback();
                                                            //           },
                                                            //           child: Container(
                                                            //             decoration: BoxDecoration(
                                                            //               borderRadius:
                                                            //               BorderRadius.circular(10.0),
                                                            //               color: Colors.Colors.green.withOpacity(0.4),
                                                            //             ),
                                                            //             width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
                                                            //             height: 120,
                                                            //             child: Padding(
                                                            //               padding: const EdgeInsets.all(18.0),
                                                            //               child: Column(
                                                            //                 mainAxisAlignment: MainAxisAlignment.start,
                                                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                 children: [
                                                            //                   Icon(Icons.add_shopping_cart_rounded),
                                                            //                   Expanded(
                                                            //                     child: Align(
                                                            //                       alignment: Alignment.bottomLeft,
                                                            //                       child: Text(
                                                            //                         'Add orders',
                                                            //                         style: TextStyle(
                                                            //                             fontSize: 18,
                                                            //                             fontWeight: FontWeight.w600,
                                                            //                             color: Colors.Colors.black.withOpacity(0.6)
                                                            //                         ),
                                                            //                       ),
                                                            //                     ),
                                                            //                   )
                                                            //                 ],
                                                            //               ),
                                                            //             ),
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: const EdgeInsets.only(
                                                            //             left: 7.5, right: 7.5),
                                                            //         child: Container(
                                                            //           decoration: BoxDecoration(
                                                            //             borderRadius:
                                                            //             BorderRadius.circular(10.0),
                                                            //             color: Colors.Colors.blue.withOpacity(0.4),
                                                            //           ),
                                                            //           width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
                                                            //           height: 120,
                                                            //           child: Padding(
                                                            //             padding: const EdgeInsets.all(18.0),
                                                            //             child: Column(
                                                            //               mainAxisAlignment: MainAxisAlignment.start,
                                                            //               crossAxisAlignment: CrossAxisAlignment.start,
                                                            //               children: [
                                                            //                 Icon(Icons.volunteer_activism),
                                                            //                 Expanded(
                                                            //                     child: Align(
                                                            //                       alignment: Alignment.bottomLeft,
                                                            //                       child: TextButton(
                                                            //                         onPressed: (){
                                                            //                           Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyDiscount()
                                                            //                           ),
                                                            //                           );
                                                            //                         },
                                                            //                         child: Text('Add discount',
                                                            //                           style: TextStyle(
                                                            //                               fontSize: 18,
                                                            //                               fontWeight: FontWeight.w600,
                                                            //                               color: Colors.Colors.black.withOpacity(0.6)
                                                            //                           ),),
                                                            //                       ),
                                                            //                     )
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //     ],
                                                            //   ),
                                                            // ),

                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 20.0),
                                                            //   child: Container(
                                                            //     child: Row(
                                                            //       children: [
                                                            //         Text('5,503,230 MMKs',
                                                            //           textAlign: TextAlign.left,
                                                            //           style: TextStyle(
                                                            //               fontSize: 20,
                                                            //               fontWeight: FontWeight.w600,
                                                            //               color: Colors.Colors.black),
                                                            //         ),
                                                            //         Expanded(
                                                            //           child: GestureDetector(
                                                            //             onTap: () {
                                                            //               Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
                                                            //             },
                                                            //             child: Text('12%',
                                                            //               textAlign: TextAlign.right,
                                                            //               style: TextStyle(
                                                            //                   fontSize: 20,
                                                            //                   fontWeight: FontWeight.w600,
                                                            //                   color: Colors.Colors.green),
                                                            //             ),
                                                            //           ),
                                                            //         )
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // ),

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
                                                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 2.0),
                                                                    child: Container(
                                                                      child: Row(
                                                                        children: [
                                                                          Text(totalBySlide(),
                                                                            textAlign: TextAlign.left,
                                                                            style: GoogleFonts.lato(
                                                                                textStyle: TextStyle(
                                                                                    letterSpacing: 1,
                                                                                    fontSize: 30,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.Colors.black
                                                                                )
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 12.0),
                                                                            child: Text(' MMK',
                                                                              textAlign: TextAlign.left,
                                                                              style: GoogleFonts.roboto(
                                                                                  textStyle: TextStyle(
                                                                                      letterSpacing: 1,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.Colors.black
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
                                                                                color: Colors.Colors.green,
                                                                              ),
                                                                              width: 50,
                                                                              height: 25,
                                                                              child: Center(
                                                                                child: Text('12%',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Text('Total sales',
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.Colors.black),
                                                                        ),
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Text('View detail',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.Colors.blue),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 4.5),
                                                                                  child: Container(
                                                                                    width: 25,
                                                                                    height: 25,
                                                                                    child: IconButton(
                                                                                        icon: Icon(
                                                                                          Icons.arrow_forward_ios_rounded,
                                                                                          size: 13,
                                                                                          color: Colors.Colors.blue,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                        }),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
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
                                                                                      child: Text('203,230',
                                                                                        textAlign: TextAlign.left,
                                                                                        style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(
                                                                                                letterSpacing: 1,
                                                                                                fontSize: 20,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.Colors.black
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
                                                                                Text('Net Profit',
                                                                                  style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.Colors.black.withOpacity(0.6)),
                                                                                ),

                                                                                Positioned(
                                                                                    right: 0,
                                                                                    bottom: 2,
                                                                                    child: Text('+20%',
                                                                                      style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.Colors.green),
                                                                                    )
                                                                                ),
                                                                                Positioned(
                                                                                  left: 0,
                                                                                  bottom: 2,
                                                                                  child: Text('MMK',
                                                                                    style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.Colors.black.withOpacity(0.6)),
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
                                                                                      child: Text('3,230',
                                                                                        textAlign: TextAlign.left,
                                                                                        style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(
                                                                                                letterSpacing: 1,
                                                                                                fontSize: 20,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.Colors.black
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
                                                                                Text('Debts',
                                                                                  style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.Colors.black.withOpacity(0.6)),
                                                                                ),

                                                                                Positioned(
                                                                                    right: 0,
                                                                                    bottom: 2,
                                                                                    child: Text('+2%',
                                                                                      style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.Colors.red),
                                                                                    )
                                                                                ),
                                                                                Positioned(
                                                                                  left: 0,
                                                                                  bottom: 2,
                                                                                  child: Text('MMK',
                                                                                    style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.Colors.black.withOpacity(0.6)),
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
                                                                                      child: Text('1,903,230',
                                                                                        textAlign: TextAlign.left,
                                                                                        style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(
                                                                                                letterSpacing: 1,
                                                                                                fontSize: 20,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.Colors.black
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
                                                                                Text('Buys',
                                                                                  style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.Colors.black.withOpacity(0.6)),
                                                                                ),

                                                                                Positioned(
                                                                                    right: 0,
                                                                                    bottom: 2,
                                                                                    child: Text('+20%',
                                                                                      style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.Colors.green),
                                                                                    )
                                                                                ),
                                                                                Positioned(
                                                                                  left: 0,
                                                                                  bottom: 2,
                                                                                  child: Text('MMK',
                                                                                    style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.Colors.black.withOpacity(0.6)),
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
                                                                              color: Colors.Colors.white
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
                                                                                      child: Text('230',
                                                                                        textAlign: TextAlign.left,
                                                                                        style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(
                                                                                                letterSpacing: 1,
                                                                                                fontSize: 20,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.Colors.black
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
                                                                                Text('Refunds',
                                                                                  style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.Colors.black.withOpacity(0.6)),
                                                                                ),

                                                                                Positioned(
                                                                                    right: 0,
                                                                                    bottom: 2,
                                                                                    child: Text('+20%',
                                                                                      style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.Colors.blue),
                                                                                    )
                                                                                ),
                                                                                Positioned(
                                                                                  left: 0,
                                                                                  bottom: 2,
                                                                                  child: Text('MMK',
                                                                                    style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.Colors.black.withOpacity(0.6)),
                                                                                  ),
                                                                                ),
                                                                                // Container(
                                                                                //     constraints: BoxConstraints(
                                                                                //         maxWidth: double.infinity, minWidth: 100, maxHeight: 30),
                                                                                //   // color: Colors.Colors.blue,
                                                                                //   child: Row(
                                                                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                                                                //     children: [
                                                                                //       Text('Net Profit',
                                                                                //         style: TextStyle(
                                                                                //             fontSize: 15,
                                                                                //             fontWeight: FontWeight.w500,
                                                                                //             color: Colors.Colors.black.withOpacity(0.8)),
                                                                                //       ),
                                                                                //       Align(
                                                                                //         alignment: Alignment.topRight,
                                                                                //         child: Text('?')
                                                                                //       )],
                                                                                //   ),
                                                                                // ),
                                                                                //
                                                                                //
                                                                                // Align(
                                                                                //   alignment: Alignment.bottomLeft,
                                                                                //   child: Container(
                                                                                //     constraints: BoxConstraints(
                                                                                //         maxWidth: double.infinity, minWidth: 100, maxHeight: 30),
                                                                                //     // color: Colors.Colors.blue,
                                                                                //     child: Row(
                                                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                                                                //       children: [
                                                                                //         Text('MMK',
                                                                                //           style: TextStyle(
                                                                                //               fontSize: 15,
                                                                                //               fontWeight: FontWeight.w500,
                                                                                //               color: Colors.Colors.black.withOpacity(0.8)),
                                                                                //         ),
                                                                                //         Align(
                                                                                //             alignment: Alignment.bottomRight,
                                                                                //             child: Text('+12%',
                                                                                //               style: TextStyle(
                                                                                //                   fontSize: 15,
                                                                                //                   fontWeight: FontWeight.w500,
                                                                                //                   color: Colors.Colors.black.withOpacity(0.8)),
                                                                                //             )
                                                                                //         )],
                                                                                //     ),
                                                                                //   ),
                                                                                // )

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
                                                                      height: 0.0
                                                                  ),
                                                                  Stack(
                                                                    children: [

                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 10.0),
                                                                        child: AspectRatio(
                                                                          aspectRatio: 1.5,
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                              // color: Color(0xffFFFFFF)),
                                                                              // color: Colors.Colors.white,
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
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 15.0, right: 15.0),
                                                                    child: Container(
                                                                      height: 2,
                                                                      color: Colors.Colors.grey.withOpacity(0.1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              height: 0,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(10.0),
                                                                    ),
                                                                    border: Border(
                                                                      bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                                                      top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                                                      left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                                                      right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                                                    ),
                                                                    color: AppTheme.lightBgColor
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                                                                      child: Row(
                                                                        children: [
                                                                          Text('Top sale categories',
                                                                            textAlign: TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.Colors.black),
                                                                          ),
                                                                          Expanded(
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
                                                                              },
                                                                              child: Text('Detail',
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.Colors.blue),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 15.0),
                                                                      child: Container(
                                                                        height: 1,
                                                                        color: AppTheme.skBorderColor2,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                                                                      child: Container(
                                                                        width: double.infinity,
                                                                        height: 150,
                                                                        child: Container(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(0.0),
                                                                            child: new SimplePieChart.withRandomData(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
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
                                                            //           fontSize: 12, color: showAvg ? Colors.Colors.white.withOpacity(0.5) : Colors.Colors.white),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                              },
                                              // Builds 1000 ListTiles
                                              childCount: 1,
                                            ),
                                          ),

                                          // SliverFillRemaining(
                                          //   child: Container(
                                          //     // height: MediaQuery.of(context).size.height-353,
                                          //     width: MediaQuery.of(context).size.width,
                                          //     color: AppTheme.skBorderColor,
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
                                          //       child: ListView(
                                          //         children: [
                                          //           SizedBox(height: 15,),
                                          //
                                          //
                                          //           // Jiggle(
                                          //           //   jiggleController: controller,
                                          //           //   useGestures: true,
                                          //           //   extent: 3,
                                          //           //   child: Container(
                                          //           //     height: 200,
                                          //           //     margin: EdgeInsets.all(20),
                                          //           //     decoration: BoxDecoration(
                                          //           //         color: Colors.Colors.blueAccent,
                                          //           //         borderRadius: BorderRadius.circular(20)),
                                          //           //   ),
                                          //           // ),
                                          //
                                          //
                                          //
                                          //
                                          //           Padding(
                                          //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          //             child: Text(
                                          //               titleTextBySlide(),
                                          //               style: TextStyle(
                                          //                 fontWeight: FontWeight.bold,
                                          //                 fontSize: 13,
                                          //                 letterSpacing: 2,
                                          //                 color: Colors.Colors.grey,
                                          //               ),
                                          //             ),
                                          //           ),
                                          //
                                          //
                                          //           // Padding(
                                          //           //   padding: const EdgeInsets.only(
                                          //           //       left: 7.5, right: 7.5),
                                          //           //   child: Row(
                                          //           //     children: [
                                          //           //       Padding(
                                          //           //         padding: const EdgeInsets.only(left: 7.5, right: 7.5),
                                          //           //         child: GestureDetector(
                                          //           //           onTap: () {
                                          //           //             widget._callback();
                                          //           //           },
                                          //           //           child: Container(
                                          //           //             decoration: BoxDecoration(
                                          //           //               borderRadius:
                                          //           //               BorderRadius.circular(10.0),
                                          //           //               color: Colors.Colors.green.withOpacity(0.4),
                                          //           //             ),
                                          //           //             width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
                                          //           //             height: 120,
                                          //           //             child: Padding(
                                          //           //               padding: const EdgeInsets.all(18.0),
                                          //           //               child: Column(
                                          //           //                 mainAxisAlignment: MainAxisAlignment.start,
                                          //           //                 crossAxisAlignment: CrossAxisAlignment.start,
                                          //           //                 children: [
                                          //           //                   Icon(Icons.add_shopping_cart_rounded),
                                          //           //                   Expanded(
                                          //           //                     child: Align(
                                          //           //                       alignment: Alignment.bottomLeft,
                                          //           //                       child: Text(
                                          //           //                         'Add orders',
                                          //           //                         style: TextStyle(
                                          //           //                             fontSize: 18,
                                          //           //                             fontWeight: FontWeight.w600,
                                          //           //                             color: Colors.Colors.black.withOpacity(0.6)
                                          //           //                         ),
                                          //           //                       ),
                                          //           //                     ),
                                          //           //                   )
                                          //           //                 ],
                                          //           //               ),
                                          //           //             ),
                                          //           //           ),
                                          //           //         ),
                                          //           //       ),
                                          //           //       Padding(
                                          //           //         padding: const EdgeInsets.only(
                                          //           //             left: 7.5, right: 7.5),
                                          //           //         child: Container(
                                          //           //           decoration: BoxDecoration(
                                          //           //             borderRadius:
                                          //           //             BorderRadius.circular(10.0),
                                          //           //             color: Colors.Colors.blue.withOpacity(0.4),
                                          //           //           ),
                                          //           //           width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
                                          //           //           height: 120,
                                          //           //           child: Padding(
                                          //           //             padding: const EdgeInsets.all(18.0),
                                          //           //             child: Column(
                                          //           //               mainAxisAlignment: MainAxisAlignment.start,
                                          //           //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //           //               children: [
                                          //           //                 Icon(Icons.volunteer_activism),
                                          //           //                 Expanded(
                                          //           //                     child: Align(
                                          //           //                       alignment: Alignment.bottomLeft,
                                          //           //                       child: TextButton(
                                          //           //                         onPressed: (){
                                          //           //                           Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyDiscount()
                                          //           //                           ),
                                          //           //                           );
                                          //           //                         },
                                          //           //                         child: Text('Add discount',
                                          //           //                           style: TextStyle(
                                          //           //                               fontSize: 18,
                                          //           //                               fontWeight: FontWeight.w600,
                                          //           //                               color: Colors.Colors.black.withOpacity(0.6)
                                          //           //                           ),),
                                          //           //                       ),
                                          //           //                     )
                                          //           //                 ),
                                          //           //               ],
                                          //           //             ),
                                          //           //           ),
                                          //           //         ),
                                          //           //       ),
                                          //           //     ],
                                          //           //   ),
                                          //           // ),
                                          //
                                          //           SizedBox(
                                          //             height: 2,
                                          //           ),
                                          //           // Padding(
                                          //           //   padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 20.0),
                                          //           //   child: Container(
                                          //           //     child: Row(
                                          //           //       children: [
                                          //           //         Text('5,503,230 MMKs',
                                          //           //           textAlign: TextAlign.left,
                                          //           //           style: TextStyle(
                                          //           //               fontSize: 20,
                                          //           //               fontWeight: FontWeight.w600,
                                          //           //               color: Colors.Colors.black),
                                          //           //         ),
                                          //           //         Expanded(
                                          //           //           child: GestureDetector(
                                          //           //             onTap: () {
                                          //           //               Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
                                          //           //             },
                                          //           //             child: Text('12%',
                                          //           //               textAlign: TextAlign.right,
                                          //           //               style: TextStyle(
                                          //           //                   fontSize: 20,
                                          //           //                   fontWeight: FontWeight.w600,
                                          //           //                   color: Colors.Colors.green),
                                          //           //             ),
                                          //           //           ),
                                          //           //         )
                                          //           //       ],
                                          //           //     ),
                                          //           //   ),
                                          //           // ),
                                          //
                                          //           Container(
                                          //             decoration: BoxDecoration(
                                          //               borderRadius: BorderRadius.all(
                                          //                 Radius.circular(10.0),
                                          //               ),
                                          //             ),
                                          //             child: Column(
                                          //               mainAxisAlignment: MainAxisAlignment.start,
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //
                                          //                 // Padding(
                                          //                 //   padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                                          //                 //   child: Container(
                                          //                 //     height: 1,
                                          //                 //     color: AppTheme.skBorderColor2,
                                          //                 //   ),
                                          //                 // ),
                                          //                 Padding(
                                          //                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 2.0),
                                          //                   child: Container(
                                          //                     child: Row(
                                          //                       children: [
                                          //                         Text(totalBySlide(),
                                          //                           textAlign: TextAlign.left,
                                          //                           style: GoogleFonts.lato(
                                          //                               textStyle: TextStyle(
                                          //                                   letterSpacing: 1,
                                          //                                   fontSize: 30,
                                          //                                   fontWeight: FontWeight.w600,
                                          //                                   color: Colors.Colors.black
                                          //                               )
                                          //                           ),
                                          //                         ),
                                          //                         Padding(
                                          //                           padding: const EdgeInsets.only(top: 12.0),
                                          //                           child: Text(' MMK',
                                          //                             textAlign: TextAlign.left,
                                          //                             style: GoogleFonts.roboto(
                                          //                                 textStyle: TextStyle(
                                          //                                     letterSpacing: 1,
                                          //                                     fontSize: 16,
                                          //                                     fontWeight: FontWeight.w600,
                                          //                                     color: Colors.Colors.black
                                          //                                 )
                                          //                             ),
                                          //                           ),
                                          //                         ),
                                          //                         Expanded(
                                          //                           child: Container(),
                                          //                         ),
                                          //                         Padding(
                                          //                           padding: const EdgeInsets.only(top: 3.0),
                                          //                           child: Container(
                                          //                             decoration: BoxDecoration(
                                          //                               borderRadius: BorderRadius.all(
                                          //                                 Radius.circular(5.0),
                                          //                               ),
                                          //                               color: Colors.Colors.green,
                                          //                             ),
                                          //                             width: 50,
                                          //                             height: 25,
                                          //                             child: Center(
                                          //                               child: Text('12%',
                                          //                                 textAlign: TextAlign.right,
                                          //                                 style: TextStyle(
                                          //                                     fontSize: 15,
                                          //                                     fontWeight: FontWeight.w600,
                                          //                                     color: Colors.Colors.white),
                                          //                               ),
                                          //                             ),
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
                                          //                   child: Row(
                                          //                     children: [
                                          //                       Text('Total sales',
                                          //                         textAlign: TextAlign.left,
                                          //                         style: TextStyle(
                                          //                             fontSize: 15,
                                          //                             fontWeight: FontWeight.w500,
                                          //                             color: Colors.Colors.black),
                                          //                       ),
                                          //                       Expanded(
                                          //                         child: GestureDetector(
                                          //                           onTap: () {
                                          //                             Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
                                          //                           },
                                          //                           child: Row(
                                          //                             mainAxisAlignment: MainAxisAlignment.end,
                                          //                             // crossAxisAlignment: CrossAxisAlignment.end,
                                          //                             children: [
                                          //                               Text('View detail',
                                          //                                 textAlign: TextAlign.right,
                                          //                                 style: TextStyle(
                                          //                                     fontSize: 15,
                                          //                                     fontWeight: FontWeight.w500,
                                          //                                     color: Colors.Colors.blue),
                                          //                               ),
                                          //                               Padding(
                                          //                                 padding: const EdgeInsets.only(bottom: 4.5),
                                          //                                 child: Container(
                                          //                                   width: 25,
                                          //                                   height: 25,
                                          //                                   child: IconButton(
                                          //                                       icon: Icon(
                                          //                                         Icons.arrow_forward_ios_rounded,
                                          //                                         size: 13,
                                          //                                         color: Colors.Colors.blue,
                                          //                                       ),
                                          //                                       onPressed: () {
                                          //                                       }),
                                          //                                 ),
                                          //                               )
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                       )
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 8,
                                          //                 ),
                                          //                 Container(
                                          //                   height: 100,
                                          //                   child: ListView(
                                          //
                                          //                     scrollDirection: Axis.horizontal,
                                          //                     children: [
                                          //                       SizedBox(
                                          //                         width: 15,
                                          //                       ),
                                          //                       Container(
                                          //                         // width: 100,
                                          //                         height: 108,
                                          //
                                          //                         constraints: BoxConstraints(
                                          //                             maxWidth: double.infinity, minWidth: 120),
                                          //                         decoration: BoxDecoration(
                                          //                             borderRadius: BorderRadius.circular(8),
                                          //                             border: Border(
                                          //                               bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                             ),
                                          //                             color: Colors.Colors.white
                                          //                         ),
                                          //
                                          //                         child: Padding(
                                          //                           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                          //                           child: Stack(
                                          //                             children: [
                                          //                               Column(
                                          //                                 mainAxisAlignment: MainAxisAlignment.start,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                                          //                                 children: [
                                          //                                   SizedBox(
                                          //                                       height:26
                                          //                                   ),
                                          //                                   Padding(
                                          //                                     padding: const EdgeInsets.only(right:30.0),
                                          //                                     child: Text('203,230',
                                          //                                       textAlign: TextAlign.left,
                                          //                                       style: GoogleFonts.lato(
                                          //                                           textStyle: TextStyle(
                                          //                                               letterSpacing: 1,
                                          //                                               fontSize: 20,
                                          //                                               fontWeight: FontWeight.w600,
                                          //                                               color: Colors.Colors.black
                                          //                                           )
                                          //                                       ),
                                          //                                     ),
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   top: 0,
                                          //                                   child: Text('?')
                                          //                               ),
                                          //                               Text('Net Profit',
                                          //                                 style: TextStyle(
                                          //                                     fontSize: 13,
                                          //                                     fontWeight: FontWeight.w500,
                                          //                                     color: Colors.Colors.black.withOpacity(0.6)),
                                          //                               ),
                                          //
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   bottom: 2,
                                          //                                   child: Text('+20%',
                                          //                                     style: TextStyle(
                                          //                                         fontSize: 13,
                                          //                                         fontWeight: FontWeight.w500,
                                          //                                         color: Colors.Colors.green),
                                          //                                   )
                                          //                               ),
                                          //                               Positioned(
                                          //                                 left: 0,
                                          //                                 bottom: 2,
                                          //                                 child: Text('MMK',
                                          //                                   style: TextStyle(
                                          //                                       fontSize: 13,
                                          //                                       fontWeight: FontWeight.w500,
                                          //                                       color: Colors.Colors.black.withOpacity(0.6)),
                                          //                                 ),
                                          //                               ),
                                          //
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                       SizedBox(
                                          //                         width: 15,
                                          //                       ),
                                          //
                                          //                       Container(
                                          //                         // width: 100,
                                          //                         height: 108,
                                          //
                                          //                         constraints: BoxConstraints(
                                          //                             maxWidth: double.infinity, minWidth: 120),
                                          //                         decoration: BoxDecoration(
                                          //                             borderRadius: BorderRadius.circular(8),
                                          //                             border: Border(
                                          //                               bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                             ),
                                          //                             color: Colors.Colors.white
                                          //                         ),
                                          //
                                          //                         child: Padding(
                                          //                           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                          //                           child: Stack(
                                          //                             children: [
                                          //                               Column(
                                          //                                 mainAxisAlignment: MainAxisAlignment.start,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                                          //                                 children: [
                                          //                                   SizedBox(
                                          //                                       height:26
                                          //                                   ),
                                          //                                   Padding(
                                          //                                     padding: const EdgeInsets.only(right:30.0),
                                          //                                     child: Text('3,230',
                                          //                                       textAlign: TextAlign.left,
                                          //                                       style: GoogleFonts.lato(
                                          //                                           textStyle: TextStyle(
                                          //                                               letterSpacing: 1,
                                          //                                               fontSize: 20,
                                          //                                               fontWeight: FontWeight.w600,
                                          //                                               color: Colors.Colors.black
                                          //                                           )
                                          //                                       ),
                                          //                                     ),
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   top: 0,
                                          //                                   child: Text('?')
                                          //                               ),
                                          //                               Text('Debts',
                                          //                                 style: TextStyle(
                                          //                                     fontSize: 13,
                                          //                                     fontWeight: FontWeight.w500,
                                          //                                     color: Colors.Colors.black.withOpacity(0.6)),
                                          //                               ),
                                          //
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   bottom: 2,
                                          //                                   child: Text('+2%',
                                          //                                     style: TextStyle(
                                          //                                         fontSize: 13,
                                          //                                         fontWeight: FontWeight.w500,
                                          //                                         color: Colors.Colors.red),
                                          //                                   )
                                          //                               ),
                                          //                               Positioned(
                                          //                                 left: 0,
                                          //                                 bottom: 2,
                                          //                                 child: Text('MMK',
                                          //                                   style: TextStyle(
                                          //                                       fontSize: 13,
                                          //                                       fontWeight: FontWeight.w500,
                                          //                                       color: Colors.Colors.black.withOpacity(0.6)),
                                          //                                 ),
                                          //                               ),
                                          //
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                       SizedBox(
                                          //                         width: 15,
                                          //                       ),
                                          //
                                          //                       Container(
                                          //                         // width: 100,
                                          //                         height: 108,
                                          //
                                          //                         constraints: BoxConstraints(
                                          //                             maxWidth: double.infinity, minWidth: 120),
                                          //                         decoration: BoxDecoration(
                                          //                             borderRadius: BorderRadius.circular(8),
                                          //                             border: Border(
                                          //                               bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                             ),
                                          //                             color: Colors.Colors.white
                                          //                         ),
                                          //
                                          //                         child: Padding(
                                          //                           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                          //                           child: Stack(
                                          //                             children: [
                                          //                               Column(
                                          //                                 mainAxisAlignment: MainAxisAlignment.start,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                                          //                                 children: [
                                          //                                   SizedBox(
                                          //                                       height:26
                                          //                                   ),
                                          //                                   Padding(
                                          //                                     padding: const EdgeInsets.only(right:30.0),
                                          //                                     child: Text('1,903,230',
                                          //                                       textAlign: TextAlign.left,
                                          //                                       style: GoogleFonts.lato(
                                          //                                           textStyle: TextStyle(
                                          //                                               letterSpacing: 1,
                                          //                                               fontSize: 20,
                                          //                                               fontWeight: FontWeight.w600,
                                          //                                               color: Colors.Colors.black
                                          //                                           )
                                          //                                       ),
                                          //                                     ),
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   top: 0,
                                          //                                   child: Text('?')
                                          //                               ),
                                          //                               Text('Buys',
                                          //                                 style: TextStyle(
                                          //                                     fontSize: 13,
                                          //                                     fontWeight: FontWeight.w500,
                                          //                                     color: Colors.Colors.black.withOpacity(0.6)),
                                          //                               ),
                                          //
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   bottom: 2,
                                          //                                   child: Text('+20%',
                                          //                                     style: TextStyle(
                                          //                                         fontSize: 13,
                                          //                                         fontWeight: FontWeight.w500,
                                          //                                         color: Colors.Colors.green),
                                          //                                   )
                                          //                               ),
                                          //                               Positioned(
                                          //                                 left: 0,
                                          //                                 bottom: 2,
                                          //                                 child: Text('MMK',
                                          //                                   style: TextStyle(
                                          //                                       fontSize: 13,
                                          //                                       fontWeight: FontWeight.w500,
                                          //                                       color: Colors.Colors.black.withOpacity(0.6)),
                                          //                                 ),
                                          //                               ),
                                          //
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                       SizedBox(
                                          //                         width: 15,
                                          //                       ),
                                          //
                                          //                       Container(
                                          //                         // width: 100,
                                          //                         height: 100,
                                          //                         constraints: BoxConstraints(
                                          //                             maxWidth: double.infinity, minWidth: 120),
                                          //                         decoration: BoxDecoration(
                                          //                             borderRadius: BorderRadius.circular(8),
                                          //                             border: Border(
                                          //                               bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                               right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
                                          //                             ),
                                          //                             color: Colors.Colors.white
                                          //                         ),
                                          //
                                          //                         child: Padding(
                                          //                           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                          //                           child: Stack(
                                          //                             children: [
                                          //                               Column(
                                          //                                 mainAxisAlignment: MainAxisAlignment.start,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                                          //                                 children: [
                                          //                                   SizedBox(
                                          //                                       height:26
                                          //                                   ),
                                          //                                   Padding(
                                          //                                     padding: const EdgeInsets.only(right:30.0),
                                          //                                     child: Text('230',
                                          //                                       textAlign: TextAlign.left,
                                          //                                       style: GoogleFonts.lato(
                                          //                                           textStyle: TextStyle(
                                          //                                               letterSpacing: 1,
                                          //                                               fontSize: 20,
                                          //                                               fontWeight: FontWeight.w600,
                                          //                                               color: Colors.Colors.black
                                          //                                           )
                                          //                                       ),
                                          //                                     ),
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   top: 0,
                                          //                                   child: Text('?')
                                          //                               ),
                                          //                               Text('Refunds',
                                          //                                 style: TextStyle(
                                          //                                     fontSize: 13,
                                          //                                     fontWeight: FontWeight.w500,
                                          //                                     color: Colors.Colors.black.withOpacity(0.6)),
                                          //                               ),
                                          //
                                          //                               Positioned(
                                          //                                   right: 0,
                                          //                                   bottom: 2,
                                          //                                   child: Text('+20%',
                                          //                                     style: TextStyle(
                                          //                                         fontSize: 13,
                                          //                                         fontWeight: FontWeight.w500,
                                          //                                         color: Colors.Colors.blue),
                                          //                                   )
                                          //                               ),
                                          //                               Positioned(
                                          //                                 left: 0,
                                          //                                 bottom: 2,
                                          //                                 child: Text('MMK',
                                          //                                   style: TextStyle(
                                          //                                       fontSize: 13,
                                          //                                       fontWeight: FontWeight.w500,
                                          //                                       color: Colors.Colors.black.withOpacity(0.6)),
                                          //                                 ),
                                          //                               ),
                                          //                               // Container(
                                          //                               //     constraints: BoxConstraints(
                                          //                               //         maxWidth: double.infinity, minWidth: 100, maxHeight: 30),
                                          //                               //   // color: Colors.Colors.blue,
                                          //                               //   child: Row(
                                          //                               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //                               //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //                               //     children: [
                                          //                               //       Text('Net Profit',
                                          //                               //         style: TextStyle(
                                          //                               //             fontSize: 15,
                                          //                               //             fontWeight: FontWeight.w500,
                                          //                               //             color: Colors.Colors.black.withOpacity(0.8)),
                                          //                               //       ),
                                          //                               //       Align(
                                          //                               //         alignment: Alignment.topRight,
                                          //                               //         child: Text('?')
                                          //                               //       )],
                                          //                               //   ),
                                          //                               // ),
                                          //                               //
                                          //                               //
                                          //                               // Align(
                                          //                               //   alignment: Alignment.bottomLeft,
                                          //                               //   child: Container(
                                          //                               //     constraints: BoxConstraints(
                                          //                               //         maxWidth: double.infinity, minWidth: 100, maxHeight: 30),
                                          //                               //     // color: Colors.Colors.blue,
                                          //                               //     child: Row(
                                          //                               //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //                               //       crossAxisAlignment: CrossAxisAlignment.end,
                                          //                               //       children: [
                                          //                               //         Text('MMK',
                                          //                               //           style: TextStyle(
                                          //                               //               fontSize: 15,
                                          //                               //               fontWeight: FontWeight.w500,
                                          //                               //               color: Colors.Colors.black.withOpacity(0.8)),
                                          //                               //         ),
                                          //                               //         Align(
                                          //                               //             alignment: Alignment.bottomRight,
                                          //                               //             child: Text('+12%',
                                          //                               //               style: TextStyle(
                                          //                               //                   fontSize: 15,
                                          //                               //                   fontWeight: FontWeight.w500,
                                          //                               //                   color: Colors.Colors.black.withOpacity(0.8)),
                                          //                               //             )
                                          //                               //         )],
                                          //                               //     ),
                                          //                               //   ),
                                          //                               // )
                                          //
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                       SizedBox(
                                          //                         width: 15,
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                     height: 0.0
                                          //                 ),
                                          //                 Stack(
                                          //                   children: [
                                          //
                                          //                     Padding(
                                          //                       padding: const EdgeInsets.only(right: 10.0),
                                          //                       child: AspectRatio(
                                          //                         aspectRatio: 1.5,
                                          //                         child: Container(
                                          //                           decoration: const BoxDecoration(
                                          //                             borderRadius: BorderRadius.all(
                                          //                               Radius.circular(15),
                                          //                             ),
                                          //                             // color: Color(0xffFFFFFF)),
                                          //                             // color: Colors.Colors.white,
                                          //                           ),
                                          //                           child: Padding(
                                          //                             padding: const EdgeInsets.only(right: 18.0, left: 8.0, top: 10, bottom: 10),
                                          //                             child: lineChartByTab(),
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                     ),
                                          //                     // Container(
                                          //                     //     width: double.infinity,
                                          //                     //     height: 15,
                                          //                     //     color: AppTheme.skBorderColor
                                          //                     // ),
                                          //                   ],
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 15.0, right: 15.0),
                                          //                   child: Container(
                                          //                     height: 2,
                                          //                     color: AppTheme.skBorderColor2,
                                          //                   ),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //
                                          //           SizedBox(
                                          //             height: 0,
                                          //           ),
                                          //           Padding(
                                          //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          //             child: Container(
                                          //               decoration: BoxDecoration(
                                          //                   borderRadius: BorderRadius.all(
                                          //                     Radius.circular(10.0),
                                          //                   ),
                                          //                   color: Colors.Colors.white
                                          //               ),
                                          //               child: Column(
                                          //                 mainAxisAlignment: MainAxisAlignment.start,
                                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                                          //                 children: [
                                          //                   Padding(
                                          //                     padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                                          //                     child: Row(
                                          //                       children: [
                                          //                         Text('Top sale categories',
                                          //                           textAlign: TextAlign.left,
                                          //                           style: TextStyle(
                                          //                               fontSize: 15,
                                          //                               fontWeight: FontWeight.w500,
                                          //                               color: Colors.Colors.black),
                                          //                         ),
                                          //                         Expanded(
                                          //                           child: GestureDetector(
                                          //                             onTap: () {
                                          //                               Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
                                          //                             },
                                          //                             child: Text('Detail',
                                          //                               textAlign: TextAlign.right,
                                          //                               style: TextStyle(
                                          //                                   fontSize: 15,
                                          //                                   fontWeight: FontWeight.w500,
                                          //                                   color: Colors.Colors.blue),
                                          //                             ),
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                   Padding(
                                          //                     padding: const EdgeInsets.only(top: 15.0),
                                          //                     child: Container(
                                          //                       height: 1,
                                          //                       color: AppTheme.skBorderColor2,
                                          //                     ),
                                          //                   ),
                                          //                   Padding(
                                          //                     padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                                          //                     child: Container(
                                          //                       width: double.infinity,
                                          //                       height: 150,
                                          //                       child: Container(
                                          //                         child: Padding(
                                          //                           padding: const EdgeInsets.all(0.0),
                                          //                           child: new SimplePieChart.withRandomData(),
                                          //                         ),
                                          //                       ),
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           SizedBox(
                                          //             height: 20,
                                          //           ),
                                          //           // SizedBox(
                                          //           //   width: 60,
                                          //           //   height: 34,
                                          //           //   child: TextButton(
                                          //           //     onPressed: () {
                                          //           //       setState(() {
                                          //           //         showAvg = !showAvg;
                                          //           //       });
                                          //           //     },
                                          //           //     child: Text(
                                          //           //       'avg',
                                          //           //       style: TextStyle(
                                          //           //           fontSize: 12, color: showAvg ? Colors.Colors.white.withOpacity(0.5) : Colors.Colors.white),
                                          //           //     ),
                                          //           //   ),
                                          //           // ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      );
                                    }
                                    return Container();
                                  }
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                    color: AppTheme.skBorderColor2,
                                    width: 1.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 15.0, right: 15.0, bottom: 15),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(nodeFirst);
                                setState(() {
                                  loadingSearch = true;
                                });
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: AppTheme.secButtonColor,
                                ),
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 11.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                        ),
                                        child: Icon(
                                          SmartKyat_POS.search,
                                          size: 17,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                right: 5.0,
                                                top: 0.5),
                                            // child: Container(
                                            //     child: Text(
                                            //       'Search',
                                            //       textAlign: TextAlign.left,
                                            //       style: TextStyle(
                                            //           fontSize: 18,
                                            //           fontWeight: FontWeight.w500,
                                            //           color: Colors.black),
                                            //     )
                                            // ),
                                            child: TextField(
                                              textInputAction: TextInputAction.search,
                                              focusNode: nodeFirst,
                                              controller: _searchController,
                                              onSubmitted: (value) async {
                                                setState(() {
                                                  searchValue = value;
                                                });
                                                searchKeyChanged();
                                              },
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.Colors.black
                                              ),

                                              decoration: InputDecoration(
                                                hintText: 'Search',
                                                isDense: true,
                                                // contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                                                enabledBorder: const OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: Colors.Colors.transparent, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                                focusedBorder: const OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: Colors.Colors.transparent, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                //filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              keyboardType: TextInputType.text,
                                              onChanged: (value) {
                                                // setState(() {
                                                //   quantity = int.parse(value);
                                                // });
                                              },
                                              // controller: myController,
                                            )
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print('open barcode');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 18.0,
                                          ),
                                          // child: Icon(
                                          //   SmartKyat_POS.barcode,
                                          //   color: Colors.Colors.black,
                                          //   size: 25,
                                          // ),
                                          child: Container(
                                              child: Image.asset('assets/system/barcode.png', height: 28,)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: IgnorePointer(
                          ignoring: !loadingSearch,
                          child: AnimatedOpacity(
                            opacity: loadingSearch ? 1 : 0,
                            duration: Duration(milliseconds: 170),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.Colors.white,
                                    border: Border(
                                      top: BorderSide(
                                          color: AppTheme.skBorderColor2,
                                          // color: Colors.Colors.transparent,
                                          width: 1.0),
                                    )),
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverAppBar(
                                      elevation: 0,
                                      backgroundColor: Colors.Colors.white,

                                      // Provide a standard title.

                                      // Allows the user to reveal the app bar if they begin scrolling
                                      // back up the list of items.
                                      floating: true,
                                      bottom: PreferredSize(                       // Add this code
                                        preferredSize: Size.fromHeight(-1),      // Add this code
                                        child: Container(),                           // Add this code
                                      ),
                                      flexibleSpace: Padding(
                                        padding: const EdgeInsets.only(left: 0.0, top: 0.5, bottom: 0.0),
                                        child: Container(
                                          height: 58,
                                          width: MediaQuery.of(context).size.width,
                                          // color: Colors.yellow,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.Colors.white,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    // color: AppTheme.skBorderColor2,
                                                      color: Colors.Colors.white,
                                                      width: 1.0),
                                                )),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.Colors.white,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      // color: AppTheme.skBorderColor2,
                                                        color: Colors.Colors.white,
                                                        width: 1.0),
                                                  )),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 12.0, bottom: 8.5, left: 15.0, right: 15.0),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: CupertinoSlidingSegmentedControl(
                                                      children: {
                                                        0: Text('Products'),
                                                        1: Text('Buy/sellers'),
                                                        2: Text('Orders'),
                                                      },
                                                      groupValue: slidingSearch,
                                                      onValueChanged: (newValue) {
                                                        setState(() {
                                                          slidingSearch = int.parse(newValue.toString());
                                                        });
                                                        FocusScope.of(context).unfocus();
                                                        searchValue = _searchController.text;
                                                        searchKeyChanged();
                                                      }),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ),
                                      ),
                                      // Display a placeholder widget to visualize the shrinking size.
                                      // Make the initial height of the SliverAppBar larger than normal.
                                      expandedHeight: 20,
                                    ),
                                    if(noSearchData)
                                    SliverExpandableList(
                                      builder: SliverExpandableChildDelegate(
                                        sectionList: sectionListNo,
                                        headerBuilder: _buildHeader2,
                                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                                          String item = sectionListNo[sectionIndex].items[itemIndex];
                                          int length = sectionListNo[sectionIndex].items.length;
                                          return Container(
                                            height: 0.1,
                                          );
                                        },
                                      ),
                                ),
                                    if(!noSearchData)
                                    SliverExpandableList(
                                      builder: SliverExpandableChildDelegate(
                                        sectionList: sectionList,
                                        headerBuilder: _buildHeader,
                                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                                          String item = sectionList[sectionIndex].items[itemIndex];
                                          int length = sectionList[sectionIndex].items.length;
                                          if(sectionIndex == 0) {
                                            return Container(
                                              height: 0.1,
                                            );
                                            // return SliverFillRemaining(
                                            //   child: new Container(
                                            //     color: Colors.Colors.red,
                                            //   ),
                                            // );
                                          }

                                          if(slidingSearch == 0 && item.contains('^sps^')) {
                                            return GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                // context,
                                                // MaterialPageRoute(
                                                //     builder: (context) => ProductDetailsView2(
                                                //         idString: version, toggleCoinCallback:
                                                //     addProduct1, toggleCoinCallback3: addProduct3)),);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 20.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: sectionIndex == length-1 ?
                                                          BorderSide(
                                                              color: Colors.Colors.transparent,
                                                              width: 1.0) :

                                                          BorderSide(
                                                              color: Colors.Colors.grey
                                                                  .withOpacity(0.3),
                                                              width: 1.0)
                                                      )),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        5.0),
                                                                    child: item.split('^sps^')[2] != ""
                                                                        ? CachedNetworkImage(
                                                                      imageUrl:
                                                                      'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                          item.split('^sps^')[2],
                                                                      width: 75,
                                                                      height: 75,
                                                                      // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                      errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                      fadeInDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                          100),
                                                                      fadeOutDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                          10),
                                                                      fadeInCurve:
                                                                      Curves
                                                                          .bounceIn,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                        : CachedNetworkImage(
                                                                      imageUrl:
                                                                      'https://pbs.twimg.com/media/Bj6ZCa9CYAA95tG?format=jpg',
                                                                      width: 75,
                                                                      height: 75,
                                                                      // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                      errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                      fadeInDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                          100),
                                                                      fadeOutDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                          10),
                                                                      fadeInCurve:
                                                                      Curves
                                                                          .bounceIn,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  item.split('^sps^')[1],
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'MMK ' + item.split('^sps^')[1],
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    StreamBuilder(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                            'space')
                                                                            .doc(
                                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                                            .collection(
                                                                            'shops')
                                                                            .doc(
                                                                            'PucvhZDuUz3XlkTgzcjb')
                                                                            .collection(
                                                                            'products')
                                                                            .doc(item.split('^sps^')[0])
                                                                            .collection(
                                                                            'versions')
                                                                            .where('type',
                                                                            isEqualTo:
                                                                            'main')
                                                                            .snapshots(),
                                                                        builder: (BuildContext
                                                                        context,
                                                                            AsyncSnapshot<
                                                                                QuerySnapshot>
                                                                            snapshot2) {
                                                                          if (snapshot2
                                                                              .hasData) {
                                                                            int quantity =
                                                                            0;
                                                                            var mainQuantity;
                                                                            snapshot2
                                                                                .data!
                                                                                .docs
                                                                                .map((DocumentSnapshot
                                                                            document) {
                                                                              Map<String,
                                                                                  dynamic>
                                                                              data1 =
                                                                              document.data()! as Map<
                                                                                  String,
                                                                                  dynamic>;

                                                                              quantity +=
                                                                                  int.parse(
                                                                                      data1['unit_qtity']);
                                                                              mainQuantity =
                                                                                  quantity
                                                                                      .toString();
                                                                            }).toList();
                                                                            return Row(
                                                                              children: [
                                                                                Text(
                                                                                    'mainQuantity mainName ', style: TextStyle(
                                                                                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.Colors.grey,
                                                                                )),
                                                                                Icon( SmartKyat_POS.prodm, size: 17, color: Colors.Colors.grey,),
                                                                                'sub1Name' != '' ? Text(' | ', style: TextStyle(
                                                                                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.Colors.grey,
                                                                                )) : Text(''),
                                                                              ],
                                                                            );
                                                                          }
                                                                          return Container();
                                                                        }),
                                                                    StreamBuilder(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                            'space')
                                                                            .doc(
                                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                                            .collection(
                                                                            'shops')
                                                                            .doc(
                                                                            'PucvhZDuUz3XlkTgzcjb')
                                                                            .collection(
                                                                            'products')
                                                                            .doc(item.split('^sps^')[0])
                                                                            .collection(
                                                                            'versions')
                                                                            .where('type',
                                                                            isEqualTo:
                                                                            'sub1')
                                                                            .snapshots(),
                                                                        builder: (BuildContext
                                                                        context,
                                                                            AsyncSnapshot<
                                                                                QuerySnapshot>
                                                                            snapshot3) {
                                                                          if (snapshot3
                                                                              .hasData) {
                                                                            int quantity1 =
                                                                            0;
                                                                            var sub1Quantity;
                                                                            snapshot3
                                                                                .data!
                                                                                .docs
                                                                                .map((DocumentSnapshot
                                                                            document) {
                                                                              Map<String,
                                                                                  dynamic>
                                                                              data2 =
                                                                              document.data()! as Map<
                                                                                  String,
                                                                                  dynamic>;
                                                                              if (data2[
                                                                              'unit_qtity'] !=
                                                                                  '') {
                                                                                quantity1 +=
                                                                                    int.parse(
                                                                                        data2['unit_qtity']);
                                                                                sub1Quantity =
                                                                                    quantity1
                                                                                        .toString();
                                                                              } else
                                                                                return Container();
                                                                            }).toList();
                                                                            // print(sub1Quantity);
                                                                            // print(mainQuantity);

                                                                            if (sub1Quantity !=
                                                                                null) {
                                                                              return Row(
                                                                                children: [
                                                                                  Text(
                                                                                      'sub1Quantity sub1Name ', style: TextStyle(
                                                                                    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.Colors.grey,
                                                                                  )),
                                                                                  Icon( SmartKyat_POS.prods1, size: 17, color: Colors.Colors.grey,),
                                                                                  'sub2Name' != '' ? Text(' | ', style: TextStyle(
                                                                                    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.Colors.grey,
                                                                                  )) : Text(''),
                                                                                ],
                                                                              );
                                                                            }
                                                                            return Container();
                                                                          }
                                                                          return Container();
                                                                        }),
                                                                    StreamBuilder(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                            'space')
                                                                            .doc(
                                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                                            .collection(
                                                                            'shops')
                                                                            .doc(
                                                                            'PucvhZDuUz3XlkTgzcjb')
                                                                            .collection(
                                                                            'products')
                                                                            .doc(item.split('^sps^')[0])
                                                                            .collection(
                                                                            'versions')
                                                                            .where('type',
                                                                            isEqualTo:
                                                                            'sub2')
                                                                            .snapshots(),
                                                                        builder: (BuildContext
                                                                        context,
                                                                            AsyncSnapshot<
                                                                                QuerySnapshot>
                                                                            snapshot4) {
                                                                          if (snapshot4
                                                                              .hasData) {
                                                                            int quantity2 =
                                                                            0;
                                                                            var sub2Quantity;
                                                                            snapshot4
                                                                                .data!
                                                                                .docs
                                                                                .map((DocumentSnapshot
                                                                            document) {
                                                                              Map<String,
                                                                                  dynamic>
                                                                              data3 =
                                                                              document.data()! as Map<
                                                                                  String,
                                                                                  dynamic>;
                                                                              if (data3[
                                                                              'unit_qtity'] !=
                                                                                  '') {
                                                                                quantity2 +=
                                                                                    int.parse(
                                                                                        data3['unit_qtity']);
                                                                                sub2Quantity =
                                                                                    quantity2
                                                                                        .toString();
                                                                              } else
                                                                                return Container();
                                                                            }).toList();
                                                                            if (sub2Quantity !=
                                                                                null) {
                                                                              return Row(
                                                                                children: [
                                                                                  Text(
                                                                                      'sub2Quantity sub2Name ', style: TextStyle(
                                                                                    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.Colors.grey,
                                                                                  )),
                                                                                  Icon( SmartKyat_POS.prods2, size: 17, color: Colors.Colors.grey,),
                                                                                ],
                                                                              );
                                                                            }
                                                                            return Container();
                                                                          }
                                                                          return Container();
                                                                        }),
                                                                    // StreamBuilder(
                                                                    //     stream: FirebaseFirestore
                                                                    //         .instance
                                                                    //         .collection(
                                                                    //         'space')
                                                                    //         .doc(
                                                                    //         '0NHIS0Jbn26wsgCzVBKT')
                                                                    //         .collection(
                                                                    //         'shops')
                                                                    //         .doc(
                                                                    //         'PucvhZDuUz3XlkTgzcjb')
                                                                    //         .collection(
                                                                    //         'products')
                                                                    //         .doc(version)
                                                                    //         .collection(
                                                                    //         'versions')
                                                                    //         .where('type',
                                                                    //         isEqualTo:
                                                                    //         'sub3')
                                                                    //         .snapshots(),
                                                                    //     builder: (BuildContext
                                                                    //     context,
                                                                    //         AsyncSnapshot<
                                                                    //             QuerySnapshot>
                                                                    //         snapshot5) {
                                                                    //       if (snapshot5
                                                                    //           .hasData) {
                                                                    //         int quantity3 =
                                                                    //         0;
                                                                    //         var sub3Quantity;
                                                                    //         snapshot5
                                                                    //             .data!
                                                                    //             .docs
                                                                    //             .map((DocumentSnapshot
                                                                    //         document) {
                                                                    //           Map<String,
                                                                    //               dynamic>
                                                                    //           data4 =
                                                                    //           document.data()! as Map<
                                                                    //               String,
                                                                    //               dynamic>;
                                                                    //           if (data4[
                                                                    //           'unit_qtity'] !=
                                                                    //               '') {
                                                                    //             quantity3 +=
                                                                    //                 int.parse(
                                                                    //                     data4['unit_qtity']);
                                                                    //             sub3Quantity =
                                                                    //                 quantity3
                                                                    //                     .toString();
                                                                    //           } else
                                                                    //             return Container();
                                                                    //         }).toList();
                                                                    //         // print(sub1Quantity);
                                                                    //         // print(mainQuantity);
                                                                    //         if (sub3Quantity !=
                                                                    //             null) {
                                                                    //           return Text(
                                                                    //               '$sub3Quantity $sub3Name');
                                                                    //         }
                                                                    //         return Container();
                                                                    //       }
                                                                    //       return Container();
                                                                    //     }),
                                                                  ],
                                                                ),

                                                                // Text(
                                                                //   'MMK',
                                                                //   style:
                                                                //       TextStyle(
                                                                //     fontSize: 14,
                                                                //     fontWeight: FontWeight.w400,
                                                                //     color: Colors.blueGrey.withOpacity(1.0),
                                                                //   ),
                                                                // ),
                                                                // SizedBox(
                                                                //   height:
                                                                //       7,
                                                                // ),
                                                                // Text(
                                                                //   '55',
                                                                //   style:
                                                                //       TextStyle(
                                                                //     fontSize: 14,
                                                                //     fontWeight: FontWeight.w400,
                                                                //     color: Colors.blueGrey.withOpacity(1.0),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                            // Padding(
                                                            //   padding:
                                                            //       const EdgeInsets.only(
                                                            //           bottom: 20.0),
                                                            //   child: IconButton(
                                                            //     icon: Icon(
                                                            //       Icons
                                                            //           .arrow_forward_ios_rounded,
                                                            //       size: 16,
                                                            //       color: Colors.blueGrey
                                                            //           .withOpacity(0.8),
                                                            //     ),
                                                            //     onPressed: () {
                                                            //       Navigator.push(
                                                            //         context,
                                                            //         MaterialPageRoute(
                                                            //             builder: (context) => ProductDetailsView(
                                                            //                 idString: version, toggleCoinCallback:
                                                            //             addProduct1, toggleCoinCallback3: addProduct3)),);
                                                            //     },
                                                            //   ),
                                                            // ),
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  bottom: 12.0),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 16,
                                                                color: Colors.Colors.blueGrey
                                                                    .withOpacity(0.8),
                                                              ),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if(slidingSearch == 1 && item.contains('^sps^')) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (
                                                          context) =>
                                                          CustomerInfoSubs(
                                                              id: item.split('^sps^')[0],
                                                              toggleCoinCallback: addCustomer2Cart1)),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    top: index == 0
                                                        ? 10.0
                                                        : 15.0),
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: index ==
                                                              length -
                                                                  1
                                                              ?
                                                          BorderSide(
                                                              color: Colors
                                                                  .Colors.transparent,
                                                              width: 1.0)
                                                              :

                                                          BorderSide(
                                                              color: Colors
                                                                  .Colors.grey
                                                                  .withOpacity(
                                                                  0.3),
                                                              width: 1.0)
                                                      )),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            bottom: 18.0),
                                                        child: ListTile(
                                                          title: Text(
                                                            item.split('^sps^')[1].toString(),
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                            ),),
                                                          subtitle: Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top: 8.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                    item.split('^sps^')[2].toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors
                                                                          .Colors.grey,
                                                                    )),
                                                                SizedBox(
                                                                  height: 5,),
                                                                Text(
                                                                    item.split('^sps^')[3].toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors
                                                                          .Colors.grey,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                          trailing: Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  StreamBuilder(
                                                                      stream: FirebaseFirestore.instance
                                                                          .collection('space')
                                                                          .doc('0NHIS0Jbn26wsgCzVBKT')
                                                                          .collection('shops')
                                                                          .doc('PucvhZDuUz3XlkTgzcjb')
                                                                          .collection('customers')
                                                                          .doc(item.split('^sps^')[0].toString())
                                                                          .collection('orders')
                                                                          .where('debt', isGreaterThan: 0)
                                                                          .snapshots(),
                                                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                                                        // orderList[index] = 0;
                                                                        int orderLength = 0;
                                                                        int i = 0;
                                                                        if(snapshot2.hasData) {
                                                                          return snapshot2.data!.docs.length > 0? Container(
                                                                            height: 21,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                              color: AppTheme.badgeFgDanger,
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                              child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
                                                                                style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.Colors.white
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ): Container(
                                                                          );
                                                                          // int quantity = 0;
                                                                          // snapshot2.data!.docs.map((DocumentSnapshot document2) {
                                                                          //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
                                                                          //   orders = data2['daily_order'];
                                                                          //   quantity += int.parse(orders.length.toString());
                                                                          //
                                                                          //   return Text(snapshot2.data!.docs[index].id);
                                                                          // }).toList();
                                                                        }
                                                                        return Container();
                                                                      }
                                                                  ),

                                                                  // Container(
                                                                  //   height: 21,
                                                                  //   decoration: BoxDecoration(
                                                                  //     borderRadius: BorderRadius.circular(20.0),
                                                                  //     color: AppTheme.badgeFgDanger,
                                                                  //   ),
                                                                  //   child: Padding(
                                                                  //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                  //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                                                  //       style: TextStyle(
                                                                  //           fontSize: 13,
                                                                  //           fontWeight: FontWeight.w500,
                                                                  //           color: Colors.white
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),

                                                                  // Text(orderList.toString()),

                                                                  // Container(
                                                                  //   height: 21,
                                                                  //   decoration: BoxDecoration(
                                                                  //     borderRadius: BorderRadius.circular(20.0),
                                                                  //     color: AppTheme.badgeFgDanger,
                                                                  //   ),
                                                                  //   child: Padding(
                                                                  //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                  //     child: Text('2 unpaid',
                                                                  //       style: TextStyle(
                                                                  //           fontSize: 13,
                                                                  //           fontWeight: FontWeight.w500,
                                                                  //           color: Colors.white
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // )

                                                                  // Container(
                                                                  //   height: 21,
                                                                  //   decoration: BoxDecoration(
                                                                  //     borderRadius: BorderRadius.circular(20.0),
                                                                  //     color: AppTheme.badgeFgDanger,
                                                                  //   ),
                                                                  //   child: Padding(
                                                                  //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                  //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                                                  //       style: TextStyle(
                                                                  //           fontSize: 13,
                                                                  //           fontWeight: FontWeight.w500,
                                                                  //           color: Colors.white
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                  SizedBox(
                                                                      width: 12),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 2.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios_rounded,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .Colors.blueGrey
                                                                          .withOpacity(
                                                                          0.8),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              print('Items'+item);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {})),
                                              // );
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
                                                                    Text('#Text',
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 8),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(bottom: 1.0),
                                                                      child: Icon(Icons.access_time, size: 15, color: Colors.Colors.grey,),
                                                                    ),
                                                                    SizedBox(width: 4),
                                                                    Text('Text1',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text('Text2', style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.Colors.grey,
                                                                    )),

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
                                                              // if(item.split('^')[5] == '0.0')
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 6.0),
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
                                                                            color: Colors.Colors.white
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                              // if(item.split('^')[5] != '0.0')
                                                              //   Padding(
                                                              //     padding: const EdgeInsets.only(right: 6.0),
                                                              //     child: Container(
                                                              //       height: 21,
                                                              //       decoration: BoxDecoration(
                                                              //         borderRadius: BorderRadius.circular(20.0),
                                                              //         color: AppTheme.badgeFgDanger,
                                                              //       ),
                                                              //       child: Padding(
                                                              //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                              //         child: Text('Unpaid',
                                                              //           style: TextStyle(
                                                              //               fontSize: 13,
                                                              //               fontWeight: FontWeight.w500,
                                                              //               color: Colors.Colors.white
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ),

                                                              // if(item.split('^')[4][0] == 'r')
                                                              //   Padding(
                                                              //     padding: const EdgeInsets.only(right: 6.0),
                                                              //     child: Container(
                                                              //       height: 21,
                                                              //       decoration: BoxDecoration(
                                                              //         borderRadius: BorderRadius.circular(20.0),
                                                              //         color: AppTheme.badgeBgSecond,
                                                              //       ),
                                                              //       child: Padding(
                                                              //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                              //         child: Text('Refunded',
                                                              //           style: TextStyle(
                                                              //               fontSize: 13,
                                                              //               fontWeight: FontWeight.w500,
                                                              //               color: Colors.Colors.white
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ),

                                                              // if(item.split('^')[4][0] == 's')
                                                              //   Padding(
                                                              //     padding: const EdgeInsets.only(right: 6.0),
                                                              //     child: Container(
                                                              //       height: 21,
                                                              //       decoration: BoxDecoration(
                                                              //         borderRadius: BorderRadius.circular(20.0),
                                                              //         color: AppTheme.badgeBgSecond,
                                                              //       ),
                                                              //       child: Padding(
                                                              //         padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                                              //         child: Text('Partially refunded',
                                                              //           style: TextStyle(
                                                              //               fontSize: 13,
                                                              //               fontWeight: FontWeight.w500,
                                                              //               color: Colors.Colors.white
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ),


                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 15.0, bottom: 1),
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text('MMK ', style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                        )),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 16,
                                                          color: Colors.Colors.blueGrey.withOpacity(0.8),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                MediaQuery.of(context).size.width > 900
                    ? Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 57.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Colors.Colors.grey.withOpacity(0.3),
                                width: 1.0))),
                    width: MediaQuery.of(context).size.width * (1.5 / 3.5),
                  ),
                )
                    : Container(),


              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setupPerformance() {
    // Change [printPerformance] to true and set the app to release mode to
    // print performance numbers to console. By default, Flutter builds in debug
    // mode and this mode is slow. To build in release mode, specify the flag
    // blaze-run flag "--define flutter_build_mode=release".
    // The build target must also be an actual device and not the emulator.
    charts.Performance.time = (String tag) => Timeline.startSync(tag);
    charts.Performance.timeEnd = (_) => Timeline.finishSync();
  }

  addDailyExp(priContext) {
    //  final _formKey = GlobalKey<FormState>();
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              top: true,
              bottom: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(priContext).padding.top,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                                color: Colors.Colors.white.withOpacity(0.5)),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Container(
                            // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              color: Colors.Colors.white,
                            ),

                            child: Column(
                              children: [
                                Container(
                                  height: 85,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.Colors.grey
                                                  .withOpacity(0.3),
                                              width: 1.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: Colors.Colors.grey
                                                  .withOpacity(0.3)),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Colors.Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Add new product",
                                          style: TextStyle(
                                              color: Colors.Colors.black,
                                              fontSize: 17,
                                              fontFamily: 'capsulesans',
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.left,
                                        ),
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: AppTheme.skThemeColor),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Colors.Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    "PRODUCT INFORMATION",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      color: Colors.Colors.brown,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 15),
                                      height: 130,
                                      width: 150,
                                      child: Image.network(
                                        'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "Add images to show customers product details and features",
                                        style: TextStyle(
                                          color: Colors.Colors.amberAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      //height: 200,
                                      width: 380,
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          suffixText: 'Required',
                                          // errorText: 'Error message',
                                          labelText: 'First Name',
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          //filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      //height: 200,
                                      width: 380,
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: InputDecoration(
                                          labelText: 'Last Name',
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          //filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String titleTextBySlide() {
    if(_sliding == 0) {
      return "TODAY SO FAR";
    } else if(_sliding == 1) {
      return "LAST 7 DAYS";
    } else if(_sliding == 2) {
      return "LAST 28 DAYS";
    } else {
      return "LAST 12 MONTHS";
    }
  }

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
      return todayTotal.toStringAsFixed(2);
    } else if(_sliding == 1) {
      return weeklyTotal.toStringAsFixed(2);
    } else if(_sliding == 2) {
      return monthlyTotal.toStringAsFixed(2);
    } else {
      return yearlyTotal.toStringAsFixed(2);
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

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList[sectionIndex];
    if(sectionIndex == 0) {
      return Container(
        height: 0.1,
      );
    }
    return InkWell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.Colors.white,
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
                        // "BUY ORDERS",
                        section.header.split('^')[0].toUpperCase(),
                        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.Colors.black
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            section.header.split('^')[1],
                            // '#' + sectionList[sectionIndex].items.length.toString(),
                            // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                            style: TextStyle(
                              height: 0.8,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.Colors.black,
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

  Widget _buildHeader2(BuildContext context, int sectionIndex, int index) {
    if(searchValue == '') {
      return Container(
          height: 50,
          child: Center(child: Text('Search any word'))
      );
    }
    return Container(
      height: 50,
      child: Center(child: Text('No data found'))
    );
  }

  Future<void> searchKeyChanged() async {
    if(searchValue != '') {
      if(slidingSearch == 2) {
        print("search " + searchValue);
        String max = searchValue;
        // sectionList = [];
        List detailIdList = [];
        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
        // FirebaseFirestore.instance.collection('space')
            .where('each_order',  arrayContains: max)
            .limit(1)
            .get()
            .then((QuerySnapshot querySnapshot1) {

          if(querySnapshot1.docs.length == 0) {
            setState(() {
              noSearchData = true;
            });
          } else {
            setState(() {
              noSearchData = false;
            });
          }


          querySnapshot1.docs.forEach((doc) async {

            await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(doc.id).collection('detail')
                .where('orderId',  isEqualTo: max)
                .get()
                .then((QuerySnapshot querySnapshot2) {

              if(querySnapshot2.docs.length == 0) {
                setState(() {
                  noSearchData = true;
                });
              } else {
                setState(() {
                  noSearchData = false;
                });
              }
              querySnapshot2.docs.forEach((doc) {

                setState(() {
                  detailIdList.add(doc.id);
                });
              });


              setState(() {

                // if(detailIdList.length == 0) {
                //   noSearchData = true;
                // } else {
                //   noSearchData = false;
                // }
                var sections = List<ExampleSection>.empty(growable: true);

                var init = ExampleSection()
                  ..header = ''
                  ..items = ['']
                  ..expanded = true;

                var buyOrders = ExampleSection()
                  ..header = 'Buy Orders^' + detailIdList.length.toString()
                  ..items = detailIdList.cast<String>()
                  ..expanded = true;

                var sellOrders = ExampleSection()
                  ..header = 'Sell Orders^' + detailIdList.length.toString()
                  ..items = detailIdList.cast<String>()
                  ..expanded = true;

                print('buy ord ' + detailIdList.length.toString());
                sections.add(init);
                sections.add(buyOrders);
                sections.add(sellOrders);
                sectionList = sections;
              });
            });
          });


        });





      } else if (slidingSearch == 1) {

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = ''
            ..items = ['']
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          // sections.add(buyOrders);
          sectionList = sections;
        });
        List<String> items = [];

        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('customers')
            .get()
            .then((QuerySnapshot querySnapshot) {

          String sps = '^sps^';
          querySnapshot.docs.forEach((doc) {
            if(doc['customer_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
              setState(() {
                items.add(doc.id + sps + doc['customer_name'] + sps + doc['customer_phone'] + sps + doc['customer_address']);
              });

              // print(doc['prod_name'].toString());
            }
          });

          if(items.length == 0) {
            setState(() {
              noSearchData = true;
            });
          } else {
            setState(() {
              noSearchData = false;
            });
          }


        });

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = 'Customers^' + items.length.toString()
            ..items = items
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          // sections.add(buyOrders);
          sectionList.add(init);
        });


      } else {

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = ''
            ..items = ['']
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          // sections.add(buyOrders);
          sectionList = sections;
        });
        List<String> items = [];

        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products')
            .get()
            .then((QuerySnapshot querySnapshot) {

          String sps = '^sps^';
          querySnapshot.docs.forEach((doc) {
            if(doc['prod_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
              setState(() {
                items.add(doc.id + sps + doc['prod_name'] + sps + doc['img_1'] + sps + doc['unit_sell'] + '-' + doc['inStock1'].toString() + '-' + doc['unit_name'] + sps + doc['sub1_sell'] + '-' + doc['inStock2'].toString() + '-' + doc['sub1_name'] + sps + doc['sub2_sell'] + '-' + doc['inStock2'].toString() + '-' + doc['sub2_name']);
              });

              print(doc['prod_name'].toString());
            }
          });

          if(items.length == 0) {
            setState(() {
              noSearchData = true;
            });
          } else {
            setState(() {
              noSearchData = false;
            });
          }


        });

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = 'Products^' + items.length.toString()
            ..items = items
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          // sections.add(buyOrders);
          sectionList.add(init);
        });


      }
    } else {
      setState(() {
        noSearchData = true;
      });
    }
  }
}

class ShakeView extends StatelessWidget {
  final Widget child;
  final ShakeController controller;
  final Animation _anim;

  ShakeView({required this.child, required this.controller})
      : _anim = Tween<double>(begin: 50, end: 120).animate(controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        child: child,
        builder: (context, child) => Transform(
          child: child,
          transform: Matrix4.translation(_shake(_anim.value)),
        ));
  }

  Vector3 _shake(double progress) {
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 4, 0.0, 0.0);
  }
}

class ShakeController extends AnimationController {
  ShakeController(
      {required TickerProvider vsync,
        Duration duration = const Duration(milliseconds: 200)})
      : super(vsync: vsync, duration: duration);

  shake() async {
    if (status == AnimationStatus.completed) {
      await this.reverse();
    } else {
      await this.forward();
    }
  }
}

class JiggleController extends Equatable {
  final BehaviorSubject<JiggleState> _jiggleSubject =
  BehaviorSubject.seeded(JiggleState.STATIC);

  Stream<JiggleState> get stream => _jiggleSubject.stream.asBroadcastStream();

  JiggleState get state => _jiggleSubject.value;
  bool get isJiggling => _jiggleSubject.value == JiggleState.JIGGLING;

  void toggle() {
    HapticFeedback.mediumImpact();
    if (_jiggleSubject.value == JiggleState.STATIC) {
      _jiggleSubject.value = JiggleState.JIGGLING;
    } else {
      _jiggleSubject.value = JiggleState.STATIC;
    }
  }

  void dispose() {
    _jiggleSubject.close();
  }

  @override
  List<Object> get props => [state, isJiggling];

  @override
  bool get stringify => true;
}

enum JiggleState { JIGGLING, STATIC }

/// Jiggle your Widgets. 👯‍♀️
///
/// Jiggle is useful if you wish to indicate a state of uncertainity or
/// grab the attendtion of somebody.
class Jiggle extends StatefulWidget {
  Jiggle(
      {required this.child,
        required this.jiggleController,
        this.extent = 1,
        this.duration = const Duration(milliseconds: 80),
        this.useGestures = false});

  /// This is the extent in degress to which the Widget rotates.
  ///
  /// This defaults to 80 milliseconds.
  final double extent;

  /// This is the duration for which a `Jiggle` lasts.
  ///
  /// This defaults to 80 milliseconds.
  final Duration duration;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The jiggle controller.
  final JiggleController jiggleController;

  /// Set this property to true to automatically
  /// start jiggling when long pressed on the Widget.
  ///
  /// This defaults to false.
  final bool useGestures;

  @override
  _JiggleState createState() => _JiggleState();
}

class _JiggleState extends State<Jiggle> with SingleTickerProviderStateMixin {
  late AnimationController _jiggleAnimationController;
  late Animation<double> jiggleAnimation;

  @override
  void initState() {
    _jiggleAnimationController = AnimationController(
        vsync: this,
        duration: widget.duration,
        value: 0,
        lowerBound: -1,
        upperBound: 1);

    jiggleAnimation = Tween<double>(begin: 0, end: widget.extent)
        .animate(_jiggleAnimationController);

    _jiggleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jiggleAnimationController.repeat(reverse: true);
      }
    });
    super.initState();

  }



  void listenForJiggles() {
    widget.jiggleController.stream.listen((event) {
      // print("From Listen" + event.toString());
      if (event == JiggleState.STATIC) {
        _jiggleAnimationController.animateTo(1, duration: Duration.zero);
        _jiggleAnimationController.stop();
      } else if (event == JiggleState.JIGGLING) {
        _jiggleAnimationController.forward();
      }
    });
  }

  void _onLongPress() {
    if (widget.useGestures) widget.jiggleController.toggle();
  }

  @override
  Widget build(BuildContext context) {
    listenForJiggles();
    return GestureDetector(
      onLongPress: _onLongPress,
      child: AnimatedBuilder(
          animation: jiggleAnimation,
          child: widget.child,
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: radians(jiggleAnimation.value),
              child: child,
            );
          }),
    );
  }
}
