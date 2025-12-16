import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/config/api_config.dart';

/// Service for managing employees, including CRUD, retirement, and certificates.
/// Handles communication with PM, ASM, and Agent endpoints.
class EmployeeService {
  static const String baseUrl = '${ApiConfig.baseUrl}/pm';
  static const Duration timeout = ApiConfig.timeout;

  /// Fetch all employees from the API
  static Future<List<Employee>> getEmployees() async {
    try {
      print('Fetching employees from $baseUrl/employees');
      
      final response = await http.get(
        Uri.parse('$baseUrl/employees'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('GET employees status: ${response.statusCode}');
      print('GET employees body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} employees from API');
        return jsonList.map((jsonItem) {
          try {
            return Employee.fromJson(jsonItem);
          } catch (e) {
            print('Error parsing employee: $e');
            print('Problematic JSON: $jsonItem');
            // Return a "safe" placeholder or rethrow? 
            // Better to rethrow to find the bug, but user needs app to work.
            // Let's rethrow for now to see the error in logs if it persists.
            rethrow; 
          }
        }).toList();
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

  /// Request retirement for an employee
  /// Calls: POST /api/pm/employees/{id}/request-retire
  static Future<Map<String, dynamic>> requestRetirement(String id, {String? justification}) async {
    try {
      print('Requesting retirement for employee $id');
      final response = await http.post(
        Uri.parse('$baseUrl/employees/$id/request-retire'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: justification != null ? json.encode(justification) : null,
      ).timeout(timeout);

      print('POST request-retire status: ${response.statusCode}');
      print('POST request-retire body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          return {'success': true, 'message': 'Retirement requested successfully'};
        }
        try {
          return json.decode(response.body);
        } catch (_) {
          return {'success': true, 'message': response.body};
        }
      } else {
        throw Exception('Failed to request retirement: ${response.statusCode} ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in requestRetirement: $e');
      rethrow;
    }
  }

  static const String asmBaseUrl = '${ApiConfig.baseUrl}/asm';

  /// Fetch all retired employees from ASM endpoint
  static Future<List<Employee>> getRetiredEmployees() async {
    try {
      print('Fetching retired employees from $asmBaseUrl/employees');

      final response = await http.get(
        Uri.parse('$asmBaseUrl/employees'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('GET retired employees status: ${response.statusCode}');
      print('GET retired employees body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} retired employees');
        return jsonList.map((jsonItem) => Employee.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load retired employees: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in getRetiredEmployees: $e');
      throw Exception('Error fetching retired employees: $e');
    }
  }

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

  /// Transfer an employee to a different department
  /// Calls: PUT /api/pm/employees/{id}/transfer
  static Future<Map<String, dynamic>> transferEmployee(
    String id,
    int departmentId,
    DateTime effectiveDate,
  ) async {
    try {
      print('Transferring employee $id to department $departmentId');
      final response = await http.put(
        Uri.parse('$baseUrl/employees/$id/transfer'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'departmentId': departmentId,
          'effectiveDate': effectiveDate.toIso8601String().substring(0, 10),
        }),
      ).timeout(timeout);

      print('PUT transfer status: ${response.statusCode}');
      print('PUT transfer body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return {'success': true};
        try {
          return json.decode(response.body);
        } catch (_) {
          return {'success': true, 'message': response.body};
        }
      } else {
        throw Exception('Failed to transfer employee: ${response.statusCode} ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in transferEmployee: $e');
      rethrow;
    }
  }

  /// Assign an employee to department, body, and grade
  /// Calls: PUT /api/pm/employees/{id}/assign
  static Future<Map<String, dynamic>> assignRecruit(
    String id,
    int departmentId,
    int bodyId,
    int gradeId,
    DateTime startDate,
  ) async {
    try {
      print('Assigning employee $id to dept=$departmentId, body=$bodyId, grade=$gradeId');
      final response = await http.put(
        Uri.parse('$baseUrl/employees/$id/assign'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'departmentId': departmentId,
          'bodyId': bodyId,
          'gradeId': gradeId,
          'startDate': startDate.toIso8601String().substring(0, 10),
        }),
      ).timeout(timeout);

      print('PUT assign status: ${response.statusCode}');
      print('PUT assign body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return {'success': true};
        try {
          return json.decode(response.body);
        } catch (_) {
          return {'success': true, 'message': response.body};
        }
      } else {
        throw Exception('Failed to assign employee: ${response.statusCode} ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in assignRecruit: $e');
      rethrow;
    }
  }

  /// Promote an employee (PM)
  /// Calls: POST /api/pm/promotions
  static Future<void> promoteEmployee({
    required String employeeId,
    required int gradeId,
    required String rank, // e.g. "A1", "A2"
    required int step,
    required String justification,
  }) async {
    final eid = int.tryParse(employeeId);
    if (eid == null) throw Exception('Invalid employee ID');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/promotions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'employeeId': eid,
          'gradeId': gradeId,
          'rank': rank,
          'step': step,
          'justification': justification,
        }),
      ).timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to promote employee: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error promoting employee: $e');
      rethrow;
    }
  }

  /// Get employees approaching retirement (PM)
  /// Calls: GET /api/pm/employees/toRetire
  static Future<List<Employee>> getEmployeesToRetire() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employees/toRetire'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
         final List<dynamic> jsonList = json.decode(response.body);
         return jsonList.map((e) => Employee.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load employees to retire');
      }
    } catch (e) {
      throw Exception('Error fetching employees to retire: $e');
    }
  }

  /// Validate retirement request (ASM)
  /// Calls: POST /api/asm/retireRequests/{id}/validate
  static Future<Map<String, dynamic>> validateRetireRequest(String id) async {
    try {
      print('Validating retire request for employee $id');
      final response = await http.post(
        Uri.parse('$asmBaseUrl/retireRequests/$id/validate'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('POST validate status: ${response.statusCode}');
      print('POST validate body: ${response.body}');

      if (response.statusCode == 200) {
         return {'success': true, 'message': response.body};
      } else {
        throw Exception('Failed to validate retirement request: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in validateRetireRequest: $e');
      throw Exception('Error validating retirement request: $e');
    }
  }

  /// Deny retirement request (ASM)
  /// Calls: POST /api/asm/retireRequests/{id}/deny
  static Future<Map<String, dynamic>> denyRetireRequest(String id) async {
    try {
      print('Denying retire request for employee $id');
      final response = await http.post(
        Uri.parse('$asmBaseUrl/retireRequests/$id/reject'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('POST deny status: ${response.statusCode}');
      print('POST deny body: ${response.body}');

      if (response.statusCode == 200) {
         return {'success': true, 'message': response.body};
      } else {
        throw Exception('Failed to deny retirement request: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in denyRetireRequest: $e');
      throw Exception('Error denying retirement request: $e');
    }
  }

  /// Download work certificate (Agent)
  /// Calls: GET /api/agent/employees/{id}/work-certificate
  static Future<List<int>> downloadWorkCertificate(String id) async {
    final url = 'https://hr-server-3s0m.onrender.com/api/agent/employees/$id/work-certificate';
    try {
      final response = await http.get(Uri.parse(url)).timeout(timeout);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to download certificate: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading certificate: $e');
    }
  }

  /// Download retirement certificate (ASM)
  /// Calls: GET /api/asm/retirees/{id}/certificate
  static Future<List<int>> downloadRetirementCertificate(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$asmBaseUrl/retirees/$id/certificate')
      ).timeout(timeout);
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
         throw Exception('Failed to download retirement certificate');
      }
    } catch (e) {
      throw Exception('Error downloading retirement certificate: $e');
    }
  }

  /// Export employees list (Agent)
  /// Calls: GET /api/agent/export
  static Future<List<int>> exportEmployees({
    int? specialtyId,
    int? gradeId,
    String? category,
    String format = 'pdf',
  }) async {
    final queryParams = <String, String>{
      'format': format,
    };
    if (specialtyId != null) queryParams['specialtyId'] = specialtyId.toString();
    if (gradeId != null) queryParams['gradeId'] = gradeId.toString();
    if (category != null && category.isNotEmpty) queryParams['category'] = category;

    final uri = Uri.parse('${ApiConfig.baseUrl}/agent/export')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(timeout);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to export employees: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error exporting employees: $e');
    }
  }
}
