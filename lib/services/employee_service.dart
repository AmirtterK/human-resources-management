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

  /// New method to fetch all employees (including retired) from test endpoint
  static Future<List<Employee>> getAllEmployeesTest() async {
    try {
      print('Fetching ALL employees from $baseUrl/test/allemployees');
      
      final response = await http.get(
        Uri.parse('$baseUrl/test/allemployees'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('GET all employees status: ${response.statusCode}');
      print('GET all employees body length: ${response.body.length}');
      // print('GET all employees body: ${response.body}'); // Uncomment if needed

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} test employees');
        return jsonList.map((jsonItem) => Employee.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load test employees: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in getAllEmployeesTest: $e');
      throw Exception('Error fetching test employees: $e');
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

  static const String asmBaseUrl = 'https://hr-server-3s0m.onrender.com/api/asm';

  /// Fetch retirement requests from ASM API
  static Future<List<Employee>> getRetirementRequests() async {
    try {
      print('Fetching retirement requests from $asmBaseUrl/retireRequests');

      final response = await http.get(
        Uri.parse('$asmBaseUrl/retireRequests'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('GET retirement requests status: ${response.statusCode}');
      print('GET retirement requests body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} retirement requests');
        return jsonList.map((jsonItem) => Employee.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load retirement requests: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in getRetirementRequests: $e');
      throw Exception('Error fetching retirement requests: $e');
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

  /// Modify a retired employee with director's code authentication
  /// Calls the ASM endpoint: PUT /api/asm/employees/{id}/modify
  /// 
  /// Throws an exception if director's code is invalid (401/403)
  static Future<Map<String, dynamic>> modifyRetireeWithDirectorsCode(
    String id, 
    Map<String, dynamic> employeeData,
    String directorsCode,
  ) async {
    try {
      // Build the request body matching ASMModifyEmployeeRequest structure
      final requestBody = {
        'employeeDTOPM': employeeData,
        'directorsCode': directorsCode,
      };
      
      print('Modifying retiree $id with director\'s code: ${json.encode(requestBody)}');
      
      final response = await http.put(
        Uri.parse('$asmBaseUrl/employees/$id/modify'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(timeout);
      
      print('PUT ASM modify status: ${response.statusCode}');
      print('PUT ASM modify body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return {'success': true};
        try {
          return json.decode(response.body);
        } catch (_) {
          return {'success': true, 'message': response.body};
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Invalid Director\'s Code');
      } else {
        throw Exception('Failed to modify retiree: ${response.statusCode} ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in modifyRetireeWithDirectorsCode: $e');
      rethrow;
    }
  }
}
