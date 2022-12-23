import 'package:flutter/material.dart';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/data/invoices_sql_helper.dart';
import 'package:invoicer/data/payment_details_sql_helper.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
import 'package:invoicer/models/company_model.dart';
import 'package:invoicer/models/invoice_model.dart';
import 'package:invoicer/models/payment_details_model.dart';
import 'package:invoicer/models/personal_details_model.dart';
import 'package:invoicer/models/work_day_model.dart';
import 'package:invoicer/screens/companies_screen.dart';
import 'package:invoicer/screens/review_invoice_screen.dart';
import 'package:invoicer/widgets/drawer.dart';
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

  static final CompaniesSqlHelper _companiesSqlHelper = CompaniesSqlHelper();

  static final PaymentDetailsSqlHelper _paymentDetailsSqlHelper =
      PaymentDetailsSqlHelper();

  static final InvoicesSqlHelper _invoicesSqlHelper = InvoicesSqlHelper();

  int _index = 0;
  static CompanyModel? selectedCompany;
  PersonalDetailsModel? personalDetails;
  PaymentDetailsModel? paymentDetails;
  List<WorkDayModel> daysWorked = [];

  static Route<void> _myRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => CompaniesScreen(showDrawer: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isLastStep = _index + 1 == _formKeys.length;

    return Scaffold(
        appBar: AppBar(title: const Text('Create an Invoice')),
        drawer: const AppDrawer(),
        body: Stepper(
          type: StepperType.horizontal,
          currentStep: _index,
          controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
            return Row(
              children: <Widget>[
                _isLastStep
                    ? ElevatedButton.icon(
                        onPressed: dtl.onStepContinue,
                        icon: const Icon(Icons.send),
                        label: const Text('REVIEW AND SEND'),
                      )
                    : ElevatedButton(
                        onPressed: dtl.onStepContinue,
                        child: const Text('CONTINUE'),
                      ),
                TextButton(
                  onPressed: dtl.onStepCancel,
                  child: Text(_index > 0 ? 'CANCEL' : ''),
                ),
              ],
            );
          },
          onStepCancel: () {
            if (_index > 0) setState(() => _index -= 1);
          },
          onStepContinue: () {
            bool isValid = false;

            _formKeys[_index].currentState!.save();

            if (_index == 1) {
              isValid = (selectedCompany != null);
            } else {
              isValid = _formKeys[_index].currentState?.validate() ?? false;
            }

            if (isValid) {
              if (!_isLastStep) {
                if (_index == 0) {
                  _personalDetailsSqlHelper
                      .updatePersonalDetails(personalDetails!);
                }

                if (_index == 2) {
                  _paymentDetailsSqlHelper
                      .updatePaymentDetails(paymentDetails!);
                }

                setState(() {
                  _index += 1;
                });
              } else {
                reviewInvoice();
              }
            }
          },
          steps: [
            Step(
                title: Text(_index == 0 ? 'Personal Details' : ''),
                isActive: _index == 0,
                state: _index == 0 ? StepState.editing : StepState.complete,
                content: Form(
                    key: _formKeys[0],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FutureBuilder(
                        future: getPersonalDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              personalDetails =
                                  snapshot.data as PersonalDetailsModel;

                              return PersonalDetailsFormFields(
                                  personalDetails: personalDetails!);
                            } else {
                              return const Center(
                                  child:
                                      Text('Personal Details failed to load'));
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }))),
            Step(
                title: Text(_index == 1 ? 'Company Details' : ''),
                isActive: _index == 1,
                state: _index < 1
                    ? StepState.indexed
                    : _index == 1
                        ? StepState.editing
                        : StepState.complete,
                content: Form(
                    key: _formKeys[1],
                    child: FutureBuilder<List<CompanyModel>>(
                        future: getCompanies(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              selectedCompany ??= snapshot.data!.first;

                              return DropdownButtonFormField<CompanyModel>(
                                value: selectedCompany,
                                decoration:
                                    const InputDecoration(labelText: "Company"),
                                hint: const Text("Select a Company"),
                                onChanged: (CompanyModel? newValue) {
                                  setState(() {
                                    selectedCompany = newValue!;
                                  });
                                },
                                items: snapshot.data
                                    ?.map((c) => DropdownMenuItem<CompanyModel>(
                                          value: c,
                                          child: Text(c.name),
                                        ))
                                    .toList(),
                                isExpanded: true,
                              );
                            } else {
                              return Column(children: [
                                const Text("No companies have been added."),
                                TextButton(
                                  child: const Text('Add a Company'),
                                  onPressed: () async {
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                CompaniesScreen(
                                                  showDrawer: false,
                                                )))
                                        .then((value) {
                                      getCompanies();
                                      setState(() {});
                                    });
                                  },
                                )
                              ]);
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }))),
            Step(
                title: Text(_index == 2 ? 'Payment Details' : ''),
                isActive: _index == 2,
                state: _index < 2
                    ? StepState.indexed
                    : _index == 2
                        ? StepState.editing
                        : StepState.complete,
                content: Form(
                    key: _formKeys[2],
                    child: FutureBuilder(
                        future: getPaymentDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              paymentDetails =
                                  snapshot.data as PaymentDetailsModel;

                              return PaymentDetailsFormFields(
                                  paymentDetails: paymentDetails!);
                            } else {
                              return const Center(
                                  child:
                                      Text('Payment Details failed to load'));
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }))),
            Step(
                title: Text(_index == 3 ? 'Days Worked' : ''),
                isActive: _index == 3,
                state: _index < 3
                    ? StepState.indexed
                    : _index == 3
                        ? StepState.editing
                        : StepState.complete,
                content: Form(
                    key: _formKeys[3],
                    child: DaysWorkedFormFields(
                        invoiceId: 0,
                        rate: paymentDetails?.rate ?? 0,
                        daysWorked: daysWorked))),
          ],
        ));
  }

  static Future<PersonalDetailsModel> getPersonalDetails() async {
    return await _personalDetailsSqlHelper.getPersonalDetails(1);
  }

  static Future<List<CompanyModel>> getCompanies() async {
    selectedCompany = null;

    return await _companiesSqlHelper.getCompanies();
  }

  static Future<PaymentDetailsModel> getPaymentDetails() async {
    return await _paymentDetailsSqlHelper.getPaymentDetails(1);
  }

  void reviewInvoice() async {
    var invoice = InvoiceModel(0, DateTime.now(), 0, selectedCompany!.id, 0);

    invoice.personalDetails = personalDetails!;
    invoice.company = selectedCompany!;
    invoice.paymentDetails = paymentDetails!;
    invoice.workDays = daysWorked;

    invoice = await _invoicesSqlHelper.insertInvoice(invoice);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ReviewInvoice(invoice: invoice)));
  }
}
