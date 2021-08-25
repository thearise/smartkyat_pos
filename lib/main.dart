import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartkyat_pos/login.dart';
import 'package:smartkyat_pos/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/widgets/product_versions_view.dart';
final themeMode = ValueNotifier(2);


PackageInfo? packageInfo;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return MaterialApp(
      title: 'Flutter UI',
      debugShowCheckedModeBanner: false,

      theme: new ThemeData(
        // primarySwatch: Colors.teal,
        canvasColor: Colors.white,
      ),
      //home: App(settings),
      // home: HomePage(),
      home: App()
    );
  }
}

