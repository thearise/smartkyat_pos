import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartkyat_pos/login.dart';
import 'package:smartkyat_pos/pages2/home_page2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';
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
  final navigatorKey = GlobalKey<NavigatorState>();
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
      navigatorKey: OneContext().key,
      title: 'Flutter UI',
      debugShowCheckedModeBanner: false,

      theme: new ThemeData(
        // primarySwatch: Colors.teal,
        canvasColor: Colors.transparent,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      ),
      navigatorObservers: [OneContext().heroController],
      builder: OneContext().builder,
      //home: App(settings),
      // home: HomePage(),
      home: HomePage()
    );
  }
}



// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(App());
// }
//
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           child: Text('Add entries'),
//           onPressed: () async {
//             List<PersonEntry> persons = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SOF(),
//               ),
//             );
//             if (persons != null) persons.forEach(print);
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class SOF extends StatefulWidget {
//   @override
//   _SOFState createState() => _SOFState();
// }
//
// class _SOFState extends State<SOF> {
//   var nameTECs = <TextEditingController>[];
//   var ageTECs = <TextEditingController>[];
//   var jobTECs = <TextEditingController>[];
//   var cards = <Card>[];
//
//   Card createCard() {
//     var nameController = TextEditingController();
//     var ageController = TextEditingController();
//     var jobController = TextEditingController();
//     nameTECs.add(nameController);
//     ageTECs.add(ageController);
//     jobTECs.add(jobController);
//     return Card(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text('Person ${cards.length + 1}'),
//           TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Full Name')),
//           TextField(
//               controller: ageController,
//               decoration: InputDecoration(labelText: 'Age')),
//           TextField(
//               controller: jobController,
//               decoration: InputDecoration(labelText: 'Study/ job')),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     cards.add(createCard());
//   }
//
//   _onDone() {
//     List<PersonEntry> entries = [];
//     for (int i = 0; i < cards.length; i++) {
//       var name = nameTECs[i].text;
//       var age = ageTECs[i].text;
//       var job = jobTECs[i].text;
//       entries.add(PersonEntry(name, age, job));
//     }
//     Navigator.pop(context, entries);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: cards.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return cards[index];
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: RaisedButton(
//               child: Text('add new'),
//               onPressed: () => setState(() => cards.add(createCard())),
//             ),
//           )
//         ],
//       ),
//       floatingActionButton:
//       FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
//     );
//   }
// }
//
// class PersonEntry {
//   final String name;
//   final String age;
//   final String studyJob;
//
//   PersonEntry(this.name, this.age, this.studyJob);
//   @override
//   String toString() {
//     return 'Person: name= $name, age= $age, study job= $studyJob';
//   }
// }
