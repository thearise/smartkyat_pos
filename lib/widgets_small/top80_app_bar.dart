import 'package:flutter/material.dart';

class Top80AppBar extends StatelessWidget {
  Top80AppBar(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            height: 80,
            child:
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 15.8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(subtitle,
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                              overflow: TextOverflow.ellipsis
                          ),
                          strutStyle: StrutStyle(
                            height: 1.4,
                            // fontSize:,
                            forceStrutHeight: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(title,
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            overflow: TextOverflow.ellipsis
                          ),
                          strutStyle: StrutStyle(
                            height: 1.7,
                            // fontSize:,
                            forceStrutHeight: true,
                          ),
                        ),
                      ),
                      // Text(widget.selectedDev.toString())
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1.0))),
        ),
      ],
    );
  }
}