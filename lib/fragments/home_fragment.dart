import 'package:flutter/material.dart';

import '../app_theme.dart';

class HomeFragment extends StatefulWidget {
  HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
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
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom-250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(child: Text('Home', style: TextStyle(fontSize: 20),)),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      addDailyExp(context);
                    },
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
                            Padding(
                              padding: const EdgeInsets.only(right:15.0,),
                              child: Icon(Icons.bar_chart, color: Colors.green, size: 22,),
                            )
                          ],
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


  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag:false,
        isScrollControlled:true,
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
                              child: Column(
                                children: [
                                  Container(
                                    height: 85,
                                    decoration: BoxDecoration(

                                      border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
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
                                                color: Colors.grey.withOpacity(0.3)
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },

                                            ),
                                          ),
                                          Text(
                                            "Add new product",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontFamily: 'capsulesans',
                                                fontWeight: FontWeight.w600
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                                color: AppTheme.skThemeColor
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },

                                            ),
                                          )

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
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     color: Colors.yellow,
                  //     height: 100,
                  //   ),
                  // )
                ],
              ),
            ),
          );

        });
  }



}
