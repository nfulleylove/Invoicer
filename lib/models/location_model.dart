class LocationModel {
  int id;
  String name;

  LocationModel(this.id, this.name);

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(map['id'], map['name']);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}
