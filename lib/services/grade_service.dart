import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Grade.dart';

class GradeService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api/asm';
  static const Duration timeout = Duration(seconds: 60);

  static Future<List<Grade>> getGradesByBody(String bodyId) async {
    final idNum = int.tryParse(bodyId);
    if (idNum == null) return [];
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bodies/$idNum/grades'), headers: {
        'Content-Type': 'application/json',
      }).timeout(timeout);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => Grade.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load grades: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> createGrade({
    required String bodyId,
    required String code,
    required String designationFR,
    required String designationAR,
  }) async {
    final idNum = int.tryParse(bodyId);
    if (idNum == null) throw Exception('Invalid bodyId');
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/bodies/$idNum/grades/create'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode({
                'code': code,
                'designationFR': designationFR,
                'designationAR': designationAR,
              }))
          .timeout(timeout);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create grade: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> modifyGrade({
    required String bodyId,
    required String gradeId,
    required String code,
    required String designationFR,
    required String designationAR,
  }) async {
    final idNum = int.tryParse(bodyId);
    final gid = int.tryParse(gradeId);
    if (idNum == null || gid == null) throw Exception('Invalid ids');
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/bodies/$idNum/grades/$gid/modify'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode({
                'code': code,
                'designationFR': designationFR,
                'designationAR': designationAR,
              }))
          .timeout(timeout);
      if (response.statusCode != 200) {
        throw Exception('Failed to modify grade: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteGrade({
    required String bodyId,
    required String gradeId,
  }) async {
    final idNum = int.tryParse(bodyId);
    final gid = int.tryParse(gradeId);
    if (idNum == null || gid == null) throw Exception('Invalid ids');
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/bodies/$idNum/grades/$gid/delete'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              })
          .timeout(timeout);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete grade: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
