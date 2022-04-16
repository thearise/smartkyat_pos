import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/widgets_small/top80_app_bar.dart';

import '../../app_theme.dart';

class BuyListRefund extends StatefulWidget {
  final _callback;

  const BuyListRefund(
      {Key? key,  required this.documentId, required this.data, required this.docId, required this.shopId, required this.data2, required this.realPrice, required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  final String data;
  final List data2;
  final double realPrice;
  final String shopId;
  final String docId;
  final String documentId;

  @override
  _BuyListRefundState createState() => _BuyListRefundState();
}

class _BuyListRefundState extends State<BuyListRefund>
    with TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<BuyListRefund>{
  @override
  bool get wantKeepAlive => true;
  List<double> refundItems = [];
  List<double> deffItems = [];
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  List<TextEditingController> quantityCtrlList = [];
  String currencyUnit = 'MMK';

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  String textSetTtlRefund = 'Refunded items price';
  String textSetTtlRefundAmount = 'Total refund amount';
  String textSetRefundBtn = 'Refund';
  @override
  void initState() {
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetTtlRefund = 'ပြန်ပေးပစ္စည်းများ ကျသင့်ငွေ';
          textSetTtlRefundAmount = 'စုစုပေါင်း ပြန်ပေးငွေ';
          textSetRefundBtn = 'ပြန်ပေးပစ္စည်းထည့်မည်';
        });
      } else if(value=='english') {
        setState(() {
          textSetTtlRefund = 'Refunded items price';
          textSetTtlRefundAmount = 'Total refund amount';
          textSetRefundBtn = 'Refund';
        });
      }
    });

    getCurrency().then((value){
      if(value == 'US Dollar (USD)') {
        setState(() {
          currencyUnit = 'USD';
        });
      } else if(value == 'Myanmar Kyat (MMK)') {
        setState(() {
          currencyUnit = 'MMK';
        });
      }
    });
    for(int i=0; i<widget.data2.length; i++) {
      quantityCtrlList.add(TextEditingController());
      quantityCtrlList[i].text = double.parse(widget.data2[i].split('-')[7]).round().toString();
      quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));

    }
    print('phyopyaesohn' + widget.data.toString());
    super.initState();
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
  @override
  void dispose() {
    super.dispose();
  }

  bool initAttempt = false;
  int changedPrice = 0;
  List<String> prodListView = [];
  bool disableTouch = false;
  bool loadingState = false;
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
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('shops')
                        .doc(widget.shopId)
                        .collection('merchants')
                        .doc(widget.data
                        .split('^')[3]
                        .split('&')[widget.data.split('^')[3].split('&').length-1])
                        .snapshots(),
                    builder: (BuildContext context, snapshot3) {
                      if (snapshot3.hasData) {
                        var output1 = snapshot3.data!.data();
                        var mainUnit =
                        output1?['merchant_name'];
                        return Top80AppBar('#' +
                            widget.data.split('^')[1] + ' (' + mainUnit + ')', '$currencyUnit ' + (double.parse(widget.data.split('^')[2]).toStringAsFixed(1)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'));
                      }
                      return Top80AppBar('#' +
                          widget.data.split('^')[1] + ' (Loading)', '$currencyUnit ' + (double.parse(widget.data.split('^')[2]).toStringAsFixed(1)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'));

                    }
                ),
                // orderDateId(widget.data)
                if (widget.docId != null && widget.docId != '')
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('shops')
                          .doc(widget.shopId)
                          .collection('buyOrder')
                          .doc(widget.docId)
                          .snapshots(),
                      builder: (BuildContext context, snapshot2) {
                        if (snapshot2.hasData) {
                          var output1 = snapshot2.data!.data();
                          // print(output1?['subs'].toString());
                          List prodList = output1?['subs'];
                          List prodListBefore = widget.data2;
                          prodListView = [];
                          prodListView.add(prodList[0]);

                          double ttlQtity = double.parse(prodList[0].split('-')[3]);
                          double ttlRefun = double.parse(prodList[0].split('-')[3]);
                          for (int j=1;j< prodList.length; j++) {
                            int k = prodListView.length-1;
                            if(prodList[j].split('-')[0] == prodListView[k].split('-')[0] && prodList[j].split('-')[5] == prodListView[k].split('-')[5]) {
                              ttlQtity += int.parse(prodList[j].split('-')[3]);
                              ttlRefun += int.parse(prodList[j].split('-')[7]);
                              prodListView[k] = prodListView[k].split('-')[0] + '-' + prodListView[k].split('-')[1] + '-' + prodListView[k].split('-')[2] + '-' + ttlQtity.toString() + '-' +
                                  prodListView[k].split('-')[4] + '-' + prodListView[k].split('-')[5] + '-' + prodListView[k].split('-')[6] + '-' + (double.parse(prodListView[k].split('-')[7]).round() + double.parse(prodList[j].split('-')[7]).round()).toString() + '-' +
                                  prodListView[k].split('-')[8] ;
                            } else {
                              prodListView.add(prodList[j]);
                              ttlQtity = double.parse(prodList[j].split('-')[3]);
                              ttlRefun += double.parse(prodList[j].split('-')[7]);
                            }
                          }
                          if (!initAttempt) {
                            for (int i = 0; i < prodListView.length; i++) {
                              // refundItems[i] = int.parse(prodList[i].split('-')[5]);
                              refundItems
                                  .add(double.parse(prodListView[i].split('-')[7]));
                              deffItems
                                  .add(double.parse(prodListView[i].split('-')[7]));
                            }
                            initAttempt = true;
                          }

                          return Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.all(0.0),
                                    children: [
                                      for (int i = 0; i < prodListView.length; i++)
                                        StreamBuilder<
                                            DocumentSnapshot<Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection('shops')
                                              .doc(widget.shopId)
                                              .collection('products')
                                              .doc(prodListView[i].split('-')[0])
                                              .snapshots(),
                                          builder: (BuildContext context, snapshot10) {
                                            String image = '';
                                            if (snapshot10.hasData) {
                                              var output2 = snapshot10.data!.data();
                                              image = output2?['img_1'];
                                              return Container(
                                                  color: Colors.white,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 12),
                                                            ListTile(
                                                              leading: ClipRRect(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                                child: image != ""
                                                                    ? CachedNetworkImage(
                                                                  imageUrl:
                                                                  'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                      image,
                                                                  width: 56.5,
                                                                  height: 56.5,
                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/system/default-product.png'), height: 58, width: 58,),
                                                                  errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                      Image(image: AssetImage('assets/system/default-product.png'), height: 58, width: 58,),
                                                                  fadeInDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                      100),
                                                                  fadeOutDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                      10),
                                                                  fadeInCurve:
                                                                  Curves
                                                                      .bounceIn,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                                    :  Image.asset('assets/system/default-product.png', height: 58, width: 58),),
                                                              title: Tooltip(
                                                                message: output2?['prod_name'],
                                                                // preferOri: PreferOrientation.up,
                                                                // isShow: false,
                                                                child: Text(
                                                                  output2?['prod_name'],
                                                                  maxLines: 1,
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.w500, fontSize: 16, height: 1.3, overflow: TextOverflow.ellipsis,),
                                                                ),
                                                              ),
                                                              subtitle: Padding(
                                                                padding: const EdgeInsets.only(top: 4.0),
                                                                child: Row(
                                                                  children: [
                                                                    if (prodListView[i].split('-')[5] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                                    else if(prodListView[i].split('-')[5] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                                    else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                    Text(' ' + output2?[prodListView[i].split('-')[5]] + ' ', style: TextStyle(
                                                                      fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                              trailing: Container(

                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        if(prodListView[i].split('-')[7] == '0' || double.parse(prodListView[i].split('-')[7]) < refundItems[i]) {
                                                                          setState(() {
                                                                            if (refundItems[i] <= 0) {
                                                                            } else {
                                                                              refundItems[i] =
                                                                                  refundItems[i] - 1;
                                                                              quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                              quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                            }
                                                                          });
                                                                        }
                                                                        print('dataRMM' + widget.data.toString());

                                                                      },
                                                                      child: Container(
                                                                        width: 42,
                                                                        height: 42,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                            color: AppTheme.buttonColor2),
                                                                        child: Container(
                                                                            child: Icon(
                                                                              Icons.remove, size: 20,
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 10),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 0.5),
                                                                      child: Container(
                                                                        width: 55,
                                                                        height: 42,
                                                                        child: TextField(
                                                                          textAlign: TextAlign.center,
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
                                                                            contentPadding: EdgeInsets.only(bottom: 0, right: 10.0, left: 10.0),
                                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                            //filled: true,
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                          ),
                                                                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                                                                          inputFormatters: <TextInputFormatter>[
                                                                            FilteringTextInputFormatter.allow(RegExp(_getNum())),],
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              if ((double.parse(value)) <=
                                                                                  double.parse(prodListView[i].split('-')[3])) {
                                                                                refundItems[i] = double.parse(value);
                                                                                quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                                quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                              } else {refundItems[i] = refundItems[i];
                                                                              quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                              quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                              }
                                                                            });
                                                                          },
                                                                          controller: quantityCtrlList[i],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Text(refundItems[i].toString(), style: TextStyle(
                                                                    //   fontSize: 14,
                                                                    //   fontWeight: FontWeight.w500,
                                                                    // ),),
                                                                    SizedBox(width: 10),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          if ((refundItems[i]) >=
                                                                              double.parse(prodListView[i]
                                                                                  .split('-')[3])) {
                                                                          } else {
                                                                            refundItems[i] = refundItems[i] + 1;
                                                                            quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                            quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        width: 42,
                                                                        height: 42,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                            color: AppTheme.themeColor),
                                                                        child: Container(
                                                                            child: Icon(
                                                                              Icons.add, size: 20,
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 15.0),
                                                              child: Container(height: 12,
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                      bottom:
                                                                      BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                                                                    )),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top : 10,
                                                        left : 50,
                                                        child: Container(
                                                          height: 20,
                                                          width: 30,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: AppTheme.skBorderColor2,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0),
                                                              border: Border.all(
                                                                color: Colors.white,
                                                                width: 2,
                                                              )),
                                                          child: Text((double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7])).round().toString(), style: TextStyle(
                                                            fontSize: 11, fontWeight: FontWeight.w500,
                                                          )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );


                                            }
                                            return Container(
                                              color: Colors.white,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 12),
                                                        ListTile(
                                                          leading: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                            child: image != ""
                                                                ? CachedNetworkImage(
                                                              imageUrl:
                                                              'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                  image,
                                                              width: 56.5,
                                                              height: 56.5,
                                                              placeholder: (context, url) => Image(image: AssetImage('assets/system/default-product.png'), height: 58, width: 58,),
                                                              errorWidget: (context,
                                                                  url,
                                                                  error) =>
                                                                  Image(image: AssetImage('assets/system/default-product.png'), height: 58, width: 58,),
                                                              fadeInDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                  100),
                                                              fadeOutDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                  10),
                                                              fadeInCurve:
                                                              Curves
                                                                  .bounceIn,
                                                              fit: BoxFit
                                                                  .cover,
                                                            )
                                                                :  Image.asset('assets/system/default-product.png', height: 58, width: 58),),
                                                          title: Tooltip(
                                                            message: 'Unknown item',
                                                            // preferOri: PreferOrientation.up,
                                                            // isShow: false,
                                                            child: Text(
                                                              'Unknown item',
                                                              maxLines: 1,
                                                              style:
                                                              TextStyle(
                                                                fontWeight: FontWeight.w500, fontSize: 16, height: 1.3, overflow: TextOverflow.ellipsis,),
                                                            ),
                                                          ),
                                                          subtitle: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: Row(
                                                              children: [
                                                                if (prodListView[i].split('-')[5] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                                else if(prodListView[i].split('-')[5] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                                else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                Text(' ' + subItemsOff(prodListView[i].split('-')[5]) + ' ', style: TextStyle(
                                                                    fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                          trailing: Container(

                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if(prodListView[i].split('-')[7] == '0' || double.parse(prodListView[i].split('-')[7]) < refundItems[i]) {
                                                                      setState(() {
                                                                        if (refundItems[i] <= 0) {
                                                                        } else {
                                                                          refundItems[i] =
                                                                              refundItems[i] - 1;
                                                                          quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                          quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                        }
                                                                      });
                                                                    }
                                                                    print('dataRMM' + widget.data.toString());

                                                                  },
                                                                  child: Container(
                                                                    width: 42,
                                                                    height: 42,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(10.0),
                                                                        color: AppTheme.buttonColor2),
                                                                    child: Container(
                                                                        child: Icon(
                                                                          Icons.remove, size: 20,
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 10),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 0.5),
                                                                  child: Container(
                                                                    width: 55,
                                                                    height: 42,
                                                                    child: TextField(
                                                                      textAlign: TextAlign.center,
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
                                                                        contentPadding: EdgeInsets.only(bottom: 0, right: 10.0, left: 10.0),
                                                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                        //filled: true,
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                                                                      inputFormatters: <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.allow(RegExp(_getNum())),],
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          if ((double.parse(value)) <=
                                                                              double.parse(prodListView[i].split('-')[3])) {
                                                                            refundItems[i] = double.parse(value);
                                                                            quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                            quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                          } else {refundItems[i] = refundItems[i];
                                                                          quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                          quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                          }
                                                                        });
                                                                      },
                                                                      controller: quantityCtrlList[i],
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Text(refundItems[i].toString(), style: TextStyle(
                                                                //   fontSize: 14,
                                                                //   fontWeight: FontWeight.w500,
                                                                // ),),
                                                                SizedBox(width: 10),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      if ((refundItems[i]) >=
                                                                          double.parse(prodListView[i]
                                                                              .split('-')[3])) {
                                                                      } else {
                                                                        refundItems[i] = refundItems[i] + 1;
                                                                        quantityCtrlList[i].text = refundItems[i].round().toString();
                                                                        quantityCtrlList[i].selection = TextSelection.fromPosition(TextPosition(offset: quantityCtrlList[i].text.length));
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width: 42,
                                                                    height: 42,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(10.0),
                                                                        color: AppTheme.themeColor),
                                                                    child: Container(
                                                                        child: Icon(
                                                                          Icons.add, size: 20,
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 15.0),
                                                          child: Container(height: 12,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                  bottom:
                                                                  BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                                                                )),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top : 8,
                                                    left : 50,
                                                    child: Container(
                                                      height: 20,
                                                      width: 30,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: AppTheme.skBorderColor2,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2,
                                                          )),
                                                      child: Text((double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7])).round().toString(), style: TextStyle(
                                                        fontSize: 11, fontWeight: FontWeight.w500,
                                                      )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ListTile(
                                        title: Text(
                                         textSetTtlRefund,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        subtitle: totalItems() == 1? Text(totalItems().toString() + ' item',
                                            style: TextStyle(
                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                            )) : Text(totalItems().toString() + ' items',
                                            style: TextStyle(
                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                            )),
                                        trailing: Text('$currencyUnit '+
                                            totalPriceView().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                         textSetTtlRefundAmount,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        subtitle: totalItems() == 1? Text(totalItems().toString() + ' item',
                                            style: TextStyle(
                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                            )) : Text(totalItems().toString() + ' items',
                                            style: TextStyle(
                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                            )),
                                        trailing: Text('$currencyUnit '+
                                            totalRefund().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ),





                                      // Align(
                                      //   alignment: Alignment.bottomCenter,
                                      //   child: Padding(
                                      //     padding: EdgeInsets.only(bottom: homeBotPadding),
                                      //     child: Container(
                                      //       color: Colors.white,
                                      //       child: Padding(
                                      //         padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                                      //         child: ButtonTheme(
                                      //           minWidth: MediaQuery.of(context).size.width,
                                      //           splashColor: Colors.transparent,
                                      //           height: 50,
                                      //           child: FlatButton(
                                      //             color: AppTheme.skThemeColor,
                                      //             shape: RoundedRectangleBorder(
                                      //               borderRadius:
                                      //               BorderRadius.circular(10.0),
                                      //               side: BorderSide(
                                      //                 color: AppTheme.skThemeColor,
                                      //               ),
                                      //             ),
                                      //             onPressed: () async {
                                      //               WriteBatch batch = FirebaseFirestore.instance.batch();
                                      //               setState(() {
                                      //                 loadingState = true;
                                      //                 disableTouch = true;
                                      //               });
                                      //               double total = 0;
                                      //               bool refund = false;
                                      //               List<String> ref2Cust = [];
                                      //               List<String> ref2Shop = [];
                                      //               for (int i = 0; i < refundItems.length; i++) {
                                      //                 prodListView[i] = prodListView[i].split('-')[0] + '-' + prodListView[i].split('-')[1] + '-' + prodListView[i].split('-')[2] + '-' +
                                      //                     prodListView[i].split('-')[3] + '-' + prodListView[i].split('-')[4] + '-' + prodListView[i].split('-')[5] + '-' +
                                      //                     prodListView[i].split('-')[6] +
                                      //                     '-' +
                                      //                     refundItems[i].toString() +
                                      //                     '-' +
                                      //                     prodListView[i].split('-')[8];
                                      //                 total += (double.parse(prodListView[i]
                                      //                     .split('-')[3]) -
                                      //                     refundItems[i]) *
                                      //                     double.parse(
                                      //                         prodListView[i].split('-')[4]);
                                      //
                                      //                 if (refundItems[i] > 0) {
                                      //                   refund = true;
                                      //                 }
                                      //
                                      //                 print('unit _name' + prodListView[i]);
                                      //                 print('unit ' + deffItems[i].toString() + ' ' + refundItems[i].toString() + (deffItems[i] - refundItems[i]).toString());
                                      //
                                      //                 ref2Cust = [];
                                      //                 ref2Shop = [];
                                      //                 for(int i=0; i < deffItems.length; i++) {
                                      //                   if(deffItems[i] - refundItems[i] < 0) {
                                      //                     print('ref to shop ' + prodListView[i].split('-')[3] + ' ' + prodListView[i].split('-')[5]);
                                      //                     ref2Shop.add(prodListView[i].split('-')[0] + '-' + prodListView[i].split('-')[1] + '-' + (deffItems[i] - refundItems[i]).abs().toString() + '-' + prodListView[i].split('-')[5]);
                                      //                   } else if(deffItems[i] - refundItems[i] > 0) {
                                      //                     print('ref to cust ' + prodListView[i].split('-')[3] + ' ' + prodListView[i].split('-')[5]);
                                      //                   }
                                      //                 }
                                      //               }
                                      //
                                      //               print('che ' + ref2Shop.toString());
                                      //               print('che2 ' + prodListView.toString());
                                      //
                                      //               print('prodList 5  1 ' + total.toString() + ' ' + prodList.toString());
                                      //
                                      //               if(widget.data.split('^')[6] != '0.0') {
                                      //                 if(widget.data.split('^')[6].split('-')[1] == 'p') {
                                      //                   total = total - (total * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
                                      //                 } else {
                                      //                   total = total - (total * (double.parse(widget.data.split('^')[6].split('-')[0])/widget.realPrice));
                                      //                 }
                                      //               }
                                      //               print('result__ 3' + total.toString());
                                      //               print('prodListBef 1 ' + prodListBefore.toString());
                                      //
                                      //               for(int i=0; i < prodListView.length; i++) {
                                      //                 // int.parse(ref2Shop[i].split('-')[2])
                                      //                 double value = double.parse(prodListView[i].split('-')[7]);
                                      //                 String prodId = prodListView[i].split('-')[0];
                                      //                 String prodTp = prodListView[i].split('-')[5];
                                      //
                                      //                 print(prodId + ' ' + prodTp);
                                      //
                                      //                 for(int j=0; j< prodList.length; j++) {
                                      //                   print('debuug ' + i.toString() + ' ' + j.toString() + ' ' + value.toString());
                                      //                   double refund = 0;
                                      //                   if(prodId == prodList[j].split('-')[0] && prodTp == prodList[j].split('-')[5] && value <= double.parse(prodList[j].split('-')[3])) {
                                      //                     refund = value - double.parse(prodList[j].split('-')[7]);
                                      //                     print('refun ' + refund.toString() + ' ' + value.toString() + ' ' + prodList[j].split('-')[7]);
                                      //                     prodList[j] = prodList[j].split('-')[0] + '-' + prodList[j].split('-')[1] + '-' + prodList[j].split('-')[2] + '-' + prodList[j].split('-')[3] + '-' + prodList[j].split('-')[4] + '-' + prodList[j].split('-')[5] + '-' + prodList[j].split('-')[6] + '-' +
                                      //                         value.toString() + '-' + prodList[j].split('-')[8];
                                      //
                                      //                     // prodListBefore[j] = prodListBefore[j].split('-')[0] + '-' + prodListBefore[j].split('-')[1] + '-' + prodListBefore[j].split('-')[2] + '-' + prodListBefore[j].split('-')[3] + '-' + prodListBefore[j].split('-')[4] + '-' + prodListBefore[j].split('-')[5] + '-' + prodListBefore[j].split('-')[6] + '-' +
                                      //                     //     refund.toString() + '-' + prodListBefore[j].split('-')[8];
                                      //                     break;
                                      //                   } else if (prodId == prodList[j].split('-')[0] && prodTp == prodList[j].split('-')[5] && value > int.parse(prodList[j].split('-')[3])) {
                                      //                     refund = value - int.parse(prodList[j].split('-')[7]);
                                      //                     print('refun ' + refund.toString() + ' ' + value.toString() + ' ' + prodList[j].split('-')[7]);
                                      //                     prodList[j] = prodList[j].split('-')[0] + '-' + prodList[j].split('-')[1] + '-' + prodList[j].split('-')[2] + '-' + prodList[j].split('-')[3] + '-' + prodList[j].split('-')[4] + '-' + prodList[j].split('-')[5] + '-' + prodList[j].split('-')[6] + '-' +
                                      //                         prodList[j].split('-')[3] + '-' + prodList[j].split('-')[8];
                                      //                     value = value - int.parse(prodList[j].split('-')[3]);
                                      //                   }
                                      //                 }
                                      //               }
                                      //
                                      //               print('prodList 5  2 ' + total.toString() + ' ' + prodList.toString());
                                      //               print('prodListBef 2 ' + prodListBefore.toString());
                                      //               List prodRets = prodList;
                                      //               for(int i=0; i < prodList.length; i++) {
                                      //                 double refNum = double.parse(prodList[i].split('-')[7]) - double.parse(prodListBefore[i].split('-')[7]);
                                      //                 if(refNum > 0) {
                                      //                   print('pyan thwin ' + prodList[i].split('-')[0] + '-' + prodList[i].split('-')[1] + '-' + refNum.toString());
                                      //                   var docSnapshot = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId)
                                      //                       .collection('products').doc(prodList[i].split('-')[0]).get();
                                      //                   if (docSnapshot.exists) {
                                      //                     Map<String, dynamic>? data = docSnapshot.data();
                                      //                     batch = await updateProduct(batch, prodList[i].split('-')[0], prodList[i].split('-')[5], refNum);
                                      //                     // CollectionReference prods = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
                                      //                     // prods.doc(prodList[i].split('-')[0])
                                      //                     //     .update({changeUnitName2Stock(prodList[i].split('-')[5]): FieldValue.increment(0 - double.parse(refNum.toString()))
                                      //                     // })
                                      //                     //     .then((value) => print("User Updated"))
                                      //                     //     .catchError((error) => print("Failed to update user: $error"));
                                      //                   }
                                      //                 }
                                      //               }
                                      //
                                      //               double debt = double.parse(widget.data.split('^')[5]);
                                      //               String refundAmount = 'F';
                                      //               bool reFilter = false;
                                      //               bool deFilter = false;
                                      //               var monthId = '';
                                      //               bool monthExist = false;
                                      //               var yearId = '';
                                      //               bool yearExist = false;
                                      //               DateTime now = DateTime.now();
                                      //               double chgTotal = 0;
                                      //
                                      //               if(total <= double.parse(widget.data.split('^')[5])) {
                                      //                 debt = total;
                                      //               }
                                      //
                                      //               double ttlR = 0.0;
                                      //               double ttlQ = 0.0;
                                      //               for (int i = 0; i < prodList.length; i++) {
                                      //                 ttlR += double.parse(prodList[i].split('-')[7]);
                                      //                 ttlQ += double.parse(prodList[i].split('-')[3]);
                                      //               }
                                      //
                                      //               print('totalTest ' + ttlR.toString() + ' ' +ttlQ.toString());
                                      //               if (ttlR.toString()  != '0' &&  ttlR == ttlQ) {
                                      //                 refundAmount = 'T';
                                      //                 reFilter = true;
                                      //               }
                                      //               if (ttlR.toString()  != '0'  &&  ttlR != ttlQ) {
                                      //                 refundAmount = 'P';
                                      //                 reFilter = true;
                                      //               }
                                      //
                                      //               int totalRefunds = 0;
                                      //               double chgDebts = 0;
                                      //               int ttlDebts = 0;
                                      //               print('leesin ' +widget.data.split('^')[4].toString());
                                      //
                                      //
                                      //               if (double.parse(widget.data.split('^')[5]) != debt) {
                                      //                 chgDebts = double.parse(widget.data.split('^')[5]) - debt;
                                      //               } else {
                                      //                 chgDebts = 0;
                                      //               }
                                      //
                                      //               if (double.parse(widget.data.split('^')[5]) != debt && debt == 0) {
                                      //                 ttlDebts = 1;
                                      //               } else {
                                      //                 ttlDebts = 0;
                                      //               }
                                      //
                                      //               if (debt == 0) {
                                      //                 deFilter = false;
                                      //               } else {
                                      //                 deFilter = true;
                                      //               }
                                      //
                                      //               if(widget.data.split('^')[4] == 'F') {
                                      //                 totalRefunds = 1;
                                      //               } else {
                                      //                 totalRefunds = 0;
                                      //               }
                                      //
                                      //               if (double.parse(widget.data.split('^')[2]) != total) {
                                      //                 chgTotal = double.parse(widget.data.split('^')[2]) - total;
                                      //               } else {
                                      //                 chgTotal = 0;
                                      //               }
                                      //
                                      //               var refundId = '';
                                      //
                                      //               batch = await updateRefund(batch, widget.data.split('^')[3].split('&')[1], totalRefunds, ttlDebts, chgDebts);
                                      //
                                      //
                                      //               CollectionReference monthlyData = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly');
                                      //
                                      //               monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse( widget.data.split('^')[0].substring(0,4) + '-' +  widget.data.split('^')[0].substring(4,6) + '-' + '01' + ' 00:00:00'))
                                      //                   .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse( widget.data.split('^')[0].substring(0,4) + '-' +  widget.data.split('^')[0].substring(4,6) + '-' + '31' + ' 23:59:59'))
                                      //                   .get()
                                      //                   .then((QuerySnapshot querySnapshot)  async {
                                      //                 querySnapshot.docs.forEach((doc) {
                                      //                   refundId = doc.id;
                                      //                 });
                                      //                 batch = await updateMonthlyData1(batch, refundId,  widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'cash_merc', widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'debt_merc', chgTotal, chgDebts);
                                      //                 // monthlyData.doc(refundId).update({
                                      //                 //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'cash_merc' : FieldValue.increment(0 - double.parse(chgTotal.toString())),
                                      //                 //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'debt_merc' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                      //                 //
                                      //                 // }).then((value) => print("data Updated"))
                                      //                 //     .catchError((error) => print("Failed to update user: $error"));
                                      //
                                      //
                                      //
                                      //               monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '01' + ' 00:00:00'))
                                      //                   .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '31' + ' 23:59:59'))
                                      //                   .get()
                                      //                   .then((QuerySnapshot querySnapshot)  async {
                                      //                 querySnapshot.docs.forEach((doc) {
                                      //                   monthExist = true;
                                      //                   monthId = doc.id;
                                      //                 });
                                      //                 print('month ' + monthExist.toString());
                                      //                 if (monthExist) {
                                      //                   batch = await updateMonthlyData2(batch, monthId, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc', chgTotal);
                                      //                   // monthlyData.doc(monthId).update({
                                      //                   //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc' : FieldValue.increment(chgTotal),
                                      //                   //
                                      //                   // }).then((value) => print("data Updated"))
                                      //                   //     .catchError((error) => print("Failed to update user: $error"));
                                      //                 }
                                      //                 else {
                                      //                   monthlyData.add({
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                      //                     for(int j = 1; j<= 31; j++)
                                      //                       now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_merc' : 0,
                                      //
                                      //                     'date': now,
                                      //
                                      //                   }).then((value) async {
                                      //                    // print('valueid' + value.id.toString());
                                      //                     batch = await updateMonthlyData2(batch, value.id, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc', chgTotal);
                                      //                     // monthlyData.doc(value.id).update({
                                      //                     //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc' : FieldValue.increment(chgTotal),
                                      //                     // }).then((value) => print("Data Updated"))
                                      //                     //     .catchError((error) => print("Failed to update user: $error"));
                                      //                   }).catchError((error) => print("Failed to update user: $error"));
                                      //                 }
                                      //
                                      //
                                      //               CollectionReference yearlyData = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly');
                                      //               var refundYearId = '';
                                      //
                                      //               yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0,4) + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                      //                   .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0,4) + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                      //                   .get()
                                      //                   .then((QuerySnapshot querySnapshot)  async {
                                      //                 querySnapshot.docs.forEach((doc) {
                                      //                   refundYearId = doc.id;
                                      //                 });
                                      //                 batch = await updateYearlyData1(batch, refundYearId, widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'cash_merc', widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'debt_merc', chgTotal, chgDebts);
                                      //                 // yearlyData.doc(refundYearId).update({
                                      //                 //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'cash_merc' : FieldValue.increment(0 - double.parse(chgTotal.toString())),
                                      //                 //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'debt_merc' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                      //                 //
                                      //                 // }).then((value) => print("data Updated"))
                                      //                 //     .catchError((error) => print("Failed to update user: $error"));
                                      //
                                      //               yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                      //                   .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                      //                   .get()
                                      //                   .then((QuerySnapshot querySnapshot)  async {
                                      //                 querySnapshot.docs.forEach((doc) {
                                      //                   yearExist = true;
                                      //                   yearId = doc.id;
                                      //                 });
                                      //                 print('year ' + yearExist.toString());
                                      //                 if (yearExist) {
                                      //                   batch = await updateYearlyData2(batch, yearId, now.year.toString() +  zeroToTen(now.month.toString())  + 'refu_merc', chgTotal);
                                      //                   // yearlyData.doc(yearId).update({
                                      //                   //   now.year.toString() +  zeroToTen(now.month.toString())  + 'refu_merc' : FieldValue.increment(chgTotal),
                                      //                   //
                                      //                   // }).then((value) => print("data Updated"))
                                      //                   //     .catchError((error) => print("Failed to update user: $error"));
                                      //                 }
                                      //                 else {
                                      //                   yearlyData.add({
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString()  + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString()  + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString() + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString() + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString() + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString() + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                      //                     for(int j = 1; j<= 12; j++)
                                      //                       now.year.toString() + zeroToTen(j.toString()) + 'refu_merc' : 0,
                                      //
                                      //                     'date': now,
                                      //
                                      //                   }).then((value12) async {
                                      //                    batch = await updateYearlyData2(batch, value12.id,  now.year.toString() +  zeroToTen(now.month.toString()) + 'refu_merc', chgTotal);
                                      //                     // yearlyData.doc(value12.id).update({
                                      //                     //   now.year.toString() +  zeroToTen(now.month.toString()) + 'refu_merc' : FieldValue.increment(chgTotal),
                                      //                     // }).then((value) => print("Data Updated"))
                                      //                     //     .catchError((error) => print("Failed to update user: $error"));
                                      //                   }).catchError((error) => print("Failed to update user: $error"));
                                      //                 }
                                      //
                                      //
                                      //               String data = widget.data;
                                      //
                                      //               String noCustomer = '';
                                      //               if(data.split('^')[3].split('&')[0] == 'No merchant') {
                                      //                 noCustomer = 'name';
                                      //               } else {noCustomer = data.split('^')[3].split('&')[0];}
                                      //
                                      //               String dataRm = data.split('^')[0] +
                                      //                   '^' +
                                      //                   data.split('^')[1] +
                                      //                   '^' +
                                      //                   data.split('^')[2] +
                                      //                   '^' +
                                      //                   data.split('^')[3].split('&')[1] + '<>' + noCustomer  +
                                      //                   '^' +
                                      //                   data.split('^')[4] + '^' + data.split('^')[5] + '^' + data.split('^')[6];
                                      //
                                      //               data = data.split('^')[0] +
                                      //                   '^' +
                                      //                   data.split('^')[1] +
                                      //                   '^' +
                                      //                   total.toString() +
                                      //                   '^' +
                                      //                   data.split('^')[3].split('&')[1] + '<>' + noCustomer  +
                                      //                   '^' +
                                      //                   refundAmount + '^' + debt.toString() + '^' + data.split('^')[6];
                                      //
                                      //               print('result___ ' + data + dataRm);
                                      //
                                      //               CollectionReference dOrder = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder');
                                      //               CollectionReference cusRefund = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants');
                                      //               CollectionReference dailyOrders = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders');
                                      //
                                      //               batch = await updateDailyOrder(batch, widget.documentId, dataRm, data);
                                      //
                                      //               // dailyOrders.doc(widget.documentId).update({
                                      //               //   'daily_order':
                                      //               //   FieldValue.arrayRemove([dataRm])
                                      //               // }).then((value) {print('array removed');})
                                      //               //     .catchError((error) => print("Failed to update user: $error"));
                                      //               //
                                      //               // dailyOrders.doc(widget.documentId).update({
                                      //               //   'daily_order':
                                      //               //   FieldValue.arrayUnion([data])
                                      //               // }).then((value) { print('array updated');})
                                      //               //     .catchError((error) => print("Failed to update user: $error"));
                                      //
                                      //               batch = await updateOrderDetail(batch, widget.docId, prodList, total, refundAmount, debt, reFilter, deFilter);
                                      //               // dOrder.doc(widget.docId).update({
                                      //               //   'subs': prodList,
                                      //               //   'total': total.toString(),
                                      //               //   'refund' : refundAmount,
                                      //               //   'debt' : debt,
                                      //               //   'refund_filter' : reFilter,
                                      //               //   'debt_filter' : deFilter,
                                      //               // }).then((value) { print('detail updated');})
                                      //               //     .catchError((error) => print("Failed to update user: $error"));
                                      //
                                      //                 // cusRefund.doc(widget.data.split('^')[3].split('&')[1]).update({
                                      //                 //   'total_refunds' : FieldValue.increment(double.parse(totalRefunds.toString())),
                                      //                 //   'debts' : FieldValue.increment(0 - double.parse(ttlDebts.toString())),
                                      //                 //   'debtAmount' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                      //                 // }).then((value) {
                                      //                 //   print('merchant updated');
                                      //                 // }).catchError((error) => print("Failed to update user: $error"));
                                      //               batch.commit();
                                      //
                                      //               });});});});
                                      //
                                      //               setState(() {
                                      //                 loadingState = false;
                                      //                 disableTouch = false;
                                      //               });
                                      //
                                      //               Navigator.of(context).popUntil((route) => route.isFirst);
                                      //               smartKyatFlash(currencyUnit + totalRefund().toString() + 'is successfully refunded to #' + widget.data.split('^')[1].toString(), 's');
                                      //             },
                                      //             child: loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                      //                 child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                      //               padding: const EdgeInsets.only(
                                      //                   left: 8.0,
                                      //                   right: 8.0,
                                      //                   bottom: 2.0),
                                      //               child: Container(
                                      //                 child: Text(
                                      //                  textSetRefundBtn,
                                      //                   textAlign: TextAlign.center,
                                      //                   style: TextStyle(
                                      //                       fontSize: 18,
                                      //                       fontWeight: FontWeight.w500,
                                      //                       color: Colors.black),
                                      //                 ),
                                      //               ),
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    // padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? homeBotPadding + 20: homeBotPadding),
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? 0 + 20: homeBotPadding),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                                      child:  ButtonTheme(
                                        minWidth: MediaQuery.of(context).size.width,
                                        splashColor: Colors.transparent,
                                        height: 50,
                                        child: FlatButton(
                                          color: AppTheme.skThemeColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: AppTheme.skThemeColor,
                                            ),
                                          ),
                                          onPressed: ()  async {
                                            WriteBatch batch = FirebaseFirestore.instance.batch();
                                            setState(() {
                                              loadingState = true;
                                              disableTouch = true;
                                            });
                                            double total = 0;
                                            bool refund = false;
                                            List<String> ref2Cust = [];
                                            List<String> ref2Shop = [];
                                            for (int i = 0; i < refundItems.length; i++) {
                                              prodListView[i] = prodListView[i].split('-')[0] + '-' + prodListView[i].split('-')[1] + '-' + prodListView[i].split('-')[2] + '-' +
                                                  prodListView[i].split('-')[3] + '-' + prodListView[i].split('-')[4] + '-' + prodListView[i].split('-')[5] + '-' +
                                                  prodListView[i].split('-')[6] +
                                                  '-' +
                                                  refundItems[i].toString() +
                                                  '-' +
                                                  prodListView[i].split('-')[8];
                                              total += (double.parse(prodListView[i]
                                                  .split('-')[3]) -
                                                  refundItems[i]) *
                                                  double.parse(
                                                      prodListView[i].split('-')[4]);

                                              if (refundItems[i] > 0) {
                                                refund = true;
                                              }

                                              print('unit _name' + prodListView[i]);
                                              print('unit ' + deffItems[i].toString() + ' ' + refundItems[i].toString() + (deffItems[i] - refundItems[i]).toString());

                                              ref2Cust = [];
                                              ref2Shop = [];
                                              for(int i=0; i < deffItems.length; i++) {
                                                if(deffItems[i] - refundItems[i] < 0) {
                                                  print('ref to shop ' + prodListView[i].split('-')[3] + ' ' + prodListView[i].split('-')[5]);
                                                  ref2Shop.add(prodListView[i].split('-')[0] + '-' + prodListView[i].split('-')[1] + '-' + (deffItems[i] - refundItems[i]).abs().toString() + '-' + prodListView[i].split('-')[5]);
                                                } else if(deffItems[i] - refundItems[i] > 0) {
                                                  print('ref to cust ' + prodListView[i].split('-')[3] + ' ' + prodListView[i].split('-')[5]);
                                                }
                                              }
                                            }

                                            print('che ' + ref2Shop.toString());
                                            print('che2 ' + prodListView.toString());

                                            print('prodList 5  1 ' + total.toString() + ' ' + prodList.toString());

                                            if(widget.data.split('^')[6] != '0.0') {
                                              if(widget.data.split('^')[6].split('-')[1] == 'p') {
                                                total = total - (total * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
                                              } else {
                                                total = total - (total * (double.parse(widget.data.split('^')[6].split('-')[0])/widget.realPrice));
                                              }
                                            }
                                            print('result__ 3' + total.toString());
                                            print('prodListBef 1 ' + prodListBefore.toString());

                                            for(int i=0; i < prodListView.length; i++) {
                                              // int.parse(ref2Shop[i].split('-')[2])
                                              double value = double.parse(prodListView[i].split('-')[7]);
                                              String prodId = prodListView[i].split('-')[0];
                                              String prodTp = prodListView[i].split('-')[5];

                                              print(prodId + ' ' + prodTp);

                                              for(int j=0; j< prodList.length; j++) {
                                                print('debuug ' + i.toString() + ' ' + j.toString() + ' ' + value.toString());
                                                double refund = 0;
                                                if(prodId == prodList[j].split('-')[0] && prodTp == prodList[j].split('-')[5] && value <= double.parse(prodList[j].split('-')[3])) {
                                                  refund = value - double.parse(prodList[j].split('-')[7]);
                                                  print('refun ' + refund.toString() + ' ' + value.toString() + ' ' + prodList[j].split('-')[7]);
                                                  prodList[j] = prodList[j].split('-')[0] + '-' + prodList[j].split('-')[1] + '-' + prodList[j].split('-')[2] + '-' + prodList[j].split('-')[3] + '-' + prodList[j].split('-')[4] + '-' + prodList[j].split('-')[5] + '-' + prodList[j].split('-')[6] + '-' +
                                                      value.toString() + '-' + prodList[j].split('-')[8];

                                                  // prodListBefore[j] = prodListBefore[j].split('-')[0] + '-' + prodListBefore[j].split('-')[1] + '-' + prodListBefore[j].split('-')[2] + '-' + prodListBefore[j].split('-')[3] + '-' + prodListBefore[j].split('-')[4] + '-' + prodListBefore[j].split('-')[5] + '-' + prodListBefore[j].split('-')[6] + '-' +
                                                  //     refund.toString() + '-' + prodListBefore[j].split('-')[8];
                                                  break;
                                                } else if (prodId == prodList[j].split('-')[0] && prodTp == prodList[j].split('-')[5] && value > int.parse(prodList[j].split('-')[3])) {
                                                  refund = value - int.parse(prodList[j].split('-')[7]);
                                                  print('refun ' + refund.toString() + ' ' + value.toString() + ' ' + prodList[j].split('-')[7]);
                                                  prodList[j] = prodList[j].split('-')[0] + '-' + prodList[j].split('-')[1] + '-' + prodList[j].split('-')[2] + '-' + prodList[j].split('-')[3] + '-' + prodList[j].split('-')[4] + '-' + prodList[j].split('-')[5] + '-' + prodList[j].split('-')[6] + '-' +
                                                      prodList[j].split('-')[3] + '-' + prodList[j].split('-')[8];
                                                  value = value - int.parse(prodList[j].split('-')[3]);
                                                }
                                              }
                                            }

                                            print('prodList 5  2 ' + total.toString() + ' ' + prodList.toString());
                                            print('prodListBef 2 ' + prodListBefore.toString());
                                            List prodRets = prodList;
                                            for(int i=0; i < prodList.length; i++) {
                                              double refNum = double.parse(prodList[i].split('-')[7]) - double.parse(prodListBefore[i].split('-')[7]);
                                              if(refNum > 0) {
                                                print('pyan thwin ' + prodList[i].split('-')[0] + '-' + prodList[i].split('-')[1] + '-' + refNum.toString());
                                                var docSnapshot = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId)
                                                    .collection('products').doc(prodList[i].split('-')[0]).get();
                                                if (docSnapshot.exists) {
                                                  Map<String, dynamic>? data = docSnapshot.data();
                                                  batch = await updateProduct(batch, prodList[i].split('-')[0], prodList[i].split('-')[5], refNum);
                                                  // CollectionReference prods = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
                                                  // prods.doc(prodList[i].split('-')[0])
                                                  //     .update({changeUnitName2Stock(prodList[i].split('-')[5]): FieldValue.increment(0 - double.parse(refNum.toString()))
                                                  // })
                                                  //     .then((value) => print("User Updated"))
                                                  //     .catchError((error) => print("Failed to update user: $error"));
                                                }
                                              }
                                            }

                                            double debt = double.parse(widget.data.split('^')[5]);
                                            String refundAmount = 'F';
                                            bool reFilter = false;
                                            bool deFilter = false;
                                            var monthId = '';
                                            bool monthExist = false;
                                            var yearId = '';
                                            bool yearExist = false;
                                            DateTime now = DateTime.now();
                                            double chgTotal = 0;

                                            if(total <= double.parse(widget.data.split('^')[5])) {
                                              debt = total;
                                            }

                                            double ttlR = 0.0;
                                            double ttlQ = 0.0;
                                            for (int i = 0; i < prodList.length; i++) {
                                              ttlR += double.parse(prodList[i].split('-')[7]);
                                              ttlQ += double.parse(prodList[i].split('-')[3]);
                                            }

                                            print('totalTest ' + ttlR.toString() + ' ' +ttlQ.toString());
                                            if (ttlR.toString()  != '0' &&  ttlR == ttlQ) {
                                              refundAmount = 'T';
                                              reFilter = true;
                                            }
                                            if (ttlR.toString()  != '0'  &&  ttlR != ttlQ) {
                                              refundAmount = 'P';
                                              reFilter = true;
                                            }

                                            int totalRefunds = 0;
                                            double chgDebts = 0;
                                            int ttlDebts = 0;
                                            print('leesin ' +widget.data.split('^')[4].toString());


                                            if (double.parse(widget.data.split('^')[5]) != debt) {
                                              chgDebts = double.parse(widget.data.split('^')[5]) - debt;
                                            } else {
                                              chgDebts = 0;
                                            }

                                            if (double.parse(widget.data.split('^')[5]) != debt && debt == 0) {
                                              ttlDebts = 1;
                                            } else {
                                              ttlDebts = 0;
                                            }

                                            if (debt == 0) {
                                              deFilter = false;
                                            } else {
                                              deFilter = true;
                                            }

                                            if(widget.data.split('^')[4] == 'F') {
                                              totalRefunds = 1;
                                            } else {
                                              totalRefunds = 0;
                                            }

                                            if (double.parse(widget.data.split('^')[2]) != total) {
                                              chgTotal = double.parse(widget.data.split('^')[2]) - total;
                                            } else {
                                              chgTotal = 0;
                                            }

                                            var refundId = '';

                                            batch = await updateRefund(batch, widget.data.split('^')[3].split('&')[1], totalRefunds, ttlDebts, chgDebts);


                                            CollectionReference monthlyData = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly');

                                            monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse( widget.data.split('^')[0].substring(0,4) + '-' +  widget.data.split('^')[0].substring(4,6) + '-' + '01' + ' 00:00:00'))
                                                .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse( widget.data.split('^')[0].substring(0,4) + '-' +  widget.data.split('^')[0].substring(4,6) + '-' + '31' + ' 23:59:59'))
                                                .get()
                                                .then((QuerySnapshot querySnapshot)  async {
                                              querySnapshot.docs.forEach((doc) {
                                                refundId = doc.id;
                                              });
                                              batch = await updateMonthlyData1(batch, refundId,  widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'cash_merc', widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'debt_merc', chgTotal, chgDebts);
                                              // monthlyData.doc(refundId).update({
                                              //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'cash_merc' : FieldValue.increment(0 - double.parse(chgTotal.toString())),
                                              //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'debt_merc' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                              //
                                              // }).then((value) => print("data Updated"))
                                              //     .catchError((error) => print("Failed to update user: $error"));



                                              monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '01' + ' 00:00:00'))
                                                  .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '31' + ' 23:59:59'))
                                                  .get()
                                                  .then((QuerySnapshot querySnapshot)  async {
                                                querySnapshot.docs.forEach((doc) {
                                                  monthExist = true;
                                                  monthId = doc.id;
                                                });
                                                print('month ' + monthExist.toString());
                                                if (monthExist) {
                                                  batch = await updateMonthlyData2(batch, monthId, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc', chgTotal);
                                                  // monthlyData.doc(monthId).update({
                                                  //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc' : FieldValue.increment(chgTotal),
                                                  //
                                                  // }).then((value) => print("data Updated"))
                                                  //     .catchError((error) => print("Failed to update user: $error"));
                                                }
                                                else {
                                                  monthlyData.add({
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                                    for(int j = 1; j<= 31; j++)
                                                      now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_merc' : 0,

                                                    'date': now,

                                                  }).then((value) async {
                                                    // print('valueid' + value.id.toString());
                                                    batch = await updateMonthlyData2(batch, value.id, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc', chgTotal);
                                                    // monthlyData.doc(value.id).update({
                                                    //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'refu_merc' : FieldValue.increment(chgTotal),
                                                    // }).then((value) => print("Data Updated"))
                                                    //     .catchError((error) => print("Failed to update user: $error"));
                                                  }).catchError((error) => print("Failed to update user: $error"));
                                                }


                                                CollectionReference yearlyData = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly');
                                                var refundYearId = '';

                                                yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0,4) + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                                    .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0,4) + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                                    .get()
                                                    .then((QuerySnapshot querySnapshot)  async {
                                                  querySnapshot.docs.forEach((doc) {
                                                    refundYearId = doc.id;
                                                  });
                                                  batch = await updateYearlyData1(batch, refundYearId, widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'cash_merc', widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'debt_merc', chgTotal, chgDebts);
                                                  // yearlyData.doc(refundYearId).update({
                                                  //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'cash_merc' : FieldValue.increment(0 - double.parse(chgTotal.toString())),
                                                  //   widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'debt_merc' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                                  //
                                                  // }).then((value) => print("data Updated"))
                                                  //     .catchError((error) => print("Failed to update user: $error"));

                                                  yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                                      .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                                      .get()
                                                      .then((QuerySnapshot querySnapshot)  async {
                                                    querySnapshot.docs.forEach((doc) {
                                                      yearExist = true;
                                                      yearId = doc.id;
                                                    });
                                                    print('year ' + yearExist.toString());
                                                    if (yearExist) {
                                                      batch = await updateYearlyData2(batch, yearId, now.year.toString() +  zeroToTen(now.month.toString())  + 'refu_merc', chgTotal);
                                                      // yearlyData.doc(yearId).update({
                                                      //   now.year.toString() +  zeroToTen(now.month.toString())  + 'refu_merc' : FieldValue.increment(chgTotal),
                                                      //
                                                      // }).then((value) => print("data Updated"))
                                                      //     .catchError((error) => print("Failed to update user: $error"));
                                                    }
                                                    else {
                                                      yearlyData.add({
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString()  + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString()  + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString() + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString() + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString() + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString() + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                                        for(int j = 1; j<= 12; j++)
                                                          now.year.toString() + zeroToTen(j.toString()) + 'refu_merc' : 0,

                                                        'date': now,

                                                      }).then((value12) async {
                                                        batch = await updateYearlyData2(batch, value12.id,  now.year.toString() +  zeroToTen(now.month.toString()) + 'refu_merc', chgTotal);
                                                        // yearlyData.doc(value12.id).update({
                                                        //   now.year.toString() +  zeroToTen(now.month.toString()) + 'refu_merc' : FieldValue.increment(chgTotal),
                                                        // }).then((value) => print("Data Updated"))
                                                        //     .catchError((error) => print("Failed to update user: $error"));
                                                      }).catchError((error) => print("Failed to update user: $error"));
                                                    }


                                                    String data = widget.data;

                                                    String noCustomer = '';
                                                    if(data.split('^')[3].split('&')[0] == 'No merchant') {
                                                      noCustomer = 'name';
                                                    } else {noCustomer = data.split('^')[3].split('&')[0];}

                                                    String dataRm = data.split('^')[0] +
                                                        '^' +
                                                        data.split('^')[1] +
                                                        '^' +
                                                        data.split('^')[2] +
                                                        '^' +
                                                        data.split('^')[3].split('&')[1] + '<>' + noCustomer  +
                                                        '^' +
                                                        data.split('^')[4] + '^' + data.split('^')[5] + '^' + data.split('^')[6];

                                                    data = data.split('^')[0] +
                                                        '^' +
                                                        data.split('^')[1] +
                                                        '^' +
                                                        total.toString() +
                                                        '^' +
                                                        data.split('^')[3].split('&')[1] + '<>' + noCustomer  +
                                                        '^' +
                                                        refundAmount + '^' + debt.toString() + '^' + data.split('^')[6];

                                                    print('result___ ' + data + dataRm);

                                                    CollectionReference dOrder = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder');
                                                    CollectionReference cusRefund = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants');
                                                    CollectionReference dailyOrders = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders');

                                                    batch = await updateDailyOrder(batch, widget.documentId, dataRm, data);

                                                    // dailyOrders.doc(widget.documentId).update({
                                                    //   'daily_order':
                                                    //   FieldValue.arrayRemove([dataRm])
                                                    // }).then((value) {print('array removed');})
                                                    //     .catchError((error) => print("Failed to update user: $error"));
                                                    //
                                                    // dailyOrders.doc(widget.documentId).update({
                                                    //   'daily_order':
                                                    //   FieldValue.arrayUnion([data])
                                                    // }).then((value) { print('array updated');})
                                                    //     .catchError((error) => print("Failed to update user: $error"));

                                                    batch = await updateOrderDetail(batch, widget.docId, prodList, total, refundAmount, debt, reFilter, deFilter);
                                                    // dOrder.doc(widget.docId).update({
                                                    //   'subs': prodList,
                                                    //   'total': total.toString(),
                                                    //   'refund' : refundAmount,
                                                    //   'debt' : debt,
                                                    //   'refund_filter' : reFilter,
                                                    //   'debt_filter' : deFilter,
                                                    // }).then((value) { print('detail updated');})
                                                    //     .catchError((error) => print("Failed to update user: $error"));

                                                    // cusRefund.doc(widget.data.split('^')[3].split('&')[1]).update({
                                                    //   'total_refunds' : FieldValue.increment(double.parse(totalRefunds.toString())),
                                                    //   'debts' : FieldValue.increment(0 - double.parse(ttlDebts.toString())),
                                                    //   'debtAmount' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                                    // }).then((value) {
                                                    //   print('merchant updated');
                                                    // }).catchError((error) => print("Failed to update user: $error"));
                                                    batch.commit();

                                                  });});});});

                                            setState(() {
                                              loadingState = false;
                                              disableTouch = false;
                                            });

                                            Navigator.of(context).popUntil((route) => route.isFirst);
                                            smartKyatFlash(currencyUnit + totalRefund().toString() + 'is successfully refunded to #' + widget.data.split('^')[1].toString(), 's');
                                          },
                                          child:  loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                              child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 2.0),
                                            child: Container(
                                              child: Text(
                                                textSetRefundBtn,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
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
                              ],
                            ),
                          );
                        }
                        return Expanded(child: Container());
                      }),
                Container(
                  color: Colors.white,
                  // height: MediaQuery.of(context).viewInsets.bottom,
                  // height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                  height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                ),
              ]
          ),
        ),
      ),
    );
  }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(priContext).padding.top,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              color: Colors.white.withOpacity(0.5)),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            color: Colors.white,
                          ),

                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(
                                        "New Expense",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'capsulesans',
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context, changedPrice);
                                          print('clicked');
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.yellow,
                    height: 100,
                  ),
                )
              ],
            ),
          );
        });
  }

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  totalItems() {
    double totalItems = 0;
    for(int i=0; i<refundItems.length; i++) {
      totalItems += refundItems[i];
    }
    return totalItems;
  }

  totalRefund() {
    double totalM = 0.0;
    double debtM = 0.0;
    double refundAmount = 0.0;
    totalM = double.parse(widget.data.split('^')[2]) - totalPriceView();
    debtM = double.parse(widget.data.split('^')[2]) -  double.parse(widget.data.split('^')[5]);
    if(debtM > totalM) {
      refundAmount = debtM - totalM;
    } else refundAmount = 0.0;
    return refundAmount;
  }

  totalPriceView() {
    double totalPrice = 0.0;
    for(int i=0; i<refundItems.length; i++) {
      totalPrice += refundItems[i] * double.parse(prodListView[i].split('-')[4]);
    }

    // widget.data.split('^')[6].split('-')[1] == 'p' ?
    if(widget.data.split('^')[6] != '0.0') {
      if(widget.data.split('^')[6].split('-')[1] == 'p') {
        totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
      } else {
        totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0])/widget.realPrice));
      }
    }

    return totalPrice;
  }

  changeUnitName2Stock(String split) {
    if(split == 'unit_name') {
      return 'inStock1';
    } else {
      return 'inStock' + (int.parse(split[3]) + 1).toString();
    }
  }

  updateProduct(WriteBatch batch, id, unit, num) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops')
        .doc(widget.shopId).collection('products').doc(id);
    batch.update(documentReference, {changeUnitName2Stock(unit): FieldValue.increment(0 - double.parse(num.toString())),});
    return batch;
  }

  updateMonthlyData1(WriteBatch batch, id, field1, field2, double price1, double price2) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse((0 - price1).toString())),
      field2 : FieldValue.increment(double.parse((0 - price2).toString())),

    });
    return batch;
  }

  updateMonthlyData2(WriteBatch batch, id, field1, double price1) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse(price1.toString())),

    });
    return batch;
  }

  updateYearlyData1(WriteBatch batch, id, field1, field2, double price1, double price2) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse((0 - price1).toString())),
      field2 : FieldValue.increment(double.parse((0 - price2).toString())),
    });
    return batch;
  }

  updateYearlyData2(WriteBatch batch, id, field1, double price1) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse(price1.toString())),
    });
    return batch;
  }

  updateDailyOrder(WriteBatch batch, id, orgData, updateData) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders').doc(id);

    batch.update(documentReference, {
      'daily_order' :  FieldValue.arrayRemove([orgData]),
    });

    batch.update(documentReference, {
      'daily_order': FieldValue.arrayUnion([updateData])
    });
    return batch;
  }

  updateOrderDetail(WriteBatch batch, id,  lists, total, refAmt, debt, reF, deF) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').doc(id);
    print('updateDetail '+ id.toString() + lists.toString() + total.toString() + debt.toString() + deF.toString());
    batch.update(documentReference, {
      'subs': lists,
      'total': total.toString(),
      'refund' : refAmt,
      'debt' : debt,
      'refund_filter' : reF,
      'debt_filter' : deF,
    });
    return batch;
  }

  updateRefund(WriteBatch batch, id, totalRefs,  totalDes, changeDes) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants').doc(id);

    batch.update(documentReference, {
      'total_refunds' : FieldValue.increment(double.parse(totalRefs.toString())),
      'debts' : FieldValue.increment(0 - double.parse(totalDes.toString())),
      'debtAmount' : FieldValue.increment(0 - double.parse(changeDes.toString())),
    });
    return batch;
  }

  String subItemsOff(String split) {
    if(split == 'unit_name') {
      return 'main';
    } else if(split == 'sub1_name') {
      return 'sub1';
    } else {
      return 'sub2';
    }
  }

}
