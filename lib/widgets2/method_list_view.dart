///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 11:00
///
import 'dart:io';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartkyat_pos/fragments/products_fragment2.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';

import '../app_theme.dart';
import '../constants/picker_method.dart';

class MethodListView extends StatelessWidget {
  const MethodListView({
    Key? key,
    required this.isEnglish,
    required this.pickMethods,
    required this.onSelectMethod,
  }) : super(key: key);

  final bool isEnglish;
  final List<PickMethod> pickMethods;
  final Function(PickMethod method) onSelectMethod;

  Widget methodItemBuilder(BuildContext context, int index) {
    final PickMethod model = pickMethods[index];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 0.0,
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: ButtonTheme(
            splashColor: Colors.transparent,
            minWidth: MediaQuery.of(context).size.width,
            height: 50,
            child: CustomFlatButton(
              color: AppTheme.secButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () async {
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    await onSelectMethod(model);
                    debugPrint('go on');
                    Future.delayed(const Duration(milliseconds: 300), () {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                    });
                  }
                } on SocketException catch (_) {
                  Color bdColor = Color(0xffffffff);
                  Color bgColor = Color(0xffffffff);
                  Widget widgetCon = Container();
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
                                  child: Text(isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
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
                      );
                    },
                  );
                  debugPrint('Internet connection');
                 // smartKyatFlash(widget.isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', 'w');
                }


                // ProductsFragmentState().closeNewProduct();
                // addNewProd(context);
              },
              child: Text(
                isEnglish? 'Add image': 'ပုံထည့်ရန်', textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.3,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w500,
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
      // child: Row(
      //   children: <Widget>[
      //     Container(
      //       margin: const EdgeInsets.all(2.0),
      //       width: 48,
      //       height: 48,
      //       child: Center(
      //         child: Text(
      //           model.icon,
      //           style: const TextStyle(fontSize: 24.0),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: 12.0),
      //     Expanded(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Text(
      //             model.name,
      //             style: const TextStyle(
      //               fontSize: 18.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //           ),
      //           const SizedBox(height: 5),
      //           Text(
      //             model.description,
      //             style: Theme.of(context).textTheme.caption,
      //           ),
      //         ],
      //       ),
      //     ),
      //     // const Icon(Icons.chevron_right, color: Colors.grey),
      //   ],
      // ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        itemCount: pickMethods.length,
        itemBuilder: methodItemBuilder,
      ),
    );
  }
}
