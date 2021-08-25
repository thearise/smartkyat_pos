///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 11:46
///
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    // checkDoneMap();
    // if(doneMap) {
    //   print(' done map ');
    // }

  }

  MixinGlo() {
    print('max c ' + maxAssetsCount.toString());
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

  pageMixinGlo() {
    print('Mixin innerr ' + assets.length.toString());
    // return assets;
  }

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = true;
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

  late List<File> fileList;
  final Map params = new Map();


  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        if (assets.isNotEmpty)
          GestureDetector(
            onTap: () {
              // _waitUntilDone();
              print('_waitUntilDone ' + assets.length.toString());






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

  var completer;
  var doneMap = false;




  Future<void> _waitUntilDone() async {

    // completer = Completer();
    doneMap = false;

    var length = 0;
    // print(assets[0].toString());
    for (final AssetEntity entity in assets) {
      late List<Map> s = <Map>[];

      // If the entity `isAll`, that's the "Recent" entity you want.
      Random random = new Random();
      int randomNumber = random.nextInt(10000000);

      entity.originBytes.then((value) {
        // Map a = ;
        s.add({
          'fileName': randomNumber.toString(),
          'encoded' : Base64Encoder().convert(value!)
          //'encoded': randomNumber.toString()
        });
        length = length+1;

      }).then((value) {
        //await Future.delayed(Duration(seconds: 2));
        print('shining ' + s.toString());

        // List<Map> attch = toBase64(fileList);

        params["attachment"] = jsonEncode(s);
        httpSend(params).then((sukses){
          print('done connect ' + sukses.toString());
        });

        // if(length == assets.length) {
        // }
      });




    }



    // return completer.complete();


  }


//   Future addProduct(File imageFile) async {
// // ignore: deprecated_member_use
//     var stream = new http.ByteStream(
//         DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
//     var uri = Uri.parse("http://10.0.2.2/foodsystem/uploadg.php");
//
//     var request = new http.MultipartRequest("POST", uri);
//
//     var multipartFile = new http.MultipartFile(
//         "image", stream, length, filename: basename(imageFile.path));
//
//     request.files.add(multipartFile);
//     request.fields['productname'] = controllerName.text;
//     request.fields['productprice'] = controllerPrice.text;
//     request.fields['producttype'] = controllerType.text;
//     request.fields['product_owner'] = globals.restaurantId;
//
//     var respond = await request.send();
//     if (respond.statusCode == 200) {
//       print("Image Uploaded");
//     } else {
//       print("Upload Failed");
//     }
//   }


  // checkDoneMap() async {
  //   while(true) {
  //     await Future.delayed(Duration(seconds: 2));
  //
  //     if(doneMap) {
  //       print('yes');
  //     } else {
  //       print('no');
  //     }
  //
  //   }
  //
  // }





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

  List<Map> toBase64(List<File> fileList){
    List<Map> s = <Map>[];
    Random random = new Random();
    int randomNumber = random.nextInt(10000000);
    if(fileList.length>0)
      fileList.forEach((element){
        Map a = {
          'fileName': randomNumber.toString(),
          'encoded' : base64Encode(element.readAsBytesSync())
        };
        s.add(a);
      });
    return s;
  }
}
