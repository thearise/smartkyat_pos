import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';

import '../app_theme.dart';

class ReportsFragment extends StatefulWidget {
  const ReportsFragment(
      {Key? key});
  @override
  ReportsFragmentState createState() => ReportsFragmentState();
}

class ReportsFragmentState extends State<ReportsFragment> {

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
            child: Text('SALES SUMMARY OVERVIEW', textScaleFactor: 1,
              style: TextStyle(
                height: 0.9,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 14,color: Colors.black,
              ),),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '7,245 M',
                        textScaleFactor: 1, textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )
                        ),
                      ),
                      Text(
                        'Net sales (MMK)',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.2
                      ),
                        style: TextStyle(
                            fontSize: 13, height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1,245 M',
                        textScaleFactor: 1, textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )
                        ),
                      ),
                      Text(
                        'Avg profit (MMK)',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.2
                      ),
                        style: TextStyle(
                            fontSize: 13, height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors
                              .grey
                              .withOpacity(
                              0.3),
                          width: 1.0)
                  )),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1,259',
                        textScaleFactor: 1, textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )
                        ),
                      ),
                      Text(
                        'Total orders',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.2
                      ),
                        style: TextStyle(
                            fontSize: 13, height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '6,245 M',
                        textScaleFactor: 1, textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )
                        ),
                      ),
                      Text(
                        'Stock costs (MMK)',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.2
                      ),
                        style: TextStyle(
                            fontSize: 13, height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors
                              .grey
                              .withOpacity(
                              0.3),
                          width: 1.0)
                  )),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '89 M',
                        textScaleFactor: 1, textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )
                        ),
                      ),
                      Text(
                        'Refunds (MMK)',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.2
                      ),
                        style: TextStyle(
                            fontSize: 13, height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '45 M',
                        textScaleFactor: 1, textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )
                        ),
                      ),
                      Text(
                        'Returns (MMK)',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.2
                      ),
                        style: TextStyle(
                            fontSize: 13, height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              splashColor: Colors.transparent,
              height: 50,
              child: FlatButton(
                color: AppTheme.buttonColor2,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: AppTheme.buttonColor2,
                  ),
                ),
                onPressed: () async {

                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                      bottom: 2.0),
                  child: Container(
                    child: Text(
                        'View more', textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing:-0.1
                        ),
                        strutStyle: StrutStyle(
                          height: 1.4,
                          forceStrutHeight: true,
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors
                              .grey
                              .withOpacity(
                              0.3),
                          width: 1.0)
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Text('PRODUCT SALE SUMMARY', textScaleFactor: 1,
              style: TextStyle(
                height: 0.9,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 14,color: Colors.black,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey
                              .withOpacity(0.2),
                          width: 1.0))),
              child: Row(
                children: [
                  Text('Total products', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.grey,
                  ),),
                  Spacer(),
                  Text('7,345', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.black,
                  ),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey
                              .withOpacity(0.2),
                          width: 1.0))),
              child: Row(
                children: [
                  Text('Categories', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.grey,
                  ),),
                  Spacer(),
                  Text('1,345', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.black,
                  ),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey
                              .withOpacity(0.2),
                          width: 1.0))),
              child: Row(
                children: [
                  Text('Average items', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.grey,
                  ),),
                  Spacer(),
                  Text('453', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.black,
                  ),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey
                              .withOpacity(0.2),
                          width: 1.0))),
              child: Row(
                children: [
                  Text('Monthly sale', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.grey,
                  ),),
                  Spacer(),
                  Text('90,345', textScaleFactor: 1, style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, color: Colors.black,
                  ),),
                ],
              ),
            ),
          ),
        ],
      ),

      ),
    );
  }
}