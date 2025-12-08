import 'package:hr_management/classes/Employee.dart';

class Body {
  final String id;
  final String code;
  final String designationFR;
  final String designationAR;
  final int totalMembers;
  final List<Employee> employees;

  Body({
    required this.id,
    required this.code,
    required this.designationFR,
    required this.designationAR,
    required this.totalMembers,
    required this.employees,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      designationFR: json['designationFR'] ?? '',
      designationAR: json['designationAR'] ?? '',
      totalMembers: json['totalMembers'] ?? 0,
      employees: [], // Employees will be fetched separately if needed
    );
  }
}
