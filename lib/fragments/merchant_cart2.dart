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
      {Key? key,
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

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
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


  @override
  initState() {
    merchId = widget.merchantId.split('^')[1];
    merchRealId = widget.merchantId.split('^')[0];
    print('initializing ' + widget.prodList2.toString());
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

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetMerchOrders = 'အ၀ယ်စာရင်း';
          textSetClearCart = 'စာရင်းမလုပ်သေးပါ';
          textSetDiscount = 'လျော့ဈေး';
          textSetNoMerchant = 'ဝယ်ယူသူမရွေးရသေးပါ';
          textSetTotalSale = 'စုစုပေါင်းကျသင့်ငွေ';
          textSetCheckout = 'ငွေရှင်းမည်';
          textSetAmountApplied = 'Amount applied';
          textSetPercent = 'Percentage';
          textSetCashAccept = 'Cash acceptance';
          textSetCashRev = 'CASH RECEIVED';
          textSetCustom = 'Custom amount';
          textSetDebt = 'Unpaid amount';
          textSetRefund = 'Cash refund';
          textSetDone = 'ငွေရှင်းမည်';
        });
      }
      else if(value=='english') {
        setState(() {
          textSetMerchOrders = 'Merchant cart';
          textSetClearCart = 'Clear cart';
          textSetDiscount = 'Discount';
          textSetNoMerchant = 'No merchant';
          textSetTotalSale = 'Total sale';
          textSetCheckout = 'Checkout';
          textSetAmountApplied = 'Amount applied';
          textSetPercent = 'Percentage';
          textSetCashAccept = 'Cash acceptance';
          textSetCashRev = 'CASH RECEIVED';
          textSetCustom = 'Custom amount';
          textSetDebt = 'Unpaid amount';
          textSetRefund = 'Cash refund';
          textSetDone = 'Done';
        });
      }
    });
    deviceIdNum = widget.deviceId;
    shopId = widget.shop;
    super.initState();
  }
  @override
  void dispose() {
    _textFieldController2.dispose();
    myController.dispose();
    buyPriceController.dispose();
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
        widget.prodList2[index].split('^')[2] + '^' + widget.prodList2[index].split('^')[3] + '^' + widget.prodList2[index].split('^')[4] + '^' + widget.prodList2[index].split('^')[5] + '^' + widget.prodList2[index].split('^')[6] + '^' + widget.prodList2[index].split('^')[7] + '^' + widget.prodList2[index].split('^')[8] +'^' + widget.prodList2[index].split('^')[9];

    print('prodincart ' + widget.prodList2.toString());
    String image = widget.prodList2[index].split('^')[9];
    prodListInd = prodListInd.split('^')[0] + '^' + widget.prodList2[index].split('^')[6] + '^' +
        prodListInd.split('^')[1] + '^' + prodListInd.split('^')[4] + '^' + prodListInd.split('^')[2] + '^' + prodListInd.split('^')[6];
    return GestureDetector(
      onTap: (){
        print('error prod' + prodListInd.toString());
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
        //     mystate((){
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
                          'https://riftplus.me/smartkyat_pos/api/uploads/' +
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
                        widget.prodList2[index].split('^')[7],
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
                          Text(' ' + widget.prodList2[index].split('^')[8] + ' ', style: TextStyle(
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
                      style: TextStyle(
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
                  child: Text(double.parse(prodListInd.split('^')[4]).round().toString(), style: TextStyle(
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
    return Scaffold(
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

                                }),
                          ),
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(merchId == 'name' ? 'No merchant' : merchId,
                              style: TextStyle(
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
                            Text(textSetMerchOrders,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3
                              ),
                              strutStyle: StrutStyle(
                                height: 1.7,
                                // fontSize:,
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
                                              textSetClearCart,
                                              textScaleFactor: 1,
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
                                              title: 'Choose discount type',
                                              actions: [
                                                SheetAction(
                                                  icon: Icons.error,
                                                  label: 'Amount',
                                                  key: 'amount',
                                                ),
                                                SheetAction(
                                                  icon: Icons.warning,
                                                  label: 'Percent',
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
                                                        if (value == null || value.isEmpty) {
                                                          // return '';
                                                          return 'this field is required ';
                                                        } else {
                                                          if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                            return 'no item in cart';
                                                          } else if(double.parse(value) > double.parse(TtlProdListPriceInit2())) {
                                                            return 'much less than total sale';
                                                          } else if(double.parse(value) < 0) {
                                                            return 'invalid amount';
                                                          }
                                                        }
                                                        return null;
                                                      },
                                                      // initialText: 'mono0926@gmail.com',
                                                    ),
                                                  ],
                                                  title: 'Discount',
                                                  message: 'Add Discount Amount to Cart',
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
                                                        if (value == null || value.isEmpty) {
                                                          // return '';
                                                          return 'this field is required ';
                                                        } else {
                                                          if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                            return 'no item in cart';
                                                          }
                                                          if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                            return 'invalid amount';
                                                          }
                                                        }
                                                        return null;
                                                      },
                                                      // initialText: 'mono0926@gmail.com',
                                                    ),
                                                  ],
                                                  title: 'Discount',
                                                  message: 'Add Discount Percent to Cart',
                                                );
                                                setState(() {
                                                  discount2 =double.parse(percentage![0].toString());
                                                });
                                              }
                                              print('dis' + result.toString());
                                              setState(() {
                                                print('do something');
                                              });
                                            }
                                          }


                                        } else {
                                          final result = await showModalActionSheet<String>(
                                            context: context,
                                            title: 'Choose discount type',
                                            actions: [
                                              SheetAction(
                                                icon: Icons.error,
                                                label: 'Amount',
                                                key: 'amount',
                                              ),
                                              SheetAction(
                                                icon: Icons.warning,
                                                label: 'Percent',
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
                                                      if (value == null || value.isEmpty) {
                                                        // return '';
                                                        return 'this field is required ';
                                                      } else {
                                                        if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                          return 'no item in cart';
                                                        } else if(double.parse(value) > double.parse(TtlProdListPriceInit2())) {
                                                          return 'much less than total sale';
                                                        } else if(double.parse(value) < 0) {
                                                          return 'invalid amount';
                                                        }
                                                      }
                                                      return null;
                                                    },
                                                    // initialText: 'mono0926@gmail.com',
                                                  ),
                                                ],
                                                title: 'Discount',
                                                message: 'Add Discount Amount to Cart',
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
                                                      if (value == null || value.isEmpty) {
                                                        // return '';
                                                        return 'this field is required ';
                                                      } else {
                                                        if(double.parse(TtlProdListPriceInit2()) <= 0) {
                                                          return 'no item in cart';
                                                        }
                                                        if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                          return 'invalid amount';
                                                        }
                                                      }
                                                      return null;
                                                    },
                                                    // initialText: 'mono0926@gmail.com',
                                                  ),
                                                ],
                                                title: 'Discount',
                                                message: 'Add Discount Percent to Cart',
                                              );
                                              setState(() {
                                                discount2 =double.parse(percentage![0].toString());
                                              });
                                            }
                                            print('dis' + result.toString());
                                            setState(() {
                                              print('do something');
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
                                              textSetDiscount,
                                              textScaleFactor: 1,
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
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(merchId == 'name' ? 'No merchant' : merchId , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),),
                                                // Text(customerId.split('^')[1].toString() == 'name' ? 'Unknown' : address,
                                                //     style: TextStyle(
                                                //       fontSize: 14,
                                                //       color: Colors.grey
                                                //     )),
                                              ],
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
                                      title: Text(textSetDiscount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      subtitle: Text('$textSetPercent (' +  discountAmount2.toString() + '%)', style: TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      )),
                                      trailing: Text('- $currencyUnit ' + (double.parse(TtlProdListPriceInit2()) - double.parse(TtlProdListPrice2())).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                    ) :  ListTile (
                                      title: Text(textSetDiscount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      subtitle: Text(textSetAmountApplied, style: TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      )),
                                      trailing: Text('- $currencyUnit ' + discount2.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                  return Container();
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
                        textSetTotalSale,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight
                                .w500),
                      ),
                      subtitle: int.parse(totalItems2()) == 1? Text(totalItems2() + ' item set',
                          style: TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                          )) : Text(totalItems2() + ' item sets',
                          style: TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                          )),
                      trailing: Text('$currencyUnit '+
                          TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                        style: TextStyle(
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

                            print('totalAmount '+ totalAmount2.toString());
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
                                            textSetCheckout,
                                            textScaleFactor: 1,
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
                        ),
                      ),
                    ) :
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
                        child: GestureDetector(
                          onTap: () {
                            print('no products to refill');
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
                                            textSetCheckout,
                                            textScaleFactor: 1,
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
    print('myanmar' + widget.prodList2.toString());
    for (String str in widget.prodList2) {
      total += double.parse(str.split('^')[1]) * int.parse(str.split('^')[2]);
    }
    return total.toString();
  }

  TtlProdListPrice2()  {
    double total = 0;
    print(widget.prodList2.toString());
    for (String str in widget.prodList2) {
      total += double.parse(str.split('^')[1]) * double.parse(str.split('^')[2]);
      disPercent2 = (double.parse(total.toString()) *
          (discountAmount2 / 100)).round();
    }
    if(isDiscount2 == 'percent'){
      discountAmount2 = discount2;
      print(discountAmount2.toString());
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

  Future<void> buyOrderLengthIncrease() async {
    print('CHECKING PRODSALE ORD');
    CollectionReference users = await FirebaseFirestore.instance.collection('shops');

    // print('gg ' + str.split('^')[0] + ' ' + changeUnitName2Stock(str.split('^')[3]));

    users
        .doc(shopId)
        .update({'buyOrders_length': FieldValue.increment(1)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> addDateExist(id1, dOrder , length) async {
    CollectionReference daily = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders');
    daily.doc(id1).update({
      'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> DatenotExist(dOrder, date, length) async {
    CollectionReference daily = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders');

    String customId = date.year.toString() + zeroToTen(date.month.toString()) + zeroToTen(date.day.toString()) +  deviceIdNum.toString();

    daily.doc(customId).set({
      'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
      'date' : date
    }).then((value) {
      print('date Exist added');
    }).catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> Detail2(date, length , subs, docId, reFilter, deFilter, dateTime) async {
    CollectionReference detail = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrder');
    String customId = deviceIdNum.toString() + length.toString();
    print('detailsub3 ' + subs.toString());
    detail.doc(customId).set({
      'date' : date,
      'total': TtlProdListPrice2(),
      'debt' : debt2,
      'discount' : discountAmount2.toString() + disText2,
      'refund': 'F',
      'subs': subs,
      'merchantId' : merchRealId,
      'deviceId' : deviceIdNum.toString() + '-',
      'orderId' : length.toString(),
      'documentId' : docId,
      'refund_filter': reFilter,
      'debt_filter': deFilter,
      'dateTime': dateTime.toString()
    })

        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> merchOrder(ttlOrders, debts , debtAmount) async {
    print('CHECKING PRODSALE ORD');
    CollectionReference cusOrder = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants');

    cusOrder.doc(merchRealId).update({
      'total_orders': FieldValue.increment(double.parse(ttlOrders.toString())),
      'debtAmount' : FieldValue.increment(double.parse(debtAmount.toString())),
      'debts': FieldValue.increment(double.parse(debts.toString())),
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  double totalFixAmount = 0.0;
  double titlePrice = 0;
  fixItems(){
    totalAmount2 = double.parse(TtlProdListPrice2());
    titlePrice = double.parse(buyPriceController.text);
    totalFixAmount = double.parse(myController.text) * double.parse(buyPriceController.text);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter mystate) {
          myController.addListener((){
            setState(() {
              mystate((){
                (myController.text != '' && buyPriceController.text != '') ? totalFixAmount =double.parse(myController.text) * double.parse(buyPriceController.text) : totalFixAmount = 0.0;
              });});
          });

          buyPriceController.addListener((){
            setState(() {
              mystate((){
                (myController.text != '' && buyPriceController.text != '') ? totalFixAmount =double.parse(myController.text) * double.parse(buyPriceController.text) : totalFixAmount = 0.0;
                if( buyPriceController.text != '') {
                  titlePrice = double.parse(buyPriceController.text);
                  price2 = double.parse(buyPriceController.text); } else {
                  titlePrice = 0.0;
                  price2 = 0;
                }
              });});
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
                                      Text('$currencyUnit '+ titlePrice.toString(), style: TextStyle(
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
                                  Text(productName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
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
                      stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(productId).snapshots(),
                      builder: (BuildContext context, snapshot2) {
                        if (snapshot2.hasData) {
                          var output2 = snapshot2.data!.data();
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
                                        Text('QUANTITY', style: TextStyle(
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
                                                  mystate((){
                                                    quantity2 = double.parse(myController.text) - 1;
                                                    myController.text = quantity2.toString();
                                                    print('qqq' + quantity2.toString());
                                                  });});
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
                                                    height: 0.95
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
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                onChanged: (value) {
                                                  setState(() {
                                                    mystate(() {
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
                                                  mystate((){
                                                    quantity2 = double.parse(myController.text) + 1;
                                                    myController.text = quantity2.toString();
                                                    print('qqq' + quantity2.toString());
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
                                        Text('COST PER UNIT', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                        SizedBox(height: 15,),
                                        TextFormField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
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
                                              height: 0.95
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
                                            labelText: 'Custom Buy Price',
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
//filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Text('UNIT PRICING', style: TextStyle(
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
                                                      Text('Sell price', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      eachProd.split('^')[3]== 'unit_name' ? Text('$currencyUnit ' +   output2?['unit_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) :
                                                      eachProd.split('^')[3]== 'sub1_name' ? Text('$currencyUnit ' +   output2?['sub1_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) :  Text('$currencyUnit ' +   output2?['sub2_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
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
                                                      Text('In stock', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      eachProd.split('^')[3]== 'unit_name' ? Text( output2!['inStock1'].round().toString() + ' ' + output2['unit_name'], style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : eachProd.split('^')[3]== 'sub1_name'? Text( output2!['inStock2'].round().toString() + ' ' + output2['sub1_name'], style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : Text(output2!['inStock3'].round().toString() + ' ' + output2['sub2_name'], style:
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
                                                      Text('Loss', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      eachProd.split('^')[3]== 'unit_name' ? Text(output2['Loss1'].round().toString() + ' ' +output2['unit_name'], style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : eachProd.split('^')[3]== 'sub1_name'? Text(output2['Loss2'].round().toString() + ' ' + output2['sub1_name'], style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),) : Text(output2['Loss3'].round().toString() + ' ' + output2['sub2_name'], style:
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
                                                      Text('Barcode', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      Text(output2['bar_code'].toString(), style:
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
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight
                                          .w500),
                                ),
                                trailing: Text('$currencyUnit '+
                                    (totalFixAmount).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  style: TextStyle(
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
                                    print('eachProduct' +eachProd);

                                    for (int j = 0; j < widget.prodList2.length; j++)
                                      if( widget.prodList2[j].split('^')[0] == eachProd.split('^')[0] && widget.prodList2[j].split('^')[4] == eachProd.split('^')[3]){
                                        setState((){
                                          mystate((){
                                            eachProd = eachProd.split('^')[0] +'^' + price2.toString() +'^'+(quantity2.toString())+'^'+ 'Phyo'+ '^'+ eachProd.split('^')[3]+'^'+ '1' +'^'+ eachProd.split('^')[5] + '^' + widget.prodList2[j].split('^')[7] +'^'+ widget.prodList2[j].split('^')[8] +'^'+ widget.prodList2[j].split('^')[9];
                                            widget.prodList2[j] = eachProd;
                                          });  });
                                      } else print('leelar');

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
                                                  'Save',
                                                  textScaleFactor: 1,
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
        builder: (BuildContext context, StateSetter mystate) {
          _textFieldController2.addListener((){
            print("value: ${_textFieldController2.text}");
            setState(() {
              mystate(() {
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
                                            mystate(() {
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
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(merchId == 'name' ? 'No merchant' : merchId,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5
                                      ),
                                      strutStyle: StrutStyle(
                                        height: 1.4,
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    Text(textSetCashAccept,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
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
                                          Text('Total sale - $currencyUnit',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),
                                          SizedBox(height: 8),
                                          Text(TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                              textAlign: TextAlign.center,
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
                                  Text(textSetCashRev,style: TextStyle(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,color: Colors.grey
                                  ),),
                                  SizedBox(height: 15),
                                  TextField(
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skBorderColor, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skThemeColor2, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                      suffixText: '$currencyUnit',
                                      suffixStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
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
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                    onChanged: (value) {
                                      setState(() {
                                        mystate(()
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
                                          mystate(() {
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
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
                                  child: debt2!= 0 ? ListTile(
                                    title: Text(
                                      textSetDebt,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                    trailing: Text('- $currencyUnit '+
                                        debt2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                  ) : ListTile(
                                    title: Text(
                                      textSetRefund,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                    trailing: Text('$currencyUnit '+
                                        refund2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                      style: TextStyle(
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
                                    discountAmount2 = discount2;
                                    subList2 = [];
                                    DateTime now = DateTime.now();
                                    CollectionReference prods =  await FirebaseFirestore.instance.collection('shops').doc(
                                        shopId).collection('products');
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
                                    double debtAmounts = 0 ;
                                    print('order creating here2');

                                    mystate(() {
                                      setState(() {
                                        disableTouch = true;
                                        merchCartCreating = true;
                                        widget.merchCartLoadingState();
                                      });
                                    });

                                    FirebaseFirestore.instance.collection('shops').doc(shopId).get().then((value) async {
                                      length = int.parse(
                                          value.data()!['buyOrders_length']
                                              .toString());
                                      print('lengthsss' + length.toString());

                                      length = length + 1;

                                      //buyOrderLengthIncrease();
                                      batch = await updateOrderLength(batch);

                                      for (String str in widget.prodList2) {
                                        subList2.add(
                                            str.split('^')[0] + '-' + 'veriD' +
                                                '-' + 'buy0' + '-' +
                                                str.split('^')[2] + '-' +
                                                str.split('^')[1] + '-' +
                                                str.split('^')[4] + '-' +
                                                str.split('^')[2] + '-0-' +
                                                'date');
                                        print('subList2 init ' + subList2.toString());

                                        List<String> subLink = [];
                                        List<String> subName = [];
                                        List<double> subStock = [];

                                        var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('^')[0]).get();

                                        if (docSnapshot10.exists) {
                                          Map<String,
                                              dynamic>? data10 = docSnapshot10
                                              .data();

                                          for (int i = 0; i < int.parse(
                                              data10 ? ["sub_exist"]) +
                                              1; i++) {
                                            subLink.add(data10 ? ['sub' +
                                                (i + 1).toString() + '_link']);
                                            subName.add(data10 ? ['sub' +
                                                (i + 1).toString() + '_name']);
                                            print(
                                                'inStock' + (i + 1).toString());
                                            subStock.add(double.parse(
                                                (data10 ? ['inStock' +
                                                    (i + 1).toString()])
                                                    .toString()));
                                          }
                                        }

                                        if (str.split('^')[4] == 'unit_name') {

                                          batch = await updateProduct(batch, str.split('^')[0], 'inStock1', 'buyPrice1', str.split('^')[2], str.split('^')[1]);
                                          // prods.doc(
                                          //     str.split('^')[0])
                                          //     .update({
                                          //   'inStock1': FieldValue.increment(
                                          //       double.parse(str.split('^')[2]
                                          //           .toString())),
                                          //   'buyPrice1': str.split('^')[1]
                                          //       .toString(),
                                          // })
                                          //     .then((value) =>
                                          //     print("User Updated"))
                                          //     .catchError((error) => print(
                                          //     "Failed to update user: $error"));
                                        }
                                        else
                                        if (str.split('^')[4] == 'sub1_name') {
                                          batch = await updateProduct(batch, str.split('^')[0], 'inStock2', 'buyPrice2', str.split('^')[2], str.split('^')[1]);

                                          // prods.doc(
                                          //     str.split('^')[0])
                                          //     .update({
                                          //   'inStock2': FieldValue.increment(
                                          //       double.parse(str.split('^')[2]
                                          //           .toString())),
                                          //   'buyPrice2': str.split('^')[1]
                                          //       .toString(),
                                          // })
                                          //     .then((value) =>
                                          //     print("User Updated"))
                                          //     .catchError((error) => print(
                                          //     "Failed to update user: $error"));
                                        } else
                                        if (str.split('^')[4] == 'sub2_name') {
                                          batch = await updateProduct(batch, str.split('^')[0], 'inStock3', 'buyPrice3', str.split('^')[2], str.split('^')[1]);

                                          // prods.doc(
                                          //     str.split('^')[0])
                                          //     .update({
                                          //   'inStock3': FieldValue.increment(
                                          //       double.parse(str.split('^')[2]
                                          //           .toString())),
                                          //   'buyPrice3': str.split('^')[1]
                                          //       .toString(),
                                          // })
                                          //     .then((value) =>
                                          //     print("User Updated"))
                                          //     .catchError((error) => print(
                                          //     "Failed to update user: $error"));
                                        }

                                      }

                                      if(debt2.toString() != '0.0') {
                                        debts = 1;
                                        debtAmounts = debt2;
                                        deFilter = true;
                                      } else {
                                        debts = 0;
                                        debtAmounts = 0;
                                        deFilter = true;
                                      }
                                      totalOrders = totalOrders + 1;
                                      //merchOrder(totalOrders, debts, debtAmounts);
                                      batch = await updateMerchOrder(batch, merchRealId, totalOrders, debts, debtAmounts);

                                      print('subList2 Two'+ subList2.toString());
                                      CollectionReference monthlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly');

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
                                          batch = await updateMonthlyData(batch, monthId, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                          // monthlyData.doc(monthId).update({
                                          //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                          //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc' : FieldValue.increment(debtAmounts),
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
                                            batch = await updateMonthlyData(batch, value.id, now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                            // print('valueid' + value.id.toString());
                                            // monthlyData.doc(value.id).update({
                                            //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                            //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_merc' : FieldValue.increment(debtAmounts),
                                            //
                                            // }).then((value) => print("Data Updated"))
                                            //     .catchError((error) => print("Failed to update user: $error"));
                                          }).catchError((error) => print("Failed to update user: $error"));
                                        }

                                        CollectionReference yearlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly');

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
                                            batch = await updateYearlyData(batch, yearId, now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc', TtlProdListPrice2(), debtAmounts);
                                            // yearlyData.doc(yearId).update({
                                            //   now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                            //   now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc' : FieldValue.increment(debtAmounts)
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

                                            }).then((value13) async {
                                              print('valueid' + value.id.toString());
                                              batch = await updateYearlyData(batch, value13.id, now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_merc', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc', TtlProdListPrice2(), debtAmounts);

                                              // yearlyData.doc(value.id).update({
                                              //   now.year.toString() +  zeroToTen(now.month.toString()) + 'cash_merc' : FieldValue.increment(double.parse(TtlProdListPrice2())),
                                              //   now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_merc' : FieldValue.increment(debtAmounts)
                                              // }).then((value) => print("Data Updated"))
                                              //     .catchError((error) => print("Failed to update user: $error"));
                                            }).catchError((error) => print("Failed to update user: $error"));
                                          }

                                          FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders')
                                              .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
                                              .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
                                              .get()
                                              .then((QuerySnapshot querySnapshot) async {
                                            querySnapshot.docs.forEach((doc) {
                                              dateExist = true;
                                              dateId = doc.id;
                                            });

                                            if (dateExist) {
                                              batch = await updateDateExist(batch, dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())+ '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId +'^F' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2, length.toString());
                                              // addDateExist(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())   + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId +'^F' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2, length.toString());
                                              //Detail2(now, length.toString() , subList2, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                              batch = await updateDetail(batch, now, length.toString(), subList2, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                              print('adddateexist added');
                                            }
                                            else {
                                              DatenotExist(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())  + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchRealId + '<>' + merchId + '^F' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2, now, length.toString());
                                              batch = await updateDetail(batch, now, length.toString(), subList2, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                              //Detail2(now, length.toString(), subList2, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                              print('adddateexist not');
                                            }
                                            batch.commit();
                                          });
                                        });
                                      }); });


                                    widget.clearMerch();
                                    widget.clearProd();

                                    Future.delayed(const Duration(milliseconds: 3000), () {
                                      mystate(() {
                                        setState(() {
                                          widget.endMerchCartLoadingState();
                                          disableTouch = false;
                                          merchCartCreating = false;
                                        });
                                      });
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      smartKyatFlash('Refill process has been complete successfully.', 's');
                                    });
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
                                            textSetDone,
                                            textScaleFactor: 1,
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

  updateOrderLength(WriteBatch batch){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId);
    batch.update(documentReference, {'buyOrders_length': FieldValue.increment(1)});
    return batch;
  }

  updateProduct(WriteBatch batch, id, field1, field2, amount, price){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id);
    batch.update(documentReference, {
      field1: FieldValue.increment(double.parse(amount.toString())),
      field2: price.toString(),});
    return batch;
  }

  updateMerchOrder(WriteBatch batch, id, totalOrds, debt, debtAmt) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants').doc(id);
    batch.update(documentReference, {

      'total_orders' : FieldValue.increment(double.parse(totalOrds.toString())),
      'debtAmount' : FieldValue.increment(double.parse(debtAmt.toString())),
      'debts' : FieldValue.increment(double.parse(debt.toString())),
    });
    return batch;
  }

  updateMonthlyData(WriteBatch batch, id, field1, field2, price1, price2) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse(price1.toString())),
      field2 : FieldValue.increment(double.parse(price2.toString())),

    });
    return batch;
  }

  updateYearlyData(WriteBatch batch, id, field1, field2, price1, price2) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse(price1.toString())),
      field2 : FieldValue.increment(double.parse(price2.toString())),

    });
    return batch;
  }

  updateDateExist(WriteBatch batch, id1, dOrder , length) {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders').doc(id1);
    batch.update(documentReference, {'daily_order': FieldValue.arrayUnion([dOrder.toString()]),});
    return batch;
  }

  updateDetail(WriteBatch batch, date, length, subs, docId, reF, deF, dateTime) {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrder').doc(deviceIdNum.toString() + length.toString());
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
      'dateTime' : dateTime.toString()
    });
    return batch;
  }

}