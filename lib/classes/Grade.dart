class Grade {
  final String id;
  final String code;
  final String designationFR;
  final String designationAR;

  Grade({
    required this.id,
    required this.code,
    required this.designationFR,
    required this.designationAR,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      designationFR: json['designationFR']?.toString() ?? '',
      designationAR: json['designationAR']?.toString() ?? '',
    );
  }
}
