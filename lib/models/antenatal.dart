// Model class for AntenatalVisit
class AntenatalVisit {
  String pregnancyId;
  String visitDate;
  String bp;
  double hbLevel;
  double weight;
  String healthNotes;
  String nextVisitDate;
  int visitNumber;

  AntenatalVisit({
    required this.pregnancyId,
    required this.visitDate,
    required this.bp,
    required this.hbLevel,
    required this.weight,
    required this.healthNotes,
    required this.nextVisitDate,
    required this.visitNumber,
  });

  // Factory constructor to create instance from JSON
  factory AntenatalVisit.fromJson(Map<String, dynamic> json) {
    return AntenatalVisit(
      pregnancyId: json['pregnancyId'] as String,
      visitDate: json['visitDate'] as String,
      bp: json['bp'] as String,
      hbLevel: (json['hbLevel'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      healthNotes: json['healthNotes'] as String,
      nextVisitDate: json['nextVisitDate'] as String,
      visitNumber: json['visitNumber'] as int,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'pregnancyId': pregnancyId,
      'visitDate': visitDate,
      'bp': bp,
      'hbLevel': hbLevel,
      'weight': weight,
      'healthNotes': healthNotes,
      'nextVisitDate': nextVisitDate,
      'visitNumber': visitNumber,
    };
  }
}
