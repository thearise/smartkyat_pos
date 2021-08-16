import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';

import '../app_theme.dart';

class CustomersFragment extends StatefulWidget {
  CustomersFragment({Key? key}) : super(key: key);

  @override
  _CustomersFragmentState createState() => _CustomersFragmentState();
}

class _CustomersFragmentState extends State<CustomersFragment> {
  @override
  initState() {
    // await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      220,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: ListView(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Customers',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ButtonTheme(
                            splashColor: Colors.transparent,
                            minWidth: MediaQuery.of(context).size.width,
                            height: 56,
                            child: FlatButton(
                              color: AppTheme.skThemeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: BorderSide(
                                  color: AppTheme.skThemeColor,
                                ),
                              ),
                              onPressed: () {
                                addNewProd(context);
                              },
                              child: Text(
                                'Add new customers',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('space')
                                .doc('0NHIS0Jbn26wsgCzVBKT')
                                .collection('shops')
                                .doc('PucvhZDuUz3XlkTgzcjb')
                                .collection('customers')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }

                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  // return ListTile(
                                  //   title: Text(data['prod_name']),
                                  // );
                                  return CustomerInfo(data['customer_name'],
                                      'Monywa', '(+959)794335708');

                                }).toList(),
                              );
                            }
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Icon(
                              Icons.search,
                              size: 26,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                  child: Text(
                                'Search',
                                style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //addDailyExp(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 15.0,
                              ),
                              child: SizedBox(
                                width: 34,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.bar_chart,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QRViewExample()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
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
                                          Navigator.pop(context);
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

  addNewProd(priContext) {
    final List<String> prodFieldsValue = [];
    final _formKey = GlobalKey<FormState>();
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: SafeArea(
              top: true,
              bottom: true,
              child: Column(
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

                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 85,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                width: 1.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                        .validate() ||
                                                    !_formKey.currentState!
                                                        .validate()) {
                                                  if (prodFieldsValue.length >
                                                      0) {
                                                    showOkCancelAlertDialog(
                                                      context: context,
                                                      title: 'Are you sure?',
                                                      message:
                                                          'You added data in some inputs.',
                                                      defaultType:
                                                          OkCancelAlertDefaultType
                                                              .cancel,
                                                    ).then((result) {
                                                      if (result ==
                                                          OkCancelResult.ok) {
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          Text(
                                            "Add new customer",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontFamily: 'capsulesans',
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                                color: AppTheme.skThemeColor),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // If the form is valid, display a snackbar. In the real world,
                                                  // you'd often call a server or save the information in a database.
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Processing Data')),
                                                  );
                                                  // print(prodFieldsValue);

                                                  CollectionReference spaces =
                                                      FirebaseFirestore.instance
                                                          .collection('space');
                                                  var prodExist = false;
                                                  var spaceDocId = '';
                                                  FirebaseFirestore.instance
                                                      .collection('space')
                                                      .where('user_id',
                                                          isEqualTo:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                      .get()
                                                      .then((QuerySnapshot
                                                          querySnapshot) {
                                                    querySnapshot.docs
                                                        .forEach((doc) {
                                                      spaceDocId = doc.id;
                                                    });

                                                    print('space shi p thar');
                                                    getStoreId()
                                                        .then((String result2) {
                                                      print('store id ' +
                                                          result2.toString());

                                                      FirebaseFirestore.instance
                                                          .collection('space')
                                                          .doc(spaceDocId)
                                                          .collection('shops')
                                                          .doc(result2)
                                                          .collection(
                                                              'customers')
                                                          .where(
                                                              'customer_name',
                                                              isEqualTo:
                                                                  prodFieldsValue[
                                                                      0])
                                                          .get()
                                                          .then((QuerySnapshot
                                                              querySnapshot) async {
                                                        querySnapshot.docs
                                                            .forEach((doc) {
                                                          prodExist = true;
                                                        });

                                                        if (prodExist) {
                                                          print(
                                                              'product already');
                                                          var result =
                                                              await showOkAlertDialog(
                                                            context: context,
                                                            title: 'Warning',
                                                            message:
                                                                'Product name already!',
                                                            okLabel: 'OK',
                                                          );
                                                        } else {
                                                          CollectionReference
                                                              shops =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'space')
                                                                  .doc(
                                                                      spaceDocId)
                                                                  .collection(
                                                                      'shops')
                                                                  .doc(result2)
                                                                  .collection(
                                                                      'customers');
                                                          return shops.add({
                                                            'customer_name':
                                                                prodFieldsValue[
                                                                    0]
                                                          }).then((value) {
                                                            print(
                                                                'product added');

                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        }
                                                      });
                                                    });
                                                  });
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     Container(
                                  //       padding: EdgeInsets.only(left: 15),
                                  //       height: 130,
                                  //       width: 150,
                                  //       child: Image.network(
                                  //         'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
                                  //         fit: BoxFit.fill,
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: 20,
                                  //     ),
                                  //     Container(
                                  //       width: 200,
                                  //       child: Expanded(
                                  //           child: Text(
                                  //             "Add images to show customers product details and features",
                                  //             style: TextStyle(
                                  //               color: Colors.amberAccent,
                                  //               fontSize: 15,
                                  //               fontWeight: FontWeight.w500,
                                  //             ),
                                  //           )),
                                  //     ),
                                  //   ],
                                  // ),

                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(top: 20, left: 15),
                                    child: Text(
                                      "CONTACT INFORMATION",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        letterSpacing: 2,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: TextFormField(
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        prodFieldsValue.add(value);
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            top: 20.0,
                                            bottom: 20.0),
                                        suffixText: 'Required',
                                        suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'capsulesans',
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        // errorText: 'Error message',
                                        labelText: 'First name',
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: TextFormField(
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        prodFieldsValue.add(value);
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            top: 20.0,
                                            bottom: 20.0),
                                        suffixText: 'Required',
                                        suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'capsulesans',
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        // errorText: 'Error message',
                                        labelText: 'Address',
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: TextFormField(
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        prodFieldsValue.add(value);
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            top: 20.0,
                                            bottom: 20.0),
                                        suffixText: 'Required',
                                        suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'capsulesans',
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        // errorText: 'Error message',
                                        labelText: 'Phone number',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Future<String> getStoreId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return(prefs.getString('store'));

  var index = prefs.getString('store');
  print(index);
  if (index == null) {
    return 'idk';
  } else {
    return index;
  }
}

class CustomerInfo extends StatelessWidget {
  final String customerName;
  final String customerAddress;
  final String customerPhone;

  CustomerInfo(this.customerName, this.customerAddress, this.customerPhone);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                customerAddress,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey.withOpacity(1.0),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                customerPhone,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey.withOpacity(1.0),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.blueGrey.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}
