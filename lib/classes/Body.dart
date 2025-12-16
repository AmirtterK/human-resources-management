import 'package:hr_management/classes/Employee.dart';

/// Represents an organizational body (e.g., a large division or unit).
class Body {
  final String id;
  final String code;
  final String designationFR;
  final String designationAR;
  final int totalMembers;
  final List<Employee> employees;
  late final String _nameEn;
  late final String _nameAr;

  Body({
    required this.id,
    required this.code,
    required this.designationFR,
    required this.designationAR,
    required this.totalMembers,
    required this.employees,
    required String nameEn,
    required String nameAr,
  }) : _nameEn = nameEn,
       _nameAr = nameAr;

  String get nameEn => _nameEn;
  String get nameAr => _nameAr;

  factory Body.fromJson(Map<String, dynamic> json) {
    final fr = (json['designationFR'] ?? '').toString();
    final ar = (json['designationAR'] ?? '').toString();
    final en = (json['nameEn'] ?? fr).toString();
    final arName = (json['nameAr'] ?? ar).toString();
    return Body(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      designationFR: fr,
      designationAR: ar,
      totalMembers: json['totalMembers'] is int
          ? json['totalMembers'] as int
          : int.tryParse(json['totalMembers']?.toString() ?? '0') ?? 0,
      employees: [],
      nameEn: en,
      nameAr: arName,
    );
  }
}
