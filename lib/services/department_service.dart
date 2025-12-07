import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Department.dart';

class DepartmentService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const Duration timeout = Duration(seconds: 60);

  /// Fetch all departments from the API
  static Future<List<Department>> getDepartments() async {
    try {
      print('Fetching departments from $baseUrl/departments');
      
      final response = await http.get(
        Uri.parse('$baseUrl/departments'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      print('GET departments status: ${response.statusCode}');
      print('GET departments body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} departments from API');
        return jsonList.map((jsonItem) => Department.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load departments: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in getDepartments: $e');
      throw Exception('Error fetching departments: $e');
    }
  }
}

