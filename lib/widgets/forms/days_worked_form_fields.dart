import 'package:flutter/material.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';
import 'package:invoicer/screens/dialogues/add_work_days_dialogue.dart';
import 'package:invoicer/screens/dialogues/update_work_day_dialogue.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/work_day_model.dart';

class DaysWorkedFormFields extends StatefulWidget {
  final int invoiceId;
  final double rate;

  const DaysWorkedFormFields(
      {Key? key,
      required this.invoiceId,
      required this.rate,
      required this.daysWorked})
      : super(key: key);

  final List<WorkDayModel> daysWorked;

  @override
  State<DaysWorkedFormFields> createState() => _DaysWorkedFormFieldsState();
}

class _DaysWorkedFormFieldsState extends State<DaysWorkedFormFields> {
  @override
  Widget build(BuildContext context) {
    var workDays = widget.daysWorked;

    return SingleChildScrollView(
        child: Column(children: [
      Align(
          alignment: Alignment.topRight,
          child: TextButton(
              onPressed: addWorkDay, child: const Text('Add Work Days'))),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: workDays.length,
        itemBuilder: (context, index) {
          workDays.sort(((a, b) => a.date.compareTo(b.date)));
          var workDay = workDays[index];

          return InkWell(
              onTap: () => updateWorkDay(index),
              child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => deleteWorkDay(workDay),
                  confirmDismiss: confirmDeletion,
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(workDay.dateAsString),
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.currency_pound_sharp,
                                        size: 25,
                                      ),
                                      Text(workDay.grossPay.toStringAsFixed(2))
                                    ]),
                                Wrap(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Icon(
                                        MdiIcons.car,
                                        size: 25,
                                      ),
                                      Text(workDay.miles.toString() + ' miles')
                                    ]),
                                Wrap(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Icon(
                                        MdiIcons.mapMarker,
                                        size: 25,
                                      ),
                                      Text(
                                        workDay.location,
                                      )
                                    ]),
                              ]))),
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  )));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )
    ]));
  }

  Future addWorkDay() async {
    var result = await showDialog<List<WorkDayModel>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddWorkDaysDialogue(
            invoiceId: widget.invoiceId, rate: widget.rate);
      },
    );

    if (result != null) {
      setState(() {
        widget.daysWorked.addAll(result);
      });
    }
  }

  Future updateWorkDay(int index) async {
    var workDay = widget.daysWorked[index];

    var result = await showDialog<WorkDayModel>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UpdateWorkDayDialogue(workDay: workDay);
      },
    );

    if (result != null) {
      setState(() {
        workDay.date = result.date;
        workDay.location = result.location;
        workDay.miles = result.miles;
        workDay.rate = result.rate;
        workDay.hours = result.hours;
      });
    }
  }

  Future deleteWorkDay(WorkDayModel workDay) async {
    bool isDeleted = false;

    if (widget.invoiceId > 0) {
      isDeleted = await WorkDaysSqlHelper().deleteWorkDay(workDay);
    }

    if (isDeleted || widget.invoiceId == 0) {
      setState(() {
        widget.daysWorked.remove(workDay);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Work day deleted"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error deleting work day"),
      ));
    }
  }

  Future<bool?> confirmDeletion(DismissDirection direction) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Work Day'),
          content: const Text('Are you sure you want to delete the Work Day?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
