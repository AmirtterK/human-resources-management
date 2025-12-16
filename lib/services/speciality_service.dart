import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Speciality.dart';
import 'package:hr_management/classes/Domain.dart';

/// Service for managing specialities and their domains.
class SpecialityService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const String asmBase = 'https://hr-server-3s0m.onrender.com/api/asm';
  static const Duration timeout = Duration(seconds: 60);

  /// Fetch all specialities.
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

  static Future<List<Domain>> getDomains() async {
    try {
      final response = await http
          .get(
            Uri.parse('$asmBase/domains'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Domain.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load domains: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching domains: $e');
      throw Exception('Error fetching domains: $e');
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

  static Future<Domain?> createDomain({required String name}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$asmBase/domains/create'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(name),
          )
          .timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) return null;
        return Domain.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create domain: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating domain: $e');
    }
  }

  static Future<void> deleteDomain({required String domainId}) async {
    final did = int.tryParse(domainId);
    if (did == null) throw Exception('Invalid domain id');
    try {
      final response = await http
          .delete(
            Uri.parse('$asmBase/domains/$did/delete'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete domain: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting domain: $e');
    }
  }
}
