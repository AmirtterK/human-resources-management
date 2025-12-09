import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Speciality.dart';

class SpecialityService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const String asmBase = 'https://hr-server-3s0m.onrender.com/api/asm';
  static const Duration timeout = Duration(seconds: 60);

  static Future<List<Speciality>> getSpecialities() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/specialties'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeout);

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

  static Future<Speciality?> createSpeciality({
    required String domainId,
    required String name,
  }) async {
    final did = int.tryParse(domainId);
    if (did == null) throw Exception('Invalid domain id');
    final res = await http
        .post(
          Uri.parse('$asmBase/domains/$did/specialities/create'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(name),
        )
        .timeout(timeout);
    if (res.statusCode == 200 || res.statusCode == 201) {
      try {
        final Map<String, dynamic> obj = json.decode(res.body);
        return Speciality.fromJson(obj);
      } catch (_) {
        return null;
      }
    }
    throw Exception('Failed to create speciality: ${res.statusCode}');
  }

  static Future<void> deleteSpeciality({required String specialityId}) async {
    final sid = int.tryParse(specialityId);
    if (sid == null) throw Exception('Invalid speciality id');
    final res = await http
        .delete(
          Uri.parse('$asmBase/specialities/$sid/delete'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(timeout);
    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception('Failed to delete speciality: ${res.statusCode}');
  }
}
