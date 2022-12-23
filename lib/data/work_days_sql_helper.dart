import 'package:sqflite/sqflite.dart';

import '../models/work_day_model.dart';
import 'invoices_database.dart';

class WorkDaysSqlHelper {
  static final Future<Database?> _db = InvoicesDatabase().database;

  static const String tableWorkDays = 'DaysWorked';

  static const String colId = 'id';
  static const String colInvoiceId = 'invoiceId';
  static const String colDate = 'date';
  static const String colLocation = 'location';
  static const String colMiles = 'miles';
  static const String colRate = 'rate';
  static const String colHours = 'hours';

  Future<List<WorkDayModel>> getWorkDaysForInvoice(int id) async {
    var database = await _db;

    List<Map<String, dynamic>> map = await database!
        .query(tableWorkDays, where: '$colInvoiceId = ?', whereArgs: [id]);

    List<WorkDayModel> workDays = [];

    for (var element in map) {
      workDays.add(WorkDayModel.fromMap(element));
    }

    return workDays;
  }

  Future<int> insert(WorkDayModel workDay) async {
    var database = await _db;

    int result = await database!.insert(tableWorkDays, workDay.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  Future<bool> updateWorkDay(WorkDayModel workDay) async {
    var database = await _db;

    int result = await database!.update(tableWorkDays, workDay.toMap(),
        where: '$colId = ?', whereArgs: [workDay.id]);

    return result == 1;
  }

  Future<bool> deleteWorkDay(WorkDayModel workDay) async {
    var database = await _db;

    int result = await database!
        .delete(tableWorkDays, where: '$colId = ?', whereArgs: [workDay.id]);

    return result == 1;
  }
}
