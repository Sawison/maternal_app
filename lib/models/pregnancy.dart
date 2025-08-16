class Pregnancy {
  final String pregnancyId;
  final String patientId;
  final String? lastmenstructionperiod;
  final int gestationWeeks;
  final String? dueDate;
  final String? pregnancyStatus;
  final DateTime? createdAt;

  Pregnancy({
    this.pregnancyId = '',
    required this.patientId,
    this.lastmenstructionperiod,
    this.gestationWeeks = 0,
    this.dueDate,
    this.pregnancyStatus,
    this.createdAt,
  });

  factory Pregnancy.fromJson(Map<String, dynamic> json) {
    return Pregnancy(
      pregnancyId: json['pregnancyId'] ?? '',
      patientId: json['patientId'] ?? '',
      lastmenstructionperiod: json['lastmenstructionperiod'],
      gestationWeeks: json['gestationWeeks'] ?? 0,
      dueDate: json['dueDate'],
      pregnancyStatus: json['pregnancyStatus'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'lastmenstructionperiod': lastmenstructionperiod,
      'gestationWeeks': gestationWeeks,
      'dueDate': dueDate,
      'pregnancyStatus': pregnancyStatus,
    };
  }
}
