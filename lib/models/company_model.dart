import 'package:invoicer/data/companies_sql_helper.dart';

class CompanyModel {
  int id = -1;
  String name;
  String address;
  String town;
  String county;
  String postcode;
  String email;

  String get addressText => '$name\n$address\n$town\n$county\n$postcode';

  CompanyModel(this.id, this.name, this.address, this.town, this.county,
      this.postcode, this.email);

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      map[CompaniesSqlHelper.colId],
      map[CompaniesSqlHelper.colName],
      map[CompaniesSqlHelper.colAddress],
      map[CompaniesSqlHelper.colTown],
      map[CompaniesSqlHelper.colCounty],
      map[CompaniesSqlHelper.colPostcode],
      map[CompaniesSqlHelper.colEmail],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CompaniesSqlHelper.colName: name,
      CompaniesSqlHelper.colAddress: address,
      CompaniesSqlHelper.colTown: town,
      CompaniesSqlHelper.colCounty: county,
      CompaniesSqlHelper.colPostcode: postcode,
      CompaniesSqlHelper.colEmail: email
    };
  }

  @override
  bool operator ==(dynamic other) =>
      other != null &&
      other is CompanyModel &&
      id == other.id &&
      name == other.name &&
      address == other.address &&
      town == other.town &&
      county == other.county &&
      postcode == other.postcode &&
      email == other.email;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
