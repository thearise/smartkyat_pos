import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Transparent extends StatefulWidget {
  const Transparent({Key? key}) : super(key: key);

  @override
  TransparentState createState() => TransparentState();
}

class TransparentState extends State<Transparent>
    with TickerProviderStateMixin<Transparent>{


  @override
  void dispose() {
    super.dispose();
  }

  disLoading() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(),
    );
  }
}
