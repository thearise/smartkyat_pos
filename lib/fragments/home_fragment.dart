import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/subs/donut.dart';
import 'package:smartkyat_pos/fragments/subs/top_sale_detail.dart';
import 'package:smartkyat_pos/pie_chart/simple.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:smartkyat_pos/widgets/apply_discount_to_cart.dart';
import 'package:smartkyat_pos/widgets/line_chart_sample2.dart';
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


class HomeFragment extends StatefulWidget {
  final _callback;

  HomeFragment({required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  @override
  _HomeFragmentState createState() => _HomeFragmentState();

// HomeFragment({Key? key, required void toggleCoinCallback()}) : super(key: key);
//
// @override
// _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeFragment> {
  @override
  bool get wantKeepAlive => true;

  final JiggleController controller = JiggleController();


  void _jiggleStuff() {
    controller.toggle();
  }

  @override
  initState() {
    super.initState();
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


  LineChartData mainData() {
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
                return '0';
              case 5:
                return '05';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
              case 25:
                return '25';
              case 30:
                return '30';

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
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
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
      maxX: 30,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 4),
            FlSpot(6, 3),
            FlSpot(7, 2),
            FlSpot(8, 5),
            FlSpot(9, 3.1),
            FlSpot(10, 0),
            FlSpot(11, 4),
            FlSpot(12, 3),
            FlSpot(13, 5),
            FlSpot(14, 5),
            FlSpot(15, 3.1),
            FlSpot(16, 4),
            FlSpot(17, 2),
            FlSpot(18, 3),
            FlSpot(19, 2),
            FlSpot(20, 1),
            FlSpot(21, 3),
            FlSpot(22, 3),
            FlSpot(23, 4),
            FlSpot(24, 3.1),
            FlSpot(25, 1.2),
            FlSpot(26, 4),
            FlSpot(27, 2),
            FlSpot(28, 4.1),
            FlSpot(29, 2),
            FlSpot(30, 2.7),
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




  LineChartData weeklyData() {
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
                return 'Sun';
              case 1:
                return 'Mon';
              case 2:
                return 'Tue';
              case 3:
                return 'Wed';
              case 4:
                return 'Thu';
              case 5:
                return 'Fri';
              case 6:
                return 'Sat';

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
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 35,
          margin: 8,
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
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 4),
            FlSpot(6, 3),
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

    return Scaffold(
      body: Container(
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
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 76.0, bottom: 0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      // color: AppTheme.skBorderColor2,
                                        color: Colors.Colors.white,
                                        width: 1.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 15.0, right: 15.0),
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
                            Container(
                              height: MediaQuery.of(context).size.height-353,
                              width: MediaQuery.of(context).size.width,
                              color: AppTheme.skBorderColor,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
                                child: ListView(
                                  children: [
                                    SizedBox(height: 15,),


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
                                      height: 10,
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
                                                  Text('15,503,230',
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
                                                                  Navigator.pop(context);
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
                                            height: 108,
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
                                                              height:30
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right:30.0),
                                                              child: Text('203,230',
                                                                textAlign: TextAlign.left,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(
                                                                        letterSpacing: 1,
                                                                        fontSize: 22,
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
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.Colors.black.withOpacity(0.6)),
                                                        ),

                                                        Positioned(
                                                            right: 0,
                                                            bottom: 3,
                                                            child: Text('+20%',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.Colors.green),
                                                            )
                                                        ),
                                                        Positioned(
                                                          left: 0,
                                                          bottom: 3,
                                                          child: Text('MMK',
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                                                height:30
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right:30.0),
                                                              child: Text('3,230',
                                                                textAlign: TextAlign.left,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(
                                                                        letterSpacing: 1,
                                                                        fontSize: 22,
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
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.Colors.black.withOpacity(0.6)),
                                                        ),

                                                        Positioned(
                                                            right: 0,
                                                            bottom: 3,
                                                            child: Text('+2%',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.Colors.red),
                                                            )
                                                        ),
                                                        Positioned(
                                                          left: 0,
                                                          bottom: 3,
                                                          child: Text('MMK',
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                                                height:30
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right:30.0),
                                                              child: Text('1,903,230',
                                                                textAlign: TextAlign.left,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(
                                                                        letterSpacing: 1,
                                                                        fontSize: 22,
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
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.Colors.black.withOpacity(0.6)),
                                                        ),

                                                        Positioned(
                                                            right: 0,
                                                            bottom: 3,
                                                            child: Text('+20%',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.Colors.green),
                                                            )
                                                        ),
                                                        Positioned(
                                                          left: 0,
                                                          bottom: 3,
                                                          child: Text('MMK',
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                                                height:30
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right:30.0),
                                                              child: Text('230',
                                                                textAlign: TextAlign.left,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(
                                                                        letterSpacing: 1,
                                                                        fontSize: 22,
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
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.Colors.black.withOpacity(0.6)),
                                                        ),

                                                        Positioned(
                                                            right: 0,
                                                            bottom: 3,
                                                            child: Text('+20%',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.Colors.blue),
                                                            )
                                                        ),
                                                        Positioned(
                                                          left: 0,
                                                          bottom: 3,
                                                          child: Text('MMK',
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                                      padding: const EdgeInsets.only(right: 18.0, left: 8.0, top: 5, bottom: 15),
                                                      child: LineChart(

                                                        _sliding == 0 ? weeklyData() : mainData(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  width: double.infinity,
                                                  height: 15,
                                                  color: AppTheme.skBorderColor
                                              ),
                                            ],
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
                                            color: Colors.Colors.white
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
                            ),
                          ],
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
                              top: 10.0, left: 15.0, right: 15.0, bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              // addDailyExp(context);
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
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 1.0),
                                        child: Container(
                                            child: Text(
                                              'Search',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.Colors.black),
                                            )
                                        ),
                                      ),
                                    ),
                                    Padding(
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
                                    )
                                  ],
                                ),
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
                  : Container()
            ],
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
