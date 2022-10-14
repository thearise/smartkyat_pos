// import 'dart:developer';
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
// import 'package:smartkyat_pos/fragments/subs/donut.dart';
// import 'package:smartkyat_pos/fragments/subs/top_sale_detail.dart';
// import 'package:smartkyat_pos/pie_chart/simple.dart';
// import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
// import 'package:flutter/src/material/colors.dart' as Colors;
// import 'package:smartkyat_pos/widgets/apply_discount_to_cart.dart';
// import 'package:smartkyat_pos/widgets/line_chart_sample2.dart';
// import 'package:vector_math/vector_math_64.dart';
// import '../../app_theme.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import '../../a11y/a11y_gallery.dart' as a11y show buildGallery;
// import '../../bar_chart/bar_gallery.dart' as bar show buildGallery;
// import '../../gallery_scaffold.dart';
// import '../../time_series_chart/time_series_gallery.dart' as time_series
//     show buildGallery;
// import '../../line_chart/line_gallery.dart' as line show buildGallery;
// import '../../scatter_plot_chart/scatter_plot_gallery.dart' as scatter_plot
//     show buildGallery;
// import '../../combo_chart/combo_gallery.dart' as combo show buildGallery;
// import '../../pie_chart/pie_gallery.dart' as pie show buildGallery;
// import '../../axes/axes_gallery.dart' as axes show buildGallery;
// import '../../behaviors/behaviors_gallery.dart' as behaviors show buildGallery;
// import '../../i18n/i18n_gallery.dart' as i18n show buildGallery;
// import '../../legends/legends_gallery.dart' as legends show buildGallery;
// import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
// import 'package:one_context/one_context.dart';
//
//
// class TopSaleDetail extends StatefulWidget {
//   const TopSaleDetail({Key? key, required this.shopId});
//   final String shopId;
//
//   @override
//   _TopSaleDetailState createState() => _TopSaleDetailState();
// }
//
// class _TopSaleDetailState extends State<TopSaleDetail>   with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TopSaleDetail> {
//
//   @override
//   bool get wantKeepAlive => true;
//   DateTime? _dateTime;
//   String _format = 'yyyy-MMMM-dd';
//
//   zeroAddDate(String str) {
//     if(str.length>1) {
//       return str;
//     } else {
//       return '0' + str;
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     _dateTime = DateTime.now();
//     fetchOrders();
//     //dateTime = DateTime.parse(DateTime.now().year.toString() + '-' + zeroAddDate(DateTime.now().month.toString()) + '-' + zeroAddDate(DateTime.now().day.toString()));
//     //  debugPrint(DateTime.now().year.toString() + '-' + DateTime.now().month.toString() + '-' + DateTime.now().day.toString());
//
//     super.initState();
//
//   }
//
//   zeroToTen(String string) {
//     if(int.parse(string) > 9) {
//       return string;
//     } else {
//       return '0'+string;
//     }
//   }
//   List<double> thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//   List<double> thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//   List<double> todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//   List<double> thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
//
//
//
//   fetchOrders() async {
//     todayOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//     thisWeekOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//     thisMonthOrdersChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//     thisYearOrdersChart =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
//     DateTime sevenDaysAgo = _dateTime!.subtract(const Duration(days: 8));
//     DateTime monthAgo = _dateTime!.subtract(const Duration(days: 31));
//
//
//     CollectionReference orders = FirebaseFirestore
//         .instance.collection('shops').doc(widget.shopId).collection('orders');
//
//     orders.get().then((QuerySnapshot
//     querySnapshot) async {
//       // debugPrint(DateTime.now().subtract(duration))
//       //today = today.add(const Duration(hours: 1));
//       sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));
//       monthAgo = monthAgo.add(const Duration(days: 1));
//       querySnapshot.docs
//           .forEach((doc) {
//         int week = 0;
//         int month = 0;
//         int year = 0;
//         sevenDaysAgo = _dateTime!.subtract(const Duration(days: 8));
//         monthAgo = _dateTime!.subtract(const Duration(days: 31));
//
//         while(!(_dateTime!.year.toString() == sevenDaysAgo.year.toString() && _dateTime!.month.toString() == sevenDaysAgo.month.toString() && _dateTime!.day.toString() == sevenDaysAgo.day.toString())) {
//           sevenDaysAgo = sevenDaysAgo.add(const Duration(days: 1));
//           debugPrint('each258 ' + _dateTime.toString());
//           debugPrint('seven Days Ago ' + sevenDaysAgo.day.toString() + ' ' + week.toString());
//
//
//           debugPrint('shwe shwe ' + sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString()));
//
//           if(doc['date'] == sevenDaysAgo.year.toString() + zeroToTen(sevenDaysAgo.month.toString()) + zeroToTen(sevenDaysAgo.day.toString())) {
//             double total = 0;
//             // debugPrint(doc['daily_order'].toString());
//             for(String str in doc['daily_order']) {
//               // debugPrint(double.parse(str));
//               total += double.parse(str.split('^')[2]);
//             }
//             debugPrint('total ' + total.toString());
//             setState(() {
//               thisWeekOrdersChart[week] = total;
//             });
//
//           }
//           week = week + 1;
//
//         }
//
//         while(!(_dateTime!.year.toString() == monthAgo.year.toString() && _dateTime!.month.toString() == monthAgo.month.toString() && _dateTime!.day.toString() == monthAgo.day.toString())) {
//           monthAgo = monthAgo.add(const Duration(days: 1));
//
//           debugPrint('month Days Ago ' + monthAgo.day.toString() + ' ' + month.toString());
//           debugPrint('here shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));
//
//
//           debugPrint('shwe shwe ' + monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString()));
//
//           if(doc['date'] == monthAgo.year.toString() + zeroToTen(monthAgo.month.toString()) + zeroToTen(monthAgo.day.toString())) {
//             double total = 0;
//             // debugPrint(doc['daily_order'].toString());
//             for(String str in doc['daily_order']) {
//               // debugPrint(double.parse(str));
//               debugPrint('testing ' + str.split('^')[2]);
//               total += double.parse(str.split('^')[2]);
//             }
//             debugPrint('tatoos ' + total.toString());
//             setState(() {
//               thisMonthOrdersChart[month] = total;
//             });
//
//           }
//           month = month + 1;
//         }
//         if (doc['date'].substring(0,8) == _dateTime!.year.toString() +
//             zeroToTen(_dateTime!.month.toString()) +
//             zeroToTen(_dateTime!.day.toString())) {
//           double total = 0;
//           for (String str in doc['daily_order']) {
//             for(int i=0; i<=24 ; i++ ){
//
//               if(str.split('^')[0].substring(0, 10) == _dateTime!.year.toString() +
//                   zeroToTen(_dateTime!.month.toString()) +
//                   zeroToTen(_dateTime!.day.toString()) +
//                   zeroToTen(i.toString()))
//               {
//                 total += double.parse(str.split('^')[2]);
//                 setState(() {
//                   todayOrdersChart[i]+=double.parse(str.split('^')[2]);
//                 });
//               }
//               // debugPrint('laos ' + total.toString());
//               debugPrint('World ' +todayOrdersChart.toString());
//             }
//           }
//         }
//         if (doc['date'].substring(0,4) == _dateTime!.year.toString()){
//           double total = 0;
//           for (String str in doc['daily_order']) {
//             for(int i=1; i<=12 ; i++ ){
//               // debugPrint('helloworld '+i.toString());
//
//               if(str.split('^')[0].substring(0,6) == _dateTime!.year.toString()+ zeroToTen(i.toString()))
//               {
//                 total += double.parse(str.split('^')[2]);
//                 setState(() {
//                   thisYearOrdersChart[i]+=double.parse(str.split('^')[2]);
//                   debugPrint('fortune ' +thisYearOrdersChart.toString()); });
//               }
//               //debugPrint('laos ' + total.toString());
//
//             }
//           }
//         }
//
//         // while(!(today.year.toString() == yearAgo.year.toString() && today.month.toString() == yearAgo.month.toString() && today.day.toString() == yearAgo.day.toString())) {
//         //   yearAgo = yearAgo.add(const Duration(days: 1));
//         //
//         //   if(doc['date'] == yearAgo.year.toString() + zeroToTen(yearAgo.month.toString()) + zeroToTen(yearAgo.day.toString())) {
//         //     double total = 0;
//         //     // debugPrint(doc['daily_order'].toString());
//         //     for(String str in doc['daily_order']) {
//         //       // debugPrint(double.parse(str));
//         //       total += double.parse(str.split('^')[2]);
//         //     }
//         //     debugPrint('total ' + total.toString());
//         //     setState(() {
//         //       thisYearOrdersChart[year] = total;
//         //     });
//         //
//         //   }
//         //   year = year + 1;
//         //
//         // }
//         debugPrint('this year' + thisYearOrdersChart.toString());
//         debugPrint('this week ' + thisWeekOrdersChart.toString());
//         // for(int j = 20210909; j <= 20210915; j++) {
//         //
//         //   // debugPrint('seven Days Ago 2 ' + sevenDaysAgo.day.toString() + ' ' + ij.toString());
//         //   debugPrint('here shwe 2 ' + j.toString());
//         //   // if(doc['date'] == j.toString()) {
//         //   //   double total = 0;
//         //   //   // debugPrint(doc['daily_order'].toString());
//         //   //   for(String str in doc['daily_order']) {
//         //   //     // debugPrint(double.parse(str));
//         //   //     total += double.parse(str.split('^')[2]);
//         //   //   }
//         //   //   debugPrint('total ' + total.toString());
//         //   //   setState(() {
//         //   //     thisWeekOrdersChart[ij] = total;
//         //   //   });
//         //   //
//         //   // }
//         //   // ij = ij + 1;
//         //   // debugPrint(ij);
//         // }
//
//
//         // debugPrint('this week 2' + thisWeekOrdersChart.toString());
//
//         // debugPrint('each ' + doc.id.toString());
//       });
//       debugPrint('this month ' + thisMonthOrdersChart.toString());
//       // setState(() {
//       //   thisWeekOrdersChart
//       // });
//     });
//
//     // CollectionReference col1 = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc(widget.shopId).collection('orders');
//     // final snapshots = col1.snapshots().map((snapshot) => snapshot.docs.where((doc) => doc['date'] == "20210914" || doc['date'] == "20210913"));
//     //
//     // debugPrint((await snapshots.first).toList());
//   }
//
//   int findMax(List<int> numbers) {
//     return numbers.reduce(max);
//   }
//
//   List<Color> gradientColors = [
//     // AppTheme.badgeFgSecond
//     Colors.Colors.blue
//     // const Color(0xff23b6e6),
//     // const Color(0xff02d39a),
//   ];
//
//   LineChartData todayData(_dateTime) {
//     String subHours = _dateTime!.hour.toString();
//     List<int> roundToday = [];
//     for(double dbl in todayOrdersChart) {
//       roundToday.add(dbl.round());
//     }
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xFFd6d8db),
//             strokeWidth: 1,
//             // dashArray: [0]
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//               color: const Color(0xFFd6d8db),
//               strokeWidth: 1,
//               dashArray: [5]
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           interval: 1,
//           getTextStyles: (context, value) =>
//           const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0:
//                 return _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString());
//               case 4:
//                 return _dateTime!.subtract(Duration(hours: (int.parse(subHours)-4))).hour.toString() + ' hr';
//               case 8:
//                 return _dateTime!.subtract(Duration(hours: int.parse(subHours)-8)).hour.toString()+ ' hr';
//               case 12:
//                 return _dateTime!.subtract(Duration(hours: int.parse(subHours)-12)).hour.toString()+ ' hr';
//               case 16:
//                 return _dateTime!.subtract(Duration(hours: int.parse(subHours)-16)).hour.toString()+ ' hr';
//               case 20:
//                 return _dateTime!.subtract(Duration(hours: int.parse(subHours)-20)).hour.toString()+ ' hr';
//               case 24:
//                 return 'Next Day';
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.w500,
//             fontSize: 13,
//           ),
//           getTitles: (value) {
//             chgDeci3Place(findMax(roundToday));
//             var unit;
//             var quantity;
//             if(chgDeci3Place(findMax(roundToday))==100.0) {
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundToday))*10;
//             } else if(chgDeci3Place(findMax(roundToday))==1000.0){
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundToday));
//             }else if(chgDeci3Place(findMax(roundToday))==10000.0){
//               unit='K';
//               quantity = chgDeci3Place(findMax(roundToday))/10;
//             }else if(chgDeci3Place(findMax(roundToday))==100000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundToday))*10;
//             }else if(chgDeci3Place(findMax(roundToday))==1000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundToday));
//             }else if(chgDeci3Place(findMax(roundToday))==10000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundToday))/10;
//             }else if(chgDeci3Place(findMax(roundToday))==100000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundToday))*10;
//             }else if(chgDeci3Place(findMax(roundToday))== 1000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundToday));
//             }else if(chgDeci3Place(findMax(roundToday))== 10000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundToday))/10;
//             }else {
//               unit='';
//               quantity = 1;
//             }
//
//             if(value.toInt() == 5) {
//               return (findMax(roundToday)/quantity).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 3) {
//               return ((findMax(roundToday)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 1) {
//               return ((findMax(roundToday)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
//             }
//             return '';
//           },
//           reservedSize: 35,
//           margin: 8,
//         ),
//       ),
//       borderData:
//       FlBorderData(show: true, border: Border.all(color: const Color(0xFFd6d8db), width: 0)),
//       minX: 0,
//       maxX: 24,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//
//         LineChartBarData(
//           spots: [
//             FlSpot(0, (((todayOrdersChart[0]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[0]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[0]).toString() + '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours))).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(1, (((todayOrdersChart[1]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[1]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[1]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-1)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(2, (((todayOrdersChart[2]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[2]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[2]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-2)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(3, (((todayOrdersChart[3]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[3]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[3]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-3)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(4, (((todayOrdersChart[4]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[4]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[4]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-4)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(5, (((todayOrdersChart[5]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[5]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[5]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-5)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(6, (((todayOrdersChart[6]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[6]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[6]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-6)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(7, (((todayOrdersChart[7]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[7]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))),(todayOrdersChart[7]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-7)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(8, (((todayOrdersChart[8]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[8]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[8]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-8)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(9, (((todayOrdersChart[9]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[9]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[9]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-9)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(10, (((todayOrdersChart[10]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[10]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[10]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-10)).hour.toString()+ ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(11, (((todayOrdersChart[11]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[11]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[11]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-11)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(12, (((todayOrdersChart[12]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[12]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[12]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-12)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(13, (((todayOrdersChart[13]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[13]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[13]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-13)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(14, (((todayOrdersChart[14]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[14]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[14]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-14)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(15, (((todayOrdersChart[15]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[15]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[15]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-15)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(16, (((todayOrdersChart[16]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[16]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[16]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-16)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(17, (((todayOrdersChart[17]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[17]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[17]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-17)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(18, (((todayOrdersChart[18]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[18]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[18]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-18)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(19, (((todayOrdersChart[19]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[19]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[19]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-19)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(20, (((todayOrdersChart[20]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[20]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[20]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-20)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(21, (((todayOrdersChart[21]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[21]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[21]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-21)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(22, (((todayOrdersChart[22]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[22]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[22]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-22)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(23, (((todayOrdersChart[23]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[23]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[23]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-23)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) +')'),
//             FlSpot(24, (((todayOrdersChart[24]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday)))).toString() == "NaN" ? 0.0 : ((todayOrdersChart[24]/chgDeci3Place(findMax(roundToday))) * 5 )/ (findMax(roundToday)/chgDeci3Place(findMax(roundToday))), (todayOrdersChart[24]).toString()+ '\n(' + _dateTime!.subtract(Duration(hours: int.parse(subHours)-24)).hour.toString() + ':00, '+ _dateTime!.day.toString() + ' '+changeMonth2String(_dateTime!.add(Duration(days: 0)).month.toString()) +')'),
//           ],
//           isCurved: true,
//           colors: gradientColors,
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: false,
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData monthlyData(_dateTime) {
//     List<int> roundMonth = [];
//     for(double dbl in thisMonthOrdersChart) {
//       roundMonth.add(dbl.round());
//     }
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xFFd6d8db),
//             strokeWidth: 1,
//             // dashArray: [0]
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//               color: const Color(0xFFd6d8db),
//               strokeWidth: 1,
//               dashArray: [5]
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           interval: 1,
//           getTextStyles: (context, value) =>
//           const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
//           getTitles: (value) {
//             // DateTime day = DateTime.now().add(Duration(days: 1));
//             // for(int i = 0; i<7; i++) {
//             //   today = today.subtract(Duration(days: 1));
//             //   return today.day.toString();
//             //
//             // }
//             // return '';
//             // DateTime today = DateTime.now();
//             // today.day.toString()
//             switch (value.toInt()) {
//               case 0:
//                 return _dateTime!.subtract(Duration(days: 30)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 29)).month.toString());
//               case 5:
//                 return _dateTime!.subtract(Duration(days: 25)).day.toString();
//               case 10:
//                 return _dateTime!.subtract(Duration(days: 20)).day.toString();
//               case 15:
//                 return _dateTime!.subtract(Duration(days: 15)).day.toString();
//               case 20:
//                 return _dateTime!.subtract(Duration(days: 10)).day.toString();
//               case 25:
//                 return _dateTime!.subtract(Duration(days: 5)).day.toString();
//               case 30:
//                 return 'Today';
//             // return today.day.toString() + ', ' + changeMonth2String(today.month.toString());
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.w500,
//             fontSize: 13,
//           ),
//           getTitles: (value) {
//             // switch (value.toInt()) {
//             //   case 1:
//             //     return '10k';
//             //   case 3:
//             //     return '30k';
//             //   case 5:
//             //     return (findMax(roundWeek)/1000000).round().toString() + 'M';
//             // }
//             // return '';
//
//             chgDeci3Place(findMax(roundMonth));
//             var unit;
//             var quantity;
//             if(chgDeci3Place(findMax(roundMonth))==100.0) {
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundMonth))*10;
//             } else if(chgDeci3Place(findMax(roundMonth))==1000.0){
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundMonth));
//             }else if(chgDeci3Place(findMax(roundMonth))==10000.0){
//               unit='K';
//               quantity = chgDeci3Place(findMax(roundMonth))/10;
//             }else if(chgDeci3Place(findMax(roundMonth))==100000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundMonth))*10;
//             }else if(chgDeci3Place(findMax(roundMonth))==1000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundMonth));
//             }else if(chgDeci3Place(findMax(roundMonth))==10000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundMonth))/10;
//             }else if(chgDeci3Place(findMax(roundMonth))==100000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundMonth))*10;
//             }else if(chgDeci3Place(findMax(roundMonth))== 1000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundMonth));
//             }else if(chgDeci3Place(findMax(roundMonth))== 10000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundMonth))/10;
//             }else {
//               unit='';
//               quantity = 1;
//             }
//
//             if(value.toInt() == 5) {
//               return (findMax(roundMonth)/quantity).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 3) {
//               return ((findMax(roundMonth)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 1) {
//               return ((findMax(roundMonth)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
//             }
//
//
//
//             debugPrint('value ' + findMax(roundMonth).toString());
//             return '';
//           },
//           reservedSize: 42,
//           margin: 6,
//         ),
//       ),
//       borderData:
//       FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFFd6d8db), width: 0))),
//       minX: 0,
//       maxX: 30,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: [
//             // double.parse(((thisWeekOrdersChart[5]/1000000)).toString())
//             FlSpot(0, (((thisMonthOrdersChart[0]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[0]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[0]).toString()  + '\n(' + _dateTime!.subtract(Duration(days: 30)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 30)).month.toString()) + ')'),
//             FlSpot(1, (((thisMonthOrdersChart[1]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[1]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[1]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 29)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 29)).month.toString()) + ')'),
//             FlSpot(2, (((thisMonthOrdersChart[2]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[2]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[2]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 28)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 28)).month.toString()) + ')'),
//             FlSpot(3, (((thisMonthOrdersChart[3]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[3]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[3]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 27)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 27)).month.toString()) + ')'),
//             // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
//             // (thisWeekOrdersChart[4]/1000000) * 3.260
//             FlSpot(4, (((thisMonthOrdersChart[4]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[4]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[4]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 26)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 26)).month.toString()) + ')'),
//             FlSpot(5, (((thisMonthOrdersChart[5]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[5]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[5]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 25)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 25)).month.toString()) + ')'),
//             FlSpot(6, (((thisMonthOrdersChart[6]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[6]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[6]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 24)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 24)).month.toString()) + ')'),
//
//             FlSpot(7, (((thisMonthOrdersChart[7]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[7]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[7]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 23)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 23)).month.toString()) + ')'),
//             FlSpot(8, (((thisMonthOrdersChart[8]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[8]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[8]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 22)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 22)).month.toString()) + ')'),
//             FlSpot(9, (((thisMonthOrdersChart[9]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[9]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[9]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 21)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 21)).month.toString()) + ')'),
//             FlSpot(10, (((thisMonthOrdersChart[10]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[10]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[10]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 20)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 20)).month.toString()) + ')'),
//             // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
//             // (thisWeekOrdersChart[4]/1000000) * 3.260
//             FlSpot(11, (((thisMonthOrdersChart[11]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[11]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[11]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 19)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 19)).month.toString()) + ')'),
//             FlSpot(12, (((thisMonthOrdersChart[12]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[12]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[12]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 18)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 18)).month.toString()) + ')'),
//             FlSpot(13, (((thisMonthOrdersChart[13]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[13]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[13]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 17)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 17)).month.toString()) + ')'),
//
//             FlSpot(14, (((thisMonthOrdersChart[14]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[14]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[14]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 16)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 16)).month.toString()) + ')'),
//             FlSpot(15, (((thisMonthOrdersChart[15]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[15]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[15]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 15)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 15)).month.toString()) + ')'),
//             FlSpot(16, (((thisMonthOrdersChart[16]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[16]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[16]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 14)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 14)).month.toString()) + ')'),
//             FlSpot(17,(((thisMonthOrdersChart[17]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[17]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[17]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 13)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 13)).month.toString()) + ')'),
//             // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
//             // (thisWeekOrdersChart[4]/1000000) * 3.260
//             FlSpot(18, (((thisMonthOrdersChart[18]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[18]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[18]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 12)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 12)).month.toString()) + ')'),
//             FlSpot(19, (((thisMonthOrdersChart[19]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[19]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[19]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 11)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 11)).month.toString()) + ')'),
//             FlSpot(20, (((thisMonthOrdersChart[20]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[20]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[20]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 10)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 10)).month.toString()) + ')'),
//
//             FlSpot(21,(((thisMonthOrdersChart[21]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[21]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[21]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 9)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 9)).month.toString()) + ')'),
//             FlSpot(22, (((thisMonthOrdersChart[22]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[22]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[22]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 8)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 8)).month.toString()) + ')'),
//             FlSpot(23, (((thisMonthOrdersChart[23]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[23]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[23]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 7)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 7)).month.toString()) + ')'),
//             FlSpot(24, (((thisMonthOrdersChart[24]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[24]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[24]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 6)).month.toString()) + ')'),
//             // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
//             // (thisWeekOrdersChart[4]/1000000) * 3.260
//             FlSpot(25, (((thisMonthOrdersChart[25]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[25]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[25]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 5)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 5)).month.toString()) + ')'),
//             FlSpot(26, (((thisMonthOrdersChart[26]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[26]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[26]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 4)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 4)).month.toString()) + ')'),
//             FlSpot(27, (((thisMonthOrdersChart[27]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[27]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[27]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 3)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 3)).month.toString()) + ')'),
//
//             FlSpot(28, (((thisMonthOrdersChart[28]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[28]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[28]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 2)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 2)).month.toString()) + ')'),
//             FlSpot(29, (((thisMonthOrdersChart[29]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[29]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[29]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 1)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 1)).month.toString()) + ')'),
//             FlSpot(30, (((thisMonthOrdersChart[30]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth)))).toString() == "NaN" ? 0.0 : ((thisMonthOrdersChart[30]/chgDeci3Place(findMax(roundMonth))) * 5 )/ (findMax(roundMonth)/chgDeci3Place(findMax(roundMonth))), (thisMonthOrdersChart[30]).toString() + '\n(' + _dateTime!.day.toString() + ', ' + changeMonth2String(_dateTime!.month.toString()) + ')'),
//           ],
//           isCurved: true,
//           colors: gradientColors,
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: false,
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData weeklyData(_dateTime) {
//     List<int> roundWeek = [];
//     for(double dbl in thisWeekOrdersChart) {
//       roundWeek.add(dbl.round());
//     }
//     int five = 5;
//     // debugPrint(roundWeek.toString);
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xFFd6d8db),
//             strokeWidth: 1,
//             // dashArray: [0]
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//               color: const Color(0xFFd6d8db),
//               strokeWidth: 1,
//               dashArray: [5]
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           interval: 1,
//           getTextStyles: (context, value) =>
//           const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
//           getTitles: (value) {
//             // DateTime day = DateTime.now().add(Duration(days: 1));
//             // for(int i = 0; i<7; i++) {
//             //   today = today.subtract(Duration(days: 1));
//             //   return today.day.toString();
//             //
//             // }
//             // return '';
//             // DateTime today = DateTime.now();
//             // today.day.toString()
//             switch (value.toInt()) {
//               case 0:
//                 return _dateTime!.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 6)).month.toString());
//               case 1:
//                 return _dateTime!.subtract(Duration(days: 5)).day.toString();
//               case 2:
//                 return _dateTime!.subtract(Duration(days: 4)).day.toString();
//               case 3:
//                 return _dateTime!.subtract(Duration(days: 3)).day.toString();
//               case 4:
//                 return _dateTime!.subtract(Duration(days: 2)).day.toString();
//               case 5:
//                 return _dateTime!.subtract(Duration(days: 1)).day.toString();
//               case 6:
//                 return 'Today';
//             // return today.day.toString() + ', ' + changeMonth2String(today.month.toString());
//
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.w500,
//             fontSize: 13,
//           ),
//           getTitles: (value) {
//             // switch (value.toInt()) {
//             //   case 1:
//             //     return '10k';
//             //   case 3:
//             //     return '30k';
//             //   case 5:
//             //     return (findMax(roundWeek)/1000000).round().toString() + 'M';
//             // }
//             // return '';
//
//             chgDeci3Place(findMax(roundWeek));
//
//             var unit;
//             var quantity;
//             if(chgDeci3Place(findMax(roundWeek))==100.0) {
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundWeek))*10;
//             } else if(chgDeci3Place(findMax(roundWeek))==1000.0){
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundWeek));
//             }else if(chgDeci3Place(findMax(roundWeek))==10000.0){
//               unit='K';
//               quantity = chgDeci3Place(findMax(roundWeek))/10;
//             }else if(chgDeci3Place(findMax(roundWeek))==100000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundWeek))*10;
//             }else if(chgDeci3Place(findMax(roundWeek))==1000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundWeek));
//             }else if(chgDeci3Place(findMax(roundWeek))==10000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundWeek))/10;
//             }else if(chgDeci3Place(findMax(roundWeek))==100000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundWeek))*10;
//             }else if(chgDeci3Place(findMax(roundWeek))== 1000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundWeek));
//             }else if(chgDeci3Place(findMax(roundWeek))== 10000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundWeek))/10;
//             }else {
//               unit='';
//               quantity = 1;
//             }
//
//             if(value.toInt() == 5) {
//               return (findMax(roundWeek)/quantity).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 3) {
//               return ((findMax(roundWeek)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 1) {
//               return ((findMax(roundWeek)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
//             }
//
//
//
//             debugPrint('value ' + findMax(roundWeek).toString());
//             return '';
//           },
//           reservedSize: 42,
//           margin: 6,
//         ),
//       ),
//       borderData:
//       FlBorderData(show: true, border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFFd6d8db), width: 0))),
//       minX: 0,
//       maxX: 6,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: [
//             // double.parse(((thisWeekOrdersChart[5]/1000000)).toString())
//             FlSpot(0, (((thisWeekOrdersChart[1]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[1]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[1]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 6)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 6)).month.toString()) + ')'),
//             FlSpot(1, (((thisWeekOrdersChart[2]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[2]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[2]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 5)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 5)).month.toString()) + ')'),
//             FlSpot(2, (((thisWeekOrdersChart[3]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[3]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[3]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 4)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 4)).month.toString()) + ')'),
//             FlSpot(3, (((thisWeekOrdersChart[4]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[4]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[4]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 3)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 3)).month.toString()) + ')'),
//             // ((thisWeekOrdersChart[3]/1000000) * 5 )/ (findMax(roundWeek)/1000000)
//             // (thisWeekOrdersChart[4]/1000000) * 3.260
//             FlSpot(4, (((thisWeekOrdersChart[5]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[5]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[5]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 2)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 2)).month.toString()) + ')'),
//             FlSpot(5, (((thisWeekOrdersChart[6]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[6]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[6]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 1)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 1)).month.toString()) + ')'),
//             FlSpot(6, (((thisWeekOrdersChart[7]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek)))).toString() == "NaN" ? 0.0 :((thisWeekOrdersChart[7]/chgDeci3Place(findMax(roundWeek))) * 5 )/ (findMax(roundWeek)/chgDeci3Place(findMax(roundWeek))), (thisWeekOrdersChart[7]).toString() + '\n(' + _dateTime!.subtract(Duration(days: 0)).day.toString() + ', ' + changeMonth2String(_dateTime!.subtract(Duration(days: 0)).month.toString()) + ')'),
//           ],
//           isCurved: true,
//           colors: gradientColors,
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: false,
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData yearlyData(_dateTime) {
//     List<int> roundYear = [];
//     String subMonths = _dateTime!.month.toString();
//     for(double dbl in thisYearOrdersChart) {
//       roundYear.add(dbl.round());
//     }
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xFFd6d8db),
//             strokeWidth: 1,
//             // dashArray: [0]
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//               color: const Color(0xFFd6d8db),
//               strokeWidth: 1,
//               dashArray: [5]
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           interval: 1,
//           getTextStyles: (context, value) =>
//           const TextStyle(color: Colors.Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
//           getTitles: (value) {
//             switch (value.toInt()) {
//             // case 0:
//             //   return (int.parse(today.month.toString()) - int.parse(subMonths)).toString();
//               case 0:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+1).toString();
//               case 1:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+2).toString();
//               case 2:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+3).toString();
//               case 3:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+4).toString();
//               case 4:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+5).toString();
//               case 5:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+6).toString();
//               case 6:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+7).toString();
//               case 7:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+8).toString();
//               case 8:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+9).toString();
//               case 9:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+10).toString();
//               case 10:
//                 return (int.parse(_dateTime!.month.toString()) - int.parse(subMonths)+11).toString();
//               case 11:
//                 return _dateTime!.year.toString();
//             }
//             return '';
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.w500,
//             fontSize: 13,
//           ),
//           getTitles: (value) {
//
//             chgDeci3Place(findMax(roundYear));
//
//             var unit;
//             var quantity;
//             if(chgDeci3Place(findMax(roundYear))==100.0) {
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundYear))*10;
//             } else if(chgDeci3Place(findMax(roundYear))==1000.0){
//               unit = 'K';
//               quantity = chgDeci3Place(findMax(roundYear));
//             }else if(chgDeci3Place(findMax(roundYear))==10000.0){
//               unit='K';
//               quantity = chgDeci3Place(findMax(roundYear))/10;
//             }else if(chgDeci3Place(findMax(roundYear))==100000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundYear))*10;
//             }else if(chgDeci3Place(findMax(roundYear))==1000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundYear));
//             }else if(chgDeci3Place(findMax(roundYear))==10000000.0){
//               unit='M';
//               quantity = chgDeci3Place(findMax(roundYear))/10;
//             }else if(chgDeci3Place(findMax(roundYear))==100000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundYear))*10;
//             }else if(chgDeci3Place(findMax(roundYear))== 1000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundYear));
//             }else if(chgDeci3Place(findMax(roundYear))== 10000000000.0){
//               unit='B';
//               quantity = chgDeci3Place(findMax(roundYear))/10;
//             }else {
//               unit='';
//               quantity = 1;
//             }
//
//             if(value.toInt() == 5) {
//               return   (findMax(roundYear)/quantity).toStringAsFixed(1) + ' $unit';
//             }else if(value.toInt() == 3) {
//               return ((findMax(roundYear)/quantity)*(3/5)).toStringAsFixed(1) + ' $unit';
//             } else if(value.toInt() == 1) {
//               return ((findMax(roundYear)/quantity)*(1/5)).toStringAsFixed(1) + ' $unit';
//             }
//             debugPrint('value ' + findMax(roundYear).toString());
//             return '';
//           },
//           reservedSize: 35,
//           margin: 8,
//         ),
//       ),
//       borderData:
//       FlBorderData(show: true, border: Border.all(color: const Color(0xFFd6d8db), width: 0)),
//       minX: 0,
//       maxX: 11,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: [
//             FlSpot(0,(((thisYearOrdersChart[1]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[1]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[1]).toString() + '\n(January)'),
//             FlSpot(1,(((thisYearOrdersChart[2]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[2]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[2]).toString() + '\n(February)'),
//             FlSpot(2,(((thisYearOrdersChart[3]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[3]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[3]).toString() + '\n(March)'),
//             FlSpot(3,(((thisYearOrdersChart[4]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[4]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[4]).toString() + '\n(April)'),
//             FlSpot(4,(((thisYearOrdersChart[5]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[5]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[5]).toString() + '\n(May)'),
//             FlSpot(5,(((thisYearOrdersChart[6]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[6]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[6]).toString() + '\n(June)'),
//             FlSpot(6,(((thisYearOrdersChart[7]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[7]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[7]).toString() + '\n(July)'),
//             FlSpot(7,(((thisYearOrdersChart[8]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[8]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[8]).toString() + '\n(August)'),
//             FlSpot(8,(((thisYearOrdersChart[9]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[9]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[9]).toString() + '\n(September)'),
//             FlSpot(9,(((thisYearOrdersChart[10]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[10]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[10]).toString() + '\n(October)'),
//             FlSpot(10,(((thisYearOrdersChart[11]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[11]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[11]).toString() + '\n(November)'),
//             FlSpot(11,(((thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear)))).toString() == "NaN" ? 0.0 : ((thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[12]).toString() + '\n(December)'),
//             //FlSpot(12,((thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))) * 5 )/ (findMax(roundYear)/chgDeci3Place(findMax(roundYear))), (thisYearOrdersChart[12]/chgDeci3Place(findMax(roundYear))).toString()),
//           ],
//           isCurved: true,
//           colors: gradientColors,
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: false,
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String changeMonth2String(String str) {
//     if(str == '1') {
//       return 'Jan';
//     } else if(str == '2') {
//       return 'Feb';
//     } else if(str == '3') {
//       return 'Mar';
//     } else if(str == '4') {
//       return 'Apr';
//     } else if(str == '5') {
//       return 'May';
//     } else if(str == '6') {
//       return 'Jun';
//     } else if(str == '7') {
//       return 'Jul';
//     } else if(str == '8') {
//       return 'Aug';
//     } else if(str == '9') {
//       return 'Sep';
//     } else if(str == '10') {
//       return 'Oct';
//     } else if(str == '11') {
//       return 'Nov';
//     } else if(str == '12') {
//       return 'Dec';
//     } else {
//       return '';
//     }
//   }
//
//   double funChange(max) {
//     // debugPrint(findMax(roundWeek));
//     max = max/chgDeci3Place(max);
//     debugPrint('gg ' + (5.0 - max).toString());
//     return 5.0 - max;
//   }
//
//   double chgDeci3Place(max) {
//     double ten = 10.0;
//     for(int i = 0; i<max.toString().length - 2; i++) {
//       ten = ten * 10;
//     }
//     return ten;
//     // debugPrint('length ' + ten.toString().toString());
//   }
//
//   int _sliding = 0;
//
//   late final bool showPerformanceOverlay;
//   late final ValueChanged<bool> onShowPerformanceOverlayChanged;
//   late final a11yGalleries = a11y.buildGallery();
//   late final barGalleries = bar.buildGallery();
//   late final timeSeriesGalleries = time_series.buildGallery();
//   late final lineGalleries = line.buildGallery();
//   late final scatterPlotGalleries = scatter_plot.buildGallery();
//   late final comboGalleries = combo.buildGallery();
//   late final pieGalleries = pie.buildGallery();
//   late final axesGalleries = axes.buildGallery();
//   late final behaviorsGalleries = behaviors.buildGallery();
//   late final i18nGalleries = i18n.buildGallery();
//   late final legendsGalleries = legends.buildGallery();
//   @override
//   Widget build(BuildContext context) {
//
//     var galleries = <Widget>[];
//
//     galleries.addAll(
//         a11yGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example bar charts.
//     galleries.addAll(
//         barGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example time series charts.
//     galleries.addAll(timeSeriesGalleries
//         .map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example line charts.
//     galleries.addAll(
//         lineGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example scatter plot charts.
//     galleries.addAll(scatterPlotGalleries
//         .map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example pie charts.
//     galleries.addAll(
//         comboGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example pie charts.
//     galleries.addAll(
//         pieGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add example custom axis.
//     galleries.addAll(
//         axesGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     galleries.addAll(behaviorsGalleries
//         .map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add legends examples
//     galleries.addAll(legendsGalleries
//         .map((gallery) => gallery.buildGalleryListTile(context)));
//
//     // Add examples for i18n.
//     galleries.addAll(
//         i18nGalleries.map((gallery) => gallery.buildGalleryListTile(context)));
//
//     _setupPerformance();
//     return Scaffold(
//       body: SafeArea(
//           top: true,
//           bottom: true,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 5),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
//                 // mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: 76,
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Colors.Colors.grey.withOpacity(0.3),
//                                 width: 1.0))),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 18.0, right: 15.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 16),
//                             child: Container(
//                               width: 37,
//                               height: 37,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(35.0),
//                                   ),
//                                   color: Colors.Colors.grey.withOpacity(0.3)),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 3.0),
//                                 child: IconButton(
//                                     icon: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       size: 17,
//                                       color: Colors.Colors.black,
//                                     ),
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     }),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 16.0),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           // example dialog
//                                           // OneContext().showDialog(
//                                           //   // barrierDismissible: false,
//                                           //     builder: (_) => AlertDialog(
//                                           //       title: new Text("The Title"),
//                                           //       content: new Text("The Body"),
//                                           //     )
//                                           // );
//
//
//
//                                           _showDatePicker(OneContext().context);
//                                           debugPrint('testing123' + DateTime.now().toString());
//                                         },
//                                         child: Text(
//                                           'Change',
//                                           textAlign: TextAlign.right,
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.Colors.blue
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         selectDaysCast(),
//                                         textAlign: TextAlign.right,
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     'Top sale categories',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.Colors.white,
//                         border: Border(
//                           bottom: BorderSide(
//                             // color: AppTheme.skBorderColor2,
//                               color: Colors.Colors.white,
//                               width: 1.0),
//                         )),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 15.0, right: 15.0),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: CupertinoSlidingSegmentedControl(
//                             children: {
//                               0: Text('Day'),
//                               1: Text('Week'),
//                               2: Text('Month'),
//                               3: Text('Year'),
//                             },
//                             groupValue: _sliding,
//                             onValueChanged: (newValue) {
//                               setState(() {
//                                 _sliding = int.parse(newValue.toString());
//                               });
//                             }),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       // height: MediaQuery.of(context).size.height-353,
//                       // width: MediaQuery.of(context).size.width,
//                       color: Colors.Colors.grey.withOpacity(0.1),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
//                         child: ListView(
//                           children: [
//                             Container(
//                               height: MediaQuery.of(context).size.height-353,
//                               width: MediaQuery.of(context).size.width,
//                               color: AppTheme.skBorderColor,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
//                                 child: ListView(
//                                   children: [
//                                     SizedBox(height: 15,),
//
//
//                                     // Jiggle(
//                                     //   jiggleController: controller,
//                                     //   useGestures: true,
//                                     //   extent: 3,
//                                     //   child: Container(
//                                     //     height: 200,
//                                     //     margin: EdgeInsets.all(20),
//                                     //     decoration: BoxDecoration(
//                                     //         color: Colors.Colors.blueAccent,
//                                     //         borderRadius: BorderRadius.circular(20)),
//                                     //   ),
//                                     // ),
//
//
//
//
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: Text(
//                                         titleTextBySlide(),
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 13,
//                                           letterSpacing: 2,
//                                           color: Colors.Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//
//
//                                     // Padding(
//                                     //   padding: const EdgeInsets.only(
//                                     //       left: 7.5, right: 7.5),
//                                     //   child: Row(
//                                     //     children: [
//                                     //       Padding(
//                                     //         padding: const EdgeInsets.only(left: 7.5, right: 7.5),
//                                     //         child: GestureDetector(
//                                     //           onTap: () {
//                                     //             widget._callback();
//                                     //           },
//                                     //           child: Container(
//                                     //             decoration: BoxDecoration(
//                                     //               borderRadius:
//                                     //               BorderRadius.circular(10.0),
//                                     //               color: Colors.Colors.green.withOpacity(0.4),
//                                     //             ),
//                                     //             width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
//                                     //             height: 120,
//                                     //             child: Padding(
//                                     //               padding: const EdgeInsets.all(18.0),
//                                     //               child: Column(
//                                     //                 mainAxisAlignment: MainAxisAlignment.start,
//                                     //                 crossAxisAlignment: CrossAxisAlignment.start,
//                                     //                 children: [
//                                     //                   Icon(Icons.add_shopping_cart_rounded),
//                                     //                   Expanded(
//                                     //                     child: Align(
//                                     //                       alignment: Alignment.bottomLeft,
//                                     //                       child: Text(
//                                     //                         'Add orders',
//                                     //                         style: TextStyle(
//                                     //                             fontSize: 18,
//                                     //                             fontWeight: FontWeight.w500,
//                                     //                             color: Colors.Colors.black.withOpacity(0.6)
//                                     //                         ),
//                                     //                       ),
//                                     //                     ),
//                                     //                   )
//                                     //                 ],
//                                     //               ),
//                                     //             ),
//                                     //           ),
//                                     //         ),
//                                     //       ),
//                                     //       Padding(
//                                     //         padding: const EdgeInsets.only(
//                                     //             left: 7.5, right: 7.5),
//                                     //         child: Container(
//                                     //           decoration: BoxDecoration(
//                                     //             borderRadius:
//                                     //             BorderRadius.circular(10.0),
//                                     //             color: Colors.Colors.blue.withOpacity(0.4),
//                                     //           ),
//                                     //           width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
//                                     //           height: 120,
//                                     //           child: Padding(
//                                     //             padding: const EdgeInsets.all(18.0),
//                                     //             child: Column(
//                                     //               mainAxisAlignment: MainAxisAlignment.start,
//                                     //               crossAxisAlignment: CrossAxisAlignment.start,
//                                     //               children: [
//                                     //                 Icon(Icons.volunteer_activism),
//                                     //                 Expanded(
//                                     //                     child: Align(
//                                     //                       alignment: Alignment.bottomLeft,
//                                     //                       child: TextButton(
//                                     //                         onPressed: (){
//                                     //                           Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyDiscount()
//                                     //                           ),
//                                     //                           );
//                                     //                         },
//                                     //                         child: Text('Add discount',
//                                     //                           style: TextStyle(
//                                     //                               fontSize: 18,
//                                     //                               fontWeight: FontWeight.w500,
//                                     //                               color: Colors.Colors.black.withOpacity(0.6)
//                                     //                           ),),
//                                     //                       ),
//                                     //                     )
//                                     //                 ),
//                                     //               ],
//                                     //             ),
//                                     //           ),
//                                     //         ),
//                                     //       ),
//                                     //     ],
//                                     //   ),
//                                     // ),
//
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     // Padding(
//                                     //   padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 20.0),
//                                     //   child: Container(
//                                     //     child: Row(
//                                     //       children: [
//                                     //         Text('5,503,230 MMKs',
//                                     //           textAlign: TextAlign.left,
//                                     //           style: TextStyle(
//                                     //               fontSize: 20,
//                                     //               fontWeight: FontWeight.w500,
//                                     //               color: Colors.Colors.black),
//                                     //         ),
//                                     //         Expanded(
//                                     //           child: GestureDetector(
//                                     //             onTap: () {
//                                     //               Navigator.push(context, MaterialPageRoute(builder: (context) => TopSaleDetail()),);
//                                     //             },
//                                     //             child: Text('12%',
//                                     //               textAlign: TextAlign.right,
//                                     //               style: TextStyle(
//                                     //                   fontSize: 20,
//                                     //                   fontWeight: FontWeight.w500,
//                                     //                   color: Colors.Colors.green),
//                                     //             ),
//                                     //           ),
//                                     //         )
//                                     //       ],
//                                     //     ),
//                                     //   ),
//                                     // ),
//
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0),
//                                         ),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//
//                                           // Padding(
//                                           //   padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
//                                           //   child: Container(
//                                           //     height: 1,
//                                           //     color: AppTheme.skBorderColor2,
//                                           //   ),
//                                           // ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 2.0),
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   Text(totalBySlide(),
//                                                     textAlign: TextAlign.left,
//                                                     style: GoogleFonts.lato(
//                                                         textStyle: TextStyle(
//                                                             letterSpacing: 1,
//                                                             fontSize: 30,
//                                                             fontWeight: FontWeight.w500,
//                                                             color: Colors.Colors.black
//                                                         )
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 12.0),
//                                                     child: Text(' MMK',
//                                                       textAlign: TextAlign.left,
//                                                       style: GoogleFonts.roboto(
//                                                           textStyle: TextStyle(
//                                                               letterSpacing: 1,
//                                                               fontSize: 16,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.Colors.black
//                                                           )
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     child: Container(),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 3.0),
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.all(
//                                                           Radius.circular(5.0),
//                                                         ),
//                                                         color: Colors.Colors.green,
//                                                       ),
//                                                       width: 50,
//                                                       height: 25,
//                                                       child: Center(
//                                                         child: Text('12%',
//                                                           textAlign: TextAlign.right,
//                                                           style: TextStyle(
//                                                               fontSize: 15,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.Colors.white),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
//                                             child: Row(
//                                               children: [
//                                                 Text('Total sales',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight: FontWeight.w500,
//                                                       color: Colors.Colors.black),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Container(
//                                             height: 100,
//                                             child: ListView(
//                                               scrollDirection: Axis.horizontal,
//                                               children: [
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//                                                 Container(
//                                                   // width: 100,
//                                                   height: 108,
//
//                                                   constraints: BoxConstraints(
//                                                       maxWidth: double.infinity, minWidth: 120),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(8),
//                                                       border: Border(
//                                                         bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                       ),
//                                                       color: Colors.Colors.white
//                                                   ),
//
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
//                                                     child: Stack(
//                                                       children: [
//                                                         Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             SizedBox(
//                                                                 height:26
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(right:30.0),
//                                                               child: Text('203,230',
//                                                                 textAlign: TextAlign.left,
//                                                                 style: GoogleFonts.lato(
//                                                                     textStyle: TextStyle(
//                                                                         letterSpacing: 1,
//                                                                         fontSize: 20,
//                                                                         fontWeight: FontWeight.w500,
//                                                                         color: Colors.Colors.black
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Positioned(
//                                                             right: 0,
//                                                             top: 0,
//                                                             child: Text('?')
//                                                         ),
//                                                         Text('Net Profit',
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.Colors.black.withOpacity(0.6)),
//                                                         ),
//
//                                                         Positioned(
//                                                             right: 0,
//                                                             bottom: 2,
//                                                             child: Text('+20%',
//                                                               style: TextStyle(
//                                                                   fontSize: 13,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.Colors.green),
//                                                             )
//                                                         ),
//                                                         Positioned(
//                                                           left: 0,
//                                                           bottom: 2,
//                                                           child: Text('MMK',
//                                                             style: TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.Colors.black.withOpacity(0.6)),
//                                                           ),
//                                                         ),
//
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//
//                                                 Container(
//                                                   // width: 100,
//                                                   height: 108,
//
//                                                   constraints: BoxConstraints(
//                                                       maxWidth: double.infinity, minWidth: 120),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(8),
//                                                       border: Border(
//                                                         bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                       ),
//                                                       color: Colors.Colors.white
//                                                   ),
//
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
//                                                     child: Stack(
//                                                       children: [
//                                                         Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             SizedBox(
//                                                                 height:26
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(right:30.0),
//                                                               child: Text('3,230',
//                                                                 textAlign: TextAlign.left,
//                                                                 style: GoogleFonts.lato(
//                                                                     textStyle: TextStyle(
//                                                                         letterSpacing: 1,
//                                                                         fontSize: 20,
//                                                                         fontWeight: FontWeight.w500,
//                                                                         color: Colors.Colors.black
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Positioned(
//                                                             right: 0,
//                                                             top: 0,
//                                                             child: Text('?')
//                                                         ),
//                                                         Text('Debts',
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.Colors.black.withOpacity(0.6)),
//                                                         ),
//
//                                                         Positioned(
//                                                             right: 0,
//                                                             bottom: 2,
//                                                             child: Text('+2%',
//                                                               style: TextStyle(
//                                                                   fontSize: 13,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.Colors.red),
//                                                             )
//                                                         ),
//                                                         Positioned(
//                                                           left: 0,
//                                                           bottom: 2,
//                                                           child: Text('MMK',
//                                                             style: TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.Colors.black.withOpacity(0.6)),
//                                                           ),
//                                                         ),
//
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//
//                                                 Container(
//                                                   // width: 100,
//                                                   height: 108,
//
//                                                   constraints: BoxConstraints(
//                                                       maxWidth: double.infinity, minWidth: 120),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(8),
//                                                       border: Border(
//                                                         bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                       ),
//                                                       color: Colors.Colors.white
//                                                   ),
//
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
//                                                     child: Stack(
//                                                       children: [
//                                                         Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             SizedBox(
//                                                                 height:26
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(right:30.0),
//                                                               child: Text('1,903,230',
//                                                                 textAlign: TextAlign.left,
//                                                                 style: GoogleFonts.lato(
//                                                                     textStyle: TextStyle(
//                                                                         letterSpacing: 1,
//                                                                         fontSize: 20,
//                                                                         fontWeight: FontWeight.w500,
//                                                                         color: Colors.Colors.black
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Positioned(
//                                                             right: 0,
//                                                             top: 0,
//                                                             child: Text('?')
//                                                         ),
//                                                         Text('Buys',
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.Colors.black.withOpacity(0.6)),
//                                                         ),
//
//                                                         Positioned(
//                                                             right: 0,
//                                                             bottom: 2,
//                                                             child: Text('+20%',
//                                                               style: TextStyle(
//                                                                   fontSize: 13,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.Colors.green),
//                                                             )
//                                                         ),
//                                                         Positioned(
//                                                           left: 0,
//                                                           bottom: 2,
//                                                           child: Text('MMK',
//                                                             style: TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.Colors.black.withOpacity(0.6)),
//                                                           ),
//                                                         ),
//
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//
//                                                 Container(
//                                                   // width: 100,
//                                                   height: 100,
//                                                   constraints: BoxConstraints(
//                                                       maxWidth: double.infinity, minWidth: 120),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(8),
//                                                       border: Border(
//                                                         bottom: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         top: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         left: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                         right: BorderSide(color: AppTheme.skBorderColor2, width: 1),
//                                                       ),
//                                                       color: Colors.Colors.white
//                                                   ),
//
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
//                                                     child: Stack(
//                                                       children: [
//                                                         Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             SizedBox(
//                                                                 height:26
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(right:30.0),
//                                                               child: Text('230',
//                                                                 textAlign: TextAlign.left,
//                                                                 style: GoogleFonts.lato(
//                                                                     textStyle: TextStyle(
//                                                                         letterSpacing: 1,
//                                                                         fontSize: 20,
//                                                                         fontWeight: FontWeight.w500,
//                                                                         color: Colors.Colors.black
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Positioned(
//                                                             right: 0,
//                                                             top: 0,
//                                                             child: Text('?')
//                                                         ),
//                                                         Text('Refunds',
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.Colors.black.withOpacity(0.6)),
//                                                         ),
//
//                                                         Positioned(
//                                                             right: 0,
//                                                             bottom: 2,
//                                                             child: Text('+20%',
//                                                               style: TextStyle(
//                                                                   fontSize: 13,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.Colors.blue),
//                                                             )
//                                                         ),
//                                                         Positioned(
//                                                           left: 0,
//                                                           bottom: 2,
//                                                           child: Text('MMK',
//                                                             style: TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.Colors.black.withOpacity(0.6)),
//                                                           ),
//                                                         ),
//                                                         // Container(
//                                                         //     constraints: BoxConstraints(
//                                                         //         maxWidth: double.infinity, minWidth: 100, maxHeight: 30),
//                                                         //   // color: Colors.Colors.blue,
//                                                         //   child: Row(
//                                                         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                         //     children: [
//                                                         //       Text('Net Profit',
//                                                         //         style: TextStyle(
//                                                         //             fontSize: 15,
//                                                         //             fontWeight: FontWeight.w500,
//                                                         //             color: Colors.Colors.black.withOpacity(0.8)),
//                                                         //       ),
//                                                         //       Align(
//                                                         //         alignment: Alignment.topRight,
//                                                         //         child: Text('?')
//                                                         //       )],
//                                                         //   ),
//                                                         // ),
//                                                         //
//                                                         //
//                                                         // Align(
//                                                         //   alignment: Alignment.bottomLeft,
//                                                         //   child: Container(
//                                                         //     constraints: BoxConstraints(
//                                                         //         maxWidth: double.infinity, minWidth: 100, maxHeight: 30),
//                                                         //     // color: Colors.Colors.blue,
//                                                         //     child: Row(
//                                                         //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         //       crossAxisAlignment: CrossAxisAlignment.end,
//                                                         //       children: [
//                                                         //         Text('MMK',
//                                                         //           style: TextStyle(
//                                                         //               fontSize: 15,
//                                                         //               fontWeight: FontWeight.w500,
//                                                         //               color: Colors.Colors.black.withOpacity(0.8)),
//                                                         //         ),
//                                                         //         Align(
//                                                         //             alignment: Alignment.bottomRight,
//                                                         //             child: Text('+12%',
//                                                         //               style: TextStyle(
//                                                         //                   fontSize: 15,
//                                                         //                   fontWeight: FontWeight.w500,
//                                                         //                   color: Colors.Colors.black.withOpacity(0.8)),
//                                                         //             )
//                                                         //         )],
//                                                         //     ),
//                                                         //   ),
//                                                         // )
//
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                               height: 0.0
//                                           ),
//                                           Stack(
//                                             children: [
//
//                                               Padding(
//                                                 padding: const EdgeInsets.only(right: 10.0),
//                                                 child: AspectRatio(
//                                                   aspectRatio: 1.5,
//                                                   child: Container(
//                                                     decoration: const BoxDecoration(
//                                                       borderRadius: BorderRadius.all(
//                                                         Radius.circular(15),
//                                                       ),
//                                                       // color: Color(0xffFFFFFF)),
//                                                       // color: Colors.Colors.white,
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.only(right: 18.0, left: 8.0, top: 10, bottom: 10),
//                                                       child: lineChartByTab(),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 15.0, right: 15.0),
//                                             child: Container(
//                                               height: 2,
//                                               color: AppTheme.skBorderColor2,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//
//                                     SizedBox(
//                                       height: 0,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0),
//                                             ),
//                                             color: Colors.Colors.white
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(15.0),
//                                   ),
//                                   color: Colors.Colors.white
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//           )),
//
//
//     );
//   }
//
//   /// Display date picker.
//   void _showDatePicker(context) {
//     DatePicker.showDatePicker(
//       context,
//       onMonthChangeStartWithFirstDate: true,
//       pickerTheme: DateTimePickerTheme(
//         showTitle: false,
//         confirm: Text('Done', style: TextStyle(color: Colors.Colors.blue)),
//       ),
//       minDateTime: DateTime.parse('2010-05-12'),
//       maxDateTime: DateTime.parse('2021-11-25'),
//       initialDateTime: _dateTime,
//       dateFormat: _format,
//       locale: DateTimePickerLocale.en_us,
//       onClose: () {
//         setState((){
//           _dateTime = _dateTime;
//           DateTime td = DateTime.now();
//           debugPrint('closed 1 ' + _dateTime.toString());
//           debugPrint('closed 2 ' + td.toString());
//         });
//         fetchOrders();
//       },
//       onCancel: () => debugPrint('onCancel'),
//       onChange: (dateTime, List<int> index) {
//         _dateTime = dateTime;
//
//       },
//       onConfirm: (dateTime, List<int> index) {
//         setState(() {
//           _dateTime = dateTime;
//         });
//       },
//     );
//   }
//
//   void _setupPerformance() {
//     // Change [printPerformance] to true and set the app to release mode to
//     // print performance numbers to console. By default, Flutter builds in debug
//     // mode and this mode is slow. To build in release mode, specify the flag
//     // blaze-run flag "--define flutter_build_mode=release".
//     // The build target must also be an actual device and not the emulator.
//     charts.Performance.time = (String tag) => Timeline.startSync(tag);
//     charts.Performance.timeEnd = (_) => Timeline.finishSync();
//   }
//
//   String titleTextBySlide() {
//     if(_sliding == 0) {
//       return "TODAY SO FAR";
//     } else if(_sliding == 1) {
//       return "LAST 7 DAYS";
//     } else if(_sliding == 2) {
//       return "LAST 28 DAYS";
//     } else {
//       return "LAST 12 MONTHS";
//     }
//   }
//
//   lineChartByTab() {
//     if(_sliding==0) {
//       return LineChart(todayData(_dateTime));
//     } else if(_sliding==1) {
//       return LineChart(weeklyData(_dateTime));
//     } else if(_sliding==2) {
//       return LineChart(monthlyData(_dateTime));
//     }else if(_sliding==3) {
//       return LineChart(yearlyData(_dateTime));
//     }
//
//     //_sliding == 0 ? mainData(): weeklyData(DateTime.now()),
//
//   }
//
//   String selectDaysCast() {
//     // if(_sliding==0) {
//     if(_dateTime!.month == 9) {
//       return 'Sep ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 1) {
//       return 'Jan ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 2) {
//       return 'Feb ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 3) {
//       return 'Mar ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 4) {
//       return 'Apr ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 5) {
//       return 'May ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 6) {
//       return 'Jun ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 7) {
//       return 'Jul ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 8) {
//       return 'Aug ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 10) {
//       return 'Oct ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 11) {
//       return 'Nov ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else if(_dateTime!.month == 12) {
//       return 'Dec ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
//     } else {
//       return '';
//     }
//
//   }
//
//   String monthInt2Str(String str0, String str) {
//     if(str0 == str) {
//       return '';
//     }
//     if(str == '9') {
//       return 'Sep ';
//     } else if(str == '8') {
//       return 'Aug ';
//     } else {
//       return '';
//     }
//   }
//
//   String totalBySlide() {
//     double todayTotal=0.0;
//     for (int i = 0; i < todayOrdersChart.length; i++){
//       todayTotal += todayOrdersChart[i];
//     }
//
//     double monthlyTotal=0.0;
//     for (int i = 0; i < thisMonthOrdersChart.length; i++){
//       monthlyTotal += thisMonthOrdersChart[i];
//     }
//
//     double weeklyTotal=0.0;
//     for (int i = 0; i < thisWeekOrdersChart.length; i++){
//       weeklyTotal += thisWeekOrdersChart[i];
//     }
//
//     double yearlyTotal=0.0;
//     for (int i = 0; i < thisYearOrdersChart.length; i++){
//       yearlyTotal += thisYearOrdersChart[i];
//     }
//     if(_sliding == 0) {
//       return todayTotal.toStringAsFixed(2);
//     } else if(_sliding == 1) {
//       return weeklyTotal.toStringAsFixed(2);
//     } else if(_sliding == 2) {
//       return monthlyTotal.toStringAsFixed(2);
//     } else {
//       return yearlyTotal.toStringAsFixed(2);
//     }
//   }
// }
