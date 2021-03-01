class PersonalInformation {
  PersonalInformation({
    this.fname,
    this.mobile,
    this.dob,
    this.raSociety,
    this.raArea,
    this.raCity,
    this.raPincode,
    this.raState,
    this.role,
    this.joiningDate,
    this.emergencyContact,
    this.relationshipEmergency,
  });

  String fname;
  String mobile;
  DateTime dob;
  String raSociety;
  String raArea;
  String raCity;
  String raPincode;
  String raState;
  String role;
  DateTime joiningDate;
  String emergencyContact;
  String relationshipEmergency;

  factory PersonalInformation.fromJson(Map<String, dynamic> json) => PersonalInformation(
    fname: json["fname"],
    mobile: json["mobile"],
    dob: DateTime.parse(json["dob"]),
    raSociety: json["ra_society"],
    raArea: json["ra_area"],
    raCity: json["ra_city"],
    raPincode: json["ra_pincode"],
    raState: json["ra_state"],
    role: json["role"],
    joiningDate: json["joining_date"] == null ? null : DateTime.parse(json["joining_date"] as String),
    emergencyContact: json["emergency_contact"],
    relationshipEmergency: json["relationship_emergency"],
  );

  Map<String, dynamic> toJson() => {
    "fname": fname,
    "mobile": mobile,
    "dob":
    "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "ra_society": raSociety,
    "ra_area": raArea,
    "ra_city": raCity,
    "ra_pincode": raPincode,
    "ra_state": raState,
    "role": role,
    "joining_date":
    "${joiningDate.year.toString().padLeft(4, '0')}-${joiningDate.month.toString().padLeft(2, '0')}-${joiningDate.day.toString().padLeft(2, '0')}",
    "emergency_contact": emergencyContact,
    "relationship_emergency": relationshipEmergency,
  };
}
