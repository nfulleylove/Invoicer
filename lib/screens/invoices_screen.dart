import 'package:flutter/material.dart';
import 'package:invoicer/data/invoices_sql_helper.dart';
import 'package:invoicer/models/invoice_model.dart';
import 'package:invoicer/screens/update_invoice_screen.dart';
import 'package:invoicer/widgets/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'create_invoice_screen.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  InvoicesSqlHelper sqlHelper = InvoicesSqlHelper();
  List<InvoiceModel> invoices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Invoices')),
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add), onPressed: addInvoice),
        body: FutureBuilder(
            future: getInvoices(),
            builder: (context, snapshot) {
              if (invoices.isNotEmpty) {
                return RefreshIndicator(
                    onRefresh: refreshInvoices,
                    child: ListView.separated(
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        var invoice = invoices[index];
                        return InkWell(
                            onTap: () => goToUpdateInvoice(
                                invoice.id, invoice.dateAsText),
                            child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => deleteInvoice(invoice),
                                confirmDismiss: confirmDeletion,
                                child: ListTile(
                                    leading: Icon(MdiIcons.fileDocumentOutline,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    title: Text(invoice.dateAsText,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark)),
                                    subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '£${invoice.totalLabourCosts.toStringAsFixed(2)}'),
                                          Text(invoice.locationsText)
                                        ])),
                                background: Container(
                                  color: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ));
              } else {
                return const Center(
                    child: Text("No invoices have been created"));
              }
            }));
  }

  Future deleteInvoice(InvoiceModel invoice) async {
    try {
      bool wasDeleted = await sqlHelper.deleteInvoice(invoice);

      if (wasDeleted) {
        setState(() {
          invoices.remove(invoice);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invoice deleted"),
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error deleting invoice"),
        ));
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error deleting incoice"),
      ));
    }
  }

  Future addInvoice() async {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => const CreateInvoiceScreen()))
        .then((value) => getInvoices());
  }

  Future<void> getInvoices() async {
    try {
      sqlHelper = InvoicesSqlHelper();
      DateTime fromDate = DateTime.now().subtract(const Duration(days: 31));

      invoices = await sqlHelper.getInvoices(fromDate, DateTime.now());
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error retrieving incoices"),
      ));
    }
  }

  Future<void> refreshInvoices() async {
    try {
      sqlHelper = InvoicesSqlHelper();
      DateTime fromDate = DateTime.now().subtract(const Duration(days: 31));

      var refreshData = await sqlHelper.getInvoices(fromDate, DateTime.now());

      setState(() {
        invoices = refreshData;
      });
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error retrieving incoices"),
      ));
    }
  }

  Future<bool?> confirmDeletion(DismissDirection direction) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Invoice'),
          content: const Text('Are you sure you want to delete the invoice?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).errorColor),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  void goToUpdateInvoice(int id, String dateText) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateInvoiceScreen(id: id, dateText: dateText)));
  }
}
