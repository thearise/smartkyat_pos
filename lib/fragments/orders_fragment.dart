import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../app_theme.dart';

class OrdersFragment extends StatefulWidget {
  OrdersFragment({Key? key}) : super(key: key);

  @override
  _OrdersFragmentState createState() => _OrdersFragmentState();
}

class _OrdersFragmentState extends State<OrdersFragment>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<OrdersFragment>{
  @override
  bool get wantKeepAlive => true;
  var sectionList;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // CollectionReference daily_exps = ;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom-250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').orderBy('date', descending: true).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.hasData) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('customers').snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                              if(snapshot2.hasData) {
                                var sections = List<ExampleSection>.empty(growable: true);
                                // snapshot.data!.docs.map((document) {
                                // }).toList();

                                snapshot.data!.docs.map((document) async {

                                  // print('herre ' + document.id);
                                  var section = ExampleSection()
                                    ..header = document['date']
                                  // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                  //   ..items = listCreation(document.id, document['data'], document).cast<String>()
                                    ..items = sortList(changeData(document['daily_order'].cast<String>(), snapshot2))
                                  //   ..items = document['daily_order'].cast<String>()
                                    ..expanded = true;
                                  sections.add(section);
                                }).toList();
                                sectionList = sections;

                                return CustomScrollView(
                                  slivers: <Widget>[
                                    SliverExpandableList(
                                      builder: SliverExpandableChildDelegate(
                                        sectionList: sectionList,
                                        headerBuilder: _buildHeader,
                                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                                          String item = sectionList[sectionIndex].items[itemIndex];
                                          int length = sectionList[sectionIndex].items.length;


                                          // CollectionReference daily_exps_inner = FirebaseFirestore.instance
                                          //     .collection('users')
                                          //     .doc(FirebaseAuth.instance.currentUser!.uid)
                                          //     .collection('daily_exp').doc('2021').collection('month').doc('july').collection('day').doc(item).collection('expenses');


                                          // StreamBuilder(
                                          //   stream: daily_exps_inner.snapshots(),
                                          //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                                          //     if(snapshot3.hasData) {
                                          //
                                          //     } else {
                                          //       return Container();
                                          //     }
                                          //   },
                                          // )
                                          if(itemIndex == length-1) {
                                            return Column(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(item.split('^')[1]);
                                                    },
                                                    child: ListTile(
                                                      // leading: CircleAvatar(
                                                      //   child: Text("$index"),
                                                      // ),
                                                      // title: Text(item.split('^')[1]),
                                                        title: Text(item)
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.white,
                                                  width: double.infinity,
                                                  height: 15,
                                                )
                                              ],
                                            );
                                          }
                                          return Container(
                                            color: Colors.white,
                                            child: GestureDetector(
                                              onTap: () {
                                                print(item.split('^')[0].substring(0,8));
                                                var dateId = '';
                                                FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                                // FirebaseFirestore.instance.collection('space')
                                                    .where('date', isEqualTo: item.split('^')[0].substring(0,8))
                                                    .get()
                                                    .then((QuerySnapshot querySnapshot) {
                                                  querySnapshot.docs.forEach((doc) {
                                                    dateId = doc.id;
                                                    FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)

                                                        .update({
                                                      'daily_order': FieldValue.arrayRemove([item])
                                                    })
                                                        .then((value) {
                                                      print('array removed');

                                                      FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)

                                                          .update({
                                                        'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
                                                      })
                                                          .then((value) {
                                                        print('array updated');
                                                      });


                                                      // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
                                                      // .doc(item.split('^')[0])
                                                      //
                                                      //     .update({
                                                      //   'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
                                                      // })
                                                      //     .then((value) {
                                                      //   print('array updated');
                                                      // });
                                                      // 2021081601575511001^1-1001^total^name^pf

                                                    });
                                                  });
                                                });

                                              },
                                              child: ListTile(
                                                // leading: CircleAvatar(
                                                //   child: Text("$index"),
                                                // ),
                                                // title: Text(item.split('^')[1]),
                                                  title: Text(item)
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                );

                              } else {
                                return Container();
                              }
                            }
                          );
                        } else {
                          return Container();
                        }

                      }
                  )
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:15.0,),
                            child: Icon(Icons.search, size: 26,),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0, right: 8.0),
                              child: Container(child:
                              Text(
                                'Search',
                                style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)
                                ),
                              )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              addDailyExp(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right:15.0,),
                              child: Icon(Icons.bar_chart, color: Colors.green, size: 22,),
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

  changeData(list, snpsht) {
    // list[0].toString()
    snpsht.data!.docs.map((document) async {
      for(var i=0;i<list.length;i++) {
        if(document.id.toString() == list[i].split('^')[3]) {
          list[i] = list[i].split('^')[0] + '^' + list[i].split('^')[1] + '^' + list[i].split('^')[2] + '^' + document['customer_name'].toString() + '^' + list[i].split('^')[4];
        }

      }
      // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // print('changeData ' + snpsht.da);
    return list;

  }

  sortList(list) {
    var dlist = list;
    dlist.sort();
    var newList = List.from(dlist.reversed);
    // dlist.sort((a, b) => b.compareTo(a));
    return newList.cast<String>();
    // list.sort(alphabetic('name'));
  }



  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList[sectionIndex];
    return InkWell(
        child: Container(
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15, bottom: 0),
                  child: Text(
                    section.header.toUpperCase(),
                    style: TextStyle(
                        height: 0.8,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.grey
                    ),
                  ),
                ),
              ),
            )),
        onTap: () {
          //toggle section expand state
          // setState(() {
          //   section.setSectionExpanded(!section.isSectionExpanded());
          // });
        });
  }

  List<String> gloTemp = [];

  // listCreation(String id, data, document) {
  //   List<String> temp = [];
  //   // temp.add('add');
  //   // temp.add('add2');UzZeGlXAnNfrH7icA1ki
  //
  //   // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(id).collection('detail')
  //   //     .get()
  //   //     .then((QuerySnapshot querySnapshot) {
  //   //   querySnapshot.docs.forEach((doc) {
  //   //     temp.add(doc["cust_name"]);
  //   //     // setState(() {
  //   //     //   gloTemp = temp;
  //   //     // });
  //   //     // gloTemp = temp;
  //   //   });
  //   //
  //   // }).then((value) {
  //   //   // print('here ' + temp.toString());
  //   //   //return temp;
  //   //   // return gloTemp;
  //   // });
  //   // print('here2 ' + temp.toString());
  //   // return gloTemp;
  //
  //
  //   // for()
  //   // var noExe = true;
  //
  //
  //   temp = data.split('^');
  //
  // }


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


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Container _tabBar;

  @override
  double get minExtent => 101;
  @override
  double get maxExtent => 101;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      height: 200,
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}


///Section model example
///
///Section model must implements ExpandableListSection<T>, each section has
///expand state, sublist. "T" is the model of each item in the sublist.
class ExampleSection implements ExpandableListSection<String> {
  //store expand state.
  late bool expanded;

  //return item model list.
  late List<String> items;

  //example header, optional
  late String header;

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}