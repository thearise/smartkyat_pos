import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

// ignore_for_file: public_member_api_docs

@Entity()
@Sync()
class Product {
  @Id()
  int id;
  bool ar;
  double b1;
  double b2;
  double bm;
  double c1;
  double c2;
  String co;
  double i1;
  double i2;
  double im;
  String n1;
  String n2;
  String na;
  String nm;
  double s1;
  double s2;
  double se;
  double sm;
  double l1;
  double l2;
  double lm;
  double wt;


  String text;
  String? comment;

  /// Note: Stored in milliseconds without time zone info.
  DateTime date;

  Product(
      this.ar,
      this.b1,
      this.b2,
      this.bm,
      this.c1,
      this.c2,
      this.co,
      this.i1,
      this.i2,
      this.im,
      this.n1,
      this.n2,
      this.na,
      this.nm,
      this.s1,
      this.s2,
      this.se,
      this.sm,
      this.l1,
      this.l2,
      this.lm,
      this.wt,
      this.text,
    {this.id = 0, DateTime? date})
    : date = date ?? DateTime.now();

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(date);

  Map<String, dynamic> toMap() {
    return {
      'ar': ar,
      'b1': b1,
      'b2': b2,
      'bm': bm,
      'c1': c1,
      'c2': c2,
      'co': co,
      'i1': i1,
      'i2': i2,
      'im': im,
      'n1': n1,
      'n2': n2,
      'na': na,
      'nm': nm,
      's1': s1,
      's2': s2,
      'se': se,
      'sm': sm,
      'l1': l1,
      'l2': l2,
      'lm': lm,
      'wt': wt,
      'text': text,
    };
  }
}
