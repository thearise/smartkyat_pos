///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 20:21
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../constants/page_mixin.dart';
import '../constants/picker_method.dart';

class MultiAssetsPage extends StatefulWidget {
  @override
  _MultiAssetsPageState createState() => _MultiAssetsPageState();
}

class _MultiAssetsPageState extends State<MultiAssetsPage>
    with AutomaticKeepAliveClientMixin, ExamplePageMixin<MultiAssetsPage> {
  @override
  int get maxAssetsCount => 9;

  @override
  List<PickMethod> get pickMethods {
    return <PickMethod>[
      PickMethod.cameraAndStay(maxAssetsCount: maxAssetsCount),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}