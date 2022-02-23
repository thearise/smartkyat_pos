// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../models/product_model.dart';
//
// class ProviderType extends ChangeNotifier {
//   String value = DateTime.now().toString();
//
//   changeValue() {
//     value = DateTime.now().toString();
//     notifyListeners();
//   }
//
//   late ProductModel productModel;
//
//   List<ProductModel> search = [];
//   productModels(QueryDocumentSnapshot element) {
//
//     productModel = ProductModel(
//       productImage: element.get("prod_name"),
//       productName: element.get("prod_name"),
//       productPrice: 10,
//       productId: element.get("prod_name"),
//       productUnit: ['20'],
//       productQuantity: 30,
//     );
//     search.add(productModel);
//   }
//
//   /////////////// herbsProduct ///////////////////////////////
//   List<ProductModel> herbsProductList = [];
//
//   fatchHerbsProductData() async {
//     List<ProductModel> newList = [];
//
//     QuerySnapshot value =
//     await FirebaseFirestore.instance.collection('shops').doc('dn5nP4BQU5ShulxlaXA8').collection('products').get();
//
//     value.docs.forEach(
//           (element) {
//         productModels(element);
//
//         newList.add(productModel);
//       },
//     );
//     herbsProductList = newList;
//     notifyListeners();
//   }
//
//   List<ProductModel> get getHerbsProductDataList {
//     return herbsProductList;
//   }
//
// //////////////// Fresh Product ///////////////////////////////////////
//
//   List<ProductModel> freshProductList = [];
//
//   fatchFreshProductData() async {
//     List<ProductModel> newList = [];
//
//     QuerySnapshot value =
//     await FirebaseFirestore.instance.collection("FreshProduct").get();
//
//     value.docs.forEach(
//           (element) {
//         productModels(element);
//         newList.add(productModel);
//       },
//     );
//     freshProductList = newList;
//     notifyListeners();
//   }
//
//   List<ProductModel> get getFreshProductDataList {
//     return freshProductList;
//   }
//
// //////////////// Root Product ///////////////////////////////////////
//
//   List<ProductModel> rootProductList = [];
//
//   fatchRootProductData() async {
//     List<ProductModel> newList = [];
//
//     QuerySnapshot value =
//     await FirebaseFirestore.instance.collection("RootProduct").get();
//
//     value.docs.forEach(
//           (element) {
//         productModels(element);
//         newList.add(productModel);
//       },
//     );
//     rootProductList = newList;
//     notifyListeners();
//   }
//
//   List<ProductModel> get getRootProductDataList {
//     return rootProductList;
//   }
//
//   /////////////////// Search Return ////////////
//   List<ProductModel> get gerAllProductSearch {
//     return search;
//   }
// }