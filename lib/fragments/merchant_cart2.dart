import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';

import '../app_theme.dart';

class MerchantCart extends StatefulWidget {
  final clearProd;
  final clearMerch;
  final merchCartLoadingState;
  final endMerchCartLoadingState;
  final remProdListIndFun;

  MerchantCart(
      {Key? key, required this.isEnglish,
        required void toggleCoinCallback3(), required void toggleCoinCallback4(), required void toggleCoinCallback(), required this.prodList2, required this.merchantId, required this.shop,
        required this.deviceId,
        required void toggleCoinCallback2(),
        required void remProdListInd(int index)
      }): clearProd = toggleCoinCallback,
        clearMerch = toggleCoinCallback2,
        merchCartLoadingState = toggleCoinCallback3,
        endMerchCartLoadingState = toggleCoinCallback4,
        remProdListIndFun = remProdListInd;

  final String shop;
  final String deviceId;
  final List<String> prodList2;
  final String merchantId;
  final bool isEnglish;

  @override
  MerchantCartState createState() => MerchantCartState();
}
class MerchantCartState extends State<MerchantCart>
    with TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MerchantCart> {
  @override
  bool get wantKeepAlive => true;

  var deviceIdNum;
  String? shopId;
  final _formKey = GlobalKey<FormState>();
  bool merchCartCreating = false;
  bool disableTouch = false;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  String currencyUnit = 'MMK';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  calHourFromTZ(DateTime dateTime) {

    return dateTime.timeZoneOffset.inMinutes;
  }

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[1-9]+[0-9]*';


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


  String textSetMerchOrders = 'Merchant cart';
  String textSetClearCart = 'Clear cart';
  String textSetDiscount = 'Discount';
  String textSetNoMerchant = 'No merchant';
  String textSetTotalSale = 'Total sale';
  String textSetCheckout = 'Checkout';
  String textSetAmountApplied = 'Amount applied';
  String textSetPercent = 'Percentage';
  String textSetCashAccept = 'Cash acceptance';
  String textSetCashRev = 'CASH RECEIVED';
  String textSetCustom = 'Custom amount';
  String textSetDebt = 'Unpaid amount';
  String textSetRefund = 'Cash refund';
  String textSetDone = 'Done';
  String textSetTSale = 'Total Buy';


  @override
  initState() {
    merchId = widget.merchantId.split('^')[1];
    merchRealId = widget.merchantId.split('^')[0];
    debugPrint('initializing ' + widget.prodList2.toString());

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

      if(widget.isEnglish == true) {

        setState(() {
          textSetMerchOrders = 'Merchant order cart';
          textSetClearCart = 'Clear cart';
          textSetDiscount = 'Discount';
          textSetNoMerchant = 'No merchant';
          textSetTotalSale = 'Total buy';
          textSetCheckout = 'Checkout';
          textSetAmountApplied = 'Amount applied';
          textSetPercent = 'Percentage';
          textSetCashAccept = 'Purchase from merchant';
          textSetCashRev = 'CASH TO MERCHANT';
          textSetCustom = 'Offered price';
          textSetDebt = 'Unpaid amount';
          textSetRefund = 'Take refunds';
          textSetDone = 'Done';
          textSetTSale = 'Total buy';
        });
      }
      else {
        setState(() {
          textSetMerchOrders = 'ကုန်သည်ထံမှ အ၀ယ်စာရင်း';
          textSetClearCart = 'ပယ်ဖျက်ရန်';
          textSetDiscount = 'လျှော့ငွေ';
          textSetNoMerchant = 'ဝယ်ယူသူမရွေးရသေးပါ';
          textSetTotalSale = 'စုစုပေါင်းကျသင့်ငွေ';
          textSetCheckout = 'ဝယ်မည်';
          textSetAmountApplied = 'Amount applied';
          textSetPercent = 'Percentage';
          textSetCashAccept = 'ကုန်သည်ဆီသို့ ငွေပေးချေရန်';
          textSetCashRev = 'CASH TO MERCHANT';
          textSetCustom ='မိမိပေးလိုက်သောငွေ';
          textSetDebt = 'ကျန်ငွေ';
          textSetRefund = 'ပြန်အမ်း ရယူရန်';
          textSetDone = 'ငွေရှင်းမည်';
          textSetTSale = 'စုစုပေါင်း';
        });
      }
    deviceIdNum = widget.deviceId;
    shopId = widget.shop;
    super.initState();
  }
  @override
  void dispose() {
    // _textFieldController2.dispose();
    // myController.dispose();
    // buyPriceController.dispose();
    super.dispose();
  }



  List<String> subList2 = [];
  double paidAmount2 = 0;
  double refund2 = 0;
  double debt2 = 0;
  double quantity2 = 0;
  double price2 = 0;

  double discount2 = 0.0;
  double discountAmount2 = 0.0;
  String disText2 = '';
  String isDiscount2 = '';
  double totalAmount2 = 0.0;
  var mainLoss = 0;
  var sub1Loss=0;
  var sub2Loss = 0;
  String eachProd = '';
  String productName = '';
  String salePrice = '';
  String barcode = '';
  String mainName = '';
  String sub1Name = '';
  String sub2Name = '';
  String unit = '';
  String name ='';
  var mainQty= 0;
  var sub1Qty = 0;
  var sub2Qty = 0;
  String buy1 = '';
  String buy2 = '';
  String buy3 = '';
  int disPercent2 =0;
  String merchId = 'name';
  String merchRealId = 'name';
  String productId = '';
  String productLink = '';

  TextEditingController myController = TextEditingController();
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

  prodInCart(String prodListInd, int index) {
    widget.prodList2[index] = widget.prodList2[index].split('^')[0] + '^' + widget.prodList2[index].split('^')[1] + '^' +
        widget.prodList2[index].split('^')[2] + '^' + widget.prodList2[index].split('^')[3] + '^' + widget.prodList2[index].split('^')[4] + '^' + widget.prodList2[index].split('^')[5] + '^' + widget.prodList2[index].split('^')[6] + '^' + widget.prodList2[index].split('^')[7] + '^' + widget.prodList2[index].split('^')[8] +'^' + widget.prodList2[index].split('^')[9] +'^' + widget.prodList2[index].split('^')[10] +'^' + widget.prodList2[index].split('^')[11] +'^' + widget.prodList2[index].split('^')[12];

    debugPrint('prodincart ' + widget.prodList2.toString());
    String image = widget.prodList2[index].split('^')[9];
    prodListInd = prodListInd.split('^')[0] + '^' + widget.prodList2[index].split('^')[3] + '^' +
        prodListInd.split('^')[1] + '^' + prodListInd.split('^')[4] + '^' + prodListInd.split('^')[2] + '^' + prodListInd.split('^')[6];
    return GestureDetector(
      onTap: (){
        debugPrint('error prod' + prodListInd.toString());
        setState((){
            quantity2 = double.parse(prodListInd.split('^')[4]);
            price2 = double.parse(prodListInd.split('^')[2]);
            eachProd = prodListInd;
            unit = prodListInd.split('^')[3];
            salePrice = prodListInd.split('^')[2];
            productId = widget.prodList2[index].split('^')[0];
            productName = widget.prodList2[index].split('^')[7];
            myController.text = double.parse(prodListInd.split('^')[4]).round().toString();
            buyPriceController.text = prodListInd.split('^')[2];
            // sellDone = false;
          });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => fixItems()
          ),
        );
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   setState(() {
        //     myState((){
        //       saleLoadingState = false;
        //     });
        //
        //   });
        // });
      },
      child: Slidable(
        key: UniqueKey(),
        actionPane:
        SlidableDrawerActionPane(),
        actionExtentRatio:
        0.25,
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
                          'https://smartkyatpos.com/api/uploads/' +
                              image,
                          width: 58,
                          height: 58,
                          // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                          errorWidget: (context, url, error) => Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,),
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 10),
                          fadeInCurve: Curves.bounceIn,
                          fit: BoxFit.cover,) : Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,)),
                    title: Tooltip(
                      message: widget.prodList2[index].split('^')[7],
                      // preferOri: PreferOrientation.up,
                      // isShow: false,
                      child: Text(
                        widget.prodList2[index].split('^')[7], textScaleFactor: 1,
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
                          if (widget.prodList2[index].split('^')[4] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                          else if(widget.prodList2[index].split('^')[4] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                          else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                          Text(' ' + widget.prodList2[index].split('^')[8] + ' ', textScaleFactor: 1, style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                          )),
                        ],
                      ),
                    ),
                    trailing: Text('$currencyUnit ' + (double.parse(
                        prodListInd.split('^')[
                        2]) *
                        double.parse( prodListInd.split('^')[
                        4]))
                        .toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                      textScaleFactor: 1, style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(height: 12,
                      decoration: BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                          )),),
                  ),
                ],
              ),
            ),
            Positioned(
              top : 11,
              right: MediaQuery.of(context).size.width - 80,
              child: Container(
                // height: 20,
                // width: 30,
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.5, right: 8.5, top: 1, bottom: 1),
                  child: Text(double.parse(prodListInd.split('^')[4]).round().toString(),textScaleFactor: 1, style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500
                  )),
                ),
              ),
            ),
          ],
        ),
        dismissal:
        SlidableDismissal(
          child:
          SlidableDrawerDismissal(),
          onDismissed:
              (actionType) {
             setState((){
              widget.prodList2.removeAt(index);
              if(discount2 > double.parse(TtlProdListPriceInit2())) {
                discount2 = 0;
              }
            });
          },
        ),
        secondaryActions: <
            Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon:
            Icons.delete,
            onTap: () {
              setState((){
                widget.prodList2.removeAt(index);
                if(discount2 > double.parse(TtlProdListPriceInit2())) {
                  discount2 = 0;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: 80,
                      child:
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    (merchId=='name'? (widget.isEnglish? 'Walk-in merchant': 'အမည်မသိ ကုန်သည်'): merchId),
                                    textScaleFactor: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.4,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(textSetMerchOrders, textScaleFactor: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.7,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15,),
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                width: 37,
                                height: 37,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                    color: Colors.grey.withOpacity(0.3)
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 23,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);

                                  })
                            ],
                          ),
                        ],
                      ),

                    ),
                  ),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1.0))),
                  ),
                ],
              ),
              StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('shops')
                      .doc(shopId)
                      .collection('merchants')
                      .doc(merchRealId.toString())
                      .snapshots(),
                  builder: (BuildContext context, snapshot5) {
                    if(snapshot5.hasData) {
                      var output3 = snapshot5.data!.data();
                      var address = output3?['merchant_address'];
                      return Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                    (MediaQuery.of(context)
                                        .size
                                        .width /
                                        2) -
                                        22.5,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(10.0),
                                        color: AppTheme.clearColor),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 15.0,
                                          bottom: 15.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState((){
                                            widget.clearProd();
                                            discount2 = 0.0;
                                            discountAmount2 = 0.0;
                                            debt2 =0;
                                            refund2 =0;
                                            widget.clearMerch();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              left:
                                              8.0,
                                              right:
                                              8.0,
                                              bottom:
                                              3.0),
                                          child: Container(
                                              child: Text(
                                                textSetClearCart, textScaleFactor: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  // height: 1.3,
                                                    fontSize: 17.5,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                ),
                                                strutStyle: StrutStyle(
                                                  height: 1.22,
                                                  forceStrutHeight: true,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context)
                                        .size
                                        .width /
                                        2) -
                                        22.5,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            10.0),
                                        color: AppTheme.buttonColor2),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 15.0,
                                          bottom: 15.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if(discount2 > 0) {
                                            final resultNew =
                                            Platform.isIOS ?
                                            await showModalActionSheet<String>(
                                              context: context,
                                              //title: 'Confirmation alert',
                                              title: 'Are you sure you want to change discount?',
                                              actions: [
                                                SheetAction(
                                                  label: 'New discount',
                                                  key: 'newdis',
                                                  isDestructiveAction: true,
                                                ),
                                              ],
                                            ) : await showModalActionSheet<String>(
                                              context: context,
                                              // title: 'Confirmation alert',
                                              title: 'Are you sure you want to change discount?',
                                              actions: [
                                                SheetAction(
                                                  label: 'New discount',
                                                  key: 'newdis',
                                                  isDestructiveAction: true,
                                                ),
                                              ],
                                            );
                                            if(resultNew.toString() == 'newdis') {
                                              setState(() {
                                                  discountAmount2 = 0.0;
                                                  discount2 = 0.0;
                                              });

                                              final result = await showModalActionSheet<String>(
                                                context: context,
                                                title: widget.isEnglish? 'Choose discount type': 'စျေးလျှော့ရန် အမျိုးအစားရွေးပါ',
                                                actions: [
                                                  SheetAction(
                                                    icon: SmartKyat_POS.dis_amount,
                                                    label: widget.isEnglish? 'Amount': 'ပမာဏ',
                                                    key: 'amount',
                                                  ),
                                                  SheetAction(
                                                    icon: SmartKyat_POS.dis_percent,
                                                    label: widget.isEnglish? 'Percent': 'ရာခိုင်နှုန်း',
                                                    key: 'percent',
                                                  ),
                                                ],
                                              );

                                              if(result != null) {
                                                setState(() {
                                                  isDiscount2 = result.toString();
                                                });

                                                if (result == 'amount') {
                                                  final amount = await showTextInputDialog(
                                                    context: context,
                                                    textFields: [
                                                      DialogTextField(
                                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                        // inputFormatters: <TextInputFormatter>[
                                                        //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                        hintText: '0',
                                                        suffixText: '$currencyUnit  ',
                                                        validator: (value) {
                                                          if(!isNumeric(value)) {
                                                            return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                          } else if (value == null || value.isEmpty) {
                                                            // return '';
                                                            return 'this field is required ';
                                                          } else {
                                                            if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                              return widget.isEnglish? 'no item in cart': 'ဝယ်စာရင်းတွင် ပစ္စည်းမရှိပါ';
                                                            } else if(double.parse(value) > double.parse(TtlProdListPriceInit2())) {
                                                              return widget.isEnglish? 'much less than total sale': 'စုစုပေါင်းစျေးထက် မများရပါ';
                                                            } else if(double.parse(value) < 0) {
                                                              return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                        // initialText: 'mono0926@gmail.com',
                                                      ),
                                                    ],
                                                    title: widget.isEnglish? 'Discount': 'လျှော့ငွေ',
                                                    message: widget.isEnglish? 'Add Discount Amount to Cart': 'လျှော့ငွေ ရာခိုင်နှုန်းထည့်ပါ',
                                                  );
                                                  setState(() {
                                                    discount2 =double.parse(amount![0].toString());
                                                  });

                                                } else if(result == 'percent') {
                                                  final percentage = await showTextInputDialog(
                                                    context: context,
                                                    textFields: [
                                                      DialogTextField(
                                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                        // inputFormatters: <TextInputFormatter>[
                                                        //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                        hintText: '0',
                                                        suffixText: '%  ',
                                                        validator: (value) {
                                                          if(!isNumeric(value)) {
                                                            return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                          } else if (value == null || value.isEmpty) {
                                                            // return '';
                                                            return 'this field is required ';
                                                          } else {
                                                            if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                              return widget.isEnglish? 'no item in cart': 'ဝယ်စာရင်းတွင် ပစ္စည်းမရှိပါ';
                                                            }
                                                            if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                              return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                        // initialText: 'mono0926@gmail.com',
                                                      ),
                                                    ],
                                                    title: widget.isEnglish? 'Discount': 'လျှော့ငွေ',
                                                    message: widget.isEnglish? 'Add discount percent to cart': 'လျှော့ငွေ ရာခိုင်နှုန်းထည့်ပါ',
                                                  );
                                                  setState(() {
                                                    discount2 =double.parse(percentage![0].toString());
                                                  });
                                                }
                                                debugPrint('dis' + result.toString());
                                                setState(() {
                                                  debugPrint('do something');
                                                });
                                              }
                                            }


                                          } else {
                                            final result = await showModalActionSheet<String>(
                                              context: context,
                                              title: widget.isEnglish? 'Choose discount type': 'စျေးလျှော့ရန် အမျိုးအစားရွေးပါ',
                                              actions: [
                                                SheetAction(
                                                  icon: SmartKyat_POS.dis_amount,
                                                  label: widget.isEnglish? 'Amount': 'ပမာဏ',
                                                  key: 'amount',
                                                ),
                                                SheetAction(
                                                  icon: SmartKyat_POS.dis_percent,
                                                  label: widget.isEnglish? 'Percent': 'ရာခိုင်နှုန်း',
                                                  key: 'percent',
                                                ),
                                              ],
                                            );

                                            if(result != null) {
                                              setState(() {
                                                isDiscount2 = result.toString();
                                              });

                                              if (result == 'amount') {
                                                final amount = await showTextInputDialog(
                                                  context: context,
                                                  textFields: [
                                                    DialogTextField(
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                      // inputFormatters: <TextInputFormatter>[
                                                      //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                      hintText: '0',
                                                      suffixText: '$currencyUnit  ',
                                                      validator: (value) {
                                                        if(!isNumeric(value)) {
                                                          return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                        } else if (value == null || value.isEmpty) {
                                                          // return '';
                                                          return 'this field is required ';
                                                        } else {
                                                          if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                            return widget.isEnglish? 'no item in cart': 'ဝယ်စာရင်းတွင် ပစ္စည်းမရှိပါ';
                                                          } else if(double.parse(value) > double.parse(TtlProdListPriceInit2())) {
                                                            return widget.isEnglish? 'much less than total sale': 'စုစုပေါင်းစျေးထက် မများရပါ';
                                                          } else if(double.parse(value) < 0) {
                                                            return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                          }
                                                        }
                                                        return null;
                                                      },
                                                      // initialText: 'mono0926@gmail.com',
                                                    ),
                                                  ],
                                                  title: widget.isEnglish? 'Discount': 'လျှော့ငွေ',
                                                  message: widget.isEnglish? 'Add Discount Amount to Cart': 'လျှော့ငွေ ရာခိုင်နှုန်းထည့်ပါ',
                                                );
                                                setState(() {
                                                  discount2 =double.parse(amount![0].toString());
                                                });

                                              } else if(result == 'percent') {
                                                final percentage = await showTextInputDialog(
                                                  context: context,
                                                  textFields: [
                                                    DialogTextField(
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                      // inputFormatters: <TextInputFormatter>[
                                                      //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                      hintText: '0',
                                                      suffixText: '%  ',
                                                      validator: (value) {
                                                        if(!isNumeric(value)) {
                                                          return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                        } else if (value == null || value.isEmpty) {
                                                          // return '';
                                                          return 'this field is required ';
                                                        } else {
                                                          if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                            return widget.isEnglish? 'no item in cart': 'ဝယ်စာရင်းတွင် ပစ္စည်းမရှိပါ';
                                                          }
                                                          if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                            return widget.isEnglish? 'invalid amount': 'မှားယွင်းနေပါသည်';
                                                          }
                                                        }
                                                        return null;
                                                      },
                                                      // initialText: 'mono0926@gmail.com',
                                                    ),
                                                  ],
                                                  title: widget.isEnglish? 'Discount': 'လျှော့ငွေ',
                                                  message: widget.isEnglish? 'Add discount percent to cart': 'လျှော့ငွေ ရာခိုင်နှုန်းထည့်ပါ',
                                                );
                                                setState(() {
                                                  discount2 =double.parse(percentage![0].toString());
                                                });
                                              }
                                              debugPrint('dis' + result.toString());
                                              setState(() {
                                                debugPrint('do something');
                                              });
                                            }
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              left: 8.0,
                                              right:
                                              8.0,
                                              bottom:
                                              3.0),
                                          child: Container(
                                              child: Text(
                                                textSetDiscount,textScaleFactor: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  // height: 1.3,
                                                    fontSize: 17.5,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                ),
                                                strutStyle: StrutStyle(
                                                  height: 1.22,
                                                  forceStrutHeight: true,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(top: 19.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // setState(() {
                                          //   customerId = 'name^name';
                                          // });
                                          setState((){
                                            merchId = 'name';
                                            merchRealId = 'name';
                                          });
                                          widget.clearMerch();
                                          // Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 1),
                                              Container(
                                                height: 58,
                                                width: 58,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5.0),
                                                    color: AppTheme.buttonColor2
                                                ),
                                                child: Icon(
                                                  SmartKyat_POS.merchant,
                                                  size: 25,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Text(
                                                  (merchId=='name'? (widget.isEnglish? 'Walk-in merchant': 'အမည်မသိ ကုန်သည်'): merchId),
                                                  textScaleFactor: 1, style: TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Container(height: 12,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                bottom:
                                                BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                              )),),
                                      ),

                                    ],
                                  ),
                                ),
                                merchId != 'name' ? Positioned(
                                  top : 11,
                                  left: 53,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState((){
                                        merchId = 'name';
                                        merchRealId = 'name';
                                      });
                                      widget.clearMerch();
                                    },
                                    child: Container(
                                      // height: 20,
                                      // width: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(0xffE9625E),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10.0),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 1, bottom: 1),
                                        child: Icon(
                                          Icons.close_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ): Container(),
                              ],
                            ),
                            for (int i = 0;
                            i < widget.prodList2.length;
                            i++)
                              prodInCart(widget.prodList2[i], i),
                            Slidable(
                              key: UniqueKey(),
                              actionPane:
                              SlidableDrawerActionPane(),
                              actionExtentRatio:
                              0.25,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    discount2 != 0.0 ? Container(
                                      child: isDiscount2 == 'percent' ?
                                      ListTile(
                                        title: Text(textSetDiscount, textScaleFactor: 1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        subtitle: Text('$textSetPercent (' +  discountAmount2.toString() + '%)',textScaleFactor: 1, style: TextStyle(
                                          fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                        )),
                                        trailing: Text('- $currencyUnit ' + (double.parse(TtlProdListPriceInit2()) - double.parse(TtlProdListPrice2())).toString(), textScaleFactor: 1,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                      ) :  ListTile (
                                        title: Text(textSetDiscount, textScaleFactor: 1,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        subtitle: Text(textSetAmountApplied, textScaleFactor: 1, style: TextStyle(
                                          fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                        )),
                                        trailing: Text('- $currencyUnit ' + discount2.toString(),textScaleFactor: 1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                              ),
                              dismissal:
                              SlidableDismissal(
                                child: SlidableDrawerDismissal(),
                                onDismissed:
                                    (actionType) {
                                  setState(() {
                                    discountAmount2 = 0.0;
                                    discount2 = 0.0;
                                  });
                                },
                              ),
                              secondaryActions: <
                                  Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon:
                                  Icons.delete,
                                  onTap: () =>
                                      setState(() {
                                        discountAmount2 = 0.0;
                                        discount2 =0.0;
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                          child: CupertinoActivityIndicator(radius: 15,)),
                    );
                  }
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                            color:
                            AppTheme.skBorderColor2,
                            width: 1.0),
                      )),
                  width: double.infinity,
                  height: 142,
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          textSetTotalSale, textScaleFactor: 1, maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                              fontSize: 17,
                              fontWeight:
                              FontWeight
                                  .w500),
                        ),
                        subtitle: int.parse(totalItems2()) == 1? Text(totalItems2() + ' item set', textScaleFactor: 1, maxLines: 1,
                            style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, overflow: TextOverflow.ellipsis,
                            )) : Text(totalItems2() + ' item sets', textScaleFactor: 1, maxLines: 1,
                            style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, overflow: TextOverflow.ellipsis,
                            )),
                        trailing: Text('$currencyUnit '+
                            TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                          textScaleFactor: 1, style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight
                                  .w500),
                        ),
                      ),
                      widget.prodList2.length != 0 ?
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                totalAmount2 = double.parse(TtlProdListPrice2());
                              });

                              debugPrint('totalAmount '+ totalAmount2.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => checkoutItems()
                                ),
                              );
                              if(_textFieldController2.text == '') { debt2 = double.parse(TtlProdListPrice2().toString());}
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  color: AppTheme.themeColor),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                        child: Container(
                                            child: Text(
                                              textSetCheckout, textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                 // height: 1.3,
                                                  fontSize: 17.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                              ),
                                              strutStyle: StrutStyle(
                                                height: 1.22,
                                                forceStrutHeight: true,
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) :
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('no products to refill');
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  color: AppTheme.themeColor),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                        child: Container(
                                            child: Text(
                                              textSetCheckout, textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                // height: 1.3,
                                                  fontSize: 17.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                              ),
                                              strutStyle: StrutStyle(
                                                height: 1.22,
                                                forceStrutHeight: true,
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  totalItems2() {
    int total = 0;
    for (String str in widget.prodList2) {
      total ++;
    }
    return total.toString();
  }

  TtlProdListPriceInit2()  {
    double total = 0;
    debugPrint('myanmar' + widget.prodList2.toString());
    for (String str in widget.prodList2) {
      total += double.parse(str.split('^')[1]) * int.parse(str.split('^')[2]);
    }
    return total.toString();
  }

  TtlProdListPrice2()  {
    double total = 0;
    debugPrint(widget.prodList2.toString());
    for (String str in widget.prodList2) {
      total += double.parse(str.split('^')[1]) * double.parse(str.split('^')[2]);
      disPercent2 = (double.parse(total.toString()) *
          (discountAmount2 / 100)).round();
    }
    if(isDiscount2 == 'percent'){
      discountAmount2 = discount2;
      debugPrint(discountAmount2.toString());
      disText2 = '-p';
      total = (double.parse(total.toString()) -
          (double.parse(total.toString()) *
              (discountAmount2 / 100)));
    } else if(isDiscount2 == 'amount'){
      discountAmount2 = discount2;
      disText2 ='-d';
      total = (double.parse(total.toString()) - discountAmount2);
    } else {
      disText2 = '';
      discountAmount2 = 0.0;
      total = double.parse(total.toString());
    }
    return total.toString();
  }

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  DatenotExist(WriteBatch batch, dOrder, date, length) async {
    CollectionReference daily = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders');

    String customId = date.year.toString() + zeroToTen(date.month.toString()) + zeroToTen(date.day.toString());
    // String ttlProdListPriceFut = await TtlProdListPriceFut();
    batch.set(
        daily.doc(customId), {
      'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
      // 'date' : date
      'date' : (DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.year.toString() + '-' + zeroToTen(date.month.toString()) + '-' + zeroToTen(date.day.toString()) + ' ' + zeroToTen(date.hour.toString()) + ':' + zeroToTen(date.minute.toString()) + ':' + zeroToTen(date.second.toString()))),
    },SetOptions(merge: true));
    DocumentReference nonceRef = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('nonce_doc').collection('nonce_col').doc();
    batch.set(nonceRef, {
      'time': FieldValue.serverTimestamp(),
    });
    return batch;
  }

  // Future<void> DatenotExist(dOrder, date, length) async {
  //   CollectionReference daily = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders');
  //
  //   String customId = date.year.toString() + zeroToTen(date.month.toString()) + zeroToTen(date.day.toString());
  //
  //   daily.doc(customId).set({
  //     'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
  //     'date' : date
  //   },SetOptions(merge: true)).then((value) {
  //   debugPrint('date Exist added');
  //   }).catchError((error) => debugPrint("Failed to update user: $error"));
  // }

  double totalFixAmount = 0.0;
  double titlePrice = 0;
  fixItems(){
    totalAmount2 = double.parse(TtlProdListPrice2());
    titlePrice = double.parse(buyPriceController.text);
    totalFixAmount = double.parse(myController.text) * double.parse(buyPriceController.text);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          final double scaleFactor = MediaQuery.of(context).textScaleFactor;
          myController.addListener((){

              myState((){
                (myController.text != '' && buyPriceController.text != '') ? totalFixAmount =double.parse(myController.text) * double.parse(buyPriceController.text) : totalFixAmount = 0.0;
              });
          });

          buyPriceController.addListener((){
            setState(() {
              if(mounted) {
                myState((){
                  (myController.text != '' && buyPriceController.text != '') ? totalFixAmount =double.parse(myController.text) * double.parse(buyPriceController.text) : totalFixAmount = 0.0;
                  if( buyPriceController.text != '') {
                    titlePrice = double.parse(buyPriceController.text);
                    price2 = double.parse(buyPriceController.text); } else {
                    titlePrice = 0.0;
                    price2 = 0;
                  }
                });
              }
            });
          });
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
              top: true,
              bottom: true,
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 80,
                          child: Row(
                            children: [
                              Container(
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
                                      }
                                  ),
                                ),
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('$currencyUnit '+ titlePrice.toString(), textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          height: 1.5
                                      )),
                                      SizedBox(width: 5),
                                      if (unit == 'unit_name') Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Icon( SmartKyat_POS.prodm, size: 15, color: Colors.grey,),
                                      )
                                      else if(unit == 'sub1_name') Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Icon(SmartKyat_POS.prods1, size: 15, color: Colors.grey,),
                                      )
                                      else if(unit == 'sub2_name') Padding(
                                          padding: const EdgeInsets.only(top: 2.0),
                                          child: Icon(SmartKyat_POS.prods2, size: 15, color: Colors.grey,),
                                        )
                                        else Icon( Icons.check, size: 15, color: Colors.grey,),
                                    ],
                                  ),
                                  Text(productName, textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.7,
                                      forceStrutHeight: true,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0))),
                      ),
                    ],
                  ),
                  eachProd.length != 0 ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('shops')
                          .doc(shopId)
                          .collection('collArr')
                          .doc('prodsArr')
                          .snapshots(),
                      builder: (BuildContext context, snapshot2) {
                        if (snapshot2.hasData) {
                          var output2 = snapshot2.data != null? snapshot2.data!.data(): null;
                      return Expanded(
                        child: ListView(
                          children: [
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0, top: 15.0),
                                child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('QUANTITY', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  myState((){
                                                    quantity2 = double.parse(myController.text) - 1;  });});
                                                    if(quantity2 < 1) {
                                                      myState((){
                                                        quantity2 = 1;
                                                        myController.text = '1';
                                                      });

                                                    } else {
                                                      myState((){
                                                        myController.text = quantity2.round().toString();
                                                      });
                                                    }

                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context).size.width - 60)/3,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    color: AppTheme.themeColor),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15.0,
                                                      bottom: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                        child: Container(
                                                            child: Icon(
                                                              Icons.remove, size: 20,
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Container(
                                              width: (MediaQuery.of(context).size.width - 60)/3,
                                              height: 50,
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    height: 0.95,
                                                  fontSize: 15/scaleFactor,
                                                ),

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
                                                      top: 20,
                                                      bottom: 20.0),
                                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                  //filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.numberWithOptions(decimal: false),
                                                inputFormatters: <TextInputFormatter>[  LengthLimitingTextInputFormatter(6),
                                                  FilteringTextInputFormatter.allow(RegExp(_getNum())),],
                                                onChanged: (value) {
                                                  setState(() {
                                                    myState(() {
                                                      quantity2 = double.parse(value);
                                                    }); });
                                                },
                                                controller: myController,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  myState((){
                                                    quantity2 = double.parse(myController.text) + 1;
                                                    myController.text = quantity2.round().toString();
                                                    debugPrint('qqq' + quantity2.toString());
                                                  }); });
                                              },
                                              child: Container(
                                                width: (MediaQuery.of(context).size.width - 60)/3,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    color: AppTheme.themeColor),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15.0,
                                                      bottom: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
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
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                        Text(widget.isEnglish? 'BUY PRICE PER UNIT': 'BUY PRICE PER UNIT (တစ်ယူနစ်ဝယ်စျေး)', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                        SizedBox(height: 15,),
                                        TextFormField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[  LengthLimitingTextInputFormatter(15),
                                            FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                          controller: buyPriceController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              // return '';
                                              return ' This field is required ';
                                            }

                                            return null;
                                          },
                                          style: TextStyle(
                                              height: 0.95, fontSize : 15/scaleFactor,
                                          ),
                                          maxLines: 1,
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
                                            // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                            // isDense: true,
                                            contentPadding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 20,
                                                bottom: 20.0),
                                            suffixText: '$currencyUnit',
                                            suffixStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: 'capsulesans',
                                            ),
                                            //errorText: wrongEmail,
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
                                            labelText: widget.isEnglish? 'Custom buy price': 'စိတ်ကြိုက်ဝယ်စျေး',
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
//filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Text('UNIT PRICING', textScaleFactor: 1, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                        SizedBox(height: 15,),
                                        Container(
                                          height: 220,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.lightBgColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text(widget.isEnglish? 'Sale price': 'ရောင်းစျေး', textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      eachProd.split('^')[3]== 'unit_name' ? Text('$currencyUnit ' +  (output2?['prods'][productId]['sm']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) :
                                                      eachProd.split('^')[3]== 'sub1_name' ? Text('$currencyUnit ' +  (output2?['prods'][productId]['s1']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) :  Text('$currencyUnit ' +  (output2?['prods'][productId]['s2']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text(widget.isEnglish? 'In stock items': 'လက်ကျန်ပစ္စည်း', textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      eachProd.split('^')[3]== 'unit_name' ? Text( (output2?['prods'][productId]['im']).round().toString() + ' ' + (output2?['prods'][productId]['nm']).toString(),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : eachProd.split('^')[3]== 'sub1_name'? Text( (output2?['prods'][productId]['i1']).round().toString() + ' ' + (output2?['prods'][productId]['n1']).toString(),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : Text((output2?['prods'][productId]['i2']).round().toString() + ' ' + (output2?['prods'][productId]['n2']).toString(), textScaleFactor: 1,style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text(widget.isEnglish? 'Loss items': 'ဆုံးရှုံးပစ္စည်း', textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      eachProd.split('^')[3]== 'unit_name' ? Text((output2?['prods'][productId]['lm']).round().toString() + ' ' +(output2?['prods'][productId]['nm']).toString(), textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : eachProd.split('^')[3]== 'sub1_name'? Text((output2?['prods'][productId]['l1']).round().toString() + ' ' + (output2?['prods'][productId]['n1']).toString(),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : Text((output2?['prods'][productId]['l2']).round().toString() + ' ' +(output2?['prods'][productId]['n2']).toString(),textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  child: Row(
                                                    children: [
                                                      Text(widget.isEnglish? 'Barcode': 'ဘားကုဒ်', textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      Text((output2?['prods'][productId]['co']).toString(), textScaleFactor: 1, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //     }
                                        //     return Container();
                                        //   },
                                        // ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ); }
                        return Container(
                          height: MediaQuery.of(context).size.height/1.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                        child: CupertinoActivityIndicator(radius: 15,)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                  ) :

                      Container(
                    height: MediaQuery.of(context).size.height/1.5,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                  child: CupertinoActivityIndicator(radius: 15,)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color:
                                AppTheme.skBorderColor2,
                                width: 1.0),
                          )),
                      width: double.infinity,
                      height: 142,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 72,
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  widget.isEnglish? 'Total': 'စုစုပေါင်း', textScaleFactor: 1, maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight
                                          .w500),
                                ),
                                trailing: Text('$currencyUnit '+
                                    (totalFixAmount).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  textScaleFactor: 1, style: TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight
                                          .w500),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    debugPrint('eachProduct' +eachProd);

                                    for (int j = 0; j < widget.prodList2.length; j++)
                                      if( widget.prodList2[j].split('^')[0] == eachProd.split('^')[0] && widget.prodList2[j].split('^')[4] == eachProd.split('^')[3]){
                                        setState((){
                                          myState((){
                                            eachProd = eachProd.split('^')[0] +'^' + price2.toString() +'^'+(quantity2.toString())+'^'+ 'Phyo'+ '^'+ eachProd.split('^')[3]+'^'+ '1' +'^'+ eachProd.split('^')[5] + '^' + widget.prodList2[j].split('^')[7] +'^'+ widget.prodList2[j].split('^')[8] +'^'+ widget.prodList2[j].split('^')[9] +'^'+ widget.prodList2[j].split('^')[10]+'^'+ widget.prodList2[j].split('^')[11]+'^'+ widget.prodList2[j].split('^')[12] ;
                                            widget.prodList2[j] = eachProd;
                                          });  });
                                      } else debugPrint('leelar');

                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      color: AppTheme.themeColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0,
                                        bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                            child: Container(
                                                child: Text(
                                                  widget.isEnglish? 'Set & done': 'ဆက်ရန်', textScaleFactor: 1,
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
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ); });

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

  checkoutItems(){
    totalAmount2 = double.parse(TtlProdListPrice2());

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          final double scaleFactor = MediaQuery.of(context).textScaleFactor;
          _textFieldController2.addListener((){
            debugPrint("value: ${_textFieldController2.text}");
            setState(() {
              myState(() {
                totalAmount2 = double.parse(TtlProdListPrice2());
                _textFieldController2.text != '' ? paidAmount2 = double.parse(_textFieldController2.text) : paidAmount2 = 0.0;
                if((totalAmount2 - paidAmount2).isNegative){
                  debt2 = 0;} else { debt2 = (totalAmount2 - paidAmount2);}
                if((paidAmount2 - totalAmount2).isNegative){
                  refund2 = 0;} else { refund2 = (paidAmount2 - totalAmount2);}
              });  });  });
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: IgnorePointer(
              ignoring: disableTouch,
              child: SafeArea(
                bottom: true,
                top: true,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            height: 80,
                            child:
                            Row(
                              children: [
                                Container(
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
                                          setState((){
                                            myState(() {
                                              _textFieldController2.clear();
                                              paidAmount2 = 0;
                                              debt2 = 0;
                                              refund2 = 0;
                                              totalAmount2 = double.parse(TtlProdListPrice2());
                                            });});
                                          Navigator.pop(context);

                                        }),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(merchId == 'name' ? 'No merchant' : merchId, textScaleFactor: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.4,
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                      Text(textSetCashAccept, textScaleFactor: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            height: 1.3
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.7,
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.3),
                                      width: 1.0))),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          border: Border.all(
                                              color: Colors.grey.withOpacity(0.2),
                                              width: 1.0),
                                          color: AppTheme.lightBgColor),
                                      height:  133,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('$textSetTSale - $currencyUnit', textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),
                                          SizedBox(height: 8),
                                          Text(TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                              textScaleFactor: 1, textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      )),
                                  // Container(
                                  //     decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.all(
                                  //           Radius.circular(10.0),
                                  //         ),
                                  //         border: Border.all(
                                  //             color: Colors.grey.withOpacity(0.2),
                                  //             width: 1.0),
                                  //         color: AppTheme.lightBgColor),
                                  //     height:  133,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     child: Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.center,
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         Text(textSetTotalSale, style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.grey,
                                  //         )),
                                  //         SizedBox(height: 3),
                                  //         Text('$currencyUnit ' + TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(
                                  //           fontSize: 23, fontWeight: FontWeight.w500,
                                  //         )),
                                  //       ],
                                  //     )),
                                  SizedBox(height: 15),
                                  Text(textSetCashRev, textScaleFactor: 1, style: TextStyle(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,color: Colors.grey
                                  ),),
                                  SizedBox(height: 15),
                                  TextField(
                                    style: TextStyle(
                                      height: 0.95,
                                      fontSize: 15/scaleFactor,
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skBorderColor, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.themeColor, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                      suffixText: '$currencyUnit',
                                      suffixStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12/scaleFactor,
                                      ),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                      // errorText: 'Error message',
                                      labelText: textSetCustom,
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      //filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: <TextInputFormatter>[  LengthLimitingTextInputFormatter(15),
                                      FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                    onChanged: (value) {
                                      setState(() {
                                        myState(()
                                        {
                                          totalAmount2 = double.parse(TtlProdListPrice2());
                                          value != '' ? paidAmount2 = double.parse(value) : paidAmount2 = 0.0;
                                          if((totalAmount2 - paidAmount2).isNegative){
                                            debt2 = 0;
                                          } else { debt2 = (totalAmount2 - paidAmount2);
                                          }
                                          if((paidAmount2 - totalAmount2).isNegative){
                                            refund2 = 0;
                                          } else { refund2 = (paidAmount2 - totalAmount2);
                                          }
                                        });});
                                    },
                                    controller: _textFieldController2,
                                  ),
                                  SizedBox(height: 15),
                                  ButtonTheme(
                                    minWidth: double.infinity,
                                    //minWidth: 50,
                                    splashColor: AppTheme.buttonColor2,
                                    height: 50,
                                    child: FlatButton(
                                      color: AppTheme.buttonColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        side: BorderSide(
                                          color: AppTheme.buttonColor2,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          myState(() {
                                            totalAmount2 =
                                                double
                                                    .parse(
                                                    TtlProdListPrice2());
                                            _textFieldController2
                                                .text =
                                                totalAmount2
                                                    .toString();
                                            paidAmount2 =
                                                totalAmount2;
                                            if ((totalAmount2 -
                                                paidAmount2)
                                                .isNegative) {
                                              debt2 = 0;
                                            } else {
                                              debt2 =
                                              (totalAmount2 -
                                                  paidAmount2);
                                            }
                                            if ((paidAmount2 -
                                                totalAmount2)
                                                .isNegative) {
                                              refund2 =
                                              0;
                                            } else {
                                              refund2 =
                                              (paidAmount2 -
                                                  totalAmount2);
                                            }
                                          }); });
                                      },
                                      child: Container(
                                        child: Text( '$currencyUnit ' +
                                            TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          textScaleFactor: 1, style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          // orderLoading?Text('Loading'):Text('')
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
                                  color:
                                  AppTheme.skBorderColor2,
                                  width: 1.0),
                            )),
                        width: double.infinity,
                        height: 142,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 72,
                                child: Center(
                                  // child: ListTile(
                                  //   title: Text(
                                  //     textSetDebt, textScaleFactor: 1,
                                  //     style: TextStyle(
                                  //         fontSize: 17,
                                  //         fontWeight:
                                  //         FontWeight
                                  //             .w500),
                                  //   ),
                                  //   trailing: Text('- $currencyUnit '+
                                  //       debt2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  //     textScaleFactor: 1, style: TextStyle(
                                  //         fontSize: 17,
                                  //         fontWeight:
                                  //         FontWeight
                                  //             .w500),
                                  //   ),
                                  // ),
                                  child: debt2!= 0 ? ListTile(
                                    title: Text(
                                      textSetDebt, textScaleFactor: 1,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                    trailing: Text('- $currencyUnit '+
                                        debt2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                      textScaleFactor: 1, style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                  ) : ListTile(
                                    title: Text(
                                      textSetRefund, textScaleFactor: 1, maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                    trailing: Text('$currencyUnit '+
                                        refund2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                      textScaleFactor: 1, style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                  ),
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    WriteBatch batch = FirebaseFirestore.instance.batch();
                                    DateTime now = DateTime.now();
                                    if (calHourFromTZ(now).toString() != "390") {
                                      await showOkAlertDialog(
                                        context: context,
                                        title:  'Unsupported TimeZone!',
                                        message:
                                        'Currently, only Myanmar TimeZone (UTC +6:30) is supported.',
                                        okLabel: 'OK',
                                      );
                                    }
                                    else {
                                      discountAmount2 = discount2;
                                      // now = now.subtract(Duration(minutes: calHourFromTZ(now)));
                                      int length = 0;
                                      int totalOrders = 0;
                                      int debts = 0;
                                      var dateExist = false;
                                      var dateId = '';
                                      var monthId = '';
                                      bool monthExist = false;
                                      var yearId = '';
                                      bool yearExist = false;
                                      bool reFilter = false;
                                      bool deFilter = false;
                                      double debtAmounts = 0;
                                      debugPrint('order creating here2');

                                      myState(() {
                                        setState(() {
                                          disableTouch = true;
                                          merchCartCreating = true;
                                          widget.merchCartLoadingState();
                                        });
                                      });
                                      openOverAllSubLoading();

                                      FirebaseFirestore.instance.collection('shops').doc(shopId)
                                          .collection('countColl').doc('buyOrdsCnt')
                                          .get()
                                          .then((value) async {
                                        length = int.parse(value.data()!['count'].toString());

                                        length = length + 1;

                                        //buyOrderLengthIncrease();
                                        batch = await updateOrderLength(batch);

                                        double sub1Buy = 0;
                                        double sub2Buy = 0;
                                        subList2 = [];
                                        for (String str in widget.prodList2) {
                                          subList2.add(
                                              str.split('^')[0] + '^' + str.split('^')[7] +
                                                  '^' + str.split('^')[8] + '^' +
                                                  str.split('^')[2] + '^' +
                                                  str.split('^')[1] + '^' +
                                                  str.split('^')[4] + '^' +
                                                  str.split('^')[2] + '^0^' +
                                                  str.split('^')[9]);
                                          debugPrint('subList2 init ' + str.split('^')[12].toString());


                                          if (str.split('^')[4] == 'unit_name') {
                                            if (double.parse(str.split('^')[12].toString()) == 1) {
                                              sub1Buy = (double.parse(str.split('^')[1]) /
                                                  double.parse(str.split('^')[10]));
                                              sub2Buy = 0;
                                            } else if (double.parse(str.split('^')[12].toString()) == 2) {
                                              sub1Buy = (double.parse(str.split('^')[1]) /
                                                  double.parse(str.split('^')[10]));
                                              sub2Buy = ((double.parse(str.split('^')[1]) /
                                                  double.parse(str.split('^')[10])) /
                                                  double.parse(str.split('^')[11]));
                                            } else {
                                              sub1Buy = 0;
                                              sub2Buy = 0;
                                            }
                                            batch = await updateProduct1(
                                                batch, str.split('^')[0], str.split('^')[2],
                                                str.split('^')[1], sub1Buy, sub2Buy);
                                          }
                                          else if (str.split('^')[4] == 'sub1_name') {
                                            if (double.parse(str.split('^')[12].toString()) == 2) {
                                              sub1Buy = (double.parse(str.split('^')[1]) /
                                                  double.parse(str.split('^')[11]));
                                            } else {
                                              sub1Buy = 0;
                                            }

                                            batch = await updateProduct2(
                                                batch, str.split('^')[0], str.split('^')[2],
                                                str.split('^')[1], sub1Buy);
                                          } else if (str.split('^')[4] == 'sub2_name') {
                                            batch = await updateProduct3(
                                                batch, str.split('^')[0], str.split('^')[2],
                                                str.split('^')[1]);
                                          }
                                        }

                                        if (debt2.toString() != '0.0') {
                                          debts = 1;
                                          debtAmounts = debt2;
                                          deFilter = true;
                                        } else {
                                          debts = 0;
                                          debtAmounts = 0;
                                          deFilter = false;
                                        }
                                        totalOrders = totalOrders + 1;
                                        //merchOrder(totalOrders, debts, debtAmounts);
                                        batch = await updateMerchOrder(
                                            batch, merchRealId, totalOrders, debts, debtAmounts);

                                        debugPrint('subList2 Two' + subList2.toString());

                                        DateTime ordCntDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                                            now.year.toString() + '-' + zeroToTen(now.month.toString()) +
                                                '-' + zeroToTen(now.day.toString()) + ' 12:00:00');
                                        batch = await updateMonthlyData(
                                            batch,
                                            now.year.toString() + zeroToTen(now.month.toString()),
                                            now.year.toString() + zeroToTen(now.month.toString()) +
                                                zeroToTen(now.day.toString()) + 'cash_merc',
                                            now.year.toString() + zeroToTen(now.month.toString()) +
                                                zeroToTen(now.day.toString()) + 'debt_merc',
                                            TtlProdListPrice2().toString(),
                                            debtAmounts,
                                            ordCntDate);
                                        batch = await updateYearlyData(
                                            batch,
                                            now.year.toString(),
                                            now.year.toString() + zeroToTen(now.month.toString()) +
                                                'cash_merc',
                                            now.year.toString() + zeroToTen(now.month.toString()) +
                                                'debt_merc',
                                            TtlProdListPrice2().toString(),
                                            debtAmounts,
                                            ordCntDate);


                                        batch = await updateDetail(
                                            batch,
                                            now,
                                            length.toString(),
                                            subList2,
                                            now.year.toString() + zeroToTen(now.month.toString()) +
                                                zeroToTen(now.day.toString()),
                                            reFilter,
                                            deFilter,
                                            now.year.toString() + zeroToTen(now.month.toString()) +
                                                zeroToTen(now.day.toString()) +
                                                zeroToTen(now.hour.toString()) +
                                                zeroToTen(now.minute.toString()));
                                        batch =
                                        await DatenotExist(batch, now.year.toString() + zeroToTen(now
                                            .month.toString()) + zeroToTen(now.day.toString()) +
                                            zeroToTen(now.hour.toString()) +
                                            zeroToTen(now.minute.toString()) + '^' +
                                            deviceIdNum.toString() + '-' + length.toString() + '^' +
                                            TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId +
                                            '^F' + '^' + debt2.toString() + '^' +
                                            discountAmount2.toString() + disText2, now,
                                            length.toString());
                                        // CollectionReference monthlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly');
                                        //
                                        // monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '01' + ' 00:00:00'))
                                        //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '31' + ' 23:59:59'))
                                        //     .get()
                                        //     .then((QuerySnapshot querySnapshot)  async {
                                        //   querySnapshot.docs.forEach((doc) {
                                        //     monthExist = true;
                                        //     monthId = doc.id;
                                        //   });
                                        //   debugPrint('month ' + monthExist.toString());
                                        //   if (monthExist) {
                                        //     batch = await updateMonthlyData(batch, monthId, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                        //     // monthlyData.doc(monthId).update({
                                        //     //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                        //     //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc' : FieldValue.increment(debtAmounts),
                                        //     // }).then((value) => debugPrint("data Updated"))
                                        //     //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //   }
                                        //   else {
                                        //     monthlyData.add({
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                        //       for(int j = 1; j<= 31; j++)
                                        //         now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_merc' : 0,
                                        //
                                        //       'date': now,
                                        //
                                        //     }).then((value) async {
                                        //       batch = await updateMonthlyData(batch, value.id, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                        //       // debugPrint('valueid' + value.id.toString());
                                        //       // monthlyData.doc(value.id).update({
                                        //       //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                        //       //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc' : FieldValue.increment(debtAmounts),
                                        //       //
                                        //       // }).then((value) => debugPrint("Data Updated"))
                                        //       //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //     }).catchError((error) => debugPrint("Failed to update user: $error"));
                                        //   }
                                        //
                                        //   CollectionReference yearlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly');
                                        //
                                        //   yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                        //       .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                        //       .get()
                                        //       .then((QuerySnapshot querySnapshot)  async {
                                        //     querySnapshot.docs.forEach((doc) {
                                        //       yearExist = true;
                                        //       yearId = doc.id;
                                        //     });
                                        //     debugPrint('year ' + yearExist.toString());
                                        //     if (yearExist) {
                                        //       batch = await updateYearlyData(batch, yearId, now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                        //       // yearlyData.doc(yearId).update({
                                        //       //   now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                        //       //   now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc' : FieldValue.increment(debtAmounts)
                                        //       //
                                        //       // }).then((value) => debugPrint("data Updated"))
                                        //       //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //     }
                                        //     else {
                                        //       yearlyData.add({
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString()  + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString()  + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString() + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString() + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString() + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString() + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                        //         for(int j = 1; j<= 12; j++)
                                        //           now.year.toString() + zeroToTen(j.toString()) + 'refu_merc' : 0,
                                        //
                                        //         'date': now,
                                        //
                                        //       }).then((value13) async {
                                        //         debugPrint('valueid' + value.id.toString());
                                        //         batch = await updateYearlyData(batch, value13.id, now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                        //
                                        //         // yearlyData.doc(value.id).update({
                                        //         //   now.year.toString() +  zeroToTen(now.month.toString()) + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                        //         //   now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc' : FieldValue.increment(debtAmounts)
                                        //         // }).then((value) => debugPrint("Data Updated"))
                                        //         //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //       }).catchError((error) => debugPrint("Failed to update user: $error"));
                                        //     }

                                        // FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders')
                                        //     .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
                                        //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
                                        //     .get()
                                        //     .then((QuerySnapshot querySnapshot) async {
                                        //   querySnapshot.docs.forEach((doc) {
                                        //     dateExist = true;
                                        //     dateId = doc.id;
                                        //   });
                                        //
                                        //   if (dateExist) {
                                        //     batch = await updateDateExist(batch, dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())+ '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId +'^F' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2, length.toString());
                                        //     // addDateExist(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())   + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId +'^F' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2, length.toString());
                                        //     //Detail2(now, length.toString() , subList2, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                        //     batch = await updateDetail(batch, now, length.toString(), subList2, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                        //     debugPrint('adddateexist added');
                                        //   }
                                        //   else {
                                        //     DatenotExist(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())  + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId + '^F' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2, now, length.toString());
                                        //     batch = await updateDetail(batch, now, length.toString(), subList2, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                        //     //Detail2(now, length.toString(), subList2, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                        //     debugPrint('adddateexist not');
                                        //   }
                                        widget.clearMerch();
                                        widget.clearProd();

                                        try {
                                          batch.commit();
                                          Future.delayed(const Duration(milliseconds: 2000), () {
                                            myState(() {
                                              setState(() {
                                                widget.endMerchCartLoadingState();
                                                disableTouch = false;
                                                merchCartCreating = false;
                                              });
                                              closeOverAllSubLoading();
                                            });
                                            Navigator.of(context).popUntil((route) => route.isFirst);
                                            smartKyatFlash(
                                                'Refill process has been complete successfully.', 's');
                                          });
                                        } catch (error) {
                                          Future.delayed(const Duration(milliseconds: 2000), () {
                                            myState(() {
                                              setState(() {
                                                widget.endMerchCartLoadingState();
                                                disableTouch = false;
                                                merchCartCreating = false;
                                              });
                                              closeOverAllSubLoading();
                                            });
                                            Navigator.of(context).popUntil((route) => route.isFirst);
                                            smartKyatFlash(
                                                'An error occurred while creating order. Please try again later.',
                                                'e');
                                          });
                                        }
                                      });


                                      // Future.delayed(const Duration(milliseconds: 3000), () {
                                      //   myState(() {
                                      //     setState(() {
                                      //       widget.endMerchCartLoadingState();
                                      //       disableTouch = false;
                                      //       merchCartCreating = false;
                                      //     });
                                      //   });
                                      //   Navigator.of(context).popUntil((route) => route.isFirst);
                                      //   smartKyatFlash('Refill process has been complete successfully.', 's');
                                      // });
                                    }
                                 },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        color: AppTheme.themeColor),
                                    child: merchCartCreating ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                        child: CupertinoActivityIndicator(radius: 10,)):
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0,
                                          bottom: 15.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                        child: Container(
                                          child: Text(
                                            textSetDone, textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              // height: 1.3,
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.22,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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

  updateOrderLength(WriteBatch batch){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('buyOrdsCnt');
    batch.update(documentReference, {'count': FieldValue.increment(1)});
    return batch;
  }

  updateProduct1(WriteBatch batch, id, amount, price, price2, price3){
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('prodsArr');
    batch.update(documentReference, {
      'prods.$id.im' : FieldValue.increment(double.parse(amount.toString())),
      'prods.$id.bm' : double.parse(price.toString()),
      'prods.$id.b1': double.parse(price2.toString()),
      'prods.$id.b2': double.parse(price3.toString()),
    });
    return batch;
  }

  updateProduct2(WriteBatch batch, id,  amount, price,  price2){
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('prodsArr');
    batch.update(documentReference, {
      'prods.$id.i1' : FieldValue.increment(double.parse(amount.toString())),
      'prods.$id.b1': double.parse(price.toString()),
      'prods.$id.b2': double.parse(price2.toString()),
    });
    return batch;
  }

  updateProduct3(WriteBatch batch, id, amount, price){
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('prodsArr');
    batch.update(documentReference, {
      'prods.$id.i2' : FieldValue.increment(double.parse(amount.toString())),
      'prods.$id.b2': double.parse(price.toString()),
    });
    return batch;
  }

  updateMerchOrder(WriteBatch batch, id, totalOrds, debt, debtAmt) async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants').doc(id);
    DocumentReference documentReference2 =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('merArr');
    if(id.toString() != 'name') {
      batch.update(documentReference2, {
        'mer.' + id +'.or': FieldValue.increment(double.parse(totalOrds.toString())),
        'mer.' + id +'.da': FieldValue.increment(double.parse(debtAmt.toString())),
        'mer.' + id +'.de': FieldValue.increment(double.parse(debt.toString())),
      });
    } else {    batch.update(documentReference, {

      'total_orders' : FieldValue.increment(double.parse(totalOrds.toString())),
      'debtAmount' : FieldValue.increment(double.parse(debtAmt.toString())),
      'debts' : FieldValue.increment(double.parse(debt.toString())),
    }); }
    return batch;
  }

  updateMonthlyData(WriteBatch batch, id, field1, field2, price1, price2, now) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly').doc(id);
    batch.set(documentReference, {
      field1.toString() : FieldValue.increment(double.parse(price1.toString())),
      field2.toString() : FieldValue.increment(double.parse(price2.toString())),
      'date': now,
    },SetOptions(merge: true));
    return batch;
  }

  updateYearlyData(WriteBatch batch, id, field1, field2, price1, price2, now) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly').doc(id);
    batch.set(documentReference, {
      field1.toString() : FieldValue.increment(double.parse(price1.toString())),
      field2.toString() : FieldValue.increment(double.parse(price2.toString())),
      'date': now,
    },SetOptions(merge: true));
    return batch;
  }

  updateDateExist(WriteBatch batch, id1, dOrder , length) {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders').doc(id1);
    batch.update(documentReference, {'daily_order': FieldValue.arrayUnion([dOrder.toString()]),});
    return batch;
  }

  updateDetail(WriteBatch batch, date, length, subs, docId, reF, deF, dateTime) {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrder').doc(deviceIdNum.toString() + length.toString());

    String merchantName = '';
    if( widget.merchantId.split('^')[1] == 'name') {
      merchantName = 'No merchant';
    } else merchantName = widget.merchantId.split('^')[1];

    batch.set(documentReference, {
      'date': date,
      'total': TtlProdListPrice2(),
      'debt' : debt2,
      'discount' : discountAmount2.toString() + disText2,
      'refund': 'F',
      'subs': subs,
      'merchantId' : widget.merchantId.split('^')[0],
      'deviceId' : deviceIdNum.toString() + '-',
      'orderId' : length.toString(),
      'documentId' : docId,
      'refund_filter' : reF,
      'debt_filter' : deF,
      'dateTime' : dateTime.toString(),
      'merName' : merchantName,
    });
    return batch;
  }

  RegExp _numeric = RegExp(r'^-?[0-9]+$');

  /// check if the string contains only numbers
  bool isNumeric(str) {
    return _numeric.hasMatch(str);
  }

}