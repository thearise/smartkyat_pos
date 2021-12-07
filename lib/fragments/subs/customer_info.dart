import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';
import 'package:smartkyat_pos/widgets/edit_customer.dart';
import '../../app_theme.dart';
import 'customer_orders_info.dart';

class CustomerInfoSubs extends StatefulWidget {
  final _callback;
  const CustomerInfoSubs({Key? key, required this.id, required this.shopId, required void toggleCoinCallback(String str)}) : _callback = toggleCoinCallback;
  final String id;
  final String shopId;

  @override
  _CustomerInfoSubsState createState() => _CustomerInfoSubsState();
}

class _CustomerInfoSubsState extends State<CustomerInfoSubs> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    //HomePageState().getStoreId().then((value) => shopId = value);
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(widget.shopId)
                .collection('customers')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var customerName = output?['customer_name'];
                var address = output?['customer_address'];
                var phone = output?['customer_phone'];
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
                                            address,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        customerName,
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
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  SizedBox(height: 15,),
                                  Container(
                                    height: 110,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: ButtonTheme(
                                            minWidth: 143,
                                            //minWidth: 50,
                                            splashColor: Colors.transparent,
                                            height: 100,
                                            child: FlatButton(
                                              color: AppTheme.buttonColor2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7.0),
                                                side: BorderSide(
                                                  color: AppTheme.buttonColor2,
                                                ),
                                              ),
                                              onPressed: () async {
                                                widget._callback(widget.id.toString() + '-' + customerName);
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 10,
                                                      left: 0,
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 7.0),
                                                            child: Icon(
                                                              SmartKyat_POS.customer1,
                                                              size: 17.5,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 14.0, top: 11.0),
                                                            child: Icon(
                                                              SmartKyat_POS.customer2,
                                                              size: 9,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5.0, top: 5),
                                                            child: Container(
                                                              width: 8,
                                                              height: 7.5,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  color: Colors.black),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 14.5, top: 7.5),
                                                            child: Container(
                                                              width: 5,
                                                              height: 4.5,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  color: Colors.black),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 0,
                                                      child: Text(
                                                        'Add to\ncart',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ButtonTheme(
                                          minWidth: 143,
                                          //minWidth: 50,
                                          splashColor: Colors.transparent,
                                          height: 100,
                                          child: FlatButton(
                                            color: AppTheme.buttonColor2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              side: BorderSide(
                                                color: AppTheme.buttonColor2,
                                              ),
                                            ),
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CustomerOrdersInfoSubs(id: widget.id, shopId: widget.shopId,)
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 10,
                                                    left: 0,
                                                    child: Icon(
                                                      SmartKyat_POS.order,
                                                      size: 21,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 0,
                                                    child: Text(
                                                      'Purchased\norders',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'CUSTOMER INFORMATION',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                letterSpacing: 2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => EditCustomer(shopId: widget.shopId, cusId: widget.id, cusName: customerName, cusAddress: address, cusPhone: phone)),);
                                              },
                                              child: Text(
                                                'EDIT',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  letterSpacing: 2,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                        Container(
                                          height: 220,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.lightBgColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text('Name', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      Text(customerName, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text('Phone', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      Spacer(),
                                                      Text(phone, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text('Address', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),),
                                                      Spacer(),
                                                      Text(address, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  child: Row(
                                                    children: [
                                                      Text('Total orders', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),),
                                                      Spacer(),
                                                      Text(phone, style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          height: 1,
                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.4),
                                              width: 1.0))),),
                                        SizedBox(height: 20),
                                        Text(
                                          'OTHER INFORMATION',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 2,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Container(
                                          height: 220,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: AppTheme.lightBgColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text('Total sale', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),),
                                                      Spacer(),
                                                      Text('1500 Far', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text('In stock', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),),
                                                      Spacer(),
                                                      Text('124 Far', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),
                                                  child: Row(
                                                    children: [
                                                      Text('Loss', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),),
                                                      Spacer(),
                                                      Text('5 Far', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 55,
                                                  child: Row(
                                                    children: [
                                                      Text('Barcode', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                      ),),
                                                      Spacer(),
                                                      Text('3kro46456218', style:
                                                      TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                      ),),
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


                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                    ]
                );
              }
              return Container();
            }),
      ),
    );
  }

}



zeroToTen(String string) {
  if (int.parse(string) > 9) {
    return string;
  } else {
    return '0' + string;
  }
}
