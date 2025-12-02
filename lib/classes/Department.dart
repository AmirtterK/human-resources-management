import 'package:hr_management/classes/Employee.dart';

class Department {
  final String id;
  final String name;
  final String headName;
  final int totalStaffMembers;
  final List<Employee> emloyees;
  Department({
    required this.id,
    required this.name,
    required this.headName,
    required this.totalStaffMembers,
    required this.emloyees,
  });
}
