import 'package:invoicer/data/locations_sql_helper.dart';

class LocationModel {
  int id = -1;
  String name;

  LocationModel(this.id, this.name);

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
        map[LocationsSqlHelper.colId], map[LocationsSqlHelper.colName]);
  }

  Map<String, dynamic> toMap() {
    return {LocationsSqlHelper.colId: id, LocationsSqlHelper.colName: name};
  }
}
