///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 11:00
///
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';

import '../app_theme.dart';
import '../constants/picker_method.dart';

class MethodListView extends StatelessWidget {
  const MethodListView({
    Key? key,
    required this.pickMethods,
    required this.onSelectMethod,
  }) : super(key: key);

  final List<PickMethod> pickMethods;
  final Function(PickMethod method) onSelectMethod;

  Widget methodItemBuilder(BuildContext context, int index) {
    final PickMethod model = pickMethods[index];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 0.0,
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: ButtonTheme(
            splashColor: Colors.transparent,
            minWidth: MediaQuery.of(context).size.width,
            height: 54,
            child: FlatButton(
              color: AppTheme.secButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () {
                onSelectMethod(model);

                // ProductsFragmentState().closeNewProduct();
                // addNewProd(context);
              },
              child: Text(
                'Add new image',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      // child: Row(
      //   children: <Widget>[
      //     Container(
      //       margin: const EdgeInsets.all(2.0),
      //       width: 48,
      //       height: 48,
      //       child: Center(
      //         child: Text(
      //           model.icon,
      //           style: const TextStyle(fontSize: 24.0),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: 12.0),
      //     Expanded(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Text(
      //             model.name,
      //             style: const TextStyle(
      //               fontSize: 18.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //           ),
      //           const SizedBox(height: 5),
      //           Text(
      //             model.description,
      //             style: Theme.of(context).textTheme.caption,
      //           ),
      //         ],
      //       ),
      //     ),
      //     // const Icon(Icons.chevron_right, color: Colors.grey),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        itemCount: pickMethods.length,
        itemBuilder: methodItemBuilder,
      ),
    );
  }
}
