import 'package:flutter/material.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
import 'package:invoicer/models/personal_details_model.dart';
import 'package:invoicer/widgets/forms/personal_details_form_fields.dart';

import '../widgets/drawer.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  static final PersonalDetailsSqlHelper _personalDetailsSqlHelper =
      PersonalDetailsSqlHelper();
  late PersonalDetailsModel personalDetails;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Personal Details')),
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            saveChanges();
          },
          icon: const Icon(Icons.save_rounded),
          label: const Text('Update'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
              future: getPersonalDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    personalDetails = snapshot.data as PersonalDetailsModel;

                    return Form(
                        key: _formKey,
                        child: PersonalDetailsFormFields(
                            personalDetails:
                                snapshot.data as PersonalDetailsModel));
                  } else {
                    return const Center(
                        child: Text('Personal Details failed to load'));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        )));
  }

  Future saveChanges() async {
    var form = _formKey.currentState;

    form?.save();

    return await _personalDetailsSqlHelper
        .updatePersonalDetails(personalDetails);
  }

  Future<PersonalDetailsModel> getPersonalDetails() async {
    return await _personalDetailsSqlHelper.getPersonalDetails();
  }
}
