import 'package:flutter/material.dart';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/data/invoices_sql_helper.dart';
import 'package:invoicer/data/payment_details_sql_helper.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';
import 'package:invoicer/models/company_model.dart';
import 'package:invoicer/models/invoice_model.dart';
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

// ignore: must_be_immutable
class UpdateInvoice extends StatefulWidget {
  int id;

  UpdateInvoice({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateInvoice> createState() => _UpdateInvoiceState();
}

class _UpdateInvoiceState extends State<UpdateInvoice> {
  static final PersonalDetailsSqlHelper _personalDetailsSqlHelper =
      PersonalDetailsSqlHelper();

  static final CompaniesSqlHelper _companiesSqlHelper = CompaniesSqlHelper();

  static final PaymentDetailsSqlHelper _paymentDetailsSqlHelper =
      PaymentDetailsSqlHelper();

  static final WorkDaysSqlHelper _workDaysSqlHelper = WorkDaysSqlHelper();

  static final InvoicesSqlHelper _invoicesSqlHelper = InvoicesSqlHelper();

  int _index = 0;
  InvoiceModel _invoice = InvoiceModel(-1, DateTime.now(), -1, -1, -1);

  static Route<void> _myRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => CompaniesScreen(showDrawer: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isLastStep = _index + 1 == _formKeys.length;

    return Scaffold(
        appBar: AppBar(title: Text('Update Invoice - ${_invoice.dateAsText}')),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: getInvoice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  _invoice = snapshot.data as InvoiceModel;
                }
                return Stepper(
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

                    isValid =
                        _formKeys[_index].currentState?.validate() ?? false;

                    if (isValid) {
                      if (!_isLastStep) {
                        if (_index == 0) {
                          _personalDetailsSqlHelper
                              .updatePersonalDetails(_invoice.personalDetails);
                        }

                        if (_index == 2) {
                          _paymentDetailsSqlHelper
                              .updatePaymentDetails(_invoice.paymentDetails);
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
                        state: _index == 0
                            ? StepState.editing
                            : StepState.complete,
                        content: Form(
                            key: _formKeys[0],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: PersonalDetailsFormFields(
                                personalDetails: _invoice.personalDetails))),
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
                                      if (!snapshot.data!
                                          .contains(_invoice.company)) {
                                        snapshot.data!.add(_invoice.company);
                                      }

                                      return DropdownButtonFormField<
                                          CompanyModel>(
                                        value: _invoice.company,
                                        decoration: const InputDecoration(
                                            labelText: "Company"),
                                        hint: const Text("Select a Company"),
                                        onChanged: (CompanyModel? newValue) {
                                          setState(() {
                                            _invoice.company = newValue!;
                                          });
                                        },
                                        items: snapshot.data
                                            ?.map((c) =>
                                                DropdownMenuItem<CompanyModel>(
                                                  value: c,
                                                  child: Text(c.name),
                                                ))
                                            .toList(),
                                        isExpanded: true,
                                      );
                                    } else {
                                      return Column(children: [
                                        const Text(
                                            "No companies have been added."),
                                        TextButton(
                                          child: const Text('Add a Company'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .restorablePush(
                                                    _myRouteBuilder);
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
                            child: PaymentDetailsFormFields(
                                paymentDetails: _invoice.paymentDetails))),
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
                                invoiceId: widget.id,
                                rate: _invoice.paymentDetails.rate,
                                daysWorked: _invoice.workDays))),
                  ],
                );
              } else {
                return const Center(child: Text('Failed to load invoice'));
              }
            }));
  }

  Future<InvoiceModel> getInvoice() async {
    return await _invoicesSqlHelper.getInvoice(widget.id);
  }

  Future<List<CompanyModel>> getCompanies() async {
    return await _companiesSqlHelper.getCompanies();
  }

  void reviewInvoice() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ReviewInvoice(invoice: _invoice)));
  }
}
