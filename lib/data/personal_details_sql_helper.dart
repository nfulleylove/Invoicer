import 'package:sqflite/sqflite.dart';

import '../models/personal_details_model.dart';
import 'invoices_database.dart';

class PersonalDetailsSqlHelper {
  final Future<Database?> db = InvoicesDatabase().database;

  static const String tablePersonalDetails = 'PersonalDetails';

  static const String colId = 'id';
  static const String colForename = 'forename';
  static const String colSurname = 'surname';
  static const String colCis4p = 'cis4p';
  static const String colNationalInsurance = 'nationalInsurance';
  static const String colCompany = 'company';
  static const String colMobile = 'mobile';
  static const String colEmail = 'email';
  static const String colAddress = 'address';
  static const String colTown = 'town';
  static const String colCounty = 'county';
  static const String colPostcode = 'postcode';

  Future<PersonalDetailsModel> getPersonalDetails() async {
    var database = await db;

    List<Map<String, dynamic>> map =
        await database!.query(tablePersonalDetails);

    return PersonalDetailsModel.fromMap(
        map.isNotEmpty ? map.first : <String, dynamic>{});
  }

  Future<int> updatePersonalDetails(
      PersonalDetailsModel personalDetails) async {
    var database = await db;

    int result = await database!.update(
        tablePersonalDetails, personalDetails.toMap(),
        where: '$colId = ?', whereArgs: [personalDetails.id]);

    return result;
  }
}
