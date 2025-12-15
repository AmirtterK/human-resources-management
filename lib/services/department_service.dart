import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Department.dart';

import 'package:hr_management/config/api_config.dart';

class DepartmentService {
  static const String baseUrl = '${ApiConfig.baseUrl}/departments'; // Modified baseUrl
  static const Duration timeout = ApiConfig.timeout; // Modified timeout

  /// Fetch all departments from the API
  static Future<List<Department>> getDepartments() async {
    try {
      print('Fetching departments from $baseUrl'); // Modified print statement
      
      final response = await http.get(
        Uri.parse(baseUrl),
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

