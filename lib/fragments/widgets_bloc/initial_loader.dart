import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
        child: CupertinoActivityIndicator(radius: 15,)));
  }
}
