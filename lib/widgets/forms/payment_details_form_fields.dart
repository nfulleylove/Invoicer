import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentDetailsFormFields extends StatefulWidget {
  const PaymentDetailsFormFields({Key? key}) : super(key: key);

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
            decoration: const InputDecoration(label: Text('Name on Card*')),
            maxLength: 150,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Name on Card is required.' : null),
        TextFormField(
            decoration: const InputDecoration(label: Text('Account Number*')),
            maxLength: 8,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) =>
                value?.isEmpty == true ? 'Account Number is required.' : null),
        TextFormField(
          decoration: const InputDecoration(label: Text('Sort Code*')),
          inputFormatters: [MaskTextInputFormatter(mask: "##-##-##")],
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Sort Code is required.';
            }

            if (RegExp('[0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
                .allMatches(value)
                .isNotEmpty) {
              return 'Invalid sort code.';
            }
            return null;
          },
        )
      ],
    );
  }
}
