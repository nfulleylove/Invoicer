import 'package:flutter/material.dart';
import 'package:invoicer/widgets/forms/invoice_stepper.dart';
import 'package:invoicer/widgets/drawer.dart';

// ignore: must_be_immutable
class UpdateInvoiceScreen extends StatefulWidget {
  int id;
  String dateText;

  UpdateInvoiceScreen({Key? key, required this.id, required this.dateText})
      : super(key: key);

  @override
  State<UpdateInvoiceScreen> createState() => _UpdateInvoiceScreenState();
}

class _UpdateInvoiceScreenState extends State<UpdateInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Update Invoice - ${widget.dateText}')),
        drawer: const AppDrawer(),
        body: InvoiceStepper(id: widget.id));
  }
}
