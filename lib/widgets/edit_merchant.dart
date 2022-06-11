import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class EditMerchant extends StatefulWidget {

  const EditMerchant({Key? key, required this.isEnglish ,required this.shopId, required this.fromSearch,required this.merchId, required this.merchName, required this.merchAddress, required this.merchPhone});
  final String shopId;
  final String merchId;
  final String merchName;
  final String merchAddress;
  final String merchPhone;
  final bool fromSearch;
  final bool isEnglish;


  @override
  _EditMerchantState createState() => _EditMerchantState();
}

class _EditMerchantState extends State<EditMerchant> {

  final _formKey = GlobalKey<FormState>();
  final merchNameCtrl = TextEditingController();
  final merchAddressCtrl = TextEditingController();
  final merchPhoneCtrl = TextEditingController();

  @override
  void initState() {
    merchNameCtrl.text = widget.merchName;
    merchAddressCtrl.text = widget.merchAddress;
    merchPhoneCtrl.text = widget.merchPhone;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  bool merchLoading = false;
  bool disableTouch = false;

  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {

    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Container(
      color: Colors.white,
      child: IgnorePointer(
        ignoring: disableTouch,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 81,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35.0),
                              ),
                              color: Colors.grey.withOpacity(0.3)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 17,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.merchName,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.isEnglish ? 'Edit Merchant' : 'ကုန်သည် ပြင်ဆင်ရန်',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
                            child: Text(
                              'MERCHANT INFORMATION',
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 45.0, right: 15.0, left:15.0),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                                FilteringTextInputFormatter.deny('^'),
                                FilteringTextInputFormatter.deny('<>'),
                              ],
                              controller: merchNameCtrl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' This field is required ';
                                }
                                return null;
                              },
                              style: TextStyle(
                                height: 0.95,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: AppTheme.skBorderColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),

                                focusedBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: AppTheme.themeColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                contentPadding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                //suffixText: 'Required',
                                suffixStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'capsulesans',
                                ),
                                // errorText: wrongPassword,
                                errorStyle: TextStyle(
                                    backgroundColor: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',
                                    height: 0.1
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
// errorText: 'Error message',
                                labelText: widget.isEnglish ? 'Name' : 'နာမည်',
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
                            padding: const EdgeInsets.only(top: 117.0, right: 15.0, left:15.0),
                            child: TextFormField(
                              controller: merchAddressCtrl,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' This field is required ';
                                }
                                return null;
                              },
                              style: TextStyle(
                                height: 0.95,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: AppTheme.skBorderColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),

                                focusedBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: AppTheme.themeColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                contentPadding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                //suffixText: 'Required',
                                suffixStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'capsulesans',
                                ),
                                // errorText: wrongPassword,
                                errorStyle: TextStyle(
                                    backgroundColor: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',
                                    height: 0.1
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
// errorText: 'Error message',
                                labelText: widget.isEnglish ? 'Address' : 'လိပ်စာ',
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
                            padding: const EdgeInsets.only(top: 189.0, right: 15.0, left:15.0),
                            child: TextFormField(
                              controller: merchPhoneCtrl,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' This field is required ';
                                }
                                return null;
                              },
                              style: TextStyle(
                                height: 0.95,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: AppTheme.skBorderColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),

                                focusedBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: AppTheme.themeColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                contentPadding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                //suffixText: 'Required',
                                suffixStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'capsulesans',
                                ),
                                // errorText: wrongPassword,
                                errorStyle: TextStyle(
                                    backgroundColor: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',
                                    height: 0.1
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
// errorText: 'Error message',
                                labelText: widget.isEnglish ? 'Phone Number' : 'ဖုန်းနံပါတ်',
                                floatingLabelBehavior:
                                FloatingLabelBehavior.auto,
//filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 261.0, right: 15.0, left:15.0),
                          //   child: ButtonTheme(
                          //     minWidth: MediaQuery
                          //         .of(context)
                          //         .size
                          //         .width,
                          //     splashColor: Colors.transparent,
                          //     height: 50,
                          //     child: FlatButton(
                          //       color: AppTheme.themeColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius:
                          //         BorderRadius.circular(10.0),
                          //         side: BorderSide(
                          //           color: AppTheme.themeColor,
                          //         ),
                          //       ),
                          //       onPressed: () async {
                          //
                          //         CollectionReference customerLocate = await FirebaseFirestore.instance.collection('shops')
                          //             .doc(widget.shopId)
                          //             .collection('merchants');
                          //         if (_formKey.currentState!.validate()) {
                          //           setState(() {
                          //             merchLoading = true;
                          //             disableTouch = true;
                          //           });
                          //           customerLocate.doc(widget.merchId).update({
                          //             'merchant_name': merchNameCtrl.text,
                          //             'merchant_address': merchAddressCtrl.text,
                          //             'merchant_phone' : merchPhoneCtrl.text,
                          //           }).then((value) {
                          //             setState(() {
                          //             merchLoading = false;
                          //             disableTouch = false;
                          //           });
                          //           }).catchError((error){debugPrint("Failed to update user: $error");});
                          //           Navigator.pop(context);
                          //           widget._openCartBtn();
                          //           smartKyatFlash(merchNameCtrl.text + ' is successfully updated.', 's');
                          //         }
                          //       },
                          //       child: merchLoading == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                          //           child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 5.0,
                          //             right: 5.0,
                          //             bottom: 2.0),
                          //         child: Container(
                          //           child: Text(
                          //             'Save Merchant',
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w600,
                          //                 letterSpacing: -0.1
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? 0 + 20: homeBotPadding),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                      child: ButtonTheme(
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width,
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

                            DocumentReference customerLocate = await FirebaseFirestore.instance.collection('shops')
                                .doc(widget.shopId)
                                .collection('collArr').doc('merArr');
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                merchLoading = true;
                                disableTouch = true;
                              });
                              openOverAllSubLoading();
                              customerLocate.update({
                                'mer.'+ widget.merchId + '.na': merchNameCtrl.text,
                                'mer.'+ widget.merchId + '.ad': merchAddressCtrl.text,
                                'mer.'+ widget.merchId + '.ph': merchPhoneCtrl.text,
                              }).then((value) {
                                Future.delayed(const Duration(milliseconds: 2000), () {
                                  setState(() {
                                    merchLoading = false;
                                    disableTouch = false;
                                  });
                                  closeOverAllSubLoading();
                                  Navigator.pop(context);
                                  smartKyatFlash(merchNameCtrl.text + ' is successfully updated.', 's');
                                });
                              }).catchError((error){
                                Future.delayed(const Duration(milliseconds: 2000), () {
                                  setState(() {
                                    merchLoading = false;
                                    disableTouch = false;
                                  });
                                  closeOverAllSubLoading();
                                  Navigator.pop(context);
                                  smartKyatFlash('An error occurred while editing merchant. Please try again later.', 'e');
                                });
                              });

                            }
                          },
                          child: merchLoading == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 5.0,
                                bottom: 2.0),
                            child: Container(
                              child: Text(
                               widget.isEnglish ? 'Save' : 'သိမ်းဆည်းမည်',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.3,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black
                                ),
                                strutStyle: StrutStyle(
                                  height: 1.3,
                                  // fontSize:,
                                  forceStrutHeight: true,
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
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
              ),
              widget.fromSearch? SizedBox(height: 65): SizedBox(height: 0)
            ],
          ),
        ),
      ),
    );
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
          child: Text ('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
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
}
