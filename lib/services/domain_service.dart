import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Domain.dart';

/// Service for managing functionality domains via backend API.
class DomainService {
  static const String baseUrl = 'https://hr-server-3s0m.onrender.com/api';
  static const String asmBase = 'https://hr-server-3s0m.onrender.com/api/asm';
  static const Duration timeout = Duration(seconds: 60);

  /// Fetch all domains.
  static Future<List<Domain>> getDomains() async {
    final res = await http
        .get(Uri.parse('$baseUrl/domains'), headers: {'Content-Type': 'application/json'})
        .timeout(timeout);
    if (res.statusCode == 200) {
      final List<dynamic> list = json.decode(res.body);
      return list.map((e) => Domain.fromJson(e)).toList();
    }
    throw Exception('Failed to load domains: ${res.statusCode}');
  }

  static Future<Domain?> createDomain(String name) async {
    final res = await http
        .post(Uri.parse('$asmBase/domains/create'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(name))
        .timeout(timeout);
    if (res.statusCode == 200 || res.statusCode == 201) {
      try {
        final Map<String, dynamic> obj = json.decode(res.body);
        return Domain.fromJson(obj);
      } catch (_) {
        return null;
      }
    }
    throw Exception('Failed to create domain: ${res.statusCode} ${res.body}');
  }

  static Future<void> deleteDomain(String id) async {
    final did = int.tryParse(id);
    if (did == null) throw Exception('Invalid domain id');
    final res = await http
        .delete(Uri.parse('$asmBase/domains/$did/delete'), headers: {'Accept': 'application/json'})
        .timeout(timeout);
    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception('Failed to delete domain: ${res.statusCode}');
  }
}
