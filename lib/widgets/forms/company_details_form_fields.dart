import 'package:flutter/material.dart';

class CompanyDetailsFormFields extends StatefulWidget {
  const CompanyDetailsFormFields({Key? key}) : super(key: key);

  @override
  State<CompanyDetailsFormFields> createState() =>
      _CompanyDetailsFormFieldsState();
}

class _CompanyDetailsFormFieldsState extends State<CompanyDetailsFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            decoration: const InputDecoration(label: Text('Email Address*')),
            maxLength: 150,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value?.isEmpty == true ? 'Email Address is required.' : null),
        TextFormField(
            decoration: const InputDecoration(label: Text('Address*')),
            maxLength: 100,
            keyboardType: TextInputType.text,
            validator: (value) =>
                value?.isEmpty == true ? 'Address is required.' : null),
        TextFormField(
            decoration: const InputDecoration(label: Text('Town*')),
            maxLength: 50,
            keyboardType: TextInputType.text,
            validator: (value) =>
                value?.isEmpty == true ? 'Town is required.' : null),
        TextFormField(
            decoration: const InputDecoration(label: Text('County*')),
            maxLength: 50,
            keyboardType: TextInputType.text,
            validator: (value) =>
                value?.isEmpty == true ? 'County is required.' : null),
        TextFormField(
            decoration: const InputDecoration(label: Text('Postcode*')),
            maxLength: 8,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            validator: (value) =>
                value?.isEmpty == true ? 'Postcode is required.' : null),
      ],
    );
  }
}
