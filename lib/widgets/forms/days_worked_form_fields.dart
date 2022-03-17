import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DaysWorkedFormFields extends StatefulWidget {
  const DaysWorkedFormFields({Key? key}) : super(key: key);

  @override
  State<DaysWorkedFormFields> createState() => _DaysWorkedFormFieldsState();
}

class _DaysWorkedFormFieldsState extends State<DaysWorkedFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Align(
          alignment: Alignment.topRight,
          child:
              TextButton(onPressed: doNothing, child: Text('Add Work Days'))),
      ListView.builder(
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return ListTile(
                title: Card(
                    child: Column(children: <Widget>[
              const ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text('10/02/2022'),
              ),
              Column(
                children: [
                  ExpansionTile(title: const Text('Details'), children: [
                    SpinBox(
                      min: 0,
                      max: 50,
                      step: 5,
                      decoration: const InputDecoration(
                          labelText: 'Hourly Rate',
                          icon: Icon(Icons.currency_pound)),
                    ),
                    SpinBox(
                      min: 0,
                      max: 50,
                      step: 5,
                      decoration: const InputDecoration(
                          labelText: 'Hours Worked',
                          icon: Icon(MdiIcons.clock)),
                    ),
                    SpinBox(
                      min: 0,
                      max: 50,
                      step: 5,
                      decoration: const InputDecoration(
                          labelText: 'Miles', icon: Icon(MdiIcons.car)),
                    ),
                  ]),
                  ExpansionTile(title: const Text('Locations'), children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: doNothing,
                          child: Text(
                            'Add Location',
                            textAlign: TextAlign.right,
                          )),
                    ),
                    Wrap(spacing: 10, children: const [
                      Chip(
                        label: Text('Stevenage'),
                        onDeleted: doNothing,
                      ),
                      Chip(
                        label: Text('Hertford - 21 aaaaaa aaaaaaaaaafffffffff'),
                        onDeleted: doNothing,
                      ),
                      Chip(
                        label: Text('Welwyn'),
                        onDeleted: doNothing,
                      ),
                    ]),
                  ])
                ],
              ),
            ])));
          })
    ]);
  }
}

void doNothing() {}
