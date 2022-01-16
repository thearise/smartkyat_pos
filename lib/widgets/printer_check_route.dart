import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/models.dart';
import 'package:blue_print_pos/receipt/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart' as posUtils;

import '../app_theme.dart';

class PrinterCheckRoute extends StatefulWidget {

  const PrinterCheckRoute({Key? key, required this.data});

  final String data;

  @override
  _PrinterCheckRouteState createState() => _PrinterCheckRouteState();
}

class _PrinterCheckRouteState extends State<PrinterCheckRoute> {
  bool disableTouch = false;

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('printing route ' + widget.data.toString());
    _onScanPressed();
    super.initState();
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
                    child: _isLoading && _blueDevices.isEmpty
                        ? Center(
                      child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                          child: CupertinoActivityIndicator(radius: 15,)),
                    )
                        : _blueDevices.isNotEmpty
                        ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5),
                            Column(
                              children: List<Widget>.generate(_blueDevices.length,
                                      (int index) {
                                    return Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: _blueDevices[index].address ==
                                                (_selectedDevice?.address ?? '')
                                                ? _onDisconnectDevice
                                                : () => _onSelectDevice(index),
                                            child: Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _blueDevices[index].name,
                                                      style: TextStyle(
                                                          color:
                                                          _selectedDevice?.address ==
                                                              _blueDevices[index]
                                                                  .address
                                                              ? AppTheme.themeColor
                                                              : Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    Text(
                                                      _blueDevices[index].address,
                                                      style: TextStyle(
                                                          color:
                                                          _selectedDevice?.address ==
                                                              _blueDevices[index]
                                                                  .address
                                                              ? Colors.blueGrey
                                                              : Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (_loadingAtIndex == index && _isLoading)
                                          Container(
                                            height: 24.0,
                                            width: 65.0,
                                            margin: const EdgeInsets.only(right: 8.0),
                                            child: Center(
                                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                    child: CupertinoActivityIndicator(radius: 10,),
                                                  )
                                              ),
                                            ),
                                          ),
                                        if (!_isLoading &&
                                            _blueDevices[index].address ==
                                                (_selectedDevice?.address ?? ''))
                                          TextButton(
                                            onPressed: _onPrintReceipt,
                                            // child: Container(
                                            //   color: _selectedDevice == null
                                            //       ? AppTheme.buttonColor2
                                            //       : AppTheme.themeColor,
                                            //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10, left: 10),
                                            //   child: Icon(
                                            //     Icons.print_rounded,
                                            //     size: 25,
                                            //     color: Colors.black,
                                            //   )
                                            //   // child: const Text(
                                            //   //     'Print',
                                            //   //     style: TextStyle(color: Colors.white)
                                            //   // ),
                                            // ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 20.0, right: 20.0),
                                              child: Icon(
                                                Icons.print_rounded,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty
                                                    .resolveWith<Color>(
                                                      (Set<MaterialState> states) {
                                                    if (states.contains(
                                                        MaterialState.pressed)) {
                                                      return AppTheme.themeColor.withOpacity(0.5);
                                                    }
                                                    return AppTheme.themeColor;
                                                  },
                                                ),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    )
                                                )
                                            ),
                                          ),
                                        SizedBox(width: 8.5)
                                      ],
                                    );
                                  }),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    )
                        : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            'Scan bluetooth device',
                            style: TextStyle(fontSize: 24, color: Colors.blue),
                          ),
                          Text(
                            'Press button scan',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    // child: _devices.isEmpty
                    //     ? Center(child: Text(_devicesMsg ?? ''))
                    //     : ListView.builder(
                    //   itemCount: _devices.length,
                    //   itemBuilder: (c, i) {
                    //     return ListTile(
                    //       leading: Icon(Icons.print),
                    //       title: Text(_devices[i].name.toString()),
                    //       subtitle: Text(_devices[i].address.toString()),
                    //       onTap: () {
                    //         // _startPrint(_devices[i]);
                    //       },
                    //     );
                    //   },
                    // )
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

  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  List<BlueDevice> _blueDevices = <BlueDevice>[];
  BlueDevice? _selectedDevice;
  bool _isLoading = false;
  int _loadingAtIndex = -1;


  Future<void> _onScanPressed() async {
    setState(() => _isLoading = true);
    _bluePrintPos.scan().then((List<BlueDevice> devices) {
      if (devices.isNotEmpty) {
        setState(() {
          _blueDevices = devices;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    });
  }

  void _onDisconnectDevice() {
    _bluePrintPos.disconnect().then((ConnectionStatus status) {
      if (status == ConnectionStatus.disconnect) {
        setState(() {
          _selectedDevice = null;
        });
      }
    });
  }

  void _onSelectDevice(int index) {
    setState(() {
      _isLoading = true;
      _loadingAtIndex = index;
    });
    final BlueDevice blueDevice = _blueDevices[index];
    _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
      if (status == ConnectionStatus.connected) {
        setState(() => _selectedDevice = blueDevice);
      } else if (status == ConnectionStatus.timeout) {
        _onDisconnectDevice();
      } else {
        print('$runtimeType - something wrong');
      }
      setState(() => _isLoading = false);
    });
  }

  Future<void> _onPrintReceipt() async {
    final ReceiptSectionText receiptText = ReceiptSectionText();

//     final doc = await PdfDocument.openFile(pdfFile!.path);
//     final pages = doc.pageCount;
//     List<imglib.Image> images = [];
//
// // get images from all the pages
//     for (int i = 1; i <= pages; i++) {
//       var page = await doc.getPage(i);
//       var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
//       var img = await imgPDF.createImageDetached();
//       var imgBytes = await img.toByteData(format: ImageByteFormat.png);
//       var libImage = imglib.decodeImage(imgBytes!.buffer
//           .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
//       images.add(libImage!);
//     }
//
// // stitch images
//     int totalHeight = 0;
//     images.forEach((e) {
//       totalHeight += e.height;
//     });
//     int totalWidth = 0;
//     images.forEach((element) {
//       totalWidth = totalWidth < element.width ? element.width : totalWidth;
//     });
//     mergedImage = imglib.Image(totalWidth, totalHeight);
//     int mergedHeight = 0;
//     images.forEach((element) {
//       imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
//       mergedHeight += element.height;
//     });

    // mergedImage!.readAsBytes().then((value ) async {
    //   List<int> bytesList = value;
    //   // await _bluePrintPos.printReceiptImage(bytesList);
    //   receiptText.addImage(
    //     base64.encode(Uint8List.view(logoBytes.buffer)),
    //     width: 450,
    //   );
    // });

    // imglib.Image gg;

    // print('type check ' + mergedImage.runtimeType.toString());
    // receiptText.addImage(
    //   base64.encode(imglib.encodeJpg(mergedImage, quality: 600)),
    //   width: 500,
    // );

    receiptText.addLeftRightText(
      'ငှက်ပျောသီး',
      '30.000 MMK',
      leftStyle: ReceiptTextStyleType.normal,
      leftSize: ReceiptTextSizeType.small,
      rightSize: ReceiptTextSizeType.small,
      rightStyle: ReceiptTextStyleType.bold,
    );

    await _bluePrintPos.printReceiptText(receiptText, useRaster: true, paperSize: posUtils.PaperSize.mm80);

    // await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: 570, useRaster: true);



    // receiptText.addText(
    //   'MY Shop Name',
    //   size: ReceiptTextSizeType.medium,
    //   style: ReceiptTextStyleType.bold,
    // );
    // receiptText.addText(
    //   'သစ်သီဆိုင်',
    //   size: ReceiptTextSizeType.small,
    // );
    // receiptText.addSpacer(useDashed: true);
    // receiptText.addLeftRightText('Time', '04/06/21, 10:00');
    // receiptText.addSpacer(useDashed: true);
    // receiptText.addLeftRightText(
    //   'ငှက်ပျောသီး',
    //   '30.000 MMK',
    //   leftStyle: ReceiptTextStyleType.normal,
    //   leftSize: ReceiptTextSizeType.small,
    //   rightSize: ReceiptTextSizeType.small,
    //   rightStyle: ReceiptTextStyleType.bold,
    // );
    // // receiptText.addSpacer(useDashed: true);
    // // receiptText.addLeftRightText(
    // //   'ပန်းသီး',
    // //   '30.000 MMK',
    // //   leftStyle: ReceiptTextStyleType.normal,
    // //   rightStyle: ReceiptTextStyleType.bold,
    // //   leftSize: ReceiptTextSizeType.small,
    // //   rightSize: ReceiptTextSizeType.small,
    // // );
    // // receiptText.addSpacer(useDashed: true);
    // // receiptText.addLeftRightText(
    // //   'လိမ္မော်သီး',
    // //   'Cash',
    // //   leftStyle: ReceiptTextStyleType.bold,
    // //   leftSize: ReceiptTextSizeType.small,
    // //   rightStyle: ReceiptTextStyleType.normal,
    // // );
    // receiptText.addSpacer(count: 2);
    //
    // await _bluePrintPos.printReceiptText(receiptText,);
    //
    // List<int> bytesList = pdfFile!.readAsBytes();




    // /// Example for print QR
    // await _bluePrintPos.printQR('www.google.com', size: 250);

    // /// Text after QR
    // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
    // receiptSecondText.addText('Powered by ayeee',
    //     size: ReceiptTextSizeType.small);
    // receiptSecondText.addSpacer();
    // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
    // setState(() {
    //   _selectedDevice = null;
    // });
    // _onDisconnectDevice();
    // _onDisconnectDevice();
  }

  // keyboardSize(){
  //   double height = 0.0;
  //   if(MediaQuery.of(context).size.width > 900) {
  //     height = 141;
  //   } else {height = 141;}
  //   return height;
  // }
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
}