import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';

class SettingsFragment extends StatefulWidget {
  SettingsFragment({Key? key}) : super(key: key);

  @override
  _SettingsFragmentState createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SettingsFragment>{
  @override
  bool get wantKeepAlive => true;
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  addShop(shopName) {
    CollectionReference spaces = FirebaseFirestore.instance.collection('space');
    var exist = false;
    var docId = '';
    var shopExist = false;
    FirebaseFirestore.instance
        .collection('space')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        docId = doc.id;
        exist = true;
      });

      if(exist) {
        print('space shi p thar');

        FirebaseFirestore.instance
            .collection('space').doc(docId).collection('shops')
            .where('shop_name', isEqualTo: shopName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            shopExist = true;
          });

          if(shopExist) {
            print('shop already');

          } else {
            CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(docId).collection('shops');
            return shops
                .add({
              'shop_name': shopName
            })
                .then((value) {
              print('shop added');
            });
          }
        });


      } else {
        print('space mshi vuu');
        return spaces
            .add({
          'user_id': FirebaseAuth.instance.currentUser!.uid
        })
            .then((value) {
          CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(value.id).collection('shops');

          return shops
              .add({
            'shop_name': shopName
          })
              .then((value) {
            print('shop added');
          });

        }).catchError((error) => print("Failed to add shop: $error"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only( left: 8.0, right: 8.0),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 16.5),
                child: Text('Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))),
                child: FlatButton(
                  height: 75,
                  onPressed: () {  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => chooseStore()),
                  );
                  },
                  child: Row(
                    children: [
                      Text('Shops',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                        color: Colors.blueGrey.withOpacity(0.8),
                        size: 16,),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))),
                child: FlatButton(
                  height: 75,
                  onPressed: () { },
                  child: Row(
                    children: [
                      Text('Screen Lock',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                        color: Colors.blueGrey.withOpacity(0.8),
                        size: 16,),
                    ],
                  ),
                ),
              ),
              FlatButton(
                height: 75,
                onPressed: () { },
                child: Row(
                  children: [
                    Text('Dark/light mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,
                      color: Colors.blueGrey.withOpacity(0.8),
                      size: 16,),
                  ],
                ),
              ),
            ],
          ),
        )


    );
  }


  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag:false,
        isScrollControlled:true,
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
                              color: Colors.white.withOpacity(0.5)
                          ),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: () {
                                        },

                                      ),
                                      Text(
                                        "New Expense",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'capsulesans',
                                            fontWeight: FontWeight.w600
                                        ),
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
}

