import 'package:flutter/material.dart';

class DetailRoute extends StatelessWidget {
  DetailRoute({required this.textEditingController, required this.index});

  final TextEditingController textEditingController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route for $index Item'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: TextField(controller: textEditingController),
      ),
    );
  }
}