import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';

import '../app_theme.dart';

class AddNewCategory extends StatelessWidget {
  final String categoryText;
  AddNewCategory(this.categoryText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ButtonTheme(
        splashColor: Colors.transparent,
        minWidth: MediaQuery.of(context).size.width,
        height: 56,
        child: CustomFlatButton(
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
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
