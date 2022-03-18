import 'package:flutter/material.dart';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/models/company_model.dart';
import 'package:invoicer/widgets/drawer.dart';
import 'package:invoicer/widgets/forms/company_details_form_fields.dart';

import '../models/company_model.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({Key? key}) : super(key: key);

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  CompaniesSqlHelper sqlHelper = CompaniesSqlHelper();
  List<CompanyModel> companies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Companies')),
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
            onPressed: addCompany, child: const Icon(Icons.add)),
        body: FutureBuilder(
            future: getCompanies(),
            builder: (context, snapshot) {
              companies =
                  snapshot.hasData ? snapshot.data as List<CompanyModel> : [];

              if (companies.isNotEmpty) {
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    var company = companies[index];
                    return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => deleteCompany(company),
                        confirmDismiss: confirmDeletion,
                        child: ListTile(
                            leading: const Icon(Icons.business),
                            trailing: TextButton(
                                onPressed: () => {updateCompany(company)},
                                child: const Text('Manage')),
                            title: Text(company.name),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(company.address),
                                  Text(company.town),
                                  Text(company.county),
                                  Text(company.postcode)
                                ])),
                        background: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerEnd,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              } else {
                return const Center(
                    child: Text("No companies have been added"));
              }
            }));
  }

  Future deleteCompany(CompanyModel company) async {
    setState(() {
      sqlHelper.deleteCompany(company);
    });
  }

  Future addCompany() async {
    final _formKey = GlobalKey<FormState>();
    var company = CompanyModel(-1, '', '', '', '', '', '');

    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Company'),
          content: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: CompanyDetailsFormFields(company: company),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  var form = _formKey.currentState;

                  if (form!.validate()) {
                    form.save();
                    sqlHelper.insertCompany(company);
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future updateCompany(CompanyModel company) async {
    final _formKey = GlobalKey<FormState>();

    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Company'),
          content: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: CompanyDetailsFormFields(company: company),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  var form = _formKey.currentState;

                  if (form!.validate()) {
                    form.save();
                    sqlHelper.updateCompany(company);
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<CompanyModel>> getCompanies() async {
    sqlHelper = CompaniesSqlHelper();

    var _companies = await sqlHelper.getCompanies();
    _companies.sort((a, b) => a.name.compareTo(b.name));

    return _companies;
  }

  Future<bool?> confirmDeletion(DismissDirection direction) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Company'),
          content: const Text('Are you sure you want to delete the company?'),
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
}
