import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:invoicer/extensions/datetime_extensions.dart';
import 'package:invoicer/helpers/pdf_helper.dart';
import 'package:invoicer/models/invoice_model.dart';
import 'package:invoicer/widgets/drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'invoices_screen.dart';

class ReviewInvoiceScreen extends StatefulWidget {
  const ReviewInvoiceScreen({Key? key, required this.invoice})
      : super(key: key);

  final InvoiceModel invoice;

  @override
  State<ReviewInvoiceScreen> createState() => _ReviewInvoiceScreenState();
}

class _ReviewInvoiceScreenState extends State<ReviewInvoiceScreen> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const InvoicesScreen()),
        (Route<dynamic> route) => false);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    var invoice = widget.invoice;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(title: const Text('Review Invoice')),
            drawer: const AppDrawer(),
            body: PdfPreview(
              canChangeOrientation: false,
              canChangePageFormat: false,
              allowSharing: false,
              canDebug: false,
              pdfFileName: '${invoice.personalDetails.forename} - Invoice',
              actions: [
                IconButton(
                    onPressed: () => send(invoice),
                    icon: const Icon(Icons.share))
              ],
              build: (format) async {
                var pdf = await PdfHelper.makePdf(invoice);
                var directory = await getApplicationDocumentsDirectory();

                var file = File('${directory.path}/${invoice.fileName}');
                await file.writeAsBytes(pdf);

                return pdf;
              },
            )));
  }

  Future<void> send(InvoiceModel invoice) async {
    try {
      var directory = await getApplicationDocumentsDirectory();

      var email = Email(
          subject: '${invoice.personalDetails.fullName} - Invoice '
              '${DateTime.now().toFormattedString('yyyyMMdd')}',
          recipients: [invoice.company.email],
          body: 'Hi,<br><br>'
              'Please find an invoice attached for work undertaken between '
              '${invoice.workDays.first.dateAsString} and '
              '${invoice.workDays.last.dateAsString}.<br><br>'
              'Regards,<br>'
              '${invoice.personalDetails.fullName}',
          attachmentPaths: ['${directory.path}/${invoice.fileName}'],
          isHTML: true);

      await FlutterEmailSender.send(email)
          .then((value) => Navigator.of(context).pop());
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending email'),
        ),
      );
    }
  }
}
