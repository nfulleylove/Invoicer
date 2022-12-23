import 'package:flutter/material.dart';
import 'package:invoicer/widgets/forms/invoice_stepper.dart';
import 'package:invoicer/widgets/drawer.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Create an Invoice')),
        drawer: const AppDrawer(),
        body: InvoiceStepper(id: 0));
  }
}
