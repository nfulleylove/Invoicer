import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/data/payment_details_sql_helper.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/invoice_model.dart';
import 'invoices_database.dart';

class InvoicesSqlHelper {
  static final Future<Database?> _db = InvoicesDatabase().database;

  static const String tableInvoices = 'Invoices';

  static const String colId = 'id';
  static const String colPersonalDetailsId = 'personalDetailsId';
  static const String colCompanyId = 'companyId';
  static const String colPaymentDetailsId = 'paymentDetailsId';
  static const String colDate = 'date';

  Future<InvoiceModel> getInvoice(int id) async {
    var database = await _db;

    List<Map<String, dynamic>> map = await database!.rawQuery(
        'SELECT * FROM $tableInvoices AS i '
        'WHERE $colId = ?',
        [id]);

    var invoice =
        InvoiceModel.fromMap(map.isNotEmpty ? map.first : <String, dynamic>{});

    invoice.personalDetails = await PersonalDetailsSqlHelper()
        .getPersonalDetails(invoice.personalDetailsId);

    invoice.company = await CompaniesSqlHelper().getCompany(invoice.companyId);

    invoice.paymentDetails = await PaymentDetailsSqlHelper()
        .getPaymentDetails(invoice.paymentDetailsId);

    invoice.workDays = await WorkDaysSqlHelper().getWorkDaysForInvoice(id);

    return invoice;
  }

  Future<InvoiceModel> insertInvoice(InvoiceModel invoice) async {
    var database = await _db;

    invoice.personalDetailsId =
        await PersonalDetailsSqlHelper().insert(invoice.personalDetails);

    invoice.paymentDetailsId =
        await PaymentDetailsSqlHelper().insert(invoice.paymentDetails);

    var map = invoice.toMap();

    invoice.id = await database!.insert(tableInvoices, invoice.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    for (var workDay in invoice.workDays) {
      workDay.invoiceId = invoice.id;
      WorkDaysSqlHelper().insert(workDay);
    }

    return invoice;
  }

  Future<List<InvoiceModel>> getInvoices(
      DateTime startDate, DateTime endDate) async {
    var database = await _db;

    List<Map<String, dynamic>> map = await database!.query(tableInvoices);

    List<InvoiceModel> invoices = [];

    for (var element in map) {
      invoices.add(InvoiceModel.fromMap(element));
    }

    return invoices;
  }

  Future<int> deleteInvoice(InvoiceModel invoice) async {
    var database = await _db;

    int result = await database!
        .delete(tableInvoices, where: '$colId = ?', whereArgs: [invoice.id]);

    return result;
  }
}
