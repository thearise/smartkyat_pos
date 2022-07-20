import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/customers_fragment2.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../app_theme.dart';

class AddCustomer extends StatefulWidget {
  final cusLoadingState;
  final endCusLoadingState;

  AddCustomer({ required void toggleCoinCallback2(), required this.isEnglish , required void toggleCoinCallback3()})
      : cusLoadingState = toggleCoinCallback2,
        endCusLoadingState = toggleCoinCallback3;
  final bool isEnglish;

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final mnameCtrl = TextEditingController();
  final maddressCtrl = TextEditingController();
  final mphoneCtrl = TextEditingController();
  static List<String> merchFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
  String? shopId;

  late BuildContext dialogContext;

  openOverAllSubLoading() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.4),
      context: context,
      builder: (context) {
        dialogContext = context;
        return Container();
      },
    );
  }

  closeOverAllSubLoading() {
    Navigator.pop(dialogContext);
  }


  String textSetInformation = 'CUSTOMER INFORMATION';
  String textSetName = 'Name';
  String textSetAddress = 'Address';
  String textSetPhone = 'Phone number';
  String textSetAdd = 'Add Customer';

  var deviceIdNum;

  @override
  void initState() {

    getDeviceId().then((value) {
      deviceIdNum = value;
    });


      if(widget.isEnglish == true) {
        setState(() {
          textSetInformation = 'CUSTOMER INFORMATION';
          textSetName = 'Name';
          textSetAddress = 'Address';
          textSetPhone = 'Phone number';
          textSetAdd = 'Save';
        });
      } else{
        setState(() {
          textSetInformation = 'CUSTOMER INFORMATION';
          textSetName = 'နာမည်';
          textSetAddress = 'လိပ်စာ';
          textSetPhone = 'ဖုန်းနံပါတ်';
          textSetAdd = 'သိမ်းဆည်းမည်';
        });
      }

    getStoreId().then((value) => shopId = value);
    super.initState();
  }

  getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('device');
  }


  bool cusCreating = false;

  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
// mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              color: Colors.white,
                            ),

                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //   child: Text('CUSTOMER INFORMATION', style: TextStyle(
                                  //     letterSpacing: 1.5,
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 14,color: Colors.grey,
                                  //   ),),
                                  // ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15.0, left: 15.0,),
                                            child: Text(textSetInformation, textScaleFactor: 1, style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,color: Colors.grey,
                                            ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0, top: 30),
                                            child: TextFormField(
// The validator receives the text that the user has entered.
                                              controller: mnameCtrl,
                                              keyboardType: TextInputType.name,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(30),
                                                FilteringTextInputFormatter.deny('^'),
                                                FilteringTextInputFormatter.deny('<>'),
                                              ],
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return ' This field is required ';
                                                }
                                                merchFieldsValue.add(value);
                                                return null;
                                              },
                                              style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
                                              decoration: InputDecoration(
                                                enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: AppTheme.skBorderColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),

                                                focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: AppTheme.themeColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
                                                // suffixText: 'Required',
                                                errorStyle: TextStyle(
                                                    backgroundColor: Colors.white,
                                                    fontSize: 12/scaleFactor,
                                                    fontFamily: 'capsulesans',
                                                    height: 0.1
                                                ),
                                                suffixStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12/scaleFactor,
                                                  fontFamily: 'capsulesans',
                                                ),
                                                labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
// errorText: 'Error message',
                                                labelText: textSetName,
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
//filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0, top: 101),
                                            child: TextFormField(
                                              controller: maddressCtrl,
                                              keyboardType: TextInputType.text,
// The validator receives the text that the user has entered.
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return ' This field is required ';
                                                }
                                                merchFieldsValue.add(value);
                                                return null;
                                              },
                                              style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
                                              decoration: InputDecoration(
                                                enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: AppTheme.skBorderColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),

                                                focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: AppTheme.themeColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
                                                //suffixText: 'MMK',
                                                suffixStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontSize: 12/scaleFactor,
//fontFamily: 'capsulesans',
                                                ),
                                                errorStyle: TextStyle(
                                                    backgroundColor: Colors.white,
                                                    fontSize: 12/scaleFactor,
                                                    fontFamily: 'capsulesans',
                                                    height: 0.1
                                                ),
                                                labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
// errorText: 'Error message',
                                                labelText: textSetAddress,
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
//filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0, top: 172),
                                            child: TextFormField(
// The validator receives the text that the user has entered.
                                              keyboardType: TextInputType.number,
                                              controller: mphoneCtrl,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return ' This field is required ';
                                                }
                                                merchFieldsValue.add(value);
                                                return null;
                                              },
                                              style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
                                              decoration: InputDecoration(
                                                enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: AppTheme.skBorderColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),

                                                focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide: const BorderSide(
                                                        color: AppTheme.themeColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
                                                // suffixText: 'Required',
                                                errorStyle: TextStyle(
                                                    backgroundColor: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'capsulesans',
                                                    height: 0.1
                                                ),
                                                suffixStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontFamily: 'capsulesans',
                                                ),
                                                labelStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
