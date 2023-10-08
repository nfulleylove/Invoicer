import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../models/payment_details_model.dart';

class PaymentDetailsFormFields extends StatefulWidget {
  const PaymentDetailsFormFields({Key? key, required this.paymentDetails})
      : super(key: key);

  final PaymentDetailsModel paymentDetails;

  @override
  State<PaymentDetailsFormFields> createState() =>
      _PaymentDetailsFormFieldsState();
}

class _PaymentDetailsFormFieldsState extends State<PaymentDetailsFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            initialValue: widget.paymentDetails.nameOnCard,
            onSaved: (val) =>
                setState(() => widget.paymentDetails.nameOnCard = val ?? ''),
            decoration: const InputDecoration(label: Text('Name on Card*')),
            maxLength: 150,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Name on Card is required.' : null),
        TextFormField(
            initialValue: widget.paymentDetails.accountNumber,
            onSaved: (val) =>
                setState(() => widget.paymentDetails.accountNumber = val ?? ''),
            decoration: const InputDecoration(label: Text('Account Number*')),
            maxLength: 8,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) =>
                value?.isEmpty == true ? 'Account Number is required.' : null),
        TextFormField(
          initialValue: widget.paymentDetails.sortCode,
          onSaved: (val) =>
              setState(() => widget.paymentDetails.sortCode = val ?? ''),
          decoration: const InputDecoration(label: Text('Sort Code*')),
          inputFormatters: [MaskTextInputFormatter(mask: "##-##-##")],
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Sort Code is required.';
            }

            if (RegExp('[0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
                .allMatches(value)
                .isEmpty) {
              return 'Invalid sort code.';
            }
            return null;
          },
        ),
        SpinBox(
            value: widget.paymentDetails.rate,
            onChanged: (value) => setState(() {
                  widget.paymentDetails.rate = value;
                }),
            decoration: const InputDecoration(label: Text('Rate')),
            step: 1,
            decimals: 2,
            min: 10,
            max: 200)
      ],
    );
  }
}
