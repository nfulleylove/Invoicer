import 'package:flutter/material.dart';

import '../../data/companies_sql_helper.dart';
import '../../data/invoices_sql_helper.dart';
import '../../data/payment_details_sql_helper.dart';
import '../../data/personal_details_sql_helper.dart';
import '../../models/company_model.dart';
import '../../models/invoice_model.dart';
import '../../models/payment_details_model.dart';
import '../../models/personal_details_model.dart';
import '../../screens/companies_screen.dart';
import '../../screens/review_invoice_screen.dart';
import 'days_worked_form_fields.dart';
import 'payment_details_form_fields.dart';
import 'personal_details_form_fields.dart';

// ignore: must_be_immutable
class InvoiceStepper extends StatefulWidget {
  int id;

  InvoiceStepper({Key? key, required this.id}) : super(key: key);

  @override
  State<InvoiceStepper> createState() => _InvoiceStepperState();
}

class _InvoiceStepperState extends State<InvoiceStepper> {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final InvoicesSqlHelper _invoicesSqlHelper = InvoicesSqlHelper();
  final CompaniesSqlHelper _companiesSqlHelper = CompaniesSqlHelper();
  final PaymentDetailsSqlHelper _paymentSqlHelper = PaymentDetailsSqlHelper();
  final PersonalDetailsSqlHelper _personalSqlHelper =
      PersonalDetailsSqlHelper();

  InvoiceModel _invoice = InvoiceModel(0, DateTime.now(), 1, 0, 1);

  int _index = 0;
  bool get _isLastStep => _index + 1 == _formKeys.length;

  @override
  Widget build(BuildContext context) {
    if (widget.id > 0) {
      return FutureBuilder(
          future: getInvoice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                _invoice = snapshot.data as InvoiceModel;

                return stepper();
              } else {
                return const Center(child: Text('Failed to load invoice'));
              }
            } else {
              return const CircularProgressIndicator();
            }
          });
    } else {
      return stepper();
    }
  }

  Stepper stepper() {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
        return _controls(dtl);
      },
      onStepCancel: () {
        _onStepCancel();
      },
      onStepContinue: () {
        _onStepContinue();
      },
      steps: [
        _personalDetailsStep(),
        _companyDetailsStep(),
        _paymentDetailsStep(),
        _daysWorkedStep(),
      ],
    );
  }

  Row _controls(ControlsDetails dtl) {
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
  }

  void _onStepContinue() {
    bool isValid = false;

    _formKeys[_index].currentState!.save();

    isValid = _formKeys[_index].currentState?.validate() ?? false;

    if (isValid) {
      if (!_isLastStep) {
        if (_index == 0) {
          _personalSqlHelper.updatePersonalDetails(_invoice.personalDetails);
        }

        if (_index == 2) {
          _paymentSqlHelper.updatePaymentDetails(_invoice.paymentDetails);
        }

        setState(() {
          _index += 1;
        });
      } else {
        createInvoice();
      }
    }
  }

  void _onStepCancel() {
    if (_index > 0) setState(() => _index -= 1);
  }

// <Invoice>
  Future<InvoiceModel> getInvoice() async =>
      await _invoicesSqlHelper.getInvoice(widget.id);

  void createInvoice() async {
    try {
      if (widget.id == 0) {
        _invoice = await _invoicesSqlHelper.insertInvoice(_invoice);
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ReviewInvoiceScreen(invoice: _invoice)));
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error creating invoice"),
      ));
    }
  }
// </Invoice>

// <Personal Details>
  Step _personalDetailsStep() {
    return Step(
        title: Text(_index == 0 ? 'Personal Details' : ''),
        isActive: _index == 0,
        state: _index == 0 ? StepState.editing : StepState.complete,
        content: Form(
            key: _formKeys[0],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: _personalDetailsForm()));
  }

  _personalDetailsForm() {
    if (widget.id > 0) {
      return PersonalDetailsFormFields(
          personalDetails: _invoice.personalDetails);
    } else {
      return FutureBuilder(
          future: getDefaultPersonalDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                _invoice.personalDetails =
                    snapshot.data as PersonalDetailsModel;

                return PersonalDetailsFormFields(
                    personalDetails: _invoice.personalDetails);
              } else {
                return const Center(
                    child: Text('Personal Details failed to load'));
              }
            } else {
              return const CircularProgressIndicator();
            }
          });
    }
  }

  Future<PersonalDetailsModel> getDefaultPersonalDetails() async =>
      await _personalSqlHelper.getPersonalDetails(1);
// </Personal Details>

// <Company Details>
  Step _companyDetailsStep() {
    return Step(
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
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      if (widget.id > 0 &&
                          !snapshot.data!.contains(_invoice.company)) {
                        snapshot.data!.add(_invoice.company);
                      } else {
                        if (_invoice.companyId == 0) {
                          _invoice.companyId = snapshot.data!.first.id;
                          _invoice.company = snapshot.data!.first;
                        }
                      }

                      return DropdownButtonFormField<CompanyModel>(
                        value: _invoice.company,
                        decoration: const InputDecoration(labelText: "Company"),
                        hint: const Text("Select a Company"),
                        onChanged: (CompanyModel? newValue) async {
                          if (widget.id > 0) {
                            await _invoicesSqlHelper.updateCompany(
                                _invoice.id, newValue!.id);
                          }

                          setState(() {
                            _invoice.companyId = newValue!.id;
                            _invoice.company = newValue;
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
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        CompaniesScreen(showDrawer: false)))
                                .then((value) async {
                              setState(() {});
                            });
                          },
                        )
                      ]);
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  }

  Future<List<CompanyModel>> getCompanies() async =>
      await _companiesSqlHelper.getCompanies();
// </Company Details>

// <Payment Details>
  Step _paymentDetailsStep() {
    return Step(
        title: Text(_index == 2 ? 'Payment Details' : ''),
        isActive: _index == 2,
        state: _index < 2
            ? StepState.indexed
            : _index == 2
                ? StepState.editing
                : StepState.complete,
        content: _paymentDetailsForm());
  }

  Form _paymentDetailsForm() {
    if (widget.id > 0) {
      return Form(
          key: _formKeys[2],
          child: PaymentDetailsFormFields(
              paymentDetails: _invoice.paymentDetails));
    } else {
      return Form(
          key: _formKeys[2],
          child: FutureBuilder(
              future: getDefaultPaymentDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    _invoice.paymentDetails =
                        snapshot.data as PaymentDetailsModel;

                    return PaymentDetailsFormFields(
                        paymentDetails: _invoice.paymentDetails);
                  } else {
                    return const Center(
                        child: Text('Payment Details failed to load'));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }));
    }
  }

  Future<PaymentDetailsModel> getDefaultPaymentDetails() async =>
      await _paymentSqlHelper.getPaymentDetails(1);
// </Payment Details>

// <Days Worked>
  Step _daysWorkedStep() {
    return Step(
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
                daysWorked: _invoice.workDays)));
  }
// </Days Worked>
}
