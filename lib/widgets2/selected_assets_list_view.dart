///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 10:51
///
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity, AssetPicker, AssetPickerViewer;

import '../main.dart' show themeColor;
import 'asset_widget_builder.dart';

class SelectedAssetsListView extends StatelessWidget {
  const SelectedAssetsListView({
    Key? key,
    required this.assets,
    required this.isDisplayingDetail,
    required this.onResult,
    required this.onRemoveAsset,
  }) : super(key: key);

  final List<AssetEntity> assets;
  final ValueNotifier<bool> isDisplayingDetail;
  final Function(List<AssetEntity>? result) onResult;
  final Function(int index) onRemoveAsset;

  Widget _selectedAssetWidget(BuildContext context, int index) {
    final AssetEntity asset = assets.elementAt(index);
    final Map params = new Map();
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    asset.originFile.then((value) async {
      // testCompressAndGetFile(value!, randomNumber.toString()+value.path).then((value2) => addProduct(value2));

      // String? jpegPath = await HeicToJpg.convert(value!.path);
      // print(jpegPath.toString());

      // addProduct(File(jpegPath.toString()));


      // uncommend
      // addProduct(value!);


    });

    // Random random = new Random();
    // int randomNumber = random.nextInt(10000000);
    // List<Map> a = <Map>[];


    // addProduct(asset.originFile);

    // asset.originBytes.then((value) {
    //
    //   a.add({
    //     'fileName': 'inner' + randomNumber.toString(),
    //     'encoded' : Base64Encoder().convert(value!)
    //     //'encoded': randomNumber.toString()
    //   });
    //
    // }).then((value) {
    //   params["attachment"] = jsonEncode(a);
    //   httpSend(params).then((sukses){
    //     print('done connect ' + sukses.toString());
    //   });
    // });





    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, __) => GestureDetector(
        onTap: () async {
          if (value) {
            final List<AssetEntity>? result =
                await AssetPickerViewer.pushToViewer(
              context,
              currentIndex: index,
              previewAssets: assets,
              themeData: AssetPicker.themeData(Colors.blue),
            );
            onResult(result);
          }
        },
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AssetWidgetBuilder(
              entity: asset,
              isDisplayingDetail: value,
            ),
          ),
        ),
      ),
    );
  }

  Future<File> testCompressAndGetFile(File? file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file!.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  Future addProduct(File imageFile) async {
// ignore: deprecated_member_use
    var stream = new http.ByteStream(
        DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://hninsunyein.me/smartkyat_pos/api/images_upload.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile(
        "image", stream, length, filename: basename(imageFile.path));

    request.files.add(multipartFile);
    // request.fields['productname'] = controllerName.text;
    // request.fields['productprice'] = controllerPrice.text;
    // request.fields['producttype'] = controllerType.text;
    // request.fields['product_owner'] = globals.restaurantId;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }

  Future<bool> httpSend(Map params) async
  {
    var endpoint = Uri.parse("https://hninsunyein.me/smartkyat_pos/api/images_upload.php");
    return await http.post(endpoint, body: params)
        .then((response) {
      print('response ' + response.body);
      if(response.statusCode==201)
      {
        Map<String, dynamic> body = jsonDecode(response.body);
        if(body['status']=='OK')
          return true;
      }
      else {
        return false;
      }
      return false;

    });
  }

  Widget _selectedAssetDeleteButton(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => onRemoveAsset(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).canvasColor.withOpacity(0.5),
        ),
        child: const Icon(Icons.close, size: 18.0),
      ),
    );
  }

  Widget get selectedAssetsListView {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: assets.length,
        itemBuilder: (BuildContext c, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _selectedAssetWidget(c, index)),
                  ValueListenableBuilder<bool>(
                    valueListenable: isDisplayingDetail,
                    builder: (_, bool value, __) => AnimatedPositioned(
                      duration: kThemeAnimationDuration,
                      top: value ? 6.0 : -30.0,
                      right: value ? 6.0 : -30.0,
                      child: _selectedAssetDeleteButton(c, index),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, __) => AnimatedContainer(
        duration: kThemeChangeDuration,
        curve: Curves.easeInOut,
        height: assets.isNotEmpty
            ? value
                ? 120.0
                : 80.0
            : 40.0,
        child: Column(
          children: <Widget>[

            // SizedBox(
            //   height: 20.0,
            //   child: GestureDetector(
            //     onTap: () {
            //       if (assets.isNotEmpty) {
            //         isDisplayingDetail.value = !isDisplayingDetail.value;
            //       }
            //     },
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: <Widget>[
            //         const Text('Selected Assets'),
            //         if (assets.isNotEmpty)
            //           Padding(
            //             padding: const EdgeInsetsDirectional.only(start: 10.0),
            //             child: Icon(
            //               value ? Icons.arrow_downward : Icons.arrow_upward,
            //               size: 18.0,
            //             ),
            //           ),
            //       ],
            //     ),
            //   ),
            // ),
            selectedAssetsListView,
          ],
        ),
      ),
    );
  }
}
