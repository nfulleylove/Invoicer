import 'package:invoicer/data/invoices_database.dart';

import 'package:invoicer/models/location_model.dart';
import 'package:sqflite/sqflite.dart';

class LocationsSqlHelper {
  Database? db = InvoicesDatabase.db;

  static String colId = "id";
  static String colName = "name";
  static String tableLocations = "Locations";

  Future<int> insertLocation(LocationModel location) async {
    return await db!.insert(tableLocations, location.toMap());
  }

  Future<List<LocationModel>> getLocations() async {
    List<Map<String, dynamic>> map = await db!.query(tableLocations);

    List<LocationModel> locations = [];

    for (var element in map) {
      locations.add(LocationModel.fromMap(element));
    }

    return locations;
  }

  Future<int> deleteLocation(LocationModel location) async {
    int result = await db!
        .delete(tableLocations, where: '$colId = ?', whereArgs: [location.id]);

    return result;
  }
}
