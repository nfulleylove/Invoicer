import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:intl/intl.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';
import 'package:invoicer/models/work_day_model.dart';

// ignore: must_be_immutable
class AddWorkDaysDialogue extends StatefulWidget {
  final int invoiceId;
  final double rate;

  AddWorkDaysDialogue({Key? key, required this.invoiceId, required this.rate})
      : super(key: key);

  DateTime lastMonday = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - (DateTime.now().weekday - 1));

  late DateTimeRange dateRange =
      DateTimeRange(start: lastMonday, end: DateTime.now());

  late WorkDayModel workDay =
      WorkDayModel(0, 0, DateTime.now(), rate, 8, 0, '');
  List<WorkDayModel> workDays = [];

  @override
  State<AddWorkDaysDialogue> createState() => _AddWorkDaysDialogueState();
}

class _AddWorkDaysDialogueState extends State<AddWorkDaysDialogue> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var workDay = widget.workDay;
    updateDateControllerText();

    return Dialog(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
      child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            const Text(
              'Add Work Days',
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
                    decoration: const InputDecoration(label: Text('Dates')))),
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
                      onPressed: onAdd, child: const Text('Add Work Days'))
                ])),
          ])),
    ));
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  Future<void> onAdd() async {
    for (DateTime date = widget.dateRange.start;
        date.isBefore(widget.dateRange.end.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      var workDay = WorkDayModel(0, widget.invoiceId, date, widget.workDay.rate,
          widget.workDay.hours, widget.workDay.miles, widget.workDay.location);

      if (widget.invoiceId > 0) {
        workDay.id = await WorkDaysSqlHelper().insert(workDay);
      }

      widget.workDays.add(workDay);
    }

    Navigator.of(context).pop(widget.workDays);
  }

  setDate() async {
    var result = await showDateRangePicker(
        context: context,
        initialDateRange: widget.dateRange,
        firstDate: DateTime.now().subtract(const Duration(days: 31)),
        lastDate: DateTime.now());

    if (result != null) {
      setState(() {
        widget.dateRange = result;
        updateDateControllerText();
      });
    }
  }

  void updateDateControllerText() {
    var formatter = DateFormat('dd/MM/yyyy');

    _dateController.text = formatter.format(widget.dateRange.start) +
        ' - ' +
        formatter.format(widget.dateRange.end);
  }
}
