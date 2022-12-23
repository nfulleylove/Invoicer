import 'package:invoicer/data/invoices_database.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';

import 'package:sqflite/sqflite.dart';

import 'invoices_sql_helper.dart';

class StatisticsSqlHelper {
  Database? db = InvoicesDatabase.db;

  static String colId = "id";
  static String colName = "name";
  static String tableLocations = "Locations";

  Future<int> getTotalMiles(DateTime startDate, DateTime endDate) async {
    String query = 'SELECT SUM(${WorkDaysSqlHelper.colMiles}) AS Miles '
        'FROM ${WorkDaysSqlHelper.tableWorkDays} AS wd '
        'JOIN ${InvoicesSqlHelper.tableInvoices} AS i ON i.${InvoicesSqlHelper.colId} = wd.${WorkDaysSqlHelper.colInvoiceId} '
        'WHERE wd.${WorkDaysSqlHelper.colDate} >= ? '
        'AND wd.${WorkDaysSqlHelper.colDate} <= ?';

    List<Map<String, dynamic>> records = await db!.rawQuery(query,
        [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch]);

    Map<String, int?> map = Map<String, int?>.from(records.first);

    return map['Miles'] ?? 0;
  }
}