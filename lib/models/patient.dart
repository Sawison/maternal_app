class Patient {
  String patientId;
  String? nationalID;
  String? fName;
  String? lName;
  String? dateOfBirth;
  String? phoneNumber;
  String? address;
  String? district;
  String? region;
  String? latitude;
  String? longitude;
  DateTime createdAt;
  Patient({
    required this.patientId,
    this.nationalID,
    this.fName,
    this.lName,
    this.dateOfBirth,
    this.phoneNumber,
    this.address,
    this.district,
    this.region,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
  }) : createdAt =
           createdAt ??
           DateTime.utc(
             DateTime.now().year,
             DateTime.now().month,
             DateTime.now().day,
           );
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: (json['patientId'] ?? '') as String,
      nationalID: (json['nationalID'] ?? '') as String?,
      fName: (json['fName'] ?? '') as String?,
      lName: (json['lName'] ?? '') as String?,
      dateOfBirth: (json['dateOfBirth'] ?? '') as String?,
      phoneNumber: (json['phoneNumber'] ?? '') as String?,
      address: (json['address'] ?? '') as String?,
      district: (json['district'] ?? '') as String?,
      region: (json['region'] ?? '') as String?,
      latitude: (json['latitude'] ?? '') as String?,
      longitude: (json['longitude'] ?? '') as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.utc(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'nationalID': nationalID,
      'fName': fName,
      'lName': lName,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'address': address,
      'district': district,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}
