import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:smartkyat_pos/widgets/apply_discount_to_cart.dart';
import 'package:vector_math/vector_math_64.dart';
import '../app_theme.dart';

class HomeFragment extends StatefulWidget {
  final _callback;

  HomeFragment( {required void toggleCoinCallback() } ) :
        _callback = toggleCoinCallback;
  @override
  _HomeFragmentState createState() => _HomeFragmentState();

// HomeFragment({Key? key, required void toggleCoinCallback()}) : super(key: key);
//
// @override
// _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeFragment>{
  @override
  bool get wantKeepAlive => true;


  final JiggleController controller = JiggleController();

  void _jiggleStuff() {
    controller.toggle();
  }

  @override
  initState() {
    super.initState();
  }

  void _incrementCounter() {
    setState(() => _counter++);
    _shakeController.shake();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _counter = 0;
  late ShakeController _shakeController;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width > 900
                    ? MediaQuery.of(context).size.width * (2 / 3.5)
                    : MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80.0, bottom: 56),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.Colors.white,
                          child: ListView(
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 7.5, right: 7.5),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7.5, right: 7.5),
                                      child: GestureDetector(
                                        onTap: () {
                                          widget._callback();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                            color: Colors.Colors.green.withOpacity(0.4),
                                          ),
                                          width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
                                          height: 120,
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.add_shopping_cart_rounded),
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Text(
                                                      'Add orders',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.Colors.black.withOpacity(0.6)
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 7.5, right: 7.5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          color: Colors.Colors.blue.withOpacity(0.4),
                                        ),
                                        width: MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(2/3.5)*(1/2)-22.5:MediaQuery.of(context).size.width*(1/2)-22.5,
                                        height: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.volunteer_activism),
                                              Expanded(
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: TextButton(
                                                      onPressed: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyDiscount()
                                                        ),
                                                        );
                                                      },
                                                      child: Text('Add discount',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.Colors.black.withOpacity(0.6)
                                                        ),),
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                              Jiggle(
                                jiggleController: controller,
                                useGestures: true,
                                extent: 3,
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 15.0, right: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            addDailyExp(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.Colors.grey.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
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
                                      padding: const EdgeInsets.only(left:8.0, right: 8.0),
                                      child: Container(child:
                                      Text(
                                        'Search',
                                        style: TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.Colors.black.withOpacity(0.6)
                                        ),
                                      )
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 15.0,
                                    ),
                                    child: Icon(
                                      Icons.bar_chart,
                                      color: Colors.Colors.green,
                                      size: 22,
                                    ),
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
              MediaQuery.of(context).size.width > 900
                  ? Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 57.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Colors.Colors.grey.withOpacity(0.3),
                              width: 1.0))),
                  width: MediaQuery.of(context).size.width * (1.5 / 3.5),
                ),
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  addDailyExp(priContext) {
    //  final _formKey = GlobalKey<FormState>();
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
                                color: Colors.Colors.white.withOpacity(0.5)),
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
                              color: Colors.Colors.white,
                            ),

                            child: Column(
                              children: [
                                Container(
                                  height: 85,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                              Colors.Colors.grey.withOpacity(0.3),
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
                                              color:
                                              Colors.Colors.grey.withOpacity(0.3)),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Colors.Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Add new product",
                                          style: TextStyle(
                                              color: Colors.Colors.black,
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
                                              color: Colors.Colors.black,
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    "PRODUCT INFORMATION",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      color: Colors.Colors.brown,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 15),
                                      height: 130,
                                      width: 150,
                                      child: Image.network(
                                        'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "Add images to show customers product details and features",
                                        style: TextStyle(
                                          color: Colors.Colors.amberAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      //height: 200,
                                      width: 380,
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          suffixText: 'Required',
                                          // errorText: 'Error message',
                                          labelText: 'First Name',
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
                                      height: 20,
                                    ),
                                    SizedBox(
                                      //height: 200,
                                      width: 380,
                                      child: TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: InputDecoration(
                                          labelText: 'Last Name',
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
          );
        });
  }
}



