import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../app_theme.dart';
import 'fill_product.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
];

class ProductDetailsView2 extends StatefulWidget {
  final _callback;
  final _callback3;

  const ProductDetailsView2(
      {Key? key,
        required this.idString,
        required void toggleCoinCallback(String str),
        required void toggleCoinCallback3(String str)})
      : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3;

  final String idString;

  @override
  _ProductDetailsViewState2 createState() => _ProductDetailsViewState2();
}

class _ProductDetailsViewState2 extends State<ProductDetailsView2> {
  addProduct2(data) {
    widget._callback(data);
  }

  addProduct3(data) {
    widget._callback3(data);
  }

  routeFill(res) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FillProduct(
              idString: widget.idString,
              toggleCoinCallback: addProduct2,
              toggleCoinCallback3: addProduct3,
              unitname: res,
            )));
  }

  TextEditingController _textFieldController = TextEditingController();
  late int valueText = 0;
  late int codeDialog =0;



  Future<void> _displayTextInputDialog(BuildContext context, prodID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Type Unit Qunaity'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  valueText = int.parse(value);
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: 'Type Unit Qunaity'),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _textFieldController.clear();
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  codeDialog = valueText;
                  print('valueText' + codeDialog.toString());
                  Navigator.pop(context);
                  List<String> subSell = [];
                  List<String> subLink = [];
                  List<String> subName = [];

                  int mainLoss =0;
                  int sub1Loss = 0;
                  int sub2Loss = 0;
                  var docSnapshot10 = await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                      .get();

                  if (docSnapshot10.exists) {
                    Map<String, dynamic>? data10 = docSnapshot10.data();
                    for(int i = 0; i < int.parse(data10 ? ["sub_exist"]); i++) {
                      subSell.add(data10 ? ['sub' + (i+1).toString() + '_sell']);
                      subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                      subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                    }
                    mainLoss = int.parse(data10 ? ["main_loss"]);
                    sub1Loss = int.parse(data10 ? ["sub1_loss"]);
                    sub2Loss = int.parse(data10 ? ["sub2_loss"]);
                  }
                  if(prodID.split('-')[3] == 'unit_name') {
                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                        .orderBy('date', descending: false)
                        .where('type', isEqualTo: 'main')
                        .get()
                        .then((QuerySnapshot querySnapshot) async {
                      int value = codeDialog;
                      double ttlQtity = 0.0;
                      double ttlPrice = 0.0;
                      int mainLoss1 = 0;
                      mainLoss1 =int.parse(value.toString()) + mainLoss;

                      await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          .update({'main_loss': mainLoss1.toString()
                      });

                      for(int j = 0; j < querySnapshot.docs.length; j++) {
                        if(value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                          int newValue = 0;
                          ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          // main_loss1 = int.parse(querySnapshot.docs[j]["unit_qtity"]) + mainLoss;

                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id)
                              .update({'unit_qtity': newValue.toString()
                          });
                          // await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          //     .update({'main_loss': main_loss1.toString()
                          // });
                          value = (int.parse(querySnapshot.docs[j]["unit_qtity"]) - value).abs();

                        } else if (value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) >= value) {
                          print(querySnapshot.docs[j]["unit_qtity"]);

                          int newValue = int.parse(querySnapshot.docs[j]["unit_qtity"]) - value;
                          ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(value.toString());
                          ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          //main_loss2 = int.parse(value.toString()) +  mainLoss;

                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id).update({'unit_qtity': newValue.toString()});
                          // await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          //    .update({'main_loss': main_loss2.toString()
                          // });
                          //subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4]+  '-0-' + querySnapshot.docs[j]["date"]);
                          break;
                        }
                      }
                    });
                  } else if(prodID.split('-')[3]== 'sub1_name'){
                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                        .orderBy('date', descending: false)
                        .where('type', isEqualTo: 'sub1')
                        .get()
                        .then((QuerySnapshot querySnapshot) async {
                      int value = codeDialog;
                      double ttlPrice = 0.0;
                      double ttlQtity = 0.0;
                      int sub1Loss1 = 0;
                      int sub1Loss2 = 0;

                      sub1Loss1 =int.parse(value.toString()) + sub1Loss;
                      await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          .update({'sub1_loss': sub1Loss1.toString()
                      });

                      for(int j = 0; j < querySnapshot.docs.length; j++) {
                        print('val ' + value.toString() + ' ' + querySnapshot.docs[j]["unit_qtity"]);
                        if(value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                          int newValue = 0;
                          ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          // sub1Loss1 = int.parse(querySnapshot.docs[j]["unit_qtity"]) + sub1Loss;
                          // print('sub1Loss1 ' + sub1Loss1.toString());
                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id)
                              .update({'unit_qtity': newValue.toString()
                          });
                          // await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          //     .update({'sub1_loss': sub1Loss1.toString()
                          // });


                          value = (int.parse(querySnapshot.docs[j]["unit_qtity"]) - value).abs();
                          //subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + querySnapshot.docs[j]["unit_qtity"] +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + querySnapshot.docs[j]["date"]);
                        } else if (value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) >= value) {
                          print(querySnapshot.docs[j]["unit_qtity"]);

                          int newValue = int.parse(querySnapshot.docs[j]["unit_qtity"]) - value;
                          ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(value.toString());
                          ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          // sub1Loss2 = int.parse(value.toString()) + sub1Loss;
                          // print('sub1Loss2 ' + sub1Loss2.toString());
                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id).update({'unit_qtity': newValue.toString()});
                          // await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          //     .update({'sub1_loss': sub1Loss2.toString()
                          // });
                          //subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4]+  '-0-' + querySnapshot.docs[j]["date"]);
                          value = 0;
                          break;
                        } else {

                        }
                      }

                      if(value != 0) {
                        print('sub1 out' + (value/int.parse(subLink[0])).ceil().toString() + ' ' + subLink[0].toString());
                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                            .orderBy('date', descending: false)
                            .where('type', isEqualTo: 'main')
                            .get()
                            .then((QuerySnapshot querySnapshotSub1Main) async {
                          int mainNhote = (value/int.parse(subLink[0])).ceil();
                          double ttlPrice = 0.0;
                          double ttlQtity = 0.0;
                          double sub1OutP = 0.0;
                          for(int j = 0; j < querySnapshotSub1Main.docs.length; j++) {
                            if(mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) < mainNhote) {
                              int newValue = 0;
                              ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                              ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id)
                                  .update({'unit_qtity': newValue.toString()
                              });
                              sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);
                              mainNhote = (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote).abs();
                            } else if (mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) >= mainNhote) {
                              print(querySnapshotSub1Main.docs[j]["unit_qtity"]);

                              int newValue = int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote;
                              ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(mainNhote.toString());
                              ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                              sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);
                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id).update({'unit_qtity': newValue.toString()});
                              // if(sub1Loss1 != 0){
                              //   sub1Loss4 = int.parse(value.toString()) + sub1Loss1;
                              // } else {
                              //   sub1Loss4 =
                              //       int.parse(value.toString()) + sub1Loss;
                              // }
                              // print('loss' + sub1Loss4.toString() + value.toString());
                              // await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                              //     .update({'sub1_loss': sub1Loss4.toString()
                              // });
                              break;
                            }
                          }



                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                              .add({
                            'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                            'unit_qtity': value%int.parse(subLink[0]) == 0? '0': (int.parse(subLink[0]) - (value%int.parse(subLink[0]))).toString(),
                            'buy_price': (sub1OutP/double.parse(subLink[0])).toString(),
                            'type': 'sub1',
                          }).then((val)  {

                            //subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub1OutP/double.parse(subLink[0])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));

                          });

                        });
                      }
                    });
                  } else if(prodID.split('-')[3]== 'sub2_name'){

                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                        .orderBy('date', descending: false)
                        .where('type', isEqualTo: 'sub2')
                        .get()
                        .then((QuerySnapshot querySnapshot) async {
                      int value = codeDialog;
                      double ttlPrice = 0.0;
                      double ttlQtity = 0.0;
                      int sub2Loss1 = 0;
                      sub2Loss1 =int.parse(value.toString()) + sub2Loss;

                      await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0])
                          .update({'sub2_loss': sub2Loss1.toString()
                      });

                      for(int j = 0; j < querySnapshot.docs.length; j++) {
                        print('val ' + value.toString() + ' ' + querySnapshot.docs[j]["unit_qtity"]);
                        if(value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                          int newValue = 0;
                          ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id)
                              .update({'unit_qtity': newValue.toString()
                          });
                          value = (int.parse(querySnapshot.docs[j]["unit_qtity"]) - value).abs();
                          //subList.add(prodID.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + querySnapshot.docs[j]["unit_qtity"] +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + querySnapshot.docs[j]["date"]);
                        } else if (value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) >= value) {
                          print(querySnapshot.docs[j]["unit_qtity"]);

                          int newValue = int.parse(querySnapshot.docs[j]["unit_qtity"]) - value;
                          ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(value.toString());
                          ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);

                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id).update({'unit_qtity': newValue.toString()});

                          //subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4]+  '-0-' + querySnapshot.docs[j]["date"]);
                          value = 0;
                          break;
                        } else {

                        }
                      }
                      if(value != 0) {
                        print('sub2 out' + (value/int.parse(subLink[1])).ceil().toString() + ' ' + subLink[1].toString());
                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                            .orderBy('date', descending: false)
                            .where('type', isEqualTo: 'sub1')
                            .get()
                            .then((QuerySnapshot querySnapshotSub1Main) async {
                          int mainNhote = (value/int.parse(subLink[1])).ceil();
                          bool mainNhoted = false;
                          double ttlPrice = 0.0;
                          double ttlQtity = 0.0;
                          double sub2OutP = 0.0;
                          for(int j = 0; j < querySnapshotSub1Main.docs.length; j++) {
                            print('situation ' + value.toString() + ' ' + mainNhote.toString());
                            if(mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) < mainNhote) {
                              int newValue = 0;
                              ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                              ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id)
                                  .update({'unit_qtity': newValue.toString()
                              });
                              sub2OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                              mainNhote = (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote).abs();
                              mainNhoted = true;

                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                                  .add({
                                'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                'unit_qtity': '0',
                                'buy_price': (sub2OutP/double.parse(subLink[1])).toString(),
                                'type': 'sub2',
                              }).then((val) {
                                //subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub2OutP/double.parse(subLink[1])).toString() + '-' + (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"])*int.parse(subLink[1])).toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));
                                value = value - (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"])*int.parse(subLink[1]));
                              });
                            } else if (mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) >= mainNhote) {
                              print(querySnapshotSub1Main.docs[j]["unit_qtity"]);

                              int newValue = int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote;
                              ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(mainNhote.toString());
                              ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                              sub2OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);
                              mainNhote = 0;

                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id).update({'unit_qtity': newValue.toString()});
                              // break;
                            }
                            if(querySnapshotSub1Main.docs.length-1 == j){
                              print('1 situation ' + value.toString() + ' ' + mainNhote.toString() + sub2OutP.toString());

                              if(sub2OutP!=0.0 && mainNhote==0) {
                                await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                                    .add({
                                  'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                  'unit_qtity': value%int.parse(subLink[1]) == 0? '0': (int.parse(subLink[1]) - (value%int.parse(subLink[1]))).toString(),
                                  'buy_price': (sub2OutP/double.parse(subLink[1])).toString(),
                                  'type': 'sub2',
                                }).then((val) {
                                  //subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub2OutP/double.parse(subLink[1])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));

                                });
                              } else {
                                if(value != 0) {
                                  print('sub2 Main out' + (value/int.parse(subLink[0])).ceil().toString() + ' ' + subLink[0].toString());
                                  await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                                      .orderBy('date', descending: false)
                                      .where('type', isEqualTo: 'main')
                                      .get()
                                      .then((QuerySnapshot querySnapshotSub1Main) async {
                                    int mainNhoteSub2 = (value/(int.parse(subLink[0]) * int.parse(subLink[1]))).ceil();
                                    print('sub2 Main out two ' + mainNhoteSub2.toString() + ' ' + value.toString());
                                    double ttlPrice = 0.0;
                                    double ttlQtity = 0.0;
                                    double sub1OutP = 0.0;
                                    for(int j = 0; j < querySnapshotSub1Main.docs.length; j++) {
                                      if(mainNhoteSub2 != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) < mainNhoteSub2) {
                                        int newValue = 0;
                                        ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                        ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id)
                                            .update({'unit_qtity': newValue.toString()
                                        });
                                        sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                        mainNhoteSub2 = (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhoteSub2).abs();
                                      } else if (mainNhoteSub2 != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) >= mainNhoteSub2) {
                                        print(querySnapshotSub1Main.docs[j]["unit_qtity"]);

                                        int newValue = int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhoteSub2;
                                        ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(mainNhoteSub2.toString());
                                        ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                        sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id).update({'unit_qtity': newValue.toString()});
                                        break;
                                      }
                                    }

                                    int newVal = 0;
                                    if(mainNhoted) {
                                      newVal = value;
                                    } else {
                                      newVal = value;
                                    }

                                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                                        .add({
                                      'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                      'unit_qtity': (newVal%(int.parse(subLink[0]) * int.parse(subLink[1])))/int.parse(subLink[1]) == 0? '0': (int.parse(subLink[0]) - ((newVal%(int.parse(subLink[0]) * int.parse(subLink[1])))/int.parse(subLink[1])).ceil()).toString(),
                                      'buy_price': (sub1OutP/double.parse(subLink[0])).toString(),
                                      'type': 'sub1',
                                    }).then((val) async {
                                      // break
                                      //subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub1OutP/double.parse(subLink[0])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));
                                      await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodID.split('-')[0]).collection('versions')
                                          .add({
                                        'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                        'unit_qtity': value%int.parse(subLink[1]) == 0? '0' : (int.parse(subLink[1])-(value%int.parse(subLink[1]))).toString(),
                                        'buy_price': ((sub1OutP/double.parse(subLink[0]))/double.parse(subLink[1])).toString(),
                                        'type': 'sub2',
                                      }).then((val) {

                                      });
                                    });
                                  });
                                }
                              }
                            }
                          }
                        });
                      }
                    });
                  } else Container();
                  _textFieldController.clear();
                },
              ),

            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child:  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('space')
                    .doc('0NHIS0Jbn26wsgCzVBKT')
                    .collection('shops')
                    .doc('PucvhZDuUz3XlkTgzcjb')
                    .collection('products')
                    .doc(widget.idString)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    var output = snapshot.data!.data();
                    var prodName = output?['prod_name'];
                    var mainName = output?['unit_name'];
                    var sub1Name = output?['sub1_name'];
                    var sub2Name = output?['sub2_name'];
                    var sub3Name = output?['sub3_name'];
                    var barcode = output?['bar_code'];
                    var mainPrice = output?['unit_sell'];
                    var sub1Price = output?['sub1_sell'];
                    var sub2Price = output?['sub2_sell'];
                    var sub3Price = output?['sub3_sell'];
                    var sub1Unit = output?['sub1_link'];
                    var sub2Unit = output?['sub2_link'];
                    var sub3Unit = output?['sub3_link'];
                    var subExist = output?['sub_exist'];
                    var mainLoss = output?['main_loss'];
                    var sub1Loss = output?['sub1_loss'];
                    var sub2Loss = output?['sub2_loss'];
                    List<String> subSell = [];
                    List<String> subLink = [];
                    List<String> subName = [];
                    for(int i = 0; i < int.parse(subExist); i++) {
                      subSell.add(output?['sub' + (i+1).toString() + '_sell']);
                      subLink.add(output?['sub' + (i+1).toString() + '_link']);
                      subName.add(output?['sub' + (i+1).toString() + '_name']);
                    }
                    print(subSell.toString() + subLink.toString() + subName.toString());
                    return
                      Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        color: Colors.grey.withOpacity(0.3)),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          size: 16,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  Text(
                                    'Product Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        color: AppTheme.skThemeColor2),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {}),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Row(
                                      children: [
                                        ButtonTheme(
                                          //minWidth: 50,
                                          splashColor: Colors.transparent,
                                          height: 120,
                                          child: FlatButton(
                                            color: AppTheme.skThemeColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              side: BorderSide(
                                                color: AppTheme.skThemeColor,
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (subExist == '0') {
                                                widget._callback(widget.idString + '-' + '-' + output?['unit_sell'] +
                                                    '-unit_name-1');
                                              } else {
                                                final result =
                                                await showModalActionSheet<String>(
                                                  context: context,
                                                  actions: [
                                                    SheetAction(
                                                      icon: Icons.info,
                                                      label: '1 ' + output?['unit_name'],
                                                      key: widget.idString +
                                                          '-' +
                                                          '-' +
                                                          output?['unit_sell'] +
                                                          '-unit_name-1',
                                                    ),
                                                    for(int i =0; i < subSell.length; i++)
                                                      if(subSell[i] != '')
                                                        SheetAction(
                                                          icon: Icons.info,
                                                          label: '1 ' + subName[i],
                                                          key: widget.idString +
                                                              '-' + subLink[i] +
                                                              '-' +
                                                              subSell[i] +
                                                              '-sub' + (i+1).toString() + '_name-1',
                                                        ),

                                                  ],
                                                );

                                                widget._callback(result.toString());
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  'Add to cart',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        ButtonTheme(
                                          //minWidth: 50,
                                          splashColor: Colors.transparent,
                                          height: 120,
                                          child: FlatButton(
                                            color: AppTheme.skThemeColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              side: BorderSide(
                                                color: AppTheme.skThemeColor,
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (subExist == '0') {
                                                routeFill('unit_name');
                                              } else {
                                                final result =
                                                await showModalActionSheet<String>(
                                                  context: context,
                                                  actions: [
                                                    SheetAction(
                                                        icon: Icons.info,
                                                        label: '1 ' + mainName,
                                                        key: 'unit_name'),
                                                    if (sub1Price != '')
                                                      SheetAction(
                                                          icon: Icons.info,
                                                          label: '1 ' + sub1Name,
                                                          key: 'sub1_name'),
                                                    if (sub2Price != '')
                                                      SheetAction(
                                                          icon: Icons.info,
                                                          label: '1 ' + sub2Name,
                                                          key: 'sub2_name'),
                                                    if (sub3Price != '')
                                                      SheetAction(
                                                          icon: Icons.info,
                                                          label: '1 ' + sub3Name,
                                                          key: 'sub3_name'),
                                                  ],
                                                );
                                                if (result != null) {
                                                  routeFill(result);
                                                }
                                              }

                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  'Fill Product',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                                    child: ButtonTheme(
                                      minWidth: 40,
                                      splashColor: Colors.transparent,
                                      child: FlatButton(
                                        color: Colors.lightBlueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          side: BorderSide(
                                            color: AppTheme.skThemeColor,
                                          ),
                                        ),
                                        child: Icon(Icons.remove, size: 30,),
                                        onPressed: () async {
                                          // _displayTextInputDialog(context);
                                          if (subExist == '0') {
                                            lossProduct(widget.idString + '-' + '-' + output?['unit_sell'] +
                                                '-unit_name');
                                          } else {
                                            final result =
                                            await showModalActionSheet<String>(
                                              context: context,
                                              actions: [
                                                SheetAction(
                                                  icon: Icons.info,
                                                  label: '1 ' + output?['unit_name'],
                                                  key: widget.idString +
                                                      '-' +
                                                      '-' +
                                                      output?['unit_sell'] +
                                                      '-unit_name',
                                                ),
                                                for(int i =0; i < subSell.length; i++)
                                                  if(subSell[i] != '')
                                                    SheetAction(
                                                      icon: Icons.info,
                                                      label: '1 ' + subName[i],
                                                      key: widget.idString +
                                                          '-' + subLink[i] +
                                                          '-' +
                                                          subSell[i] +
                                                          '-sub' + (i+1).toString() + '_name',
                                                    ),

                                              ],
                                            );
                                            lossProduct(result.toString());
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text('Edit all'),
                                    ),
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
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text('Main Unit Versions'),
                                              SizedBox(height: 15,),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(widget.idString)
                                                      .collection('versions')
                                                      .where('type', isEqualTo: 'main')
                                                      .where('unit_qtity', isNotEqualTo: '0')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot6) {
                                                    if (snapshot6.hasData) {
                                                      return ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                        NeverScrollableScrollPhysics(),
                                                        children: snapshot6.data!.docs.map(
                                                                (DocumentSnapshot document) {
                                                              Map<String, dynamic> data6 =
                                                              document.data()!
                                                              as Map<String, dynamic>;
                                                              var mainPrices = data6['buy_price'];
                                                              var mainQtity = data6['unit_qtity'];
                                                              var date = data6['date'];
                                                              return Column(
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                        context)
                                                                        .size
                                                                        .width,
                                                                    height: 50,
                                                                    color: Colors.grey
                                                                        .withOpacity(0.3),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text('$mainQtity $mainName'),
                                                                          Spacer(),
                                                                          Text('$mainPrices MMK'),
                                                                          Spacer(),
                                                                          Text('Date: $date'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                ],
                                                              );
                                                            }).toList(),
                                                      );
                                                    }
                                                    return Container();
                                                  }), ],
                                          ),
                                          sub1Name!=''? Column(
                                            children: [
                                              Text('Sub1 Versions'),
                                              SizedBox(height: 15,),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(widget.idString)
                                                      .collection('versions')
                                                      .where('type', isEqualTo: 'sub1')
                                                      .where('unit_qtity', isNotEqualTo: '0')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot6) {
                                                    if (snapshot6.hasData) {
                                                      return ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                        NeverScrollableScrollPhysics(),
                                                        children: snapshot6.data!.docs.map(
                                                                (DocumentSnapshot document) {
                                                              Map<String, dynamic> data6 =
                                                              document.data()!
                                                              as Map<String, dynamic>;
                                                              var mainPrices = data6['buy_price'];
                                                              var mainQtity = data6['unit_qtity'];
                                                              var date = data6['date'];
                                                              return Column(
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                        context)
                                                                        .size
                                                                        .width,
                                                                    height: 50,
                                                                    color: Colors.grey
                                                                        .withOpacity(0.3),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text('$mainQtity $sub1Name'),
                                                                          Spacer(),
                                                                          Text('$mainPrices MMK'),
                                                                          Spacer(),
                                                                          Text('Date: $date'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                ],
                                                              );
                                                            }).toList(),
                                                      );
                                                    }
                                                    return Container();
                                                  }), ],
                                          ): Container(),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Quantity",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            children: [
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(widget.idString)
                                                      .collection('versions')
                                                      .where('type',
                                                      isEqualTo: 'main')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot2) {
                                                    if (snapshot2.hasData) {
                                                      int quantity = 0;
                                                      var mainQuantity;
                                                      snapshot2.data!.docs.map(
                                                              (DocumentSnapshot
                                                          document) {
                                                            Map<String, dynamic> data1 =
                                                            document.data()! as Map<
                                                                String, dynamic>;

                                                            quantity += int.parse(
                                                                data1['unit_qtity']);
                                                            mainQuantity =
                                                                quantity.toString();
                                                          }).toList();
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Main Quantity',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize: 16,
                                                                // letterSpacing: 2,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '$mainQuantity $mainName',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              color: Colors.blueGrey
                                                                  .withOpacity(1.0),
                                                            ),
                                                          ),
                                                          Container(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              height: 1.5,
                                                              color: Colors.grey
                                                                  .withOpacity(0.3)),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(widget.idString)
                                                      .collection('versions')
                                                      .where('type',
                                                      isEqualTo: 'sub1')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot3) {
                                                    if (snapshot3.hasData) {
                                                      int quantity1 = 0;
                                                      var sub1Quantity;
                                                      snapshot3.data!.docs.map(
                                                              (DocumentSnapshot
                                                          document) {
                                                            Map<String, dynamic> data2 =
                                                            document.data()! as Map<
                                                                String, dynamic>;
                                                            if (data2['unit_qtity'] !=
                                                                '') {
                                                              quantity1 += int.parse(
                                                                  data2['unit_qtity']);
                                                              sub1Quantity =
                                                                  quantity1.toString();
                                                            } else
                                                              return Container();
                                                          }).toList();
                                                      // print(sub1Quantity);
                                                      // print(mainQuantity);

                                                      if (sub1Quantity != null) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Sub1 Quantity',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  fontSize: 16,
                                                                  // letterSpacing: 2,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '$sub1Quantity $sub1Name',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                color: Colors.blueGrey
                                                                    .withOpacity(1.0),
                                                              ),
                                                            ),
                                                            Container(
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                height: 1.5,
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.3)),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    }
                                                    return Container();
                                                  }),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(widget.idString)
                                                      .collection('versions')
                                                      .where('type',
                                                      isEqualTo: 'sub2')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot4) {
                                                    if (snapshot4.hasData) {
                                                      int quantity2 = 0;
                                                      var sub2Quantity;
                                                      snapshot4.data!.docs.map(
                                                              (DocumentSnapshot
                                                          document) {
                                                            Map<String, dynamic> data3 =
                                                            document.data()! as Map<
                                                                String, dynamic>;
                                                            if (data3['unit_qtity'] !=
                                                                '') {
                                                              quantity2 += int.parse(
                                                                  data3['unit_qtity']);
                                                              sub2Quantity =
                                                                  quantity2.toString();
                                                            } else
                                                              return Container();
                                                          }).toList();
                                                      if (sub2Quantity != null) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Sub2 Quantity',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  fontSize: 16,
                                                                  // letterSpacing: 2,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '$sub2Quantity $sub2Name',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                color: Colors.blueGrey
                                                                    .withOpacity(1.0),
                                                              ),
                                                            ),
                                                            Container(
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                height: 1.5,
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.3)),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    }
                                                    return Container();
                                                  }),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(widget.idString)
                                                      .collection('versions')
                                                      .where('type',
                                                      isEqualTo: 'sub3')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                      snapshot5) {
                                                    if (snapshot5.hasData) {
                                                      int quantity3 = 0;
                                                      var sub3Quantity;
                                                      snapshot5.data!.docs.map(
                                                              (DocumentSnapshot
                                                          document) {
                                                            Map<String, dynamic> data4 =
                                                            document.data()! as Map<
                                                                String, dynamic>;
                                                            if (data4['unit_qtity'] !=
                                                                '') {
                                                              quantity3 += int.parse(
                                                                  data4['unit_qtity']);
                                                              sub3Quantity =
                                                                  quantity3.toString();
                                                            } else
                                                              return Container();
                                                          }).toList();
                                                      // print(sub1Quantity);
                                                      // print(mainQuantity);
                                                      if (sub3Quantity != null) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Sub3 Quantity',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  fontSize: 16,
                                                                  // letterSpacing: 2,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '$sub3Quantity $sub3Name',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                color: Colors.blueGrey
                                                                    .withOpacity(1.0),
                                                              ),
                                                            ),
                                                            Container(
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width,
                                                                height: 1.5,
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.3)),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    }
                                                    return Container();
                                                  }),
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Pricing",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Text(
                                              'Main Unit Price',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                // letterSpacing: 2,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            mainPrice,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey.withOpacity(1.0),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              height: 1.5,
                                              color: Colors.grey.withOpacity(0.3)),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          sub1Price != ""
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub1 Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub1Price,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub2Price != ""
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub2 Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub2Price,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub3Price != ""
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub3 Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub3Price,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub1Unit != ""
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Sub per Main Unit",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    letterSpacing: 2,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Sub1',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub1Unit,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub2Unit != ""
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub2',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub2Unit,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub3Unit != ""
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub3',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub3Unit,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          mainLoss != "0"
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Main Unit Loss',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                mainLoss,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub1Loss != "0"
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub1 Loss',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub1Loss,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          sub2Loss != "0"
                                              ? Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Sub2 Loss',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    // letterSpacing: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                sub2Loss,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 1.5,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          )
                                              : Container(),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "OTHER INFORMATION",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                letterSpacing: 2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          _productDetails('Bar Code', barcode),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "PRODUCT IMAGES",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                letterSpacing: 2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 100,
                                            child: ListView(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullscreenSliderDemo(
                                                                      0)));
                                                    },
                                                    child: Image.network(
                                                      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullscreenSliderDemo(
                                                                      1)));
                                                    },
                                                    child: Image.network(
                                                      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullscreenSliderDemo(
                                                                      2)));
                                                    },
                                                    child: Image.network(
                                                      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullscreenSliderDemo(
                                                                      3)));
                                                    },
                                                    child: Image.network(
                                                      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullscreenSliderDemo(
                                                                      4)));
                                                    },
                                                    child: Image.network(
                                                      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      );
                  }
                  return Container();
                })
        ),
      ),
    );
  }
  List <String> prodList = [];
  lossProduct(data) async {
    _displayTextInputDialog(context, data);
    print(data.toString());
  }



  subsDataStream(Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: documentStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            var output = snapshot.data!.data();
            var prodName = output?['prod_name'];


          }
          return Container();
        });
  }
}

class _productDetails extends StatelessWidget {
  late final String title_text;
  late final String quantity_price;
  _productDetails(this.title_text, this.quantity_price);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            title_text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              // letterSpacing: 2,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            quantity_price,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

zeroToTen(String string) {
  if (int.parse(string) > 9) {
    return string;
  } else {
    return '0' + string;
  }
}

class FullscreenSliderDemo extends StatelessWidget {
  final int index;
  FullscreenSliderDemo(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            return Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: height,
                    initialPage: index,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    // autoPlay: false,
                  ),
                  items: imgList
                      .map((item) => Container(
                    child: Center(
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: height,
                        )),
                  ))
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: Colors.black),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
