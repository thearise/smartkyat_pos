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

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: 150),
              child: _buildQrView(context)),
          if (result != null)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 175),
              height: 70,
              color: Colors.blue,
              child: Text(
                'Barcode: ${result!.code}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          else
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 175),
              height: 70,
              color: Colors.blue,
              child: Text('Point camera at barcode',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),),
            ),
          Stack(
            children: [
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                height: 65,
                margin: EdgeInsets.only(top: 65),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,),
                        child: IconButton(
                          icon:  Icon(Icons.arrow_back, size: 26,
                         color: Colors.black.withOpacity(0.6),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0, right: 8.0),
                          child: Container(child:
                          Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.6)
                            ),
                          )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:15.0,),
                        child: Icon(Icons.bar_chart, color: Colors.green, size: 22,),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.transparent,
            alignment: Alignment.topCenter,
            margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: ElevatedButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
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
                  setState(() {});
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
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black,
          borderRadius: 10,
          borderLength: 30 ,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
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