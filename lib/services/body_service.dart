import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Body.dart';

class BodyService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const Duration timeout = Duration(seconds: 60);

  static Future<List<Body>> getBodies() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/bodies'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeout);

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

  static Future<Body?> createBody({
    required String code,
    required String designationFR,
    required String designationAR,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/agent/bodies/create'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'code': code,
              'designationFR': designationFR,
              'designationAR': designationAR,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          return null;
        }
        try {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          return Body.fromJson(jsonBody);
        } catch (_) {
          return null;
        }
      } else {
        throw Exception(
          'Failed to create body: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error creating body: $e');
      rethrow;
    }
  }

  static Future<Body?> modifyBody({
    required String id,
    required String code,
    required String designationFR,
    required String designationAR,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/agent/bodies/$id/modify'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'code': code,
              'designationFR': designationFR,
              'designationAR': designationAR,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        }
        try {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          return Body.fromJson(jsonBody);
        } catch (_) {
          return null;
        }
      } else {
        throw Exception(
          'Failed to modify body: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error modifying body: $e');
      rethrow;
    }
  }

  static Future<void> deleteBody({required String id}) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/agent/bodies/$id/delete'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception(
          'Failed to delete body: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error deleting body: $e');
      rethrow;
    }
  }
}
