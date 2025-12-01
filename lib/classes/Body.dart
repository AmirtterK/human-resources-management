import 'package:hr_management/classes/Employee.dart';

class Body {
  final String id;
  final String nameEn;
  final String nameAr;
  final int totalMembers;
  final List<Employee> employees;

  Body({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.totalMembers,
    required this.employees,
  });
}
