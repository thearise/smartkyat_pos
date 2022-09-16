import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TestingThree extends StatefulWidget {
  const TestingThree({Key? key}) : super(key: key);

  @override
  TestingThreeState createState() => TestingThreeState();
}

class TestingThreeState extends State<TestingThree>
    with TickerProviderStateMixin<TestingThree>{


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
      body: GestureDetector(
        onTap: () {
          debugPrint('pooping ');
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              child: Hero(
                tag: '0',
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(
                      Icons.wifi_tethering_rounded,
                      size: 24.5,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
