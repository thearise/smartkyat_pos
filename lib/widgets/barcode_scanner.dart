import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../app_theme.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
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
      padding: const EdgeInsets.only(top: 142.0, bottom: 20.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
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
              padding: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
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
                              debugPrint('gg' + snapshot.data.toString());
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
          // Container(
          //   color: Colors.transparent,
          //   alignment: Alignment.topCenter,
          //   margin:
          //   EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       await controller?.flipCamera();
          //       // setState(() {});
          //     },
          //     style: ElevatedButton.styleFrom(
          //       padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(30.0)),
          //       primary: Colors.white.withOpacity(0.5),
          //     ),
          //     child: FutureBuilder(
          //       future: controller?.getCameraInfo(),
          //       builder: (context, snapshot) {
          //         if (snapshot.data != null) {
          //           return Icon(
          //             Icons.flip_camera_ios,
          //             color: Colors.black,
          //             size: 30,
          //             //'Camera facing ${describeEnum(snapshot.data!)}'
          //           );
          //         } else {
          //           return Icon(
          //             Icons.flip_camera_ios,
          //             color: Colors.black,
          //             size: 40,
          //           );
          //         }
          //       },
          //     ),
          //   ),
          // ),
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   child: ElevatedButton(
          //       onPressed: () async {
          //         await controller?.toggleFlash();
          //         // setState(() {});
          //       },
          //       child: FutureBuilder(
          //         future: controller?.getFlashStatus(),
          //         builder: (context, snapshot) {
          //           return Text('Flash: ${snapshot.data}');
          //         },
          //       )),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0, top: 10),
          //   child: ButtonTheme(
          //     minWidth: 35,
          //     splashColor: Colors.transparent,
          //     height: 35,
          //     child: FlatButton(
          //       height: 35,
          //       minWidth: 35,
          //       padding: const EdgeInsets.all(0),
          //       color: AppTheme.buttonColor2,
          //       shape: RoundedRectangleBorder(
          //         borderRadius:
          //         BorderRadius.circular(20),
          //         side: BorderSide(
          //           color: AppTheme.buttonColor2,
          //         ),
          //       ),
          //       onPressed: () async {
          //         Navigator.of(context).pop();
          //       },
          //       child: Container(
          //         child: Icon(
          //           Icons.close_rounded,
          //           size: 25,
          //           color: Colors.blue,
          //         ),
          //       ),
          //     ),
          //   ),
          //   // child: IconButton(
          //   //   icon: Container(
          //   //
          //   //     child: Icon(
          //   //       Icons.close_rounded,
          //   //       size: 20,
          //   //       color: Colors.blue,
          //   //     ),
          //   //   ),
          //   //   onPressed: () {
          //   //     Navigator.of(context).pop();
          //   //   },
          //   // ),
          // ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
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
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.white,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 35.0, left: 15.0, right: 15.0),
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
                            // color: AppTheme.themeColor,
                              color: Colors.transparent
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5.0,
                              bottom: 3.0),
                          child: Container(
                            child: Text(
                              'Close camera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing:-0.1
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
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