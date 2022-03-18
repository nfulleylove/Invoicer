import 'package:invoicer/models/company_model.dart';
import 'package:sqflite/sqflite.dart';

import 'invoices_database.dart';

class CompaniesSqlHelper {
  Database? db = InvoicesDatabase.db;

  static const String tableCompanies = 'Companies';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colAddress = 'address';
  static const String colTown = 'town';
  static const String colCounty = 'county';
  static const String colPostcode = 'postcode';
  static const String colEmail = 'email';

  Future<int> insertCompany(CompanyModel company) async {
    var map = company.toMap();
    map.remove(colId);

    return await db!.insert(tableCompanies, map);
  }

  Future<List<CompanyModel>> getCompanies() async {
    List<CompanyModel> companies = [];

    List<Map<String, dynamic>> map = await db!.query(tableCompanies);

    for (var company in map) {
      companies.add(CompanyModel.fromMap(company));
    }

    return companies;
  }

  Future<int> updateCompany(CompanyModel company) async {
    int result = await db!.update(tableCompanies, company.toMap(),
        where: '$colId = ?', whereArgs: [company.id]);

    return result;
  }

  Future<int> deleteCompany(CompanyModel company) async {
    int result = await db!
        .delete(tableCompanies, where: '$colId = ?', whereArgs: [company.id]);

    return result;
  }
}
