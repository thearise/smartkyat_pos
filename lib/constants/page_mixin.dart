///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 11:46
///
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show
        AssetEntity,
        DefaultAssetPickerProvider,
        DefaultAssetPickerBuilderDelegate;

import '../widgets2/method_list_view.dart';
import '../widgets2/selected_assets_list_view.dart';
import 'picker_method.dart';

mixin ExamplePageMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isDisplayingDetail.dispose();
    super.dispose();
  }

  int get maxAssetsCount;

  List<AssetEntity> assets = <AssetEntity>[];

  int get assetsLength => assets.length;

  List<PickMethod> get pickMethods;

  /// These fields are for the keep scroll position feature.
  late DefaultAssetPickerProvider keepScrollProvider =
      DefaultAssetPickerProvider();
  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  Future<void> selectAssets(PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = false;
    }
    setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        if (assets.isNotEmpty)
          GestureDetector(
            onTap: () {
              // print(assets[0].toString());
              for (final AssetEntity entity in assets) {
                // If the entity isAll, that's the "Recent" entity you want.
                entity.originFile.then((value) => print(value));
              }
              },
            child: SelectedAssetsListView(
              assets: assets,
              isDisplayingDetail: isDisplayingDetail,
              onResult: onResult,
              onRemoveAsset: removeAsset,
            ),
          ),
        Expanded(
          child: MethodListView(
            pickMethods: pickMethods,
            onSelectMethod: selectAssets,
          ),
        ),

      ],
    );
  }
}
