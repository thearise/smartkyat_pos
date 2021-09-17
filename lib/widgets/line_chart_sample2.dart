import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    // AppTheme.badgeFgSecond
    Colors.blue
    // const Color(0xff23b6e6),
    // const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: const BoxDecoration(
                // borderRadius: BorderRadius.all(
                //   Radius.circular(15),
                // ),
                // color: Color(0xffFFFFFF)),
              color: AppTheme.lightBgColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 8.0, top: 24, bottom: 12),
              child: LineChart(
                  mainData()
                // showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFd6d8db),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xFFd6d8db),
            strokeWidth: 1,
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
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
            fontWeight: FontWeight.bold,
            fontSize: 12,
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
          reservedSize: 32,
          margin: 8,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xFFd6d8db), width: 1)),
      minX: 0,
      maxX: 30,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3, ''),
            FlSpot(1, 2, ''),
            FlSpot(2, 5, ''),
            FlSpot(3, 3.1, ''),
            FlSpot(4, 4, ''),
            FlSpot(5, 4, ''),
            FlSpot(6, 3, ''),
            FlSpot(7, 2, ''),
            FlSpot(8, 5, ''),
            FlSpot(9, 3.1, ''),
            FlSpot(10, 0, ''),
            FlSpot(11, 4, ''),
            FlSpot(12, 3, ''),
            FlSpot(13, 5, ''),
            FlSpot(14, 5, ''),
            FlSpot(15, 3.1, ''),
            FlSpot(16, 4, ''),
            FlSpot(17, 2, ''),
            FlSpot(18, 3, ''),
            FlSpot(19, 2, ''),
            FlSpot(20, 1, ''),
            FlSpot(21, 3, ''),
            FlSpot(22, 3, ''),
            FlSpot(23, 4, ''),
            FlSpot(24, 3.1, ''),
            FlSpot(25, 1.2, ''),
            FlSpot(26, 4, ''),
            FlSpot(27, 2, ''),
            FlSpot(28, 4.1, ''),
            FlSpot(29, 2, ''),
            FlSpot(30, 2.7, ''),
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

  // LineChartData avgData() {
  //   return LineChartData(
  //     lineTouchData: LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: true,
  //       drawHorizontalLine: true,
  //       getDrawingVerticalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingHorizontalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: SideTitles(
  //         showTitles: true,
  //         reservedSize: 22,
  //         getTextStyles: (context, value) =>
  //         const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 2:
  //               return 'MAR';
  //             case 5:
  //               return 'JUN';
  //             case 8:
  //               return 'SEP';
  //           }
  //           return '';
  //         },
  //         margin: 8,
  //         interval: 1,
  //       ),
  //       leftTitles: SideTitles(
  //         showTitles: true,
  //         getTextStyles: (context, value) => const TextStyle(
  //           color: Color(0xff67727d),
  //           fontWeight: FontWeight.bold,
  //           fontSize: 15,
  //         ),
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 1:
  //               return '10k';
  //             case 3:
  //               return '30k';
  //             case 5:
  //               return '50k';
  //           }
  //           return '';
  //         },
  //         reservedSize: 32,
  //         interval: 1,
  //         margin: 12,
  //       ),
  //       topTitles: SideTitles(showTitles: false),
  //       rightTitles: SideTitles(showTitles: false),
  //     ),
  //     borderData:
  //     FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
  //     minX: 0,
  //     maxX: 11,
  //     minY: 0,
  //     maxY: 6,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: [
  //           FlSpot(0, 3.44),
  //           FlSpot(2.6, 3.44),
  //           FlSpot(4.9, 3.44),
  //           FlSpot(6.8, 3.44),
  //           FlSpot(8, 3.44),
  //           FlSpot(9.5, 3.44),
  //           FlSpot(11, 3.44),
  //         ],
  //         isCurved: true,
  //         colors: [
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
  //         ],
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(show: true, colors: [
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //               .lerp(0.2)!
  //               .withOpacity(0.1),
  //           ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //               .lerp(0.2)!
  //               .withOpacity(0.1),
  //         ]),
  //       ),
  //     ],
  //   );
  // }
}
