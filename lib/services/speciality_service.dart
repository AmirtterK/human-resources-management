import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Speciality.dart';

class SpecialityService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const Duration timeout = Duration(seconds: 60);

  static Future<List<Speciality>> getSpecialities() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/specialties'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Speciality.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load specialities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching specialities: $e');
      throw Exception('Error fetching specialities: $e');
    }
  }
}
