class InfantVisit {
  final String birthId;
  final String checkupDate;
  final double weight;
  final String illness;
  final String vaccinationInfo;
  final int visitNumber;

  InfantVisit({
    required this.birthId,
    required this.checkupDate,
    required this.weight,
    required this.illness,
    required this.vaccinationInfo,
    required this.visitNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'birthId': birthId,
      'checkupDate': checkupDate,
      'weight': weight,
      'illness': illness,
      'vaccinationInfo': vaccinationInfo,
      'visitNumber': visitNumber,
    };
  }
}
