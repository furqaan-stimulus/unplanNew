class UserDetail {
  UserDetail({
    this.id,
    this.email,
    this.name,
    this.dob,
    this.gender,
    this.mobile,
    this.image,
    this.otpCode,
    this.isConfirm,
    this.teamId,
    this.roleId,
    this.loginCount,
    this.updatedBy,
    this.updatedAt,
    this.createdAt,
    this.createdBy,
    this.deletedAt,
    this.deviceId,
    this.deviceOs,
  });

  int id;
  String email;
  String name;
  dynamic dob;
  String gender;
  String mobile;
  String image;
  dynamic otpCode;
  int isConfirm;
  int teamId;
  int roleId;
  int loginCount;
  dynamic updatedBy;
  DateTime updatedAt;
  DateTime createdAt;
  dynamic createdBy;
  dynamic deletedAt;
  String deviceId;
  String deviceOs;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        dob: json["dob"],
        gender: json["gender"],
        mobile: json["mobile"],
        image: json["image"],
        otpCode: json["otp_code"],
        isConfirm: json["is_confirm"],
        teamId: json["team_id"],
        roleId: json["role_id"],
        loginCount: json["login_count"],
        updatedBy: json["updated_by"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        deletedAt: json["deleted_at"],
        deviceId: json["device_id"],
        deviceOs: json["device_os"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "dob": dob,
        "gender": gender,
        "mobile": mobile,
        "image": image,
        "otp_code": otpCode,
        "is_confirm": isConfirm,
        "team_id": teamId,
        "role_id": roleId,
        "login_count": loginCount,
        "updated_by": updatedBy,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "deleted_at": deletedAt,
        "device_id": deviceId,
        "device_os": deviceOs,
      };
}
