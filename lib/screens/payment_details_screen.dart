import 'package:flutter/material.dart';
import 'package:invoicer/data/payment_details_sql_helper.dart';
import 'package:invoicer/models/payment_details_model.dart';
import 'package:invoicer/widgets/forms/payment_details_form_fields.dart';

import '../widgets/drawer.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  static final PaymentDetailsSqlHelper _paymentDetailsSqlHelper =
      PaymentDetailsSqlHelper();
  late PaymentDetailsModel paymentDetails;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Payment Details')),
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
              future: getPaymentDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    paymentDetails = snapshot.data as PaymentDetailsModel;

                    return Form(
                        key: _formKey,
                        child: PaymentDetailsFormFields(
                            paymentDetails:
                                snapshot.data as PaymentDetailsModel));
                  } else {
                    return const Center(
                        child: Text('Payment Details failed to load'));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        )));
  }

  Future saveChanges() async {
    var form = _formKey.currentState;

    bool isValid = form!.validate();

    if (isValid) {
      form.save();

      bool wasUpdated =
          await _paymentDetailsSqlHelper.updatePaymentDetails(paymentDetails);

      if (wasUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Payment details updated"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error updating payment details"),
        ));
      }
    }
  }

  Future<PaymentDetailsModel> getPaymentDetails() async {
    try {
      return await _paymentDetailsSqlHelper.getPaymentDetails(1);
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error retrieving payment details"),
      ));

      return Future.error(ex);
    }
  }
}
