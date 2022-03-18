import 'dart:io';
import 'package:invoicer/data/companies_sql_helper.dart';
import 'package:invoicer/data/personal_details_sql_helper.dart';
import 'package:path/path.dart';

import 'package:invoicer/models/personal_details_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'locations_sql_helper.dart';

class InvoicesDatabase {
  static const int version = 1;

  static final InvoicesDatabase _invoicesDatabase =
      InvoicesDatabase._internal();

  factory InvoicesDatabase() => _invoicesDatabase;

  InvoicesDatabase._internal();

  Future<Database> _init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'invoices.db');
    return await openDatabase(dbPath, version: version, onCreate: _createDb);
  }

  Future _createDb(Database _db, int version) async {
    await _addPersonalDetailsTable(_db);
    await _addLocationsTable(_db);
    await _addCompaniesTable(_db);
  }

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

  Future _addLocationsTable(Database _db) async {
    String query = 'CREATE TABLE ${LocationsSqlHelper.tableLocations} '
        '(${LocationsSqlHelper.colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${LocationsSqlHelper.colName} TEXT);';
    await _db.execute(query);
  }

  Future _addCompaniesTable(Database _db) async {
    String query = 'CREATE TABLE ${CompaniesSqlHelper.tableCompanies} '
        '(${CompaniesSqlHelper.colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${CompaniesSqlHelper.colName} TEXT, '
        '${CompaniesSqlHelper.colAddress} TEXT, '
        '${CompaniesSqlHelper.colTown} TEXT, '
        '${CompaniesSqlHelper.colCounty} TEXT, '
        '${CompaniesSqlHelper.colPostcode} TEXT, '
        '${CompaniesSqlHelper.colEmail} TEXT);';

    await _db.execute(query);
  }
}
