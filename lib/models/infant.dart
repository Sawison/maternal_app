class Infant {
  final String? birthId;
  final String pregnancyId;
  final String birthDate;
  final String infantGender;
  final double weight;
  final String deliveryMethod;
  final bool alive;
  final String? notes;

  Infant({
    this.birthId,
    required this.pregnancyId,
    required this.birthDate,
    required this.infantGender,
    required this.weight,
    required this.deliveryMethod,
    required this.alive,
    this.notes,
  });

  factory Infant.fromJson(Map<String, dynamic> json) {
    return Infant(
      birthId: json['birthId'],
      pregnancyId: json['pregnancyId'],
      birthDate: json['birthDate'],
      infantGender: json['infantGender'],
      weight: json['weight'].toDouble(),
      deliveryMethod: json['deliveryMethod'],
      alive: json['alive'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'pregnancyId': pregnancyId,
      'birthDate': birthDate,
      'infantGender': infantGender,
      'weight': weight,
      'deliveryMethod': deliveryMethod,
      'alive': alive,
      'notes': notes,
    };
    if (birthId != null) {
      data['birthId'] = birthId;
    }
    return data;
  }
}
