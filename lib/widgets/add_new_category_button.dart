import 'package:flutter/material.dart';

import '../app_theme.dart';

class AddNewCategory extends StatelessWidget {
  final String categoryText;
  AddNewCategory(this.categoryText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        height: 62,
        child: FlatButton(
          color: AppTheme.skThemeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
            side: BorderSide(
              color: AppTheme.skThemeColor,
            ),
          ),
          onPressed: () {},
          child: Text(
            categoryText,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
