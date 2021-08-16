import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/pages/home_page.dart';

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
      appBar: AppBar(
        title: Text('Your Stores'),
      actions: [
        IconButton (icon: Icon(Icons.check), onPressed: () { showOkCancelAlertDialog(
          context: context,
          title: 'Are you sure to change $_shop ?',
          message: 'Click OK to Continue !',
          defaultType: OkCancelAlertDefaultType.cancel,
        ).then((result) {
          if(result == OkCancelResult.ok) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          }
        }
        );
        },
        ),
      ]
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
             var index =0;
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                index++;
                return  Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: index==snapshot.data!.docs.length? BorderSide(color: Colors.transparent, width: 0): BorderSide(
                              color: Colors.grey
                                  .withOpacity(0.3),
                              width: 1.0))),
                  child: RadioListTile(
                      title: Text(data['shop_name']),
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
              )
                  .toList(),
            );

          }
      )
    );
  }
}
