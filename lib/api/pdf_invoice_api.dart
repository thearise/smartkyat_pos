import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:smartkyat_pos/api/pdf_api.dart';
import 'package:smartkyat_pos/api/utils.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/model/customer.dart';
import 'package:smartkyat_pos/model/invoice.dart';
import 'package:smartkyat_pos/model/supplier.dart';
import 'rabbit.dart';

class PdfInvoiceApi {
  static double fontSizeDesc = 0;

  static Future<File> generate(Invoice invoice, String size, bool isEnglish) async {
    if(size == 'Roll-57') {
      fontSizeDesc = 11.0;
    } else if(size == 'Roll-80') {
      fontSizeDesc = 14;
    } else if(size == 'A4') {
      fontSizeDesc = 14;
    } else if(size == 'Legal') {
      fontSizeDesc = 14;
    }
    final pdf = Document();

    final font = await rootBundle.load("assets/SangamZawgyi.ttf");
    final ttfBold = pw.Font.ttf(font);

    final font2 = await rootBundle.load("assets/ZawgyiOne2008.ttf");
    final ttfReg = pw.Font.ttf(font2);

    PdfPageFormat pageFormat = PdfPageFormat.roll80;
    if(size == 'Roll-57') {
      pageFormat = PdfPageFormat.roll57;
    } else if(size == 'Roll-80') {
      pageFormat = PdfPageFormat.roll80;
    } else if(size == 'Legal') {
      pageFormat = PdfPageFormat.legal;
    } else if(size == 'A4') {
      pageFormat = PdfPageFormat.a4;
    }

    var image = pw.MemoryImage(
      (await rootBundle.load('assets/system/poweredby.png')).buffer.asUint8List(),
    );


    pdf.addPage(pw.Page(
      pageFormat: pageFormat,
      margin: new EdgeInsets.symmetric(horizontal: 0.0),
      build: (context) => Column(
          children: [
            Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 0.5 * PdfPageFormat.cm),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size == 'Roll-80' ? 12: 10),
                      child: Column(
                          children: [
                            if(size == 'Roll-80') SizedBox(height: 0.2 * PdfPageFormat.cm),
                            pw.Text(Rabbit.uni2zg(invoice.supplier.name),
                              textAlign: pw.TextAlign.center, style: pw.TextStyle(height: -0.7, fontSize: size == 'Roll-57'? fontSizeDesc+5: fontSizeDesc+8,font: ttfBold),
                            ),
                            SizedBox(height: size == 'Roll-80' ? 0.25 * PdfPageFormat.cm: 0.2 * PdfPageFormat.cm),
                            // pw.Text(Rabbit.uni2zg("ဘာတွေလဲ ဘာေတွလဲ ဘာတွေဖြစ်နေတာလဲလို့ ပြောကြပါဦး Whatting?"),style: pw.TextStyle(fontSize: fontSizeDesc-4,font: ttfReg, fontWeight: FontWeight.bold)),
                            // ahttps://riftplus.info/dist/img/riftplus-fg.pnga
                            pw.Text(Rabbit.uni2zg(invoice.supplier.address),style: pw.TextStyle(height: 1, fontSize: fontSizeDesc-3,font: ttfReg, color: PdfColors.black)),
                            pw.Text(Rabbit.uni2zg(invoice.supplier.phone),style: pw.TextStyle(height: 1, fontSize: fontSizeDesc-3,font: ttfReg, color: PdfColors.black)),
                          ]
                      ),
                    ),
                    SizedBox(height: size == 'Roll-80'? 0.35 * PdfPageFormat.cm: 0.3 * PdfPageFormat.cm),

                    Container(decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5, color: PdfColors.black, style: BorderStyle.dashed
                          ),
                        )
                    ),height: 3),
                    SizedBox(height: size == 'Roll-80'? 0.35 * PdfPageFormat.cm: 0.3 * PdfPageFormat.cm),


                  ],
                )
            ),
            // SizedBox(height: 3 * PdfPageFormat.cm),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size == 'Roll-80' ? 12: 10),
                child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: size=='Roll-57' || size=='Roll-80'? CrossAxisAlignment.start: CrossAxisAlignment.end,
                      mainAxisAlignment: size=='Roll-57' || size=='Roll-80'? pw.MainAxisAlignment.start: pw.MainAxisAlignment.end,
                      children: [
                        Text(Rabbit.uni2zg(isEnglish? 'Receipt info: ': 'ဘောင်ချာနံပါတ်: ') + invoice.info.number,
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontSize: fontSizeDesc-1,
                              fontWeight: FontWeight.bold,)
                        ),
                        SizedBox(height: size == 'Roll-80'? 0.15 * PdfPageFormat.cm: 0.1 * PdfPageFormat.cm),
                        invoice.customer.name != 'name'?
                        pw.Text(Rabbit.uni2zg((isEnglish? 'Name: ': 'အမည်: ') + whatIsWhat(invoice.customer.name.toString(), isEnglish)),style: pw.TextStyle(fontSize: fontSizeDesc-3,font: ttfReg, color: PdfColors.grey800)) :
                        pw.Text(Rabbit.uni2zg('Name: no customer'),style: pw.TextStyle(fontSize: fontSizeDesc-3,font: ttfReg, color: PdfColors.grey800)),
                        pw.Text(Rabbit.uni2zg((isEnglish? 'Date: ': 'ရက်စွဲ: ') + invoice.info.date.day.toString() + '-' + invoice.info.date.month.toString() + '-' + invoice.info.date.year.toString()),style: pw.TextStyle(fontSize: fontSizeDesc-3,font: ttfReg, color: PdfColors.grey800)),
                        // Text('ADDRESS: Sanfran cisco', style: TextStyle(
                        //     fontSize: fontSizeDesc-6, color: PdfColors.grey600)),
                        // Text('PHONE: (+959) 751133553', style: TextStyle(
                        //     fontSize: fontSizeDesc-6, color: PdfColors.grey600)),
                        SizedBox(height: size == 'Roll-80'? 0.25 * PdfPageFormat.cm: 0.2 * PdfPageFormat.cm),
                      ],
                    )
                )
            ),
            buildInvoice(invoice, ttfReg, ttfBold, size, isEnglish),
            SizedBox(height: size == 'Roll-80'? 0.25 * PdfPageFormat.cm: 0.2 * PdfPageFormat.cm),
            Padding(
              padding: new EdgeInsets.only(top: 5.0),
              child: Container(decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.5, color: PdfColors.black, style: BorderStyle.dashed),
                  )),height: 1),
            ),
            buildTotal(invoice, size, pageFormat, ttfReg, isEnglish),
            // size == 'Roll-57' ? Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: pw.CrossAxisAlignment.center,
            //   children: [
            //     // buildSupplierAddress(invoice.supplier),
            //     Container(
            //       height: 25,
            //       width: 90,
            //       child: BarcodeWidget(
            //           barcode: Barcode.code128(),
            //           data: invoice.info.number,
            //           drawText: false
            //       ),
            //     ),
            //   ],
            // ): Container(),

            // SizedBox(height: 0.5 * PdfPageFormat.cm),
            // pw.Text('Thank you',style: pw.TextStyle(fontSize: fontSizeDesc+5, fontWeight: pw.FontWeight.bold)),
            pw.Text(Rabbit.uni2zg('ကျေးဇူးတင်ပါသည်။'),
              textAlign: pw.TextAlign.center, style: pw.TextStyle(height: -0.7, fontSize: size == 'Roll-57'? fontSizeDesc+5: fontSizeDesc+8,font: ttfBold),
            ),
            SizedBox(height: size == 'Roll-80'? 0.17 * PdfPageFormat.cm: 0.15 * PdfPageFormat.cm),
            pw.Center(
              child: pw.Image(image, height: size=='Roll-80'? fontSizeDesc + 10 : fontSizeDesc + 6),
            ),
            // pw.Text('Powered by Smart Kyat', textAlign: pw.TextAlign.center, style: pw.TextStyle(height: -0.7, fontSize: fontSizeDesc-5),),
            // pw.Icon(
            //   Icons.remove, size: 20,
            // ),
            SizedBox(height: size == 'Roll-80'? 0.8 * PdfPageFormat.cm: 0.5 * PdfPageFormat.cm),
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

  static Widget buildInvoice(Invoice invoice, ttfReg, ttfBold, String size, bool isEnglish) {
    if(size!='Roll-57' && size!='Roll-80') {
      final headers = [
        'Name',
        // 'Date',
        'Qty',
        'Unit price',
        // 'VAT',
        'Total'
      ];
      final data = invoice.items.map((item) {
        final total = item.unitPrice * item.quantity;
        RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
        return [
          // item.date.split('-')[0] == 'unit_name' ?
          Rabbit.uni2zg(item.description + ' (' + item.date + ')'),
          // Utils.formatDate(item.date),
          '${item.quantity}'.replaceAll(regex, ''),
          '${item.unitPrice} ${item.currencyUnit}',
          // '${item.vat} %',
          '${total.toStringAsFixed(2)} ${item.currencyUnit}',
        ];
      }).toList();

      return Padding(
          padding: new EdgeInsets.symmetric(horizontal: size == 'Roll-80'? 7: 5.0),
          child: Table.fromTextArray(
            headers: headers,
            data: data,
            border: null,
            headerStyle: pw.TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeDesc-3),
            cellStyle: pw.TextStyle(fontSize: fontSizeDesc-3, font: ttfReg),
            // headerDecoration: BoxDecoration(color: PdfColors.grey200),
            cellHeight: 0,
            cellPadding: const EdgeInsets.only(left: 5, right: 5, bottom: 2, top: 2),
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
    } else {
      final headers = [
        Rabbit.uni2zg(isEnglish? 'Item': 'ပစ္စည်း'),
        // 'Date',
        // 'Qty',-
        // 'UNIT PRICE',
        // 'VAT',
        Rabbit.uni2zg(isEnglish? 'Total': 'စုစုပေါင်း'),
      ];
      final data = invoice.items.map((item) {
        final total = item.unitPrice * item.quantity;
        RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
        return [
          // item.date.split('-')[0] == 'unit_name' ?
          Rabbit.uni2zg(item.description + ' (' + item.date + ' - ${item.unitPrice} x ' + '${item.quantity}'.replaceAll(regex, '') + ')'),
          // Utils.formatDate(item.date),
          // '${item.quantity}',
          // '\$ ${item.unitPrice}',
          // '${item.vat} %',
          '${total.toStringAsFixed(2)} ${item.currencyUnit}',
        ];
      }).toList();

      return Padding(
          padding: new EdgeInsets.symmetric(horizontal: size=='Roll-80'? 7.0: 5.0),
          child: Table.fromTextArray(
            headers: headers,
            data: data,
            border: null,
            headerStyle: pw.TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeDesc-2, font: ttfBold),
            cellStyle: pw.TextStyle(fontSize: fontSizeDesc-3, font: ttfReg),
            // headerDecoration: BoxDecoration(color: PdfColors.grey200),
            cellHeight: 0,
            cellPadding: const EdgeInsets.only(left: 5, right: 5, bottom: 2, top: 2),
            headerAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerRight,
              // 2: Alignment.centerRight,
              // 3: Alignment.centerRight,
              2: Alignment.centerRight,
            },
            cellAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerRight,
              // 2: Alignment.centerRight,
              // 3: Alignment.centerRight,
              2: Alignment.centerRight,
            },
          )
      );
    }

  }

  static Widget buildTotal(Invoice invoice, String size, PdfPageFormat pageFormat, ttfBold, bool isEnglish) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final disType = invoice.items.first.type;
    final debt = invoice.items.first.debt;
    final currency = invoice.items.first.currencyUnit;
    final subTotalText = invoice.items.first.subTotalText;
    final discountText = invoice.items.first.discountText;
    final totalPriceText = invoice.items.first.totalPriceText;
    final paidText = invoice.items.first.paidText;
    final totalDebtText =invoice.items.first.totalDebtText;
    final vat;
    disType == '-p' ?  vat = netTotal * (vatPercent/100) : vat = vatPercent ;
    final total = netTotal - vat;
    final paid = total - debt;
    return size != 'Roll-57' && size!='Roll-80' ?
    Padding(
        padding: new EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
        child: Container(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4 * PdfPageFormat.mm),
                child: Container(
                  height: 30,
                  width: 90,
                  child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: invoice.info.number,
                      drawText: false
                  ),
                ),
              ),
              Spacer(),
              Container(
                  width: pageFormat.width/2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size=='Roll-80'? 3 * PdfPageFormat.mm: 2.5 * PdfPageFormat.mm),
                      Padding(
                        padding: EdgeInsets.only(left: size=='Roll-80'? 12: 10, right: size=='Roll-80'? 12: 10),
                        child: buildText(
                            title:  Rabbit.uni2zg(subTotalText),
                            value: Utils.formatPrice(netTotal) + ' $currency',
                            unite: true,
                            titleStyle: TextStyle(
                                fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold,
                            )
                        ),
                      ),
                      SizedBox(height: 1.5 * PdfPageFormat.mm),
                      Padding(
                        padding: EdgeInsets.only(left: size=='Roll-80'? 12: 10, right: size=='Roll-80'? 12: 10),
                        child: buildText(
                            title: disType == '-p'? Rabbit.uni2zg('$discountText (${vatPercent * 1} %)') : Rabbit.uni2zg(discountText),
                          //title: disType == '-p'?('Discount (${vatPercent * 1} %)') : ('Discount'),
                            value: Utils.formatPrice(vat) + ' $currency',
                            unite: true,
                            titleStyle: TextStyle(
                                fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                            ),
                        ),
                      ),
                      SizedBox(height: 1.5 * PdfPageFormat.mm),
                      Padding(
                        padding: EdgeInsets.only(left: size=='Roll-80'? 12: 10, right: size=='Roll-80'? 12: 10),
                        child: buildText(
                           title: Rabbit.uni2zg(totalPriceText),
                            //title: 'Total',
                            value: Utils.formatPrice(total) + ' $currency',
                            unite: true,
                            titleStyle: TextStyle(
                                fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                            )
                        ),
                      ),
                      SizedBox(height: 1.5 * PdfPageFormat.mm),
                      Padding(
                        padding: EdgeInsets.only(left: size=='Roll-80'? 12: 10, right: size=='Roll-80'? 12: 10),
                        child: buildText(
                            title: Rabbit.uni2zg(paidText),
                            //title: 'Paid',
                            value: Utils.formatPrice(paid) + ' $currency',
                            unite: true,
                            titleStyle: TextStyle(
                                fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                            )
                        ),
                      ),
                      SizedBox(height: 1.5 * PdfPageFormat.mm),
                      Padding(
                        padding: EdgeInsets.only(left: size=='Roll-80'? 12: 10, right: size=='Roll-80'? 12: 10),
                        child: buildText(
                            title:  Rabbit.uni2zg(totalDebtText + 'test1'),
                            //title: 'Debt',

                            value: Utils.formatPrice(debt) + ' $currency',
                            unite: true,
                            titleStyle: TextStyle(
                                fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                            )
                        ),
                      ),
                      SizedBox(height: size=='Roll-80'? 1 * PdfPageFormat.cm: .5 * PdfPageFormat.cm),
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
                  )
              ),
            ],
          ),
        )
    ):
    Padding(
        padding: new EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
        child: Container(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size == 'Roll-80'? 3 * PdfPageFormat.mm: 2.5 * PdfPageFormat.mm),
                    Padding(
                      padding: EdgeInsets.only(left: size == 'Roll-80'? 12: 10, right: size == 'Roll-80'? 12: 10),
                      child: buildText(
                         title: Rabbit.uni2zg(isEnglish? 'Sub total': 'ကျသင့်ငွေပေါင်း'),
                          //title: 'Sub Total',
                          value: Utils.formatPrice(netTotal) + ' $currency',
                          unite: true,
                          titleStyle: TextStyle(
                              fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold ,  font: ttfBold
                          )
                      ),
                    ),
                    SizedBox(height: size == 'Roll-80'? 2 * PdfPageFormat.mm: 1.5 * PdfPageFormat.mm),
                    Padding(
                      padding: EdgeInsets.only(left: size == 'Roll-80'? 12: 10, right: size == 'Roll-80'? 12: 10),
                      child: buildText(
                          //title: 'Paid',
                          title:   disType == '-p'? Rabbit.uni2zg((isEnglish? 'Discount': 'လျှော့ငွေ') + ' (${vatPercent * 1} %)') : Rabbit.uni2zg((isEnglish? 'Discount': 'လျှော့ငွေ')),
                          value: Utils.formatPrice(vat) + ' $currency',
                          unite: true,
                          titleStyle: TextStyle(
                              fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                          )
                      ),
                    ),
                    SizedBox(height: size == 'Roll-80'? 2 * PdfPageFormat.mm: 1.5 * PdfPageFormat.mm),
                    Padding(
                      padding: EdgeInsets.only(left: size == 'Roll-80'? 12: 10, right: size == 'Roll-80'? 12: 10),
                      child: buildText(
                         title: Rabbit.uni2zg((isEnglish? 'Total price': 'စုစုပေါင်းကျငွေ')),
                          //title: 'Total',
                          value: Utils.formatPrice(total) + ' $currency',
                          unite: true,
                          titleStyle: TextStyle(
                              fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                          )
                      ),
                    ),
                    SizedBox(height: size == 'Roll-80'? 2 * PdfPageFormat.mm: 1.5 * PdfPageFormat.mm),
                    Padding(
                      padding: EdgeInsets.only(left: size == 'Roll-80'? 12: 10, right: size == 'Roll-80'? 12: 10),
                      child: buildText(
                         title: Rabbit.uni2zg((isEnglish? 'Paid': 'ပေးငွေ')),
                          //title: 'Paid',
                          value: Utils.formatPrice(paid) + ' $currency',
                          unite: true,
                          titleStyle: TextStyle(
                              fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                          )
                      ),
                    ),
                    SizedBox(height: size == 'Roll-80'? 2 * PdfPageFormat.mm: 1.5 * PdfPageFormat.mm),
                    Padding(
                      padding: EdgeInsets.only(left: size == 'Roll-80'? 12: 10, right: size == 'Roll-80'? 12: 10),
                      child: buildText(
                         title: Rabbit.uni2zg((isEnglish? 'Debt': 'ကျန်ငွေ')),
                          //title: 'Debt',
                          value: Utils.formatPrice(debt) + ' $currency',
                          unite: true,
                          titleStyle: TextStyle(
                              fontSize: fontSizeDesc-3, fontWeight: FontWeight.bold, font: ttfBold
                          )
                      ),
                    ),
                    SizedBox(height: size == 'Roll-80'? 0.3 * PdfPageFormat.cm: .1 * PdfPageFormat.cm),


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

  static whatIsWhat(String str, bool isEnglish) {
    if (isEnglish) {
      if (str == 'No customer') {
        return 'Walk-in customer';
      } else if(str == 'No merchant') {
        return 'Walk-in merchant';
      } else {
        return str;
      }
    } else {
      if (str == 'No customer') {
        return 'အမည်မသိ ဖောက်သည်';
      } else if(str == 'No merchant') {
        return 'အမည်မသိ ကုန်သည်';
      } else {
        return str;
      }
    }
  }
}
