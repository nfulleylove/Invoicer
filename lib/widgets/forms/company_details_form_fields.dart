import 'package:flutter/material.dart';

import '../../models/company_model.dart';

class CompanyDetailsFormFields extends StatefulWidget {
  const CompanyDetailsFormFields({Key? key, required this.company})
      : super(key: key);

  final CompanyModel company;

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
            initialValue: widget.company.name,
            onSaved: (newValue) => widget.company.name = newValue ?? '',
            decoration: const InputDecoration(label: Text('Name*')),
            maxLength: 100,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Name is required.' : null),
        TextFormField(
            initialValue: widget.company.email,
            onSaved: (newValue) => widget.company.email = newValue ?? '',
            decoration: const InputDecoration(label: Text('Email Address*')),
            maxLength: 150,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value?.isEmpty == true ? 'Email Address is required.' : null),
        TextFormField(
            initialValue: widget.company.address,
            onSaved: (newValue) => widget.company.address = newValue ?? '',
            decoration: const InputDecoration(label: Text('Address*')),
            maxLength: 100,
            keyboardType: TextInputType.text,
            validator: (value) =>
                value?.isEmpty == true ? 'Address is required.' : null),
        TextFormField(
            initialValue: widget.company.town,
            onSaved: (newValue) => widget.company.town = newValue ?? '',
            decoration: const InputDecoration(label: Text('Town*')),
            maxLength: 50,
            keyboardType: TextInputType.text,
            validator: (value) =>
                value?.isEmpty == true ? 'Town is required.' : null),
        TextFormField(
            initialValue: widget.company.county,
            onSaved: (newValue) => widget.company.county = newValue ?? '',
            decoration: const InputDecoration(label: Text('County*')),
            maxLength: 50,
            keyboardType: TextInputType.text,
            validator: (value) =>
                value?.isEmpty == true ? 'County is required.' : null),
        TextFormField(
            initialValue: widget.company.postcode,
            onSaved: (newValue) => widget.company.postcode = newValue ?? '',
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
