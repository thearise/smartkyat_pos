import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';

import '../../app_theme.dart';
import '../app_theme.dart';

class StaffSettingsSub extends StatefulWidget {

  const StaffSettingsSub({Key? key}) : super(key: key);

  @override
  _StaffSettingsSubState createState() => _StaffSettingsSubState();
}

class _StaffSettingsSubState extends State<StaffSettingsSub>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<StaffSettingsSub>{
  var _searchUserMail;

  DropdownEditingController<String> _staffSearchCtl = DropdownEditingController<String>();

  @override
  bool get wantKeepAlive => true;

  var _result;
  var _shop ;
  bool firstTime = true;

  @override
  initState() {
    HomePageState().getStoreId().then((value) {
      setState(() {
        _result = value.toString();
      });

    });

    _staffSearchCtl.addListener((){
      // setState(() {
      //   gloSearchText = _searchController.text;
      //   searchValue = _searchController.text;
      // });
      // searchKeyChanged();
      print('GG STAFF ' + _staffSearchCtl.value.toString());
    });
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
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(_result)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if(snapshot.hasData) {
                var output = snapshot.data!.data();
                var usersList = output?['users'];
                print(usersList.toString());
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 80,
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
                                        'Staff settings',
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
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                              child: Text('STAFF LIST', style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,color: Colors.grey,
                              )),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                splashColor: Colors.transparent,
                                height: 50,
                                child: FlatButton(
                                  color: AppTheme.buttonColor2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: AppTheme.buttonColor2,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final textInput = await showTextInputDialog(
                                      context: context,
                                      textFields: const [
                                        DialogTextField(
                                          hintText: 'johndoe@gmail.com',
                                        ),
                                      ],
                                      title: 'Enter an email',
                                      message: 'To add an staff, we need an email associated with that user account',
                                    );
                                    // print('Text ' + textInput![0].toString());
                                    // logger.info(text);

                                    await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                        {'users': FieldValue.arrayUnion([textInput![0].toString()]),}
                                    ).then((value) async {
                                      print('users added');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 2.0),
                                    child: Container(
                                      child: Text(
                                        'Add staff',
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
                            SizedBox(height: 20,),
                            for (int i = 0;
                            i < usersList.length;
                            i++)
                              if((FirebaseAuth.instance.currentUser == null? '':FirebaseAuth.instance.currentUser!.email) != usersList[i].toString())
                                Padding(
                                  padding: EdgeInsets.only(left: i == usersList.length-1? 0.0:15.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                              color: i == usersList.length-1? Colors.transparent: AppTheme.skBorderColor2,
                                              width: 1.0),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('email', isEqualTo: usersList[i].toString())
                                              .limit(1)
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            print('check1 ' + usersList[i].toString());
                                            if(snapshot2.hasData) {
                                              print('hasData' + snapshot2.data!.docs.length.toString());
                                              if(snapshot2.data!.docs.length == 0) {
                                                return Container(
                                                  height: 50,
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          height: 45,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                width: i == usersList.length-1? 15: 0,
                                                              ),
                                                              Text('Unknown user', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.blue),),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Expanded(child: Text(usersList[i].toString(), textAlign: TextAlign.end, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.black54),)),
                                                              Container(
                                                                // color: Colors.grey,
                                                                height: 45,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 0.0),
                                                                  child: IconButton(
                                                                      icon: Icon(
                                                                        Icons.remove_circle_rounded,
                                                                        size: 18,
                                                                        color: Colors.red,
                                                                      ),
                                                                      onPressed: () {
                                                                        showOkCancelAlertDialog(
                                                                          context: context,
                                                                          title: 'Confirmation alert',
                                                                          message: 'Are you sure you want to remove unknown user (' + usersList[i].toString() + ') from current shop?',
                                                                          defaultType: OkCancelAlertDefaultType.cancel,
                                                                        ).then((result) async {
                                                                          if(result == OkCancelResult.ok) {
                                                                            await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                                                                {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                                                            ).then((value) async {
                                                                              print('users removed');
                                                                            });
                                                                          }
                                                                        }
                                                                        );
                                                                      }
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]
                                                  ),
                                                );
                                              }
                                              return Container(
                                                height: 50,
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: snapshot2.data!.docs.map((DocumentSnapshot document) {
                                                      print('hasData' + snapshot2.data!.docs.length.toString());
                                                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                                      print('email found ' + data.toString());
                                                      return Container(
                                                        height: 45,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              width: i == usersList.length-1? 15: 0,
                                                            ),
                                                            Text(data['name'], style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5),),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(child: Text(usersList[i].toString(), textAlign: TextAlign.end, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.black54),)),
                                                            Container(
                                                              // color: Colors.grey,
                                                              height: 45,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 0.0),
                                                                child: IconButton(
                                                                    icon: Icon(
                                                                      Icons.remove_circle_rounded,
                                                                      size: 18,
                                                                      color: Colors.red,
                                                                    ),
                                                                    onPressed: () {
                                                                      showOkCancelAlertDialog(
                                                                        context: context,
                                                                        title: 'Confirmation alert',
                                                                        message: 'Are you sure you want to remove ' + data['name'] + ' (' + usersList[i].toString() + ') from current shop?',
                                                                        defaultType: OkCancelAlertDefaultType.cancel,
                                                                      ).then((result) async {
                                                                        if(result == OkCancelResult.ok) {
                                                                          await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                                                              {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                                                          ).then((value) async {
                                                                            print('users removed');
                                                                          });
                                                                        }
                                                                      }
                                                                      );
                                                                    }
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList()
                                                ),
                                              );

                                            }
                                            return Container();
                                            // return Column(
                                            //     mainAxisAlignment: MainAxisAlignment.center,
                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                            //     children: [
                                            //       Text('Pending...', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.blue),)
                                            //     ]
                                            // );
                                          }
                                      ),
                                    ),
                                  ),
                                ),
                                // Slidable(
                                //   key: UniqueKey(),
                                //   actionPane:
                                //   SlidableDrawerActionPane(),
                                //   actionExtentRatio:
                                //   0.25,
                                //   child: Padding(
                                //     padding: EdgeInsets.only(left: i == usersList.length-1? 0.0:15.0),
                                //     child: Container(
                                //       height: 50,
                                //       decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           border: Border(
                                //             bottom: BorderSide(
                                //                 color: i == usersList.length-1? Colors.transparent: AppTheme.skBorderColor2,
                                //                 width: 1.0),
                                //           )
                                //       ),
                                //       child: Padding(
                                //         padding: const EdgeInsets.only(bottom: 4.0),
                                //         child: Row(
                                //           children: [
                                //             SizedBox(
                                //               width: i == usersList.length-1? 15: 0,
                                //             ),
                                //             StreamBuilder(
                                //                 stream: FirebaseFirestore.instance
                                //                     .collection('users')
                                //                     .where('email', isEqualTo: usersList[i].toString())
                                //                     .limit(1)
                                //                     .snapshots(),
                                //                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                //                   print('check1 ' + usersList[i].toString());
                                //                   if(snapshot2.hasData) {
                                //                     print('hasData' + snapshot2.data!.docs.length.toString());
                                //                     return Column(
                                //                       mainAxisAlignment: MainAxisAlignment.center,
                                //                       crossAxisAlignment: CrossAxisAlignment.start,
                                //                       children: snapshot2.data!.docs.map((DocumentSnapshot document) {
                                //                         print('hasData' + snapshot2.data!.docs.length.toString());
                                //                         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                //                         print('email found ' + data.toString());
                                //                         return Text(data['name'], style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5),);
                                //                       }).toList()
                                //                     );
                                //
                                //                   }
                                //                   return Container();
                                //                   // return Column(
                                //                   //     mainAxisAlignment: MainAxisAlignment.center,
                                //                   //     crossAxisAlignment: CrossAxisAlignment.start,
                                //                   //     children: [
                                //                   //       Text('Pending...', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.blue),)
                                //                   //     ]
                                //                   // );
                                //               }
                                //             ),
                                //             SizedBox(
                                //               width: 15,
                                //             ),
                                //             Expanded(child: Text(usersList[i].toString(), textAlign: TextAlign.end, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15.5, color: Colors.black54),)),
                                //             SizedBox(
                                //               width: 15,
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                //   dismissal:
                                //   SlidableDismissal(
                                //     child:
                                //     SlidableDrawerDismissal(),
                                //     onDismissed:
                                //         (actionType) async {
                                //       await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                //           {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                //       ).then((value) async {
                                //         print('users removed');
                                //       });
                                //       // setState((){
                                //       //   // mystate(() {
                                //       //   //   prodList
                                //       //   //       .removeAt(
                                //       //   //       i);
                                //       //   // });
                                //       // });
                                //     },
                                //   ),
                                //   secondaryActions: <
                                //       Widget>[
                                //     IconSlideAction(
                                //       caption: 'Delete',
                                //       color: Colors.red,
                                //       icon:
                                //       Icons.delete,
                                //       onTap: () async {
                                //         await FirebaseFirestore.instance.collection('shops').doc(_result).update(
                                //             {'users': FieldValue.arrayRemove([usersList[i].toString()]),}
                                //         ).then((value) async {
                                //           print('users removed');
                                //         });
                                //         // setState((){
                                //         //   mystate(() {
                                //         //     prodList
                                //         //         .removeAt(
                                //         //         i);
                                //         //   });
                                //         // });
                                //       },
                                //     ),
                                //   ],
                                // ),
                            // SizedBox(height: 20,),
                            // Padding(
                            //   padding: const EdgeInsets.only(left:15.0, right: 15.0),
                            //   child: RichText(
                            //     text: new TextSpan(
                            //       children: [
                            //         new TextSpan(
                            //           text: 'Slide left to remove the staff from the current shop.',
                            //           style: new TextStyle(
                            //               fontSize: 12.5,
                            //               color: Colors.grey,
                            //               fontWeight: FontWeight.w500
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),

                    ]
                );
              }
              return Container();
          }
        ),
      ),
    );
  }


  final _formKey = GlobalKey<FormState>();
  // final auth = FirebaseAuth.instance;
  final _accountName = TextEditingController();
  final _email = TextEditingController();
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();

  


}



