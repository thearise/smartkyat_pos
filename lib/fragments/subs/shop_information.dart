

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';

import '../../app_theme.dart';

class ShopInformation extends StatefulWidget {
  const ShopInformation({Key? key}) : super(key: key);

  @override
  _ShopInformationState createState() => _ShopInformationState();
}

class _ShopInformationState extends State<ShopInformation>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ShopInformation>{
  @override
  bool get wantKeepAlive => true;
  var shopId;
  var _shop ;
  final _formKey = GlobalKey<FormState>();
  bool firstTime = true;

  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();


  @override
  initState() {
    HomePageState().getStoreId().then((value) {
      setState(() {
        shopId = value.toString();
      });

    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Form(
          key: _formKey,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Information',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Shop settings',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text('SHOP INFORMATION', style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,color: Colors.grey,
                ),),
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.hasData) {
                      var output = snapshot.data!.data();
                      String sName = output?['shop_name'];
                      String sAddress = output?['shop_address'];
                      String sPhone = output?['shop_phone'];
                      _shopName.text = sName;
                      _address.text =sAddress;
                      _phone.text = sPhone;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
                        child: TextFormField(
                          //obscureText: _obscureText,
                          controller: _shopName,
                          //initialValue: sName,
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
                            suffixText: 'Required' ,
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
                            labelText: 'Shop name',
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
                    padding: const EdgeInsets.only(top: 20.0,left: 15, right: 15),
                    child: TextFormField(
                      //obscureText: _obscureText,
                      controller: _address,
                     // initialValue: sAddress,
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
                        suffixText: 'Required' ,
                        suffixStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'capsulesans',
                        ),
                        //errorText: wrongPassword,
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
                        labelText: 'Shop address',
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
                    padding: const EdgeInsets.only(top: 20.0,left: 15, right: 15),
                    child: TextFormField(
                    //obscureText: _obscureText,
                    controller: _phone,
                     // initialValue: sPhone,
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
                    suffixText: 'Required' ,
                    suffixStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'capsulesans',
                    ),
                    //errorText: wrongPassword,
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
                    labelText: 'Phone',
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
                  );
                }
                    return Container();
                 }
              ),

              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
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

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 2.0),
                      child: Container(
                        child: Text(
                          'Save and exit',
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
            ],
          ),
        ),
      ),

    );
  }
}