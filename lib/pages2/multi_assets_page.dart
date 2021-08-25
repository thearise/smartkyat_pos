///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 20:21
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../constants/page_mixin.dart';
import '../constants/picker_method.dart';

class MultiAssetsPage extends StatefulWidget {
  // final _callback;
  //
  // MultiAssetsPage( {required void toggleCoinCallback() } ) :
  //       _callback = toggleCoinCallback;
  @override
  MultiAssetsPageState createState() => MultiAssetsPageState();
}

class MultiAssetsPageState extends State<MultiAssetsPage>
    with AutomaticKeepAliveClientMixin, ExamplePageMixin<MultiAssetsPage> {
  @override
  int get maxAssetsCount => 5;

  @override
  initState() {

    // await Future.delayed(Duration(seconds: 2));
    // print(assets.length.toString());
    MixinGlo();

    // pageMixinGlo();// await Firebase.initializeApp();
  }

  pageMultiGlo() {
    // pageMixinGlo();
    // pageMixinGlo().then((value)  {
    //   return value;
    // });
    // await Future.delayed(Duration(seconds: 2));
    // return assets;
  }

  @override
  List<PickMethod> get pickMethods {
    return <PickMethod>[
      // PickMethod.image(maxAssetsCount),
      // PickMethod.video(maxAssetsCount),
      // PickMethod.audio(maxAssetsCount),
      // PickMethod.camera(
      //   maxAssetsCount: maxAssetsCount,
      //   handleResult: (BuildContext context, AssetEntity result) =>
      //       Navigator.of(context).pop(<AssetEntity>[...assets, result]),
      // ),


      PickMethod.cameraAndStay(
          maxAssetsCount: maxAssetsCount,
      ),


      // PickMethod.common(maxAssetsCount),
      // PickMethod.threeItemsGrid(maxAssetsCount),
      // PickMethod.customFilterOptions(maxAssetsCount),
      // PickMethod.prependItem(maxAssetsCount),
      // PickMethod(
      //   icon: '🎭',
      //   name: 'WeChat Moment',
      //   description: 'Pick assets like the WeChat Moment pattern.',
      //   method: (BuildContext context, List<AssetEntity> assets) {
      //     return AssetPicker.pickAssets(
      //       context,
      //       maxAssets: maxAssetsCount,
      //       specialPickerType: SpecialPickerType.wechatMoment,
      //     );
      //   },
      // ),
      // PickMethod.noPreview(maxAssetsCount),
      // PickMethod.keepScrollOffset(
      //   provider: () => keepScrollProvider,
      //   delegate: () => keepScrollDelegate!,
      //   onPermission: (PermissionState state) {
      //     keepScrollDelegate ??= DefaultAssetPickerBuilderDelegate(
      //       provider: keepScrollProvider,
      //       initialPermission: state,
      //       keepScrollOffset: true,
      //     );
      //   },
      //   onLongPress: () {
      //     keepScrollProvider.dispose();
      //     keepScrollProvider = DefaultAssetPickerProvider();
      //     keepScrollDelegate?.dispose();
      //     keepScrollDelegate = null;
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Resources have been released')),
      //     );
      //   },
      // ),
      // PickMethod(
      //   icon: '🎚',
      //   name: 'Custom image preview thumb size',
      //   description: 'You can reduce the thumb size to get faster load speed.',
      //   method: (BuildContext context, List<AssetEntity> assets) {
      //     return AssetPicker.pickAssets(
      //       context,
      //       maxAssets: maxAssetsCount,
      //       selectedAssets: assets,
      //       requestType: RequestType.image,
      //       previewThumbSize: const <int>[150, 150],
      //       gridThumbSize: 80,
      //     );
      //   },
      // ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
