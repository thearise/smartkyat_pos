import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smartkyat_pos/app_theme.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;

  const PaywallWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.packages,
    required this.onClickedPackage,
  }) : super(key: key);

  @override
  _PaywallWidgetState createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        buildPackages()
      ],
    ),
  );

  buildPackages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          return buildPackage(context, package, index);
        }
      ),
    );
  }

  buildPackage(BuildContext context, Package package, int index) {
    final product = package.storeProduct;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: index==0?
        BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          color: Color(0xFFF5F5F5),
          border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0),
        ): index==1?
        BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            gradient: LinearGradient(
                colors: [Color(0xFFFFE18A), Color(0xFFC2FC1D)],
                begin: Alignment(-1.0, -2.0),
                end: Alignment(1.0, 2.0),
                tileMode: TileMode.clamp)):
        BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            gradient: LinearGradient(
                colors: [Color(0xFFDBFF76), Color(0xFF9FFFD1)],
                begin: Alignment(-1.0, -2.0),
                end: Alignment(1.0, 2.0),
                tileMode: TileMode.clamp)),
        child: ListTile(
          leading: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:3.0, top: 0.0),
                child: Icon(
                  // Icons.home_filled,
                  Icons.verified_rounded,
                  size: 32,
                  color: Colors.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 11.0, top: 8),
                child: Container(
                    color: Colors.blue,
                    width: 15,
                    height: 15
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 13.0, top: topPadding(index)),
                child: Text(
                  index == 0? '1': index==1? '3': '5',
                  textScaleFactor: 1, textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      )
                  ),
                ),
              )
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(product.title, textScaleFactor: 1, style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: -0.3
            ),
              strutStyle: StrutStyle(
                height: 1.6,
                // fontSize:,
                forceStrutHeight: true,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey
                                .withOpacity(0.3),
                            width: 1.0))),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(product.currencyCode.toString() + ' ' + disCal(product.price, index).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') + ' /month - ' + product.description, textScaleFactor: 1, style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15, color: Colors.grey,
                  ),
                    strutStyle: StrutStyle(
                      height: 1.35,
                      // fontSize:,
                      forceStrutHeight: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // FlatButton(
              //
              // child: new Text("Call now", style: TextStyle(
              //   fontWeight: FontWeight.w500,
              //   fontSize: 17, color: Colors.blue,
              // ),
              //   strutStyle: StrutStyle(
              //     height: 1.3,
              //     // fontSize:,
              //     forceStrutHeight: true,
              //   ),)),
              GestureDetector(
                onTap: () {
                  widget.onClickedPackage(package);
                },
                child: Text('Buy now ' + (index==0? '': index==1? '(save 20%)': '(save 30%)'), textScaleFactor: 1, style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17, color: Colors.blue,
                ),
                  strutStyle: StrutStyle(
                    height: 1.3,
                    // fontSize:,
                    forceStrutHeight: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),

        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 8),
    //   child: Container(
    //     decoration: index==0?
    //     BoxDecoration(
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(15.0),
    //       ),
    //       color: Color(0xFFF5F5F5),
    //       border: Border.all(
    //           color: Colors.grey.withOpacity(0.2),
    //           width: 1.0),
    //     ): index==1?
    //     BoxDecoration(
    //         borderRadius: BorderRadius.all(
    //           Radius.circular(15.0),
    //         ),
    //         gradient: LinearGradient(
    //             colors: [Color(0xFFFFE18A), Color(0xFFC2FC1D)],
    //             begin: Alignment(-1.0, -2.0),
    //             end: Alignment(1.0, 2.0),
    //             tileMode: TileMode.clamp)):
    //     BoxDecoration(
    //         borderRadius: BorderRadius.all(
    //           Radius.circular(15.0),
    //         ),
    //         gradient: LinearGradient(
    //             colors: [Color(0xFFDBFF76), Color(0xFF9FFFD1)],
    //             begin: Alignment(-1.0, -2.0),
    //             end: Alignment(1.0, 2.0),
    //             tileMode: TileMode.clamp)),
    //     child: Stack(
    //       children: [
    //         ListTile(
    //           title: Padding(
    //             padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 15.0, bottom: 10),
    //             child: Text(
    //               product.title,
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w500,
    //                 fontSize: 18,
    //                 letterSpacing: -0.3
    //               ),
    //             ),
    //           ),
    //           subtitle: Padding(
    //             padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 18.0),
    //             child: Text(
    //               product.description
    //             ),
    //           ),
    //           trailing: ButtonTheme(
    //             minWidth: 50,
    //             splashColor: Colors.transparent,
    //             height: 35,
    //             child: FlatButton(
    //               color: Colors.transparent,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius:
    //                 BorderRadius.circular(8.0),
    //                 side: BorderSide(
    //                   color: Colors.transparent,
    //                 ),
    //               ),
    //               onPressed: () async {
    //                 widget.onClickedPackage(package);
    //               },
    //               child: Container(
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 0.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsets.only(bottom: 2.0),
    //                         child: Text(
    //                           '(Save 10%)', textScaleFactor: 1,
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                             color: Colors.transparent,
    //                               fontSize: 14,
    //                               fontWeight: FontWeight.w500
    //                           ),
    //                         ),
    //                       ),
    //                       Text(
    //                         product.priceString, textScaleFactor: 1,
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           color: Colors.transparent,
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w500
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           )
    //           // Text(
    //           //   product.priceString,
    //           //
    //           // ),
    //           // onTap: () {
    //           //   widget.onClickedPackage(package);
    //           // },
    //         ),
    //         SizedBox(
    //           child: Container(
    //             color: Colors.black,
    //             child: Align(
    //               alignment: Alignment.centerRight,
    //               child: ButtonTheme(
    //                 minWidth: 50,
    //                 splashColor: Colors.transparent,
    //                 height: 35,
    //                 child: FlatButton(
    //                   color: AppTheme.buttonColor2,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius:
    //                     BorderRadius.circular(8.0),
    //                     side: BorderSide(
    //                       color: AppTheme.buttonColor2,
    //                     ),
    //                   ),
    //                   onPressed: () async {
    //                     widget.onClickedPackage(package);
    //                   },
    //                   child: Container(
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 0.0),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.only(bottom: 2.0),
    //                             child: Text(
    //                               '(Save 10%)', textScaleFactor: 1,
    //                               textAlign: TextAlign.center,
    //                               style: TextStyle(
    //                                   fontSize: 14,
    //                                   fontWeight: FontWeight.w500
    //                               ),
    //                             ),
    //                           ),
    //                           Text(
    //                             product.priceString, textScaleFactor: 1,
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w500
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  double topPadding(int index) {
    if(Platform.isAndroid) {
      if(index == 0) {
        return 4.5;
      } else if(index == 1) {
        return 5;
      } else {
        return 5.5;
      }
    } else {
      return 4.5;
    }
  }

  double disCal(double price, int index) {
    if(index==0) {
      return price;
    } else if(index ==1) {
      return (price/3);
    } else {
      return (price/5);
    }
  }
}