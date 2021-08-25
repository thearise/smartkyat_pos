import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: _buildQrView(context)),
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
          Container(
            color: Colors.transparent,
            alignment: Alignment.topCenter,
            margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: ElevatedButton(
              onPressed: () async {
                await controller?.flipCamera();
                // setState(() {});
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                primary: Colors.white,
              ),
              child: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                      Icons.flip_camera_ios,
                      color: Colors.black,
                      size: 40,
                      //'Camera facing ${describeEnum(snapshot.data!)}'
                    );
                  } else {
                    return Icon(
                      Icons.flip_camera_ios,
                      color: Colors.black,
                      size: 40,
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  // setState(() {});
                },
                child: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    return Text('Flash: ${snapshot.data}');
                  },
                )),
          ),        ],
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
            borderLength: 30 ,
            borderWidth: 10,
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