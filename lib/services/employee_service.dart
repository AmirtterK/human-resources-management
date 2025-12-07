import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Employee.dart';

class EmployeeService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api/pm';
  static const Duration timeout = Duration(seconds: 60);

  /// Fetch all employees from the API
  static Future<List<Employee>> getEmployees() async {
    try {
      print('Fetching employees from $baseUrl/employees');
      
      final response = await http.get(
        Uri.parse('$baseUrl/employees'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('GET employees status: ${response.statusCode}');
      print('GET employees body length: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} employees from API');
        return jsonList.map((jsonItem) => Employee.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in getEmployees: $e');
      throw Exception('Error fetching employees: $e');
    }
  }

  /// Create a new employee
  static Future<Map<String, dynamic>> addEmployee(Map<String, dynamic> employeeData) async {
    try {
      print('Sending employee data: ${json.encode(employeeData)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/employees/add'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(employeeData),
      ).timeout(timeout);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          return {'success': true, 'message': 'Employee added successfully'};
        }
        // Try to parse as JSON, if fails return as plain text message
        try {
          return json.decode(response.body);
        } catch (e) {
          // Server returned plain text (e.g., "Employee added successfully")
          return {'success': true, 'message': response.body};
        }
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in addEmployee: $e');
      rethrow;
    }
  }

  /// Update an existing employee (legacy, uses Employee.toJson)
  static Future<Employee> updateEmployee(String id, Employee employee) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/employees/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return Employee.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update employee: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      throw Exception('Error updating employee: $e');
    }
  }

  /// Modify employee with a specific payload matching PM endpoint structure
  static Future<Map<String, dynamic>> modifyEmployee(String id, Map<String, dynamic> data) async {
    try {
      print('Modifying employee $id with: ${json.encode(data)}');
      final response = await http.put(
        Uri.parse('$baseUrl/employees/$id/modify'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(timeout);
      print('PUT modify status: ${response.statusCode}');
      print('PUT modify body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return {'success': true};
        try {
          return json.decode(response.body);
        } catch (_) {
          return {'success': true, 'message': response.body};
        }
      } else {
        throw Exception('Failed to modify employee: ${response.statusCode} ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in modifyEmployee: $e');
      rethrow;
    }
  }

  /// Delete an employee
  static Future<void> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/employees/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete employee: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      throw Exception('Error deleting employee: $e');
    }
  }
}
