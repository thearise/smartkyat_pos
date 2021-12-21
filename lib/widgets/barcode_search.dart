import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';

import '../app_theme.dart';
import 'barcode_search_result.dart';

class QRSearchExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRSearchExampleState();
}

class _QRSearchExampleState extends State<QRSearchExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var firstTime = true;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 125.0),
            child: Container(
                child: _buildQrView(context)),
          ),
          // if (result != null)
          //   Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.only(top: 175),
          //     height: 70,
          //     color: Colors.blue,
          //     child: Text(
          //       'Barcode: ${result!.code}',
          //       style: TextStyle(
          //         fontSize: 20,
          //         color: Colors.white,
          //       ),
          //     ),
          //   )
          // else
          //   Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.only(top: 175),
          //     height: 70,
          //     color: Colors.blue,
          //     child: Text('Point camera at barcode',
          //       style: TextStyle(
          //         fontSize: 20,
          //         color: Colors.white,
          //       ),),
          //   ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: 35,
                    splashColor: Colors.transparent,
                    height: 35,
                    child: FlatButton(
                      height: 35,
                      minWidth: 35,
                      padding: const EdgeInsets.all(0),
                      color: AppTheme.buttonColor2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(50),
                      ),
                      onPressed: () async {
                        await controller?.flipCamera();
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Icon(
                                  Icons.flip_camera_ios,
                                  color: Colors.black,
                                  size: 30,
                                  //'Camera facing ${describeEnum(snapshot.data!)}'
                                );
                              } else {
                                return Icon(
                                  Icons.flip_camera_ios,
                                  color: Colors.black,
                                  size: 30,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  ButtonTheme(
                    minWidth: 35,
                    splashColor: Colors.transparent,
                    height: 35,
                    child: FlatButton(
                      height: 35,
                      minWidth: 35,
                      padding: const EdgeInsets.all(0),
                      color: AppTheme.buttonColor2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(50),
                      ),
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {

                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              print('gg' + snapshot.data.toString());
                              if (snapshot.data == null || snapshot.data == false) {
                                return Icon(
                                  Icons.flash_on_rounded,
                                  color: Colors.black,
                                  size: 30,
                                  //'Camera facing ${describeEnum(snapshot.data!)}'
                                );
                              } else if(snapshot.data == true) {
                                return Icon(
                                  Icons.flash_off_rounded,
                                  color: Colors.black,
                                  size: 30,
                                );
                              }
                              return Icon(
                                Icons.flash_on,
                                color: Colors.black,
                                size: 30,
                                //'Camera facing ${describeEnum(snapshot.data!)}'
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 125.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(
                      0.0),
                  color: AppTheme.badgeBgSuccess,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 1),
                  child: Row(
                    children: [
                      Text(
                        'Point camera at barcode',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing:-0.1,
                            color: Colors.white
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing:-0.1,
                              color: Colors.black
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        color: AppTheme.skBorderColor2,
                        width: 1.0),
                  )
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15, left: 15.0, right: 15.0, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                        width: 1.0,
                      ),
                      color: AppTheme.secButtonColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 11.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        SmartKyat_POS.search,
                                        size: 17,
                                      ),
                                    )
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 2, bottom: 1.0),
                                    //   child: Icon(
                                    //     Icons.close_rounded,
                                    //     size: 24,
                                    //   ),
                                    // )

                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Padding(
                          //       padding: EdgeInsets.only(
                          //           left: 13,
                          //           bottom: 1.5),
                          //       child: Text(
                          //         'Search',
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w500,
                          //             color: Colors.black.withOpacity(0.55)
                          //         ),
                          //       )
                          //   ),
                          // ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 0.5),
                                child: TextField(
                                  textInputAction: TextInputAction.search,
                                  // focusNode: nodeFirst,
                                  // controller: _searchController,
                                  onSubmitted: (value) async {
                                  },
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),

                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    isDense: true,
                                    // contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
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
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15, bottom: 1.0),
                              child: Icon(
                                Icons.close_rounded,
                                size: 24,
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
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Container(
      color: Colors.black,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        // formatsAllowed: [BarcodeFormat.aztec, BarcodeFormat.codabar, BarcodeFormat.upcE, BarcodeFormat.code128, BarcodeFormat.code39, BarcodeFormat.upcA, BarcodeFormat.dataMatrix, BarcodeFormat.code93, BarcodeFormat.ean8,  BarcodeFormat.ean13, BarcodeFormat.itf, BarcodeFormat.maxicode, BarcodeFormat.pdf417, BarcodeFormat.qrcode, BarcodeFormat.rss14, BarcodeFormat.rssExpanded],
        overlay: QrScannerOverlayShape(
            borderColor: Colors.black,
            borderRadius: 10,
            borderLength: 0 ,
            borderWidth: 0,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      //   result = scanData;
      // });
      if(firstTime) {
        controller.getFlashStatus().then((value) {
          if(value! == true) {
            controller.toggleFlash();
          }
        });
        print(scanData.code);
        // _onQRViewCreated(controller);
        Navigator.pop(context, scanData.code);

      } else {

      }

      firstTime=false;

    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}