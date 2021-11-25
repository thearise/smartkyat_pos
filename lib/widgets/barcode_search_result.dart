import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';

import '../app_theme.dart';

class QRSearchResult extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRSearchResultState();
}

class _QRSearchResultState extends State<QRSearchResult> {
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: Container(
        height: 500,
        width: double.infinity,
        color: Colors.white,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(left:100.0, top: 100.0),
              child: Text('TESTING'),
            )
        ),
      ),
    );
  }

}