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
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
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
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                        int subExist = output?['sub_exist'];
                        List<String> subSell = [];
                        List<String> subLink = [];
                        List<String> subName = [];
                        for(int i = 0; i < subExist; i++) {
                          subSell.add(output?['sub' + (i+1).toString() + '_sell']);
                          subLink.add(output?['sub' + (i+1).toString() + '_link']);
                          subName.add(output?['sub' + (i+1).toString() + '_name']);
                        }
                        print(subSell.toString() + subLink.toString() + subName.toString());
                        return Column(
                          children: [
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
                                        // if (sub1Name == '') {
                                        //   widget._callback(widget.idString +
                                        //       '-' +
                                        //       '-' +
                                        //       mainPrice +
                                        //       '-unit_name-1'.toString());
                                        // } else {
                                        //   final result =
                                        //   await showModalActionSheet<String>(
                                        //     context: context,
                                        //     actions: [
                                        //       SheetAction(
                                        //         icon: Icons.info,
                                        //         label: '1 ' + output?['unit_name'],
                                        //         key: widget.idString +
                                        //             '-' +
                                        //             '-' +
                                        //             output?['unit_sell'] +
                                        //             '-unit_name-1',
                                        //       ),
                                        //       for(int i =1; i <= subSell.length; i++)
                                        //         if(subSell[i] != '')
                                        //           SheetAction(
                                        //             icon: Icons.info,
                                        //             label: '1 ' + subName[i],
                                        //             key: widget.idString +
                                        //                 '-' +
                                        //                 '-' +
                                        //                 subSell[i] +
                                        //                 '-sub1_name-1',
                                        //           ),
                                        //
                                        //     ],
                                        //   );
                                        //
                                        //   widget._callback(result.toString());
                                        // }
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
                            Text(subSell.toString() + subLink.toString() + subName.toString()),
                          ],
                        );

                      }
                      return Container();
                    })
              ]),
        ),
      ),
    );
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
