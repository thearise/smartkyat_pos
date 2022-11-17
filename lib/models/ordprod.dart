import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

// ignore_for_file: public_member_api_docs

@Entity()
@Sync()
class OrdProd {
  int id;
  int pid;
  String name;
  String uname;
  double quantity;
  double sale;
  double buy;
  double refquant;
  int oid;


  String text;
  String? comment;

  /// Note: Stored in milliseconds without time zone info.
  DateTime date;

  OrdProd(
      this.pid,
      this.name,
      this.uname,
      this.quantity,
      this.sale,
      this.buy,
      this.refquant,
      this.oid,
      this.text,
      {this.id = 0, DateTime? date})
      : date = date ?? DateTime.now();
  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(date);

}
