import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Body.dart';

class BodyService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const Duration timeout = Duration(seconds: 60);

  static Future<List<Body>> getBodies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bodies'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Body.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bodies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bodies: $e');
      throw Exception('Error fetching bodies: $e');
    }
  }
}