class ShakeView extends StatelessWidget {
  final Widget child;
  final ShakeController controller;
  final Animation _anim;

  ShakeView({required this.child, required this.controller})
      : _anim = Tween<double>(begin: 50, end: 120).animate(controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        child: child,
        builder: (context, child) => Transform(
          child: child,
          transform: Matrix4.translation(_shake(_anim.value)),
        ));
  }

  Vector3 _shake(double progress) {
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 4, 0.0, 0.0);
  }
}

class ShakeController extends AnimationController {
  ShakeController(
      {required TickerProvider vsync,
        Duration duration = const Duration(milliseconds: 200)})
      : super(vsync: vsync, duration: duration);

  shake() async {
    if (status == AnimationStatus.completed) {
      await this.reverse();
    } else {
      await this.forward();
    }
  }
}


class JiggleController extends Equatable {
  final BehaviorSubject<JiggleState> _jiggleSubject =
  BehaviorSubject.seeded(JiggleState.STATIC);

  Stream<JiggleState> get stream => _jiggleSubject.stream.asBroadcastStream();

  JiggleState get state => _jiggleSubject.value;
  bool get isJiggling => _jiggleSubject.value == JiggleState.JIGGLING;

  void toggle() {
    HapticFeedback.mediumImpact();
    if (_jiggleSubject.value == JiggleState.STATIC) {
      _jiggleSubject.value = JiggleState.JIGGLING;
    } else {
      _jiggleSubject.value = JiggleState.STATIC;
    }
  }

  void dispose() {
    _jiggleSubject.close();
  }

  @override
  List<Object> get props => [state, isJiggling];

  @override
  bool get stringify => true;
}



enum JiggleState { JIGGLING, STATIC }

/// Jiggle your Widgets. 👯‍♀️
///
/// Jiggle is useful if you wish to indicate a state of uncertainity or
/// grab the attendtion of somebody.
class Jiggle extends StatefulWidget {
  Jiggle(
      {required this.child,
        required this.jiggleController,
        this.extent = 1,
        this.duration = const Duration(milliseconds: 80),
        this.useGestures = false});

  /// This is the extent in degress to which the Widget rotates.
  ///
  /// This defaults to 80 milliseconds.
  final double extent;

  /// This is the duration for which a `Jiggle` lasts.
  ///
  /// This defaults to 80 milliseconds.
  final Duration duration;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The jiggle controller.
  final JiggleController jiggleController;

  /// Set this property to true to automatically
  /// start jiggling when long pressed on the Widget.
  ///
  /// This defaults to false.
  final bool useGestures;

  @override
  _JiggleState createState() => _JiggleState();
}

class _JiggleState extends State<Jiggle> with SingleTickerProviderStateMixin {
  late AnimationController _jiggleAnimationController;
  late Animation<double> jiggleAnimation;

  @override
  void initState() {
    _jiggleAnimationController = AnimationController(
        vsync: this,
        duration: widget.duration,
        value: 0,
        lowerBound: -1,
        upperBound: 1);

    jiggleAnimation = Tween<double>(begin: 0, end: widget.extent)
        .animate(_jiggleAnimationController);

    _jiggleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jiggleAnimationController.repeat(reverse: true);
      }
    });
    super.initState();
  }

  void listenForJiggles() {
    widget.jiggleController.stream.listen((event) {
      // print("From Listen" + event.toString());
      if (event == JiggleState.STATIC) {
        _jiggleAnimationController.animateTo(1, duration: Duration.zero);
        _jiggleAnimationController.stop();
      } else if (event == JiggleState.JIGGLING) {
        _jiggleAnimationController.forward();
      }
    });
  }

  void _onLongPress() {
    if (widget.useGestures) widget.jiggleController.toggle();
  }

  @override
  Widget build(BuildContext context) {
    listenForJiggles();
    return GestureDetector(
      onLongPress: _onLongPress,
      child: AnimatedBuilder(
          animation: jiggleAnimation,
          child: widget.child,
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: radians(jiggleAnimation.value),
              child: child,
            );
          }),
    );
  }
}