import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_save/image_save.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/api/pdf_invoice_api.dart';
import 'package:smartkyat_pos/model/customer.dart';
import 'package:smartkyat_pos/model/invoice.dart';
import 'package:smartkyat_pos/model/supplier.dart';
import 'package:image/image.dart' as imglib;
import '../app_theme.dart';
import 'printer_check_route.dart';

class PrintReceiptRoute extends StatefulWidget {

  const PrintReceiptRoute({Key? key, required this.currency, required this.data, required this.prodList, required this.shopId, required void printFromOrders(File file)})
      : _printFromOrders = printFromOrders;

  final String data;
  final List prodList;
  final String shopId;
  final _printFromOrders;
  final String currency;

  @override
  _PrintReceiptRouteState createState() => _PrintReceiptRouteState();
}

class _PrintReceiptRouteState extends State<PrintReceiptRoute> {
  double paidAmount = 0;
  double refund = 0;
  double debtAmount =0;
  TextEditingController _textFieldController = TextEditingController();

  bool loadingState = false;
  bool disableTouch = false;

  String pdfText = '';
  File? pdfFile;

  bool saveImage = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textFieldController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('printing route1 ' + widget.data.toString());
    print('printing route2 ' + widget.prodList.toString());
    print('printing route3 ' + widget.data.split('^')[0].substring(0,4) + '-' + widget.data.split('^')[0].substring(4,6) + '-' + widget.data.split('^')[0].substring(6,8));

    initOrderData();
    super.initState();
  }

  initOrderData() async {
    List<String> subNameList = [];
    int subNameListLength = 0;

    List prodList = widget.prodList;

    final date = DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0,4) + '-' + widget.data.split('^')[0].substring(4,6) + '-' + widget.data.split('^')[0].substring(6,8) + ' 00:00:00');
    final dueDate = date.add(Duration(days: 7));
    // print('CUZMER CHECK ' + customerId.toString());
    var shopDocSnap = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId)
        .get();
    if (shopDocSnap.exists) {
      Map<String, dynamic>? dataShop = shopDocSnap.data();

      final invoice = Invoice(
        supplier: Supplier(
          name: dataShop?['shop_name'],
          address: dataShop?['shop_address'],
          phone: dataShop?['shop_phone'],
          paymentInfo: '',
        ),
        customer: Customer(
          // name: customerId.split('^')[1],
          name: widget.data.split('^')[3].split('&')[0],
          address: '',
        ),
        info: InvoiceInfo(
            date: date,
            dueDate: dueDate,
            description: 'My description...',
            // number: '${DateTime.now().year}-9999',
            // number: deviceIdNum.toString() + '^' + length.toString()
            number: '001'
        ),
        items: [
          for(int i=0; i<prodList.length; i++)
            InvoiceItem(
              description: widget.prodList[i].split('^')[0],
              // date: prodList[i].split('^')[3] + '^' + subNameList[i].toString(),
              date: widget.prodList[i].split('^')[1],
              quantity: double.parse(widget.prodList[i].split('^')[3]),
              // vat: discountAmount,
              // type: disText,
              // debt: debt,
              vat: double.parse(widget.data.split('^')[6].split('-')[0]),
              type: widget.data.split('^')[6] != '0.0' ? '-' + (widget.data.split('^')[6].split('-')[1]).toString() : '',
              debt: double.parse(widget.data.split('^')[5]),
              unitPrice: double.parse(widget.prodList[i].split('^')[2]), currencyUnit: widget.currency,
              // unitPrice: double.parse(prodList[i].split('^')[2]),
            )

        ],
      );

      getPaperId().then((value) async {
        print('VVAALLUUEE ' + value.toString());
        pdfFile = await PdfInvoiceApi.generate(invoice, value);

        // Uint8List bytes = pdfFile!.readAsBytesSync();

        // mystate(() {
        setState(() {
          pdfText = pdfFile!.path.toString();
        });
        // });
      });
    }



    // for (String str in prodList) {
    //   subNameListLength = subNameListLength + 1;
    //   print('DATA CHECK PROD ' + str.toString());
    //   var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(str.split('^')[0])
    //       .get();
    //   if (docSnapshot10.exists) {
    //     Map<String, dynamic>? data10 = docSnapshot10.data();
    //     subNameList.add(data10 ? [str.split('^')[3]]);
    //     if(prodList.length == subNameListLength) {
    //       print('fianlize : ' + subNameList.toString());
    //       final date = DateTime.now();
    //       final dueDate = date.add(Duration(days: 7));
    //       // print('CUZMER CHECK ' + customerId.toString());
    //       final invoice = Invoice(
    //         supplier: Supplier(
    //           name: 'shopGloName',
    //           address: 'shopGloAddress',
    //           phone: 'shopGloPhone',
    //           paymentInfo: '',
    //         ),
    //         customer: Customer(
    //           // name: customerId.split('^')[1],
    //           name: 'customerId',
    //           address: '',
    //         ),
    //         info: InvoiceInfo(
    //             date: date,
    //             dueDate: dueDate,
    //             description: 'My description...',
    //             // number: '${DateTime.now().year}-9999',
    //             // number: deviceIdNum.toString() + '^' + length.toString()
    //             number: '001'
    //         ),
    //         items: [
    //           for(int i=0; i<prodList.length; i++)
    //             InvoiceItem(
    //               description: prodList[i].split('^')[1],
    //               // date: prodList[i].split('^')[3] + '^' + subNameList[i].toString(),
    //               date: subNameList[i].toString(),
    //               quantity: int.parse(prodList[i].split('^')[4]),
    //               // vat: discountAmount,
    //               // type: disText,
    //               // debt: debt,
    //               vat: 100,
    //               type: '100',
    //               debt: 100,
    //               unitPrice: double.parse(prodList[i].split('^')[2]),
    //             )
    //
    //         ],
    //       );
    //
    //
    //       // getPaperId().then((value) async {
    //       //   print('VVAALLUUEE ' + value.toString());
    //       //   pdfFile = await PdfInvoiceApi.generate(invoice, value);
    //       //
    //       //   Uint8List bytes = pdfFile!.readAsBytesSync();
    //       //
    //       //   // mystate(() {
    //       //   //   // setState(() {
    //       //   //   pdfText = pdfFile!.path.toString();
    //       //   //   // });
    //       //   // });
    //       // });
    //
    //     }
    //   }
    //
    // }
  }

  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return IgnorePointer(
      ignoring: disableTouch,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 80,
                          child:
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
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
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('MMK ' + widget.data.split('^')[2].toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      //color: Colors.grey,
                                    ),),
                                  Text('#' +
                                      widget.data.split('^')[1].toString() + ' - ' + widget.data.split('^')[3].split('&')[0].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0))),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 12.0),
                                child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            saveImage = true;
                                          });
                                          var mergedImage;

                                          final doc = await PdfDocument.openFile(pdfFile!.path);
                                          final pages = doc.pageCount;
                                          List<imglib.Image> images = [];

