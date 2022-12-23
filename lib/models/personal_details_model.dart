import 'package:invoicer/data/personal_details_sql_helper.dart';

class PersonalDetailsModel {
  int id = 1;
  String forename;
  String surname;
  String cis4p;
  String nationalInsurance;
  String company;
  String mobile;
  String email;
  String address;
  String town;
  String county;
  String postcode;

  String get fullName => '$forename $surname';

  String get addressText =>
      '${forename.toUpperCase()} ${surname.toUpperCase()}\n$address\n$town\n$county\n$postcode\n\n$mobile\n$email';

  PersonalDetailsModel(
      this.id,
      this.forename,
      this.surname,
      this.cis4p,
      this.nationalInsurance,
      this.company,
      this.mobile,
      this.email,
      this.address,
      this.town,
      this.county,
      this.postcode);

  factory PersonalDetailsModel.fromMap(Map<String, dynamic> map) {
    var model = PersonalDetailsModel(
        map[PersonalDetailsSqlHelper.colId] ?? 0,
        map[PersonalDetailsSqlHelper.colForename] ?? '',
        map[PersonalDetailsSqlHelper.colSurname] ?? '',
        map[PersonalDetailsSqlHelper.colCis4p] ?? '',
        map[PersonalDetailsSqlHelper.colNationalInsurance] ?? '',
        map[PersonalDetailsSqlHelper.colCompany] ?? '',
        map[PersonalDetailsSqlHelper.colMobile] ?? '',
        map[PersonalDetailsSqlHelper.colEmail] ?? '',
        map[PersonalDetailsSqlHelper.colAddress] ?? '',
        map[PersonalDetailsSqlHelper.colTown] ?? '',
        map[PersonalDetailsSqlHelper.colCounty] ?? '',
        map[PersonalDetailsSqlHelper.colPostcode] ?? '');

    return model;
  }

  Map<String, dynamic> toMap() {
    return {
      PersonalDetailsSqlHelper.colForename: forename,
      PersonalDetailsSqlHelper.colSurname: surname,
      PersonalDetailsSqlHelper.colCis4p: cis4p,
      PersonalDetailsSqlHelper.colNationalInsurance: nationalInsurance,
      PersonalDetailsSqlHelper.colCompany: company,
      PersonalDetailsSqlHelper.colMobile: mobile,
      PersonalDetailsSqlHelper.colEmail: email,
      PersonalDetailsSqlHelper.colAddress: address,
      PersonalDetailsSqlHelper.colTown: town,
      PersonalDetailsSqlHelper.colCounty: county,
      PersonalDetailsSqlHelper.colPostcode: postcode
    };
  }
}
