///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 21:17
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;

import '../constants/page_mixin.dart';
import '../constants/picker_method.dart';

class SingleAssetPage extends StatefulWidget {
  @override
  _SingleAssetPageState createState() => _SingleAssetPageState();
}

class _SingleAssetPageState extends State<SingleAssetPage>
    with AutomaticKeepAliveClientMixin, ExamplePageMixin<SingleAssetPage> {
  @override
  int get maxAssetsCount => 1;

  @override
  List<PickMethod> get pickMethods {
    return <PickMethod>[
      PickMethod.cameraAndStay(maxAssetsCount: maxAssetsCount),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
