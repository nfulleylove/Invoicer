// ignore: file_names
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/invoice_model.dart';

class PdfHelper {
  static Future<Uint8List> makePdf(InvoiceModel invoice) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          return _header(invoice);
        },
        build: (context) {
          return _workDaysAndPaymentDetails(context, invoice);
        },
        footer: (pw.Context context) {
          return _footer(context);
        }));

    return pdf.save();
  }

  static pw.Column _header(InvoiceModel invoice) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: pw.Align(
                  alignment: pw.Alignment.topCenter,
                  child: pw.Text(
                    invoice.title,
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold),
                  ))),
          pw.Text(
            invoice.personalDetails.company.toUpperCase(),
            style: pw.TextStyle(
                color: PdfColor.fromHex('#2A4B7E'),
                fontSize: 18,
                fontWeight: pw.FontWeight.bold),
          ),
          pw.RichText(
              text: pw.TextSpan(children: <pw.TextSpan>[
            pw.TextSpan(
                text: 'CIS4(P): ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TextSpan(text: invoice.personalDetails.cis4p)
          ])),
          pw.RichText(
              text: pw.TextSpan(children: <pw.TextSpan>[
            pw.TextSpan(
                text: 'NI: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TextSpan(text: invoice.personalDetails.nationalInsurance)
          ])),
          pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text(
                invoice.personalDetails.addressText,
                textAlign: pw.TextAlign.right,
              )),
          pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: pw.Text(invoice.company.addressText,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))
        ]);
  }

  static List<pw.Widget> _workDaysAndPaymentDetails(
      pw.Context context, InvoiceModel invoice) {
    return [
      pw.Text('Days Worked',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      _table(context, invoice),
      pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 20),
          child: pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.RichText(
                text: pw.TextSpan(children: <pw.TextSpan>[
              pw.TextSpan(
                  text: 'Total Labour Costs: ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(
                  text: '£${invoice.totalLabourCosts.toStringAsFixed(2)}')
            ])),
          )),
      pw.Text('To be paid to:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Text(invoice.paymentDetails.nameOnCard.toUpperCase()),
      pw.RichText(
          text: pw.TextSpan(children: <pw.TextSpan>[
        pw.TextSpan(
            text: 'Account No: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TextSpan(text: invoice.paymentDetails.accountNumber)
      ])),
      pw.RichText(
          text: pw.TextSpan(children: <pw.TextSpan>[
        pw.TextSpan(
            text: 'Sort Code: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TextSpan(text: invoice.paymentDetails.sortCode)
      ])),
    ];
  }

  static pw.Widget _table(pw.Context context, InvoiceModel invoice) {
    const tableHeaders = ['Date', 'Location', 'Miles', 'Cost'];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
      ),
      headerHeight: 25,
      cellHeight: 25,
      columnWidths: {
        0: const pw.FlexColumnWidth(15),
        1: const pw.FlexColumnWidth(65),
        2: const pw.FlexColumnWidth(10),
        3: const pw.FlexColumnWidth(10)
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 10,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
          invoice.workDays.length,
          (row) => [
                invoice.workDays[row].dateAsString,
                invoice.workDays[row].location,
                invoice.workDays[row].miles.toString(),
                invoice.workDays[row].rate.toStringAsFixed(2)
              ]),
    );
  }

  static pw.Container _footer(pw.Context context) {
    return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey)));
  }
}
