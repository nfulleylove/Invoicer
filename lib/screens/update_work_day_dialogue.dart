import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';
import 'package:invoicer/models/work_day_model.dart';

// ignore: must_be_immutable
class UpdateWorkDayDialogue extends StatefulWidget {
  UpdateWorkDayDialogue({Key? key, required this.workDay}) : super(key: key);

  WorkDayModel workDay;
  late WorkDayModel updatedWorkDay = WorkDayModel(
      workDay.id,
      workDay.invoiceId,
      workDay.date,
      workDay.rate,
      workDay.hours,
      workDay.miles,
      workDay.location);

  @override
  State<UpdateWorkDayDialogue> createState() => _UpdateWorkDayDialogueState();
}

class _UpdateWorkDayDialogueState extends State<UpdateWorkDayDialogue> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var workDay = widget.updatedWorkDay;
    _dateController.text = workDay.dateAsString;

    return Dialog(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
      child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            const Text(
              'Update Work Day',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      await setDate();
                    },
                    decoration: const InputDecoration(label: Text('Date')))),
            const Text(
              'Travel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue: workDay.location,
              onChanged: (val) => setState(() => workDay.location = val),
              decoration: const InputDecoration(label: Text('Location*')),
              keyboardType: TextInputType.streetAddress,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: SpinBox(
                  value: workDay.miles.toDouble(),
                  onChanged: (val) =>
                      setState(() => workDay.miles = val.toInt()),
                  decoration: const InputDecoration(label: Text('Miles*')),
                  keyboardType: TextInputType.number,
                )),
            const Text('Pay', style: TextStyle(fontWeight: FontWeight.bold)),
            SpinBox(
              value: workDay.rate,
              onChanged: (value) => setState(() {
                workDay.rate = value;
              }),
              decimals: 2,
              step: 0.5,
              decoration: const InputDecoration(label: Text('Rate*')),
              keyboardType: TextInputType.number,
            ),
            SpinBox(
              value: workDay.hours.toDouble(),
              onChanged: (value) => setState(() {
                workDay.hours = value.toInt();
              }),
              decoration: const InputDecoration(label: Text('Hours Worked*')),
              keyboardType: TextInputType.number,
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text('Total: £' + workDay.grossPay.toStringAsFixed(2))),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(children: [
                  const Spacer(),
                  TextButton(onPressed: onCancel, child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: onUpdate, child: const Text('Update'))
                ])),
          ])),
    ));
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  Future onUpdate() async {
    if (widget.updatedWorkDay.id > 0) {
      bool isUpdated =
          await WorkDaysSqlHelper().updateWorkDay(widget.updatedWorkDay);

      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Work day updated"),
        ));

        Navigator.of(context).pop(widget.updatedWorkDay);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error updating Work day"),
        ));
      }
    }
  }

  setDate() async {
    var result = await showDatePicker(
        context: context,
        initialDate: widget.workDay.date,
        firstDate: DateTime.now().subtract(const Duration(days: 31)),
        lastDate: DateTime.now());

    if (result != null) {
      setState(() async {
        widget.updatedWorkDay.date = result;
        _dateController.text = widget.updatedWorkDay.dateAsString;
      });
    }
  }
}
