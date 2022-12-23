import 'package:flutter/material.dart';
import 'package:invoicer/data/invoices_sql_helper.dart';
import 'package:invoicer/models/invoice_model.dart';
import 'package:invoicer/screens/update_invoice_screen.dart';
import 'package:invoicer/widgets/drawer.dart';

import 'create_invoice_screen.dart';

class Invoices extends StatefulWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
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
                            onTap: () => goToUpdateInvoice(invoices[index].id),
                            child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => deleteInvoice(invoice),
                                confirmDismiss: confirmDeletion,
                                child: ListTile(
                                  title: Text(invoice.dateAsText),
                                  subtitle: Text(invoice.id.toString()),
                                ),
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
    setState(() {
      sqlHelper.deleteInvoice(invoice);
    });
  }

  Future addInvoice() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CreateInvoice()))
        .then((value) => getInvoices());
  }

  Future<void> getInvoices() async {
    sqlHelper = InvoicesSqlHelper();
    DateTime fromDate = DateTime.now().subtract(const Duration(days: 31));

    invoices = await sqlHelper.getInvoices(fromDate, DateTime.now());
  }

  Future<void> refreshInvoices() async {
    sqlHelper = InvoicesSqlHelper();
    DateTime fromDate = DateTime.now().subtract(const Duration(days: 31));

    var refreshData = await sqlHelper.getInvoices(fromDate, DateTime.now());

    setState(() {
      invoices = refreshData;
    });
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
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  void goToUpdateInvoice(int id) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UpdateInvoice(id: id)));
  }
}
