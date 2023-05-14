import 'package:flutter/material.dart';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/models/company_model.dart';
import 'package:invoicer/widgets/drawer.dart';
import 'package:invoicer/widgets/forms/company_details_form_fields.dart';

// ignore: must_be_immutable
class CompaniesScreen extends StatefulWidget {
  bool showDrawer = true;

  CompaniesScreen({Key? key, required this.showDrawer}) : super(key: key);

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
        drawer: widget.showDrawer ? const AppDrawer() : null,
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
                        child: InkWell(
                            onTap: (() => updateCompany(company)),
                            child: ListTile(
                                leading: Icon(Icons.business,
                                    color: Theme.of(context).primaryColorDark),
                                onTap: () => {updateCompany(company)},
                                title: Text(
                                  company.name,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(company.address),
                                      Text(company.town),
                                      Text(company.county),
                                      Text(company.postcode)
                                    ]))),
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
    bool wasDeleted = await sqlHelper.deleteCompany(company);

    if (wasDeleted) {
      setState(() {
        companies.remove(company);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Company deleted"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error deleting company"),
      ));
    }
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
                onPressed: () async {
                  var form = _formKey.currentState;

                  if (form!.validate()) {
                    form.save();
                    int companyId = await sqlHelper.insertCompany(company);

                    if (companyId > 0) {
                      setState(() {
                        company.id = companyId;
                        companies.add(company);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Company added"),
                      ));

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Error adding company"),
                      ));
                    }
                  }
                }),
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
                onPressed: () async {
                  var form = _formKey.currentState;

                  if (form!.validate()) {
                    form.save();
                    bool wasUpdated = await sqlHelper.updateCompany(company);

                    if (wasUpdated) {
                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Company updated"),
                      ));

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Error updating company"),
                      ));
                    }
                  }
                }),
          ],
        );
      },
    );
  }

  Future<List<CompanyModel>> getCompanies() async {
    try {
      var _companies = await sqlHelper.getCompanies();
      _companies.sort((a, b) => a.name.compareTo(b.name));

      return _companies;
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error retrieving companies"),
      ));

      return Future.error(ex);
    }
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
