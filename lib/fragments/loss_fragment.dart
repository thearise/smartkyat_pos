import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class LossProduct extends StatefulWidget {
  const LossProduct(
      {Key? key, required this.idString, required this.prodID, required this.shopId, required this.price1, required this.price2, required this.price3,});
  final String idString;
  final String prodID;
  final String shopId;
  final String price1;
  final String price2;
  final String price3;

  @override
  _LossProductState createState() => _LossProductState();
}

final _formKey = GlobalKey<FormState>();

final lossAmount = TextEditingController();
final priceAmount = TextEditingController();

late int codeDialog =0;

var deviceIdNum;

getDeviceId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('device');
}

class _LossProductState extends State<LossProduct> {

  String currencyUnit = 'MMK';

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  @override
  initState() {

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
    priceAmount.text = priceUnit();
    // TODO: implement initState
    getDeviceId().then((value) {
      deviceIdNum = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    lossAmount.clear();
    priceAmount.clear();
    super.dispose();
  }
  priceUnit(){
    String buyPrice = '';
    if( widget.prodID.split('-')[3] == 'unit_name'){
      buyPrice = widget.price1;
    } else if(widget.prodID.split('-')[3] == 'sub1_name'){
      buyPrice = widget.price2;
    } else buyPrice = widget.price3;
    return buyPrice;
  }


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
        child: SafeArea(
          top: true,
          bottom: false,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .doc(widget.shopId)
                  .collection('products')
                  .doc(widget.idString)
                  .snapshots(),
              builder: (BuildContext context, snapshot2) {
                if (snapshot2.hasData) {
                  var output1 = snapshot2.data!.data();
                  var prodName = output1?['prod_name'];
                  var mainName = output1?[widget.prodID.split('-')[3]];
                  return Column(
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
                          padding:
                          const EdgeInsets.only(left: 15.0, right: 15.0,),
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
                                        prodName,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Loss Product',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Form(
                              key: _formKey,
                              child:  Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(top: 15, left: 15, right: 15.0),
                                    child: Text(
                                      "Add Loss Product",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        letterSpacing: 2,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 45),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) * (2.41 / 4) : (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
                                          child: TextFormField(
                                            controller: lossAmount,
                                            keyboardType: TextInputType.numberWithOptions(decimal: false),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp(_getNum())),],
// The validator receives the text that the user has entered.
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'This field is required';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(
                                              height: 0.95,
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(

                                                  borderSide: BorderSide(
                                                      color: AppTheme.skBorderColor,
                                                      width: 2.0),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10.0))),

                                              focusedBorder: OutlineInputBorder(

                                                  borderSide: BorderSide(
                                                      color: AppTheme.themeColor,
                                                      width: 2.0),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10.0))),
                                              contentPadding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 20.0,
                                                  bottom: 20.0),
                                              // suffixText: 'Required',
                                              suffixStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontFamily: 'capsulesans',
                                              ),
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
                                              labelText: 'Loss Quantity',
                                              floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
//filled: true
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  -
                                              30) *
                                              (1.41 / 4) : (MediaQuery.of(context).size.width -
                                              30) *
                                              (1.41 / 4),
                                          child: Text(
                                            mainName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 118),
                                    child: TextFormField(
                                      controller: priceAmount,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
// The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        height: 0.95,
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
                                            top: 20.0,
                                            bottom: 20.0),
                                        suffixText: '$currencyUnit',
                                        suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'capsulesans',
                                        ),
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
                                        labelText: 'Buy Price',
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
//filled: true
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),

                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? homeBotPadding + 20: homeBotPadding),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                              child: ButtonTheme(
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
                                    if (_formKey.currentState!.validate()) {
                                      var dateExist = false;

                                      List<String> subLink1 = [];
                                      List<String> subName1 = [];
                                      List<double> subStock1 = [];
                                      var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(
                                          widget.shopId).collection('products').doc(
                                          widget.prodID.split('-')[0])
                                          .get();

                                      if (docSnapshot10.exists) {
                                        Map<String, dynamic>? data10 = docSnapshot10.data();
                                        for(int i = 0; i < int.parse(data10 ? ["sub_exist"]) + 1; i++) {
                                          subLink1.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                                          subName1.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                                          print('inStock' + (i+1).toString());
                                          subStock1.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
                                        }
                                      }
                                      DateTime now = DateTime.now();
                                      String buyPriceUnit = '';
                                      String buyPrice = '';
                                      String unit = '';
                                      CollectionReference lossProduct = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('loss');

                                      if (widget.prodID.split('-')[3] == 'unit_name') {
                                        decStockFromInv(widget.prodID.split('-')[0], 'main', lossAmount.text.toString());
                                        lossProduct.add({                                      //'loss_count' : FieldValue.arrayUnion([lossAmount.text.toString() + '-' + priceAmount.text.toString()]),
                                          'date': now,
                                          'prod_id' : widget.prodID.split('-')[0],
                                          'amount' : FieldValue.increment(double.parse(lossAmount.text.toString())),
                                          'buy_price' : FieldValue.increment(double.parse(priceAmount.text.toString())),
                                          'type': 'loss1',
                                        }).then((value) =>
                                            print("User Updated"))
                                            .catchError((error) =>
                                            print(
                                                "Failed to update datenotexist: $error"));
                                        // unit = 'loss1';
                                        // buyPriceUnit = 'buyPrice1';
                                      }
                                      else if (widget.prodID.split('-')[3] == 'sub1_name') {
                                        sub1Execution(subStock1, subLink1, widget.prodID.split('-')[0], lossAmount.text.toString());
                                        // unit = 'loss2';
                                        // buyPriceUnit = 'buyPrice2';
                                        lossProduct.add({
                                          //'loss_count' : FieldValue.arrayUnion([lossAmount.text.toString() + '-' + priceAmount.text.toString()]),
                                          'date': now,
                                          'prod_id' : widget.prodID.split('-')[0],
                                          'amount' : FieldValue.increment(double.parse(lossAmount.text.toString())),
                                          'buy_price' : FieldValue.increment(double.parse(priceAmount.text.toString())),
                                          'type': 'loss2',
                                        }).then((value) =>
                                            print("User Updated"))
                                            .catchError((error) =>
                                            print(
                                                "Failed to update datenotexist: $error"));
                                      }
                                      else if (widget.prodID.split('-')[3] == 'sub2_name') {
                                        sub2Execution(subStock1, subLink1, widget.prodID.split('-')[0], lossAmount.text.toString());
                                        lossProduct.add({                                      //'loss_count' : FieldValue.arrayUnion([lossAmount.text.toString() + '-' + priceAmount.text.toString()]),
                                          'date': now,
                                          'prod_id' : widget.prodID.split('-')[0],
                                          'amount' : FieldValue.increment(double.parse(lossAmount.text.toString())),
                                          'buy_price' : FieldValue.increment(double.parse(priceAmount.text.toString())),
                                          'type': 'loss3',
                                        }).then((value) =>
                                            print("User Updated"))
                                            .catchError((error) =>
                                            print(
                                                "Failed to update datenotexist: $error"));
                                        // unit = 'loss3';
                                        // buyPriceUnit = 'buyPrice3';
                                      }
                                      // var dateId = '';
                                      //
                                      // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(widget.prodID.split('-')[0]).get().then((value) async {
                                      //   buyPrice = value.data()![buyPriceUnit].toString();
                                      //
                                      //   print("SHOP ID " + widget.shopId + ' ' + widget.prodID.split('-')[0]);
                                      //   FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(widget.prodID.split('-')[0]).collection(unit)
                                      //       .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
                                      //       .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
                                      //       .get()
                                      //       .then((QuerySnapshot qsNew)  async {
                                      //
                                      //     print("LENGTH " + qsNew.docs.length.toString());
                                      //
                                      //     qsNew.docs.forEach((doc) {
                                      //       dateExist = true;
                                      //       dateId = doc.id;
                                      //       print('UNIT ' + doc.id.toString());
                                      //     });
                                      //
                                      //     print('Unit' + unit + ' ' + now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + '0' + deviceIdNum);
                                      //     print('dick exist - > ' + dateExist.toString());
                                      //
                                      //     //
                                      //     if(dateExist){
                                      //       lossProduct.doc(dateId).update({
                                      //         'loss_count' : FieldValue.arrayUnion([lossAmount.text.toString() + '-' + priceAmount.text.toString()]),
                                      //         // 'count': FieldValue.increment(double.parse(lossAmount.text.toString())),
                                      //         // 'buy_price': buyPrice,
                                      //       }).then((value) => print("User Updated"))
                                      //           .catchError((error) => print("Failed to update dateexist: $error"));
                                      //     }
                                      //     else {
                                      //       lossProduct.doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + '0' + deviceIdNum).set({
                                      //         // 'count': FieldValue
                                      //         //     .increment(
                                      //         //     double.parse(
                                      //         //         lossAmount.text.toString())),
                                      //         // 'buy_price': buyPrice,
                                      //         'loss_count' : FieldValue.arrayUnion([lossAmount.text.toString() + '-' + priceAmount.text.toString()]),
                                      //         'date': now,
                                      //       }).then((value) =>
                                      //           print("User Updated"))
                                      //           .catchError((error) =>
                                      //           print(
                                      //               "Failed to update datenotexist: $error"));
                                      //     }
                                      //   });
                                      // });
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 2.0),
                                    child: Container(
                                      child: Text(
                                        'Save Loss Product',
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
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                      ),
                    ],
                  );
                }
                return Container();
              }
          ),
        )
    );
  }
  changeUnitName2Stock(String split) {
    if(split == 'main') {
      return 'inStock1';
    } else {
      return 'inStock' + (int.parse(split[3]) + 1).toString();
    }
  }
  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }
  Future<void> decStockFromInv(id, unit, num) async {
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

    // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));

    users
        .doc(id)
        .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> incStockFromInv(id, unit, num) async {
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

    // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));

    users
        .doc(id)
        .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> sub1Execution(subStock, subLink, id, num) async {
    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[1] = double.parse((data10 ? ['inStock2']).toString());
      if(subStock[1] > double.parse(num)) {
        decStockFromInv(id, 'sub1', num);
      } else {
        decStockFromInv(id, 'main', ((int.parse(num)  - subStock[1])/int.parse(subLink[0])).ceil());
        incStockFromInv(id, 'sub1', ((int.parse(num)-subStock[1].round()) % int.parse(subLink[0])) == 0? 0: (int.parse(subLink[0]) - (int.parse(num)-subStock[1].round()) % int.parse(subLink[0])));
        decStockFromInv(id, 'sub1', subStock[1]);
      }
    }
  }

  Future<void> sub2Execution(subStock, subLink, id, num) async {
    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[2] = double.parse((data10 ? ['inStock3']).toString());
      if(subStock[2] > double.parse(num)) {
        decStockFromInv(id, 'sub2', num);
      } else {
        await incStockFromInv(id, 'sub2', ((int.parse(num)-subStock[2].round()) % int.parse(subLink[1])) == 0? 0: (int.parse(subLink[1]) - (int.parse(num)-subStock[2].round()) % int.parse(subLink[1])));
        await decStockFromInv(id, 'sub2', subStock[2]);
        sub1Execution(subStock, subLink, id, ((int.parse(num)  - subStock[2])/int.parse(subLink[1])).ceil().toString());
      }
    }
  }
}
