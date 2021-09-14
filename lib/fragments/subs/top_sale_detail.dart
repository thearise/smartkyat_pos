import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';

class TopSaleDetail extends StatefulWidget {

  @override
  _TopSaleDetailState createState() => _TopSaleDetailState();
}

class _TopSaleDetailState extends State<TopSaleDetail>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TopSaleDetail>{
  @override
  bool get wantKeepAlive => true;
  int _sliding = 0;
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM-dd';

  zeroAddDate(String str) {
    if(str.length>1) {
      return str;
    } else {
      return '0' + str;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _dateTime = DateTime.parse(DateTime.now().year.toString() + '-' + zeroAddDate(DateTime.now().month.toString()) + '-' + zeroAddDate(DateTime.now().day.toString()));
    print(DateTime.now().year.toString() + '-' + DateTime.now().month.toString() + '-' + DateTime.now().day.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 76,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35.0),
                                ),
                                color: Colors.grey.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 17,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // example dialog
                                        // OneContext().showDialog(
                                        //   // barrierDismissible: false,
                                        //     builder: (_) => AlertDialog(
                                        //       title: new Text("The Title"),
                                        //       content: new Text("The Body"),
                                        //     )
                                        // );



                                        _showDatePicker(OneContext().context);
                                      },
                                      child: Text(
                                        'Change',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      selectDaysCast(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Top sale categories',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          // color: AppTheme.skBorderColor2,
                            color: Colors.white,
                            width: 1.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 15.0, right: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoSlidingSegmentedControl(
                          children: {
                            0: Text('Day'),
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
                  color: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                    child: ListView(
                      children: [
                        SizedBox(height: 10,),
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

                        // Stack(
                        //   children: <Widget>[
                        //     AspectRatio(
                        //       aspectRatio: 1.5,
                        //       child: Container(
                        //         decoration: const BoxDecoration(
                        //           // borderRadius: BorderRadius.all(
                        //           //   Radius.circular(15),
                        //           // ),
                        //           // color: Color(0xffFFFFFF)),
                        //           color: AppTheme.lightBgColor,
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(right: 18.0, left: 8.0, top: 5, bottom: 12),
                        //           child: LineChart(
                        //
                        //             _sliding == 0 ? weeklyData() : mainData(),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 60,
                        //       height: 34,
                        //       child: TextButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             showAvg = !showAvg;
                        //           });
                        //         },
                        //         child: Text(
                        //           'avg',
                        //           style: TextStyle(
                        //               fontSize: 12, color: showAvg ? Colors.Colors.white.withOpacity(0.5) : Colors.Colors.white),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

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


                        // Container(
                        //   height: 100,
                        //   width: 100,
                        //   child: DonutPieChart.withRandomData()
                        // )

                        // Text(
                        //   titleTextBySlide(),
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 13,
                        //     letterSpacing: 2,
                        //     color: Colors.Colors.grey,
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              color: Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ])),


    );
  }

  /// Display date picker.
  void _showDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        confirm: Text('Done', style: TextStyle(color: Colors.blue)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      maxDateTime: DateTime.parse('2021-11-25'),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: DateTimePickerLocale.en_us,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  String selectDaysCast() {
    // if(_sliding==0) {
      if(_dateTime!.month == 9) {
        return 'Sep ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 1) {
        return 'Jan ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 2) {
        return 'Feb ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 3) {
        return 'Mar ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 4) {
        return 'Apr ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 5) {
        return 'May ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 6) {
        return 'Jun ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 7) {
        return 'Jul ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 8) {
        return 'Aug ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 10) {
        return 'Oct ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 11) {
        return 'Nov ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else if(_dateTime!.month == 12) {
        return 'Dec ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
      } else {
        return '';
      }
    // }

    // else if (_sliding==1) {
    //   var last7DDays = _dateTime!.subtract(new Duration(days: 7)).day.toString();
    //   var last7DMonth = _dateTime!.subtract(new Duration(days: 7)).month.toString();
    //   if(_dateTime!.month == 9) {
    //     return  'Sep ' + monthInt2Str(_dateTime!.month.toString(), last7DMonth) + last7DDays + ' - ' + _dateTime!.day.toString() + ', ' + _dateTime!.year.toString();
    //   } else {
    //     return '';
    //   }
    // } else {
    //   return '';
    // }
  }

  String monthInt2Str(String str0, String str) {
    if(str0 == str) {
      return '';
    }
    if(str == '9') {
      return 'Sep ';
    } else if(str == '8') {
      return 'Aug ';
    } else {
      return '';
    }
  }

}

