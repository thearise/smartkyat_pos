import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:smartkyat_pos/api/pdf_api.dart';
import 'package:smartkyat_pos/api/utils.dart';
import 'package:smartkyat_pos/model/customer.dart';
import 'package:smartkyat_pos/model/invoice.dart';
import 'package:smartkyat_pos/model/supplier.dart';
import 'rabbit.dart';

class PdfInvoiceApi {
  static double fontSizeDesc = 0;

  static Future<File> generate(Invoice invoice, String size) async {
    if(size == 'roll57') {
      fontSizeDesc = 11.0;
    }
    final pdf = Document();

    final font = await rootBundle.load("assets/SangamZawgyi.ttf");
    final ttfBold = pw.Font.ttf(font);

    final font2 = await rootBundle.load("assets/ZawgyiOne2008.ttf");
    final ttfReg = pw.Font.ttf(font2);


    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll57,
      margin: new EdgeInsets.symmetric(horizontal: 0.0),
      build: (context) => Column(
        children: [
          Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 1 * PdfPageFormat.cm),

                  pw.Text(Rabbit.uni2zg("SHOP NAME ဒိုးလုံး"),style: pw.TextStyle(fontSize: fontSizeDesc+5,font: ttfBold)),
                  // pw.Text(Rabbit.uni2zg("ဘာတွေလဲ ဘာေတွလဲ ဘာတွေဖြစ်နေတာလဲလို့ ပြောကြပါဦး Whatting?"),style: pw.TextStyle(fontSize: fontSizeDesc-4,font: ttfReg, fontWeight: FontWeight.bold)),
                  // ahttps://riftplus.info/dist/img/riftplus-fg.pnga
                  pw.Text(Rabbit.uni2zg("သဇင်လမ်း၊ အောင်သပြေရပ်ကွက်၊ မုံရွာမြို့"),style: pw.TextStyle(fontSize: fontSizeDesc-5,font: ttfReg, color: PdfColors.grey900)),
                  pw.Text(Rabbit.uni2zg("(+959) 751133553"),style: pw.TextStyle(fontSize: fontSizeDesc-5,font: ttfReg, color: PdfColors.grey900)),
                  SizedBox(height: 0.3 * PdfPageFormat.cm),

                  Container(decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1, color: PdfColors.grey800, style: BorderStyle.dashed),
                    )
                  ),height: 1),
                  SizedBox(height: 0.3 * PdfPageFormat.cm),


                ],
              )
          ),
          // SizedBox(height: 3 * PdfPageFormat.cm),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    Text('RECEIPT INFO',
                        style: TextStyle(
                          fontSize: fontSizeDesc-4,
                          fontWeight: FontWeight.bold,)
                    ),
                    SizedBox(height: 0.1 * PdfPageFormat.cm),
                    pw.Text(Rabbit.uni2zg("CUSTOMER: ဦးပြောင်ကြီး"),style: pw.TextStyle(fontSize: fontSizeDesc-6,font: ttfReg, color: PdfColors.grey600)),
                    pw.Text(Rabbit.uni2zg("ADDRESS: အဝေရာလမ်း၊ ထ(၁) ထောင့်"),style: pw.TextStyle(fontSize: fontSizeDesc-6,font: ttfReg, color: PdfColors.grey600)),
                    // Text('ADDRESS: Sanfran cisco', style: TextStyle(
                    //     fontSize: fontSizeDesc-6, color: PdfColors.grey600)),
                    Text('PHONE: (+959) 751133553', style: TextStyle(
                        fontSize: fontSizeDesc-6, color: PdfColors.grey600)),
                    SizedBox(height: 0.2 * PdfPageFormat.cm),
                  ],
                )
            )
          ),
          buildInvoice(invoice),
          Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: Container(decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1, color: PdfColors.grey800, style: BorderStyle.dashed),
                )),height: 1),
          ),
          buildTotal(invoice),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // buildSupplierAddress(invoice.supplier),
              Container(
                height: 25,
                width: 90,
                child: BarcodeWidget(
                    barcode: Barcode.codabar(),
                    data: invoice.info.number,
                    drawText: false
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          pw.Text('Thanks You',style: pw.TextStyle(fontSize: fontSizeDesc+5, fontWeight: pw.FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ]
      ),
      // footer: (context) => buildFooter(invoice),
    ));

    // pdf.addPage(MultiPage(
    //   pageFormat: PdfPageFormat.a4,
    //   build: (context) => [
    //     // buildHeader2(invoice),
    //     SizedBox(height: 3 * PdfPageFormat.cm),
    //     buildTitle(invoice),
    //     buildInvoice(invoice),
    //     Divider(),
    //     buildTotal(invoice),
    //   ],
    //   footer: (context) => buildFooter(invoice),
    // ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Future<pw.Widget> buildHeader2(Invoice invoice) async {
    final font = await rootBundle.load("fonts/ARIAL.TTF");
    final ttf = pw.Font.ttf(font);
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),

            Text('Shop Name', style: TextStyle(
                fontSize: fontSizeDesc, fontWeight: FontWeight.bold)),
            pw.Text("मेन",style: pw.TextStyle(fontSize: 16,font: ttf)),
            // ahttps://riftplus.info/dist/img/riftplus-fg.pnga
            SizedBox(height: 0.3 * PdfPageFormat.cm),
            Container(decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1, color: PdfColors.grey200),
                )),height: 1),
            SizedBox(height: 0.3 * PdfPageFormat.cm),


          ],
        )
    );
  }

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200, titleStyle: TextStyle(
          fontSize: 5
        ));
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier, ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: PdfPageFormat.mm * 2)),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(supplier.address, style: TextStyle(fontSize: PdfPageFormat.mm * 2)),
      ],
    );
  }

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitle2(Invoice invoice) => Padding(
    padding: new EdgeInsets.symmetric(horizontal: 15.0),
    child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            Text('RECEIPT INFO',
                style: TextStyle(
                  fontSize: fontSizeDesc-4,
                  fontWeight: FontWeight.bold,)
            ),
            SizedBox(height: 0.1 * PdfPageFormat.cm),
            Text('ADDRESS: Sanfran cisco', style: TextStyle(
                fontSize: fontSizeDesc-6, color: PdfColors.grey600)),
            Text('PHONE: (+959) 751133553', style: TextStyle(
                fontSize: fontSizeDesc-6, color: PdfColors.grey600)),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
          ],
        )
    )
  );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'NAME',
      // 'Date',
      'QTITY',
      'UNIT PRICE',
      // 'VAT',
      'TOTAL'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        // Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        // '${item.vat} %',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 5.0),
      child: Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeDesc-5),
        cellStyle: TextStyle(fontSize: fontSizeDesc-5),
        // headerDecoration: BoxDecoration(color: PdfColors.grey200),
        cellHeight: 0,
        headerAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          // 3: Alignment.centerRight,
          3: Alignment.centerRight,
        },
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          // 3: Alignment.centerRight,
          3: Alignment.centerRight,
        },
      )
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Padding(
      padding: new EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
      child: Container(
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.5 * PdfPageFormat.mm),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: buildText(
                        title: 'Sub total',
                        value: Utils.formatPrice(netTotal),
                        unite: true,
                        titleStyle: TextStyle(
                            fontSize: fontSizeDesc-5, fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  SizedBox(height: 1.5 * PdfPageFormat.mm),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: buildText(
                        title: 'Tax ${vatPercent * 100} %',
                        value: Utils.formatPrice(vat),
                        unite: true,
                        titleStyle: TextStyle(
                            fontSize: fontSizeDesc-5, fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  SizedBox(height: 1.5 * PdfPageFormat.mm),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: buildText(
                        title: 'Total price',
                        value: Utils.formatPrice(total),
                        unite: true,
                        titleStyle: TextStyle(
                            fontSize: fontSizeDesc-5, fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  SizedBox(height: .5 * PdfPageFormat.cm),


                  // Container(decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(
                  //           width: 1, color: PdfColors.grey800),
                  //     )),height: 1),
                  // buildText(
                  //   title: 'Total amount due',
                  //   titleStyle: TextStyle(
                  //       fontSize: fontSizeDesc-6, fontWeight: FontWeight.bold
                  //   ),
                  //   value: Utils.formatPrice(total),
                  //   unite: true,
                  // ),
                  // SizedBox(height: 2 * PdfPageFormat.mm),
                  // Container(height: 1, color: PdfColors.grey400),
                  // SizedBox(height: 0.5 * PdfPageFormat.mm),
                  // Container(height: 1, color: PdfColors.grey400),
                  // SizedBox(height: 1 * PdfPageFormat.cm),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
