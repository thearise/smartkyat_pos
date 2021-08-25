import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PickMethod {
  const PickMethod({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
    this.onLongPress,
  });

  factory PickMethod.cameraAndStay({required int maxAssetsCount}) {
    return PickMethod(
      icon: '',
      name: '',
      description: '',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.image,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity? result = await CameraPicker.pickFromCamera(
                  context,
                  enableRecording: false,
                );
                if (result != null) {
                  final AssetPicker<AssetEntity, AssetPathEntity> picker =
                      context.findAncestorWidgetOfExactType()!;
                  final DefaultAssetPickerProvider p =
                      picker.builder.provider as DefaultAssetPickerProvider;
                  await p.currentPathEntity!.refreshPathProperties();
                  await p.switchPath(p.currentPathEntity!);
                  p.selectAsset(result);
                }
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
        );
      },
    );
  }











  factory PickMethod.keepScrollOffset({
    required DefaultAssetPickerProvider Function() provider,
    required DefaultAssetPickerBuilderDelegate Function() delegate,
    required Function(PermissionState state) onPermission,
    GestureLongPressCallback? onLongPress,
  }) {
    return PickMethod(
      icon: '💾',
      name: 'Keep scroll offset',
      description: 'Pick assets from same scroll position.',
      method: (BuildContext context, List<AssetEntity> assets) async {
        final PermissionState _ps =
            await PhotoManager.requestPermissionExtend();
        if (_ps != PermissionState.authorized &&
            _ps != PermissionState.limited) {
          throw StateError('Permission state error with $_ps.');
        }
        onPermission(_ps);
        return AssetPicker.pickAssetsWithDelegate(
          context,
          provider: provider(),
          delegate: delegate(),
        );
      },
      onLongPress: onLongPress,
    );
  }

  final String icon;
  final String name;
  final String description;
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;
  final GestureLongPressCallback? onLongPress;
}
