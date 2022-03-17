import 'package:flutter/material.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
// import 'package:invoicer/data/locations_sql_helper.dart';
import 'package:invoicer/models/personal_details_model.dart';
import 'package:invoicer/widgets/drawer.dart';
import 'package:invoicer/widgets/forms/company_details_form_fields.dart';
import 'package:invoicer/widgets/forms/days_worked_form_fields.dart';
import 'package:invoicer/widgets/forms/payment_details_form_fields.dart';
import '../widgets/forms/personal_details_form_fields.dart';

List<GlobalKey<FormState>> _formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
];

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({Key? key}) : super(key: key);

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  static final PersonalDetailsSqlHelper _personalDetailsSqlHelper =
      PersonalDetailsSqlHelper();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an Invoice')),
      drawer: const AppDrawer(),
      body: Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            setState(() {
              bool isValid =
                  _formKeys[_index].currentState?.validate() ?? false;

              if (isValid) {
                if (_index < 1) {
                  _index += 1;
                } else {
                  _index = 0;
                }
              }
            });
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          steps: steps),
    );
  }

  List<Step> steps = [
    Step(
        title: const Text('Personal Details'),
        isActive: true,
        content: Form(
            key: _formKeys[0],
            child: FutureBuilder(
                future: getPersonalDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return PersonalDetailsFormFields(
                          personalDetails:
                              snapshot.data as PersonalDetailsModel);
                    } else {
                      return const Center(
                          child: Text('Personal Details failed to load'));
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }))),
    Step(
        title: const Text('Company Details'),
        isActive: false,
        content:
            Form(key: _formKeys[1], child: const CompanyDetailsFormFields())),
    Step(
        title: const Text('Payment Details'),
        isActive: false,
        content:
            Form(key: _formKeys[2], child: const PaymentDetailsFormFields())),
    Step(
        title: const Text('Days Worked'),
        isActive: false,
        content: Form(key: _formKeys[3], child: const DaysWorkedFormFields())),
  ];

  static Future<PersonalDetailsModel> getPersonalDetails() async {
    return await _personalDetailsSqlHelper.getPersonalDetails();
  }
}
