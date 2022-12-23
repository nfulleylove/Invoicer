import 'package:invoicer/models/company_model.dart';
import 'package:sqflite/sqflite.dart';

import 'invoices_database.dart';

class CompaniesSqlHelper {
  final Future<Database?> db = InvoicesDatabase().database;

  static const String tableCompanies = 'Companies';

  static const String colId = 'id';
  static const String colStatus = 'status';
  static const String colName = 'name';
  static const String colAddress = 'address';
  static const String colTown = 'town';
  static const String colCounty = 'county';
  static const String colPostcode = 'postcode';
  static const String colEmail = 'email';

  Future<int> insertCompany(CompanyModel company) async {
    var database = await db;

    var map = company.toMap();

    return await database!.insert(tableCompanies, map);
  }

  Future<List<CompanyModel>> getCompanies() async {
    var database = await db;

    List<CompanyModel> companies = [];

    List<Map<String, dynamic>> map =
        await database!.query(tableCompanies, where: '$colStatus = 1');

    for (var company in map) {
      companies.add(CompanyModel.fromMap(company));
    }

    return companies;
  }

  Future<bool> updateCompany(CompanyModel company) async {
    var database = await db;

    int result = await database!.update(tableCompanies, company.toMap(),
        where: '$colId = ?', whereArgs: [company.id]);

    return result == 1;
  }

  Future<bool> deleteCompany(CompanyModel company) async {
    var database = await db;

    int result = await database!.rawUpdate(
        'UPDATE $tableCompanies SET $colStatus = 0 WHERE $colId = ?',
        [company.id]);

    return result == 1;
  }

  Future<CompanyModel> getCompany(int companyId) async {
    var database = await db;

    var map = await database!
        .query(tableCompanies, where: '$colId = ?', whereArgs: [companyId]);

    return CompanyModel.fromMap(map.first);
  }
}
