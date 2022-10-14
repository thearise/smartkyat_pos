import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/add_new_category_button.dart';

class StaffFragment extends StatefulWidget {
  StaffFragment({Key? key}) : super(key: key);

  @override
  _StaffFragmentState createState() => _StaffFragmentState();
}

class _StaffFragmentState extends State<StaffFragment>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<StaffFragment>{
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
                  height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom-220,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text('Staffs', textScaleFactor: 1,
                            style: TextStyle(fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AddNewCategory("Add new Staff"),
                      ],
                    ),
                  ),
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
                                'Search', textScaleFactor: 1,
                                style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500,
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
                                        "New Expense", textScaleFactor: 1,
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
                                          debugPrint('clicked');
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
