import 'package:flutter/material.dart';
import 'package:invoicer/models/personal_details_model.dart';

class PersonalDetailsFormFields extends StatefulWidget {
  const PersonalDetailsFormFields({Key? key, required this.personalDetails})
      : super(key: key);

  final PersonalDetailsModel personalDetails;

  @override
  State<PersonalDetailsFormFields> createState() =>
      _PersonalDetailsFormFieldsState();
}

class _PersonalDetailsFormFieldsState extends State<PersonalDetailsFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            initialValue: widget.personalDetails.forename,
            onSaved: (val) =>
                setState(() => widget.personalDetails.forename = val ?? ''),
            decoration: const InputDecoration(label: Text('Forename*')),
            maxLength: 50,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Forename is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.surname,
            onSaved: (val) =>
                setState(() => widget.personalDetails.surname = val ?? ''),
            decoration: const InputDecoration(label: Text('Surname*')),
            maxLength: 50,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Surname is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.cis4p,
            onSaved: (val) =>
                setState(() => widget.personalDetails.cis4p = val ?? ''),
            decoration: const InputDecoration(label: Text('CIS4P*')),
            maxLength: 13,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            validator: (value) =>
                value?.isEmpty == true ? 'CIS4P is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.nationalInsurance,
            onSaved: (val) => setState(
                () => widget.personalDetails.nationalInsurance = val ?? ''),
            decoration: const InputDecoration(
                label: Text('National Insurance Number*')),
            maxLength: 9,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty == true
                ? 'National Insurance Number is required.'
                : null),
        TextFormField(
            initialValue: widget.personalDetails.company,
            onSaved: (val) =>
                setState(() => widget.personalDetails.company = val ?? ''),
            decoration: const InputDecoration(label: Text('Company*')),
            maxLength: 50,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Company is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.mobile,
            onSaved: (val) =>
                setState(() => widget.personalDetails.mobile = val ?? ''),
            decoration: const InputDecoration(label: Text('Mobile*')),
            maxLength: 11,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value?.isEmpty == true ? 'Mobile is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.email,
            onSaved: (val) =>
                setState(() => widget.personalDetails.email = val ?? ''),
            decoration: const InputDecoration(label: Text('Email Address*')),
            maxLength: 150,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value?.isEmpty == true ? 'Email Address is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.address,
            onSaved: (val) =>
                setState(() => widget.personalDetails.address = val ?? ''),
            decoration: const InputDecoration(label: Text('Address*')),
            maxLength: 100,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Address is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.town,
            onSaved: (val) =>
                setState(() => widget.personalDetails.town = val ?? ''),
            decoration: const InputDecoration(label: Text('Town*')),
            maxLength: 50,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'Town is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.county,
            onSaved: (val) =>
                setState(() => widget.personalDetails.county = val ?? ''),
            decoration: const InputDecoration(label: Text('County*')),
            maxLength: 50,
            keyboardType: TextInputType.name,
            validator: (value) =>
                value?.isEmpty == true ? 'County is required.' : null),
        TextFormField(
            initialValue: widget.personalDetails.postcode,
            onSaved: (val) =>
                setState(() => widget.personalDetails.postcode = val ?? ''),
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