// errorText: 'Error message',
                                                labelText: textSetPhone,
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
//filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   color: Colors.white,
                          //   height: MediaQuery.of(context).viewInsets.bottom - 80 < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 141,
                          // ),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(0.3),
                                      width: 1.0))

                          ),
                          height: 91,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                            child: Column(
                              children: [
                                ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  splashColor: Colors.transparent,
                                  height: 50,
                                  child: FlatButton(
                                    color: AppTheme.themeColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: AppTheme.themeColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      merchFieldsValue = [];
                                      if (_formKey.currentState!.validate()) {
                                        WriteBatch batch = FirebaseFirestore.instance.batch();

                                        setState(() {
                                          cusCreating = true;
                                          widget.cusLoadingState();
                                        });
                                        openOverAllSubLoading();

                                        //DocumentReference cusArr = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr2').doc('cusArr');


                                        FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('cusCnt')
                                            .get()
                                            .then((value) async {
                                          int prodsCnt = value.data()!['count'];

                                          debugPrint("adding nmow " + prodsCnt.toString());
                                          batch = await addCustomer(batch, '$deviceIdNum-' + prodsCnt.toString());

                                          // cusArr.set({
                                          //   'cus': {
                                          //     '$deviceIdNum-' + prodsCnt.toString(): {
                                          //       'na': merchFieldsValue[0],
                                          //       'ad': merchFieldsValue[1],
                                          //       'ph': merchFieldsValue[2],
                                          //       'or' : 0,
                                          //       'de' : 0,
                                          //       'da' : 0,
                                          //       're' : 0,
                                          //       'ar' : false,
                                          //     }
                                          //   }
                                          // },SetOptions(merge: true)).then((value) {
                                          //   debugPrint('arrays added ' + '0-' + prodsCnt.toString());
                                          // }).catchError((error) => debugPrint("Failed to update user: $error"));

                                          batch = await updateCount(batch);
                                          try {
                                            batch.commit();
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                cusCreating = false;
                                                widget.endCusLoadingState();
                                              });
                                              closeOverAllSubLoading();
                                              Navigator.pop(context);
                                              smartKyatFlash(merchFieldsValue[0]  + ' has been added successfully', 's');
                                            });
                                          } catch(error) {
                                            debugPrint('error while creating orders');
                                            setState(() {
                                              cusCreating = false;
                                              widget.endCusLoadingState();

                                            });
                                            closeOverAllSubLoading();
                                            Navigator.pop(context);
                                            smartKyatFlash('An error occurred while creating new customer. Please try again later.', 'e');

                                          }

                                          // FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('cusCnt')
                                          //     .update(
                                          //     {'count': FieldValue.increment(1)}
                                          // ).then((value) => debugPrint('updated product count'));
                                        });

                                      }
                                    },
                                    child:  cusCreating == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                        child: CupertinoActivityIndicator(radius: 10,)) :Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 3.0),
                                      child: Container(
                                        child: Text(
                                          textSetAdd, textScaleFactor: 1,
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
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  textSplitFunction(String text) {
    List example = text.runes.map((rune) => new String.fromCharCode(rune)).toList();
    List result = [];
    String intResult = '';
    int i = 0;
    for(int j =0; j<example.length; j++) {
      for(i = j ; i<example.length; i++) {
        intResult = intResult + example[i].toString();
        result.add(intResult.toLowerCase());
      }
      intResult = '';
    }
    return result;
  }

  void smartKyatFlash(String text, String type) {
    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }
    showFlash(
      context: context,
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(text, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
          // child: Padding(
          //   padding: const EdgeInsets.only(
          //       top: 93.0, left: 15, right: 15),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(10.0),
          //       ),
          //       color: bgColor,
          //       border: Border.all(
          //           color: bdColor,
          //           width: 1.0
          //       ),
          //     ),
          //     child: Padding(
          //         padding: const EdgeInsets.only(
          //             top: 15.0, left: 10, right: 10, bottom: 15),
          //         child: Row(
          //           children: [
          //             SizedBox(width: 5),
          //             widgetCon,
          //             SizedBox(width: 10),
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 2.5),
          //               child: Container(
          //                 child: Text(text, overflow: TextOverflow.visible, style: TextStyle(
          //                     fontWeight: FontWeight.w400, fontSize: 14.5)),
          //               ),
          //             )
          //           ],
          //         )
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  updateCount(WriteBatch batch){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('cusCnt');
    batch.update(documentReference, {'count': FieldValue.increment(1)});
    return batch;
  }

  addCustomer(WriteBatch batch, id) {

    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr2').doc('cusArr');
    batch.update(documentReference, {
      'cus.$id.na': merchFieldsValue[0],
      'cus.$id.ad': merchFieldsValue[1],
      'cus.$id.ph': merchFieldsValue[2],
      'cus.$id.de': 0,
      'cus.$id.or': 0,
      'cus.$id.da': 0,
      'cus.$id.re': 0,
      'cus.$id.ar': false,

    });

    DocumentReference nonceRef = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr2').doc('nonce_doc').collection('nonce_col').doc();
    batch.set(nonceRef, {
      'time': FieldValue.serverTimestamp(),
    });

    return batch;
  }

}