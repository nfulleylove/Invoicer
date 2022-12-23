import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }

  DateTime today() {
    var now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  String toShortDateString() => DateFormat('dd/MM/yyyy').format(this);

  String toFormattedString(String format) => DateFormat(format).format(this);
}
