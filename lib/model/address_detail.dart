class AddressDetail {
  AddressDetail({
    this.id,
    this.userId,
    this.officeLatitude,
    this.officeLongitude,
    this.homeLatitude,
    this.homeLongitude,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  String officeLatitude;
  String officeLongitude;
  String homeLatitude;
  String homeLongitude;
  DateTime createdAt;
  DateTime updatedAt;

  factory AddressDetail.fromJson(Map<String, dynamic> json) => AddressDetail(
    id: json["id"],
    userId: json["user_id"],
    officeLatitude: json["office_latitude"],
    officeLongitude: json["office_longitude"],
    homeLatitude: json["home_latitude"],
    homeLongitude: json["home_longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "office_latitude": officeLatitude,
    "office_longitude": officeLongitude,
    "home_latitude": homeLatitude,
    "home_longitude": homeLongitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
