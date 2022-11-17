import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';
import 'ordprod.dart';

// ignore_for_file: public_member_api_docs

@Entity()
@Sync()
class BuyOrder {
  int id;
  int cid;
  double debt;
  int deviceId;
  double discount;
  String refund;
  double total;

  String text;
  String? comment;

  /// Note: Stored in milliseconds without time zone info.
  DateTime date;

  BuyOrder(
      this.cid,
      this.debt,
      this.deviceId,
      this.discount,
      this.refund,
      this.total,
      this.text,
      {this.id = 0, DateTime? date})
      : date = date ?? DateTime.now();
  final ordProds = ToMany<OrdProd>();
  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(date);

}
