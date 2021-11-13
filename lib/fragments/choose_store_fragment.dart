import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/add_shop_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';

import '../app_theme.dart';


class chooseStore extends StatefulWidget {
  const chooseStore({Key? key}) : super(key: key);



  @override
  _chooseStoreState createState() => _chooseStoreState();
}

class _chooseStoreState extends State<chooseStore> {

  var _result;
  var _shop ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                 // shrinkWrap: true,
                  children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0, bottom: 25.0),
                              child: Container(
                                  child: Image.asset('assets/system/smartkyat.png', height: 68, width: 68,),
                              ),
                            ),
                          ),

                      Text('REGISTERED SHOPS', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15, letterSpacing: 2,
                        color: Colors.grey,),),
                      SizedBox(height: 18,),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(snapshot.hasData) {
                              var index = 0;
                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  index++;
                                  return  Container(
                                    margin: EdgeInsets.only(bottom: 18),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                                      color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0)),
                                       ),
                                    child: RadioListTile(
                                        title: Text(data['shop_name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        activeColor: AppTheme.themeColor,
                                        value: document.id.toString(),
                                        groupValue: _result,
                                        onChanged: (value) {
                                          setState(() {
                                            _result = value;
                                            _shop= data['shop_name'];
                                            print(_result);
                                          });
                                        }
                                    ),
                                  );
                                }
                                ).toList(),
                              );
                            }
                            return Container();
                          }
                      ),
                      SizedBox(height: 10,),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        splashColor: Colors.transparent,
                        height: 53,
                        child: FlatButton(
                          color: AppTheme.buttonColor2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: AppTheme.buttonColor2,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddShop()),);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 5.0,
                                bottom: 2.0),
                            child: Container(
                              child: Text(
                                'Create new shop',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Text('Set up some information about your shop later in shop settings.'),
                  ],
                ),
              ),
             // SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 40.0),
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,
                          splashColor: Colors.transparent,
                          height: 53,
                          child: FlatButton(
                            color: AppTheme.themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: AppTheme.themeColor,
                              ),
                            ),
                            onPressed: () {
                              showOkCancelAlertDialog(
                                context: context,
                                title: 'Are you sure to change $_shop ?',
                                message: 'Click OK to Continue !',
                                defaultType: OkCancelAlertDefaultType.cancel,
                              ).then((result) {
                                if(result == OkCancelResult.ok) {
                                  setStoreId(_result);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                                }
                              }
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  bottom: 2.0),
                              child: Container(
                                child: Text(
                                  _shop!= null ?'Enter as $_shop' : 'Enter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
      )
    );
  }

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('store', id);
  }
}
