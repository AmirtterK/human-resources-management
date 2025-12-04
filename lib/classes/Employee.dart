import 'package:hr_management/classes/types.dart';

class Employee {
  final String id;
  final String fullName;
  final String rank;
  final String category;
  final String specialty;
  final String department;
  final Status status;
  final DateTime? requestDate;
  final String? gradeEn;
  final String? gradeAr;
  Employee({
    required this.id,
    required this.fullName,
    required this.rank,
    required this.category,
    required this.specialty,
    required this.department,
    required this.status,
    this.requestDate, 
    this.gradeEn,
    this.gradeAr,
  });
}