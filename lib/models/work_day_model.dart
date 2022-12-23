import 'package:intl/intl.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';

class WorkDayModel {
  int id = 0;
  int invoiceId = 0;
  DateTime date = DateTime.now();
  double rate = 11;
  int hours = 8;
  double get grossPay => rate * hours.toDouble();
  int miles = 10;
  String location = '';

  var formatter = DateFormat('dd/MM/yyyy');

  String get dateAsString => formatter.format(date);

  WorkDayModel(this.id, this.invoiceId, this.date, this.rate, this.hours,
      this.miles, this.location);

  factory WorkDayModel.fromMap(Map<String, dynamic> map) {
    var model = WorkDayModel(
        map[WorkDaysSqlHelper.colId] ?? 0,
        map[WorkDaysSqlHelper.colInvoiceId] ?? 0,
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(map[WorkDaysSqlHelper.colDate])),
        map[WorkDaysSqlHelper.colRate] ?? 0,
        map[WorkDaysSqlHelper.colHours] ?? 0,
        map[WorkDaysSqlHelper.colMiles] ?? 0,
        map[WorkDaysSqlHelper.colLocation] ?? '');

    return model;
  }

  Map<String, dynamic> toMap() {
    return {
      WorkDaysSqlHelper.colInvoiceId: invoiceId.toString(),
      WorkDaysSqlHelper.colDate: date.millisecondsSinceEpoch,
      WorkDaysSqlHelper.colLocation: location,
      WorkDaysSqlHelper.colMiles: miles.toString(),
      WorkDaysSqlHelper.colRate: rate.toString(),
      WorkDaysSqlHelper.colHours: hours.toString()
    };
  }
}
