import 'package:flutter/material.dart';

import '../app_theme.dart';

class ApplyDiscount extends StatefulWidget {
  const ApplyDiscount({Key? key}) : super(key: key);

  @override
  _ApplyDiscountState createState() => _ApplyDiscountState();
}

class _ApplyDiscountState extends State<ApplyDiscount> {
  final List<String> prodFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Apply discount to cart', style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close,
          color: Colors.black,), onPressed: () {  },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check,
            color: Colors.black,), onPressed: () { Navigator.pop(context); },
          )
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  "DISCOUNT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Colors.grey,
                  ),
                ),),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {},
                child: Text('Clear discount', style: TextStyle(
                  fontSize: 13,
                ),),
              ),
            ),
          ],
        ),
        DefaultTabController(
          length: 2, // length of tabs
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: AppTheme.buttonColor2,
                    ),
                     borderRadius: BorderRadius.all(
                      Radius.circular(10),),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 2,
                            color: AppTheme.buttonColor2,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: AppTheme.buttonColor2,
                          ),
                        ),
                        //borderRadius: BorderRadius.circular(20), // Creates border
                        color: AppTheme.buttonColor2),
                    //indicatorColor: Colors.transparent,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Amount (Ks)'),
                      Tab(text: 'Percentage (%)'),
                    ],
                  ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                height: 200,
                child: TabBarView(children: <Widget>[
                  ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5),
                              child:
                              TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  prodFieldsValue.add(value);
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                  suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  // errorText: 'Error message',
                                  labelText: 'Amount',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  //filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  prodFieldsValue.add(value);
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                  suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  // errorText: 'Error message',
                                  labelText: 'Title',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  //filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5),
                              child: TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  prodFieldsValue.add(value);
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                  suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  // errorText: 'Error message',
                                  labelText: 'Percentage',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  //filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  prodFieldsValue.add(value);
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                  suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'capsulesans',),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  // errorText: 'Error message',
                                  labelText: 'Title',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  //filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
