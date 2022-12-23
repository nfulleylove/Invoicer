import 'dart:io';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/data/payment_details_sql_helper.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
import 'package:invoicer/data/work_days_sql_helper.dart';
import 'package:path/path.dart';

import 'package:invoicer/models/personal_details_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/payment_details_model.dart';
import 'invoices_sql_helper.dart';

class InvoicesDatabase {
  static const int version = 1;

  static final InvoicesDatabase _invoicesDatabase =
      InvoicesDatabase._internal();

  factory InvoicesDatabase() => _invoicesDatabase;

  InvoicesDatabase._internal();

  Future<Database> _init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'invoices.db');
    return await openDatabase(dbPath,
        version: version, onCreate: _createDb, onUpgrade: _updateDb);
  }

  Future _createDb(Database _db, int version) async {
    await _addPersonalDetailsTable(_db);
    await _addPaymentDetailsTable(_db);
    await _addCompaniesTable(_db);
    await _addInvoicesTable(_db);
    await _addDaysWorkedTable(_db);
  }

  Future _updateDb(Database _db, int oldVersion, int newVersion) async {}

  // Singleton pattern
  static Database? db;

  Future<Database> get database async {
    if (db != null) return db!;
    // Initialize the DB first time it is accessed
    db = await _init();
    return db!;
  }

  Future<void> _addPersonalDetailsTable(Database _db) async {
    String query =
        'CREATE TABLE ${PersonalDetailsSqlHelper.tablePersonalDetails} '
        '(${PersonalDetailsSqlHelper.colId} INTEGER PRIMARY KEY, '
        '${PersonalDetailsSqlHelper.colForename} TEXT, '
        '${PersonalDetailsSqlHelper.colSurname} TEXT, '
        '${PersonalDetailsSqlHelper.colCis4p} TEXT, '
        '${PersonalDetailsSqlHelper.colNationalInsurance} TEXT, '
        '${PersonalDetailsSqlHelper.colCompany} TEXT, '
        '${PersonalDetailsSqlHelper.colMobile} TEXT, '
        '${PersonalDetailsSqlHelper.colEmail} TEXT, '
        '${PersonalDetailsSqlHelper.colAddress} TEXT, '
        '${PersonalDetailsSqlHelper.colTown} TEXT, '
        '${PersonalDetailsSqlHelper.colCounty} TEXT, '
        '${PersonalDetailsSqlHelper.colPostcode} TEXT);';
    await _db.execute(query);

    await _seedPersonalDetailsTable(_db);
  }

  Future _seedPersonalDetailsTable(Database _db) async {
    var personalDetailsSeed =
        PersonalDetailsModel(1, '', '', '', '', '', '', '', '', '', '', '');

    await _db.insert(PersonalDetailsSqlHelper.tablePersonalDetails,
        personalDetailsSeed.toMap());
  }

  Future<void> _addPaymentDetailsTable(Database _db) async {
    String query =
        'CREATE TABLE ${PaymentDetailsSqlHelper.tablePaymentDetails} '
        '(${PaymentDetailsSqlHelper.colId} INTEGER PRIMARY KEY, '
        '${PaymentDetailsSqlHelper.colNameOnCard} TEXT, '
        '${PaymentDetailsSqlHelper.colAccountNumber} TEXT, '
        '${PaymentDetailsSqlHelper.colSortCode} TEXT, '
        '${PaymentDetailsSqlHelper.colRate} REAL);';
    await _db.execute(query);

    await _seedPaymentDetailsTable(_db);
  }

  Future _seedPaymentDetailsTable(Database _db) async {
    var paymentDetailsSeed = PaymentDetailsModel(1, '', '', '', 0);

    await _db.insert(PaymentDetailsSqlHelper.tablePaymentDetails,
        paymentDetailsSeed.toMap());
  }

  Future _addCompaniesTable(Database _db) async {
    String query = 'CREATE TABLE ${CompaniesSqlHelper.tableCompanies} '
        '(${CompaniesSqlHelper.colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${CompaniesSqlHelper.colStatus} INTEGER DEFAULT 1, '
        '${CompaniesSqlHelper.colName} TEXT, '
        '${CompaniesSqlHelper.colAddress} TEXT, '
        '${CompaniesSqlHelper.colTown} TEXT, '
        '${CompaniesSqlHelper.colCounty} TEXT, '
        '${CompaniesSqlHelper.colPostcode} TEXT, '
        '${CompaniesSqlHelper.colEmail} TEXT);';

    await _db.execute(query);
  }

  Future _addInvoicesTable(Database _db) async {
    String query = 'CREATE TABLE ${InvoicesSqlHelper.tableInvoices} '
        '(${InvoicesSqlHelper.colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${InvoicesSqlHelper.colPersonalDetailsId} INTEGER, '
        '${InvoicesSqlHelper.colCompanyId} INTEGER, '
        '${InvoicesSqlHelper.colPaymentDetailsId} INTEGER, '
        '${InvoicesSqlHelper.colDate} TEXT, '
        'FOREIGN KEY(${InvoicesSqlHelper.colPersonalDetailsId}) REFERENCES ${PersonalDetailsSqlHelper.tablePersonalDetails}(${PersonalDetailsSqlHelper.colId}) ON DELETE CASCADE, '
        'FOREIGN KEY(${InvoicesSqlHelper.colCompanyId}) REFERENCES ${CompaniesSqlHelper.tableCompanies}(${CompaniesSqlHelper.colId}) ON DELETE NO ACTION, '
        'FOREIGN KEY(${InvoicesSqlHelper.colPaymentDetailsId}) REFERENCES ${PaymentDetailsSqlHelper.tablePaymentDetails}(${PaymentDetailsSqlHelper.colId}) ON DELETE CASCADE)';

    await _db.execute(query);
  }

  Future _addDaysWorkedTable(Database _db) async {
    String query = 'CREATE TABLE ${WorkDaysSqlHelper.tableWorkDays} '
        '(${WorkDaysSqlHelper.colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${WorkDaysSqlHelper.colDate} TEXT, '
        '${WorkDaysSqlHelper.colInvoiceId} INTEGER, '
        '${WorkDaysSqlHelper.colLocation} TEXT, '
        '${WorkDaysSqlHelper.colMiles} INTEGER, '
        '${WorkDaysSqlHelper.colRate} REAL, '
        '${WorkDaysSqlHelper.colHours} INTEGER, '
        'FOREIGN KEY(${WorkDaysSqlHelper.colInvoiceId}) REFERENCES ${InvoicesSqlHelper.tableInvoices}(${InvoicesSqlHelper.colId}) ON DELETE NO ACTION)';

    await _db.execute(query);
  }
}