// get images from all the pages
                                          for (int i = 1; i <= pages; i++) {
                                            var page = await doc.getPage(i);
                                            var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
                                            var img = await imgPDF.createImageDetached();
                                            var imgBytes = await img.toByteData(format: ImageByteFormat.png);
                                            var libImage = imglib.decodeImage(imgBytes!.buffer
                                                .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
                                            images.add(libImage!);
                                          }

// stitch images
                                          int totalHeight = 0;
                                          images.forEach((e) {
                                            totalHeight += e.height;
                                          });
                                          int totalWidth = 0;
                                          images.forEach((element) {
                                            totalWidth = totalWidth < element.width ? element.width : totalWidth;
                                          });
                                          mergedImage = imglib.Image(totalWidth, totalHeight);
                                          int mergedHeight = 0;
                                          images.forEach((element) {
                                            imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
                                            mergedHeight += element.height;
                                          });

                                          // Save image as a file
                                          // final documentDirectory = await getExternalStorageDirectory();
                                          // Directory appDocDirectory = await getApplicationDocumentsDirectory();
                                          // File imgFile = new File(appDocDirectory.path + 'test.jpg');
                                          // new File(imgFile.path).writeAsBytes(imglib.encodeJpg(mergedImage));

                                          // Save to album.
                                          // bool? success = await ImageSave.saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)), "demo.jpg", albumName: "demo");
                                          _saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)));
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context).size.width - 45)* (3/4),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                            color: AppTheme.secButtonColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0,
                                                bottom: 0.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                    child: Container(
                                                        child: saveImage?
                                                        Center(
                                                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                              child: CupertinoActivityIndicator(radius: 10,)),
                                                        ):
                                                        Text(
                                                          'Save as image',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          widget._printFromOrders(pdfFile);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => PrinterCheckRoute(data: widget.data,)));
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context).size.width - 45)* (1/4),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              color: AppTheme.themeColor),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0,
                                                bottom: 0.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                                                    child: Container(
                                                        child: Icon(
                                                          Icons.print_rounded,
                                                          size: 25,
                                                          color: Colors.black,
                                                        )
                                                      // child: Text(
                                                      //   '',
                                                      //   textAlign: TextAlign.center,
                                                      //   style: TextStyle(
                                                      //       fontSize: 18,
                                                      //       fontWeight: FontWeight.w600,
                                                      //       color: Colors.black
                                                      //   ),
                                                      // )
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text('RECEIPT VOUCHER',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 2,
                                color: Colors.grey,
                              ),),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                              child: pdfText == '' ? Center(
                                child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                    child: CupertinoActivityIndicator(radius: 15,)),
                              ): GestureDetector(
                                  onTap: () {
                                    // print('clicked');
                                    // PdfApi.openFile(pdfFile!);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: PdfViewer.openFile(pdfText),
                                  )
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: homeBotPadding),
                  //   child: Container(
                  //     color: Colors.white,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                  //       child: ButtonTheme(
                  //         minWidth: MediaQuery.of(context).size.width,
                  //         splashColor: Colors.transparent,
                  //         height: 50,
                  //         child: FlatButton(
                  //           color: AppTheme.themeColor,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //             BorderRadius.circular(10.0),
                  //             side: BorderSide(
                  //               color: AppTheme.themeColor,
                  //             ),
                  //           ),
                  //           onPressed: () async {
                  //             if (_formKey.currentState!.validate()) {
                  //               String dataRm = widget.data.split('^')[0] +
                  //                   '^' +
                  //                   widget.data.split('^')[1] +
                  //                   '^' +
                  //                   widget.data.split('^')[2] +
                  //                   '^' +
                  //                   widget.data.split('^')[3].split('&')[1] +
                  //                   '^' +
                  //                   widget.data.split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data.split('^')[6];
                  //               String data = widget.data.split('^')[0] +
                  //                   '^' +
                  //                   widget.data.split('^')[1] +
                  //                   '^' +
                  //                   widget.data.split('^')[2] +
                  //                   '^' +
                  //                   widget.data.split('^')[3].split('&')[1] +
                  //                   '^' +
                  //                   widget.data.split('^')[4] + '^' + debtAmount.toString() + '^' + widget.data.split('^')[6];
                  //
                  //               CollectionReference dailyOrders = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders');
                  //               CollectionReference order = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order');
                  //               CollectionReference customerDebt = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers');
                  //
                  //               dailyOrders.doc(widget.documentId).update({
                  //                 'daily_order':
                  //                 FieldValue.arrayRemove([dataRm])
                  //               }).then((value) {print('array removed');})
                  //                   .catchError((error) => print("Failed to update user: $error"));
                  //
                  //               dailyOrders.doc(widget.documentId).update({
                  //                 'daily_order':
                  //                 FieldValue.arrayUnion([data])
                  //               }).then((value) { print('array updated');})
                  //                   .catchError((error) => print("Failed to update user: $error"));
                  //
                  //               order.doc(
                  //                   widget.docId)
                  //                   .update({
                  //                 'debt' : debtAmount
                  //               })
                  //                   .then((value) => print("User Updated"))
                  //                   .catchError((error) => print("Failed to update user: $error"));
                  //
                  //               double debts = 0;
                  //               if(debtAmount == 0.0) {
                  //                 debts = 1;
                  //               } else debts = 0;
                  //               if( widget.data.split('^')[3].split('&')[1] !='name') {
                  //                 customerDebt.doc(
                  //                     widget.data.split('^')[3].split('&')[1])
                  //                     .update({
                  //                   'debtAmount' : FieldValue.increment( 0 - double.parse(paidAmount.toString())),
                  //                   'debts' : FieldValue.increment( 0 - double.parse(debts.toString())),
                  //                 })
                  //                     .then((value) => print("User Updated"))
                  //                     .catchError((error) => print("Failed to update user: $error"));}
                  //
                  //               _textFieldController.clear();
                  //               Navigator.of(context).popUntil((route) => route.isFirst);
                  //               smartKyatFlash('$debtAmount MMK is successfully paid to #' + widget.data.split('^')[1].toString(), 's');
                  //             } },
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(
                  //                 left: 5.0,
                  //                 right: 5.0,
                  //                 bottom: 2.0),
                  //             child: Container(
                  //               child: Text(
                  //                 'Done',
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.w600,
                  //                     letterSpacing:-0.1
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // keyboardSize(){
  //   double height = 0.0;
  //   if(MediaQuery.of(context).size.width > 900) {
  //     height = 141;
  //   } else {height = 141;}
  //   return height;
  // }

  getPaperId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('paper') == null) {
      return 'Roll-57';
    }
    return prefs.getString('paper');
  }

  void smartKyatFlash(String text, String type) {
    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }
    showFlash(
      context: context,
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(text, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
          // child: Padding(
          //   padding: const EdgeInsets.only(
          //       top: 93.0, left: 15, right: 15),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(10.0),
          //       ),
          //       color: bgColor,
          //       border: Border.all(
          //           color: bdColor,
          //           width: 1.0
          //       ),
          //     ),
          //     child: Padding(
          //         padding: const EdgeInsets.only(
          //             top: 15.0, left: 10, right: 10, bottom: 15),
          //         child: Row(
          //           children: [
          //             SizedBox(width: 5),
          //             widgetCon,
          //             SizedBox(width: 10),
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 2.5),
          //               child: Container(
          //                 child: Text(text, overflow: TextOverflow.visible, style: TextStyle(
          //                     fontWeight: FontWeight.w400, fontSize: 14.5)),
          //               ),
          //             )
          //           ],
          //         )
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  Future<void> _saveImage(_data) async {
    bool success = false;
    try {
      success = (await ImageSave.saveImage(_data, "receipt.jpg", albumName: "SmartKyatPOS"))!;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }

    success ? smartKyatFlash('Saved successfully order info in your photos', 's') : smartKyatFlash('An error occurred while saving order info.', 'e');
    setState(() {
      saveImage = false;
    });
    // setState(() {
    //   _result = success ? "Save to album success" : "Save to album failed";
    // });
  }
}