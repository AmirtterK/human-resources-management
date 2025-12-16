import 'package:hr_management/classes/Employee.dart';

/// Represents a department within the organization.
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

  /// Factory constructor to create Department from JSON (API response format)
  factory Department.fromJson(Map<String, dynamic> json) {
    // Handle id - API returns int, convert to String
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    
    // Handle name
    final name = json['name']?.toString() ?? '';
    
    // Handle employees array
    final List<Employee> employees = [];
    if (json['employees'] is List) {
      try {
        employees.addAll(
          (json['employees'] as List).map((empJson) {
            try {
              return Employee.fromJson(empJson);
            } catch (e) {
              print('Error parsing employee: $e');
              print('Employee JSON: $empJson');
              rethrow;
            }
          }).toList(),
        );
        print('Successfully parsed ${employees.length} employees for department $name');
      } catch (e) {
        print('Error parsing employees array: $e');
      }
    }
    
    // Calculate total staff members from employees list
    final totalStaffMembers = employees.length;
    
    // headName is not in API response, use empty string or first employee's name as fallback
    String headName = '';
    if (employees.isNotEmpty) {
      // You might want to set a specific logic here, for now using empty
      headName = '';
    }

    return Department(
      id: id,
      name: name,
      headName: headName,
      totalStaffMembers: totalStaffMembers,
      emloyees: employees,
    );
  }
}
