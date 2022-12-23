import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoicer/data/statistics_sql_helper.dart';
import 'package:invoicer/widgets/drawer.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsSqlHelper sqlHelper = StatisticsSqlHelper();
  int miles = 0;
  double totalPay = 0;

  final TextEditingController _dateController = TextEditingController();

  static var now = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.month > 3 ? now.year - 1 : now.year - 2, 4, 1),
      end: DateTime(now.month > 3 ? now.year : now.year - 1, 4, 1)
          .subtract(const Duration(seconds: 1)));

  @override
  Widget build(BuildContext context) {
    setState(() {
      updateDateControllerText();
      updateMileage();
    });

    return Scaffold(
        appBar: AppBar(title: const Text('Statistics')),
        drawer: const AppDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: FutureBuilder(
                future: updateMileage(),
                builder: (context, snapshot) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: TextFormField(
                                  controller: _dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    await setDate();
                                  },
                                  decoration: const InputDecoration(
                                      label: Text('Dates')))),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text('Total miles: $miles')),
                          Text('Total pay: £${totalPay.toStringAsFixed(2)}')
                        ]))));
  }

  setDate() async {
    try {
      var result = await showDateRangePicker(
          context: context,
          initialDateRange: dateRange,
          firstDate: DateTime(2020, 4, 1),
          lastDate: DateTime.now());

      if (result != null) {
        setState(() {
          dateRange = result;
          updateDateControllerText();
          updateMileage();
          updateTotalPay();
        });
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error retrieving statistics"),
      ));
    }
  }

  void updateDateControllerText() {
    var formatter = DateFormat('dd/MM/yyyy');

    _dateController.text = formatter.format(dateRange.start) +
        ' - ' +
        formatter.format(dateRange.end);
  }

  Future updateMileage() async {
    miles = await sqlHelper.getTotalMiles(
        dateRange.start,
        dateRange.end
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1)));
  }

  Future updateTotalPay() async {
    totalPay = await sqlHelper.getTotalPay(
        dateRange.start,
        dateRange.end
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1)));
  }
}
