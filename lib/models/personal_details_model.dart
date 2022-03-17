class PersonalDetailsModel {
  int id;
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
        map['id'] ?? 0,
        map['forename'] ?? '',
        map['surname'] ?? '',
        map['cis4p'] ?? '',
        map['nationalInsurance'] ?? '',
        map['company'] ?? '',
        map['mobile'] ?? '',
        map['email'] ?? '',
        map['address'] ?? '',
        map['town'] ?? '',
        map['county'] ?? '',
        map['postcode'] ?? '');

    return model;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'forename': forename,
      'surname': surname,
      'cis4p': cis4p,
      'nationalInsurance': nationalInsurance,
      'company': company,
      'mobile': mobile,
      'email': email,
      'address': address,
      'town': town,
      'county': county,
      'postcode': postcode
    };
  }
}
