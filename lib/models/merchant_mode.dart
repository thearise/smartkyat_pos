import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

@Entity()
@Sync()
class MerchantModel {
  int id;
  bool ar;
  String ad;
  double da;
  double de;
  String na;
  double or;
  String ph;
  double re;

  String text;
  String? comment;

  /// Note: Stored in milliseconds without time zone info.
  DateTime date;

  MerchantModel(
      this.ar,
      this.ad,
      this.da,
      this.de,
      this.na,
      this.or,
      this.ph,
      this.re,
      this.text,
      {this.id = 0, DateTime? date})
      : date = date ?? DateTime.now();

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(date);

  Map<String, dynamic> toMap() {
    return {
      'ar': ar,
      'ad' : ad,
      'da' : da,
      'de' : de,
      'na' : na,
      'or' : or,
      'ph' : ph,
      're' : re,
      'text': text,
    };
  }
}
