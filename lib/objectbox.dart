// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:objectbox_sync_flutter_libs/objectbox_sync_flutter_libs.dart';
// import 'package:smartkyat_pos/models/border.dart';
// import 'package:smartkyat_pos/models/customer_model.dart';
// import 'package:smartkyat_pos/models/order.dart';
// import 'package:smartkyat_pos/models/product.dart';
//
// import 'model.dart';
// import 'models/merchant_mode.dart';
// import 'models/ordprod.dart';
// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`
//
// /// Provides access to the ObjectBox Store throughout the app.
// ///
// /// Create this in the apps main function.
// class ObjectBox {
//   /// The Store of this app.
//   late final Store store;
//
//   /// A Box of notes.
//   late final Box<Note> noteBox;
//   late final Box<Product> productBox;
//   late final Box<CustomerModel> customerBox;
//   late final Box<MerchantModel> merchantBox;
//   late final Box<SaleOrder> saleorderBox;
//   late final Box<OrdProd> ordProdBox;
//
//   ObjectBox._create(this.store) {
//     noteBox = Box<Note>(store);
//     productBox = Box<Product>(store);
//     customerBox = Box<CustomerModel>(store);
//     merchantBox = Box<MerchantModel>(store);
//     saleorderBox = Box<SaleOrder>(store);
//     ordProdBox = Box<OrdProd>(store);
//
//     // TODO configure actual sync server address and authentication
//     // For configuration and docs, see objectbox/lib/src/sync.dart
//     // 10.0.2.2 is your host PC if an app is run in an Android emulator.
//     // 127.0.0.1 is your host PC if an app is run in an iOS simulator.
//     final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
//     final syncClient =
//     Sync.client(store, 'ws://$syncServerIp:9999', SyncCredentials.none());
//     syncClient.start();
//   }
//
//   /// Create an instance of ObjectBox to use throughout the app.
//   static Future<ObjectBox> create() async {
//     final store = Store(getObjectBoxModel(),
//         directory: (await defaultStoreDirectory()).path + '-sync',
//         macosApplicationGroup: 'objectbox.demo' // TODO replace with a real name
//     );
//     return ObjectBox._create(store);
//   }
//
//   Stream<List<Note>> getNotes() {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = noteBox.query().order(Note_.date, flags: Order.descending);
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) => query.find());
//   }
//
//   Stream<List<SaleOrder>> getOrders() {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = saleorderBox.query().order(SaleOrder_.date, flags: Order.descending);
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) => query.find());
//   }
//
//   Stream<SaleOrder?> getOrder(int id) {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = saleorderBox.query(SaleOrder_.id.equals(id));
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) {
//       return query.findUnique();
//     });
//   }
//
//   getOverViewInfo(String type, DateTime date) {
//     int start = date.millisecondsSinceEpoch;
//     int end = date.subtract(Duration(hours: 23, minutes: 59, seconds: 59)).millisecondsSinceEpoch;
//
//     Query<SaleOrder> query = saleorderBox.query(SaleOrder_.date.between(start, end)).order(SaleOrder_.date, flags: Order.descending).build();
//     double spTotalSale = query.property(SaleOrder_.total).sum();
//     Map<dynamic, dynamic> overViewInfo = {};
//     overViewInfo['total'] = spTotalSale;
//     return overViewInfo;
//   }
//
//   Stream<List<SaleOrder>> getOverview(String type, DateTime date) {
//     if(type == 'week') {
//       int start = date.millisecondsSinceEpoch;
//       int end = date.subtract(Duration(minutes: 10)).millisecondsSinceEpoch;
//       // Timestamp myTimeStamp = Timestamp.fromDate(date);
//       // Query for all notes, sorted by their date.
//       // https://docs.objectbox.io/queries
//       final builder = saleorderBox.query(SaleOrder_.date.between(start, end));
//       // final builder = saleorderBox.query();
//       // Query<Product> query = productBox.query().build();
//       // double sumSum = query.property(Product.im).sum() + query.property(Product_.im).sum();
//       // Build and watch the query,
//       // set triggerImmediately to emit the query immediately on listen.
//       return builder
//           .watch(triggerImmediately: true)
//       // Map it to a list of notes to be used by a StreamBuilder.
//           .map((query) {
//         return query.find();
//       });
//     } else {
//       int start = date.millisecondsSinceEpoch;
//       int end = date.subtract(Duration(hours: 23, minutes: 59, seconds: 59)).millisecondsSinceEpoch;
//       debugPrint('starting checking ' + date.toString());
//       debugPrint('ending checking ' + date.subtract(Duration(hours: 23, minutes: 59, seconds: 59)).toString());
//       // Query for all notes, sorted by their date.
//       // https://docs.objectbox.io/queries
//       final builder = saleorderBox.query(SaleOrder_.date.between(start, end)).order(SaleOrder_.date, flags: Order.descending);
//       // Build and watch the query,
//       // set triggerImmediately to emit the query immediately on listen.
//       return builder
//           .watch(triggerImmediately: true)
//       // Map it to a list of notes to be used by a StreamBuilder.
//           .map((query) => query.find());
//     }
//   }
//
//   /// Add a note within a transaction.
//   ///
//   /// To avoid frame drops, run ObjectBox operations that take longer than a
//   /// few milliseconds, e.g. putting many objects, in an isolate with its
//   /// own Store instance.
//   /// For this example only a single object is put which would also be fine if
//   /// done here directly.
//   Future<void> addNote(String text) =>
//       store.runInTransactionAsync(TxMode.write, _addNoteInTx, text);
//
//   /// Note: due to [dart-lang/sdk#36983](https://github.com/dart-lang/sdk/issues/36983)
//   /// not using a closure as it may capture more objects than expected.
//   /// These might not be send-able to an isolate. See Store.runAsync for details.
//   static void _addNoteInTx(Store store, String text) {
//     // Perform ObjectBox operations that take longer than a few milliseconds
//     // here. To keep it simple, this example just puts a single object.
//     store.box<Note>().put(Note(text));
//   }
//
//   static void _addNoteInTx2(Store store, String text) {
//     // Perform ObjectBox operations that take longer than a few milliseconds
//     // here. To keep it simple, this example just puts a single object.
//     store.box().putMany([]);
//   }
//
//   Stream<List<Product>> getProducts() {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = productBox.query().order(Product_.date, flags: Order.descending);
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product_.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) => query.find());
//   }
//
//   Stream<List<OrdProd>> getOrdProds(int parse) {
//     final builder = ordProdBox.query(OrdProd_.oid.equals(parse)).order(OrdProd_.date, flags: Order.descending);
//     return builder
//         .watch(triggerImmediately: true)
//         .map((query) => query.find());
//   }
//
//   Stream<Product?> getProduct(int id) {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = productBox.query(Product_.id.equals(id));
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) {
//       return query.findUnique();
//     });
//   }
//
//   List<Product> getProdByIds(List<int> ids) {
//     List<Product> prods = [];
//     try {
//       store.runInTransaction(TxMode.read, () {
//         for(int i=0; i < ids.length; i++) {
//           Product prod = productBox.get(ids[i]) ?? Product(
//               false, 1000,1000,1000,1000,1000, '', 1000,1000,1000,'','','','',1000,1000,1000,1000,1000,100,100,100,''
//           );
//           prods.add(prod);
//         }
//       });
//       debugPrint('prods goingfine');
//       return prods;
//     } catch (e) {
//       debugPrint('prods catching');
//       return [];
//     }
//   }
//
//   Stream<List<CustomerModel>> getCustomers() {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = customerBox.query().order(CustomerModel_.date, flags: Order.descending);
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product_.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) => query.find());
//   }
//
//   Stream<CustomerModel?> getCustomer(int id) {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = customerBox.query(CustomerModel_.id.equals(id));
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) {
//       return query.findUnique();
//     });
//   }
//
//   Stream<List<MerchantModel>> getMerchants() {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = merchantBox.query().order(MerchantModel_.date, flags: Order.descending);
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product_.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) => query.find());
//   }
//
//
//   Stream<MerchantModel?> getMerchant(int id) {
//     // Query for all notes, sorted by their date.
//     // https://docs.objectbox.io/queries
//     final builder = merchantBox.query(MerchantModel_.id.equals(id));
//     // Query<Product> query = productBox.query().build();
//     // double sumSum = query.property(Product.im).sum() + query.property(Product_.im).sum();
//     // Build and watch the query,
//     // set triggerImmediately to emit the query immediately on listen.
//     return builder
//         .watch(triggerImmediately: true)
//     // Map it to a list of notes to be used by a StreamBuilder.
//         .map((query) {
//       return query.findUnique();
//     });
//   }
//   /// Add a note within a transaction.
//   ///
//   /// To avoid frame drops, run ObjectBox operations that take longer than a
//   /// few milliseconds, e.g. putting many objects, in an isolate with its
//   /// own Store instance.
//   /// For this example only a single object is put which would also be fine if
//   /// done here directly.
//   void addProduct(
//       bool ar,
//       double b1,
//       double b2,
//       double bm,
//       double c1,
//       double c2,
//       String co,
//       double i1,
//       double i2,
//       double im,
//       String n1,
//       String n2,
//       String na,
//       String nm,
//       double s1,
//       double s2,
//       double se,
//       double sm,
//       double l1,
//       double l2,
//       double lm,
//       double wt,
//       String text,
//
//       ) =>
//       productBox.put(Product(ar,b1,b2,bm,c1,c2,co,i1,i2,im,n1,n2,na,nm,s1,s2,se,sm,l1,l2,lm,wt, text));
//
//   void addOrder(List<OrdProd> prods, int cid, double debt, int deviceId, double discount, bool refund, double total, String text) {
//     SaleOrder saleOrder = SaleOrder(0, debt, deviceId, discount, refund, total, text);
//     saleOrder.ordProds.addAll(prods);
//     saleorderBox.put(saleOrder);
//     // saleorderBox.pu
//   }
//
//   bool addSaleOrder(List<Product> orgProds, List<OrdProd> prods, int cid, double debt, int deviceId, double discount, bool refund, double total, String text) {
//
//     SaleOrder saleOrder = SaleOrder(0, debt, deviceId, discount, refund, total, text);
//     // store.runInTransaction(TxMode.write, () {
//     //   saleorderBox.put(saleOrder);
//     // });
//     // store.box().putMany([saleOrder]);
//     try {
//       store.runInTransaction(TxMode.write, () {
//         // existing code
//         int orderId = saleorderBox.put(saleOrder);
//         for(int i = 0; i< prods.length; i++) {
//           prods[i].oid = orderId;
//         }
//         ordProdBox.putMany(prods);
//         productBox.putMany(orgProds);
//       });
//       return true;
//     } catch (e) {
//       return false;
//     }
//
//   }
//
//   bool addSaleOrder2() {
//
//     // SaleOrder saleOrder = SaleOrder(0, debt, deviceId, discount, refund, total, text);
//     // List<SaleOrder> saleOrders = [];
//     // for(int i = 0; i < 1; i++) {
//     //   saleOrders.add(SaleOrder(0, 100, 1, 50, true, 100000, 'text'));
//     // }
//     // // store.runInTransaction(TxMode.write, () {
//     // //   saleorderBox.put(saleOrder);
//     // // });
//     // // store.box().putMany([saleOrder]);
//     // try {
//     //   saleorderBox.putMany(saleOrders);
//     //   return true;
//     // } catch (e) {
//     //   return false;
//     // }
//
//     List<SaleOrder> saleOrders = [];
//     for(int i = 0; i < 1; i++) {
//       saleOrders.add(SaleOrder(0, 100, 1, 50, true, 100000, 'text'));
//     }
//     // store.runInTransaction(TxMode.write, () {
//     //   saleorderBox.put(saleOrder);
//     // });
//     // store.box().putMany([saleOrder]);
//     try {
//       // store.runInTransaction(TxMode.write, () {
//       //   saleorderBox.put(SaleOrder(0, 100, 1, 50, true, 100000, 'text'));
//       // });
//       saleorderBox.putMany(saleOrders);
//       return true;
//     } catch (e) {
//       return false;
//     }
//
//   }
//
//   bool addSaleOrder3() {
//
//     // SaleOrder saleOrder = SaleOrder(0, debt, deviceId, discount, refund, total, text);
//     // List<SaleOrder> saleOrders = [];
//     // for(int i = 0; i < 1; i++) {
//     //   saleOrders.add(SaleOrder(0, 100, 1, 50, true, 100000, 'text'));
//     // }
//     // // store.runInTransaction(TxMode.write, () {
//     // //   saleorderBox.put(saleOrder);
//     // // });
//     // // store.box().putMany([saleOrder]);
//     // try {
//     //   saleorderBox.putMany(saleOrders);
//     //   return true;
//     // } catch (e) {
//     //   return false;
//     // }
//
//     List<OrdProd> ordProds = [];
//     for(int i = 0; i < 1000; i++) {
//       ordProds.add((OrdProd(2, 'name', 'barll', 10, 1000, 1000, 10, 0, '')));
//     }
//     // store.runInTransaction(TxMode.write, () {
//     //   saleorderBox.put(saleOrder);
//     // });
//     // store.box().putMany([saleOrder]);
//     try {
//       // store.runInTransaction(TxMode.write, () {
//       //   saleorderBox.put(SaleOrder(0, 100, 1, 50, true, 100000, 'text'));
//       // });
//       ordProdBox.putMany(ordProds);
//       return true;
//     } catch (e) {
//       return false;
//     }
//
//   }
//
//   void addCustomer(
//   bool ar,
//   String ad,
//   double da,
//   double de,
//   String na,
//   double or,
//   String ph,
//   double re,
//   String text,
//
//       ) =>
//       customerBox.put(CustomerModel(ar, ad, da, de, na, or, ph, re, text));
//
//   void addMerchant(
//       bool ar,
//       String ad,
//       double da,
//       double de,
//       String na,
//       double or,
//       String ph,
//       double re,
//       String text,
//
//       ) =>
//       merchantBox.put(MerchantModel(ar, ad, da, de, na, or, ph, re, text));
//       // store.runInTransactionAsync(TxMode.write, _addProductInTx, na);
//
//   /// Note: due to [dart-lang/sdk#36983](https://github.com/dart-lang/sdk/issues/36983)
//   /// not using a closure as it may capture more objects than expected.
//   /// These might not be send-able to an isolate. See Store.runAsync for details.
//   static void _addProductInTx(Store store,
//       bool ar,
//       double b1,
//       double b2,
//       double bm,
//       double c1,
//       double c2,
//       String co,
//       double i1,
//       double i2,
//       double im,
//       String n1,
//       String n2,
//       String na,
//       String nm,
//       double s1,
//       double s2,
//       double se,
//       double sm,
//       double l1,
//       double l2,
//       double lm,
//       double wt,
//       String text,
//     ) {
//     // Perform ObjectBox operations that take longer than a few milliseconds
//     // here. To keep it simple, this example just puts a single object.
//     store.box<Product>().put(Product(ar,b1,b2,bm,c1,c2,co,i1,i2,im,n1,n2,na,nm,s1,s2,se,sm,l1,l2,lm,wt, text));
//   }
//
//
// }
