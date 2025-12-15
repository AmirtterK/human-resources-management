import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/config/api_config.dart';

/// Authentication service for validating user credentials via backend API
/// 
/// This service communicates with the Spring Boot backend for authentication.
class AuthService {
  static const String baseUrl = '${ApiConfig.baseUrl}/auth';
  static const Duration timeout = ApiConfig.timeout;

  // Map of usernames to display names (for UI purposes)
  static final Map<String, String> _displayNames = {
    'pm': 'Personnel Manager',
    'agent': 'Agent',
    'asm': 'Archive Manager',
  };

  // Map of backend role strings to frontend User enum
  static User? _mapRoleToUser(String role) {
    switch (role) {
      case 'PERSONAL_MANAGER':
        return User.pm;
      case 'AGENT':
        return User.agent;
      case 'ARCHIVE_SERVICE_MANAGER':
        return User.archiver;
      default:
        return null;
    }
  }

  /// Authenticates a user with username and password via backend API
  /// 
  /// Returns the User role enum if credentials are valid, null otherwise
  static Future<User?> login(String username, String password) async {
    username = username.trim();
    password = password.trim();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        // Backend returns the role as a string (e.g., "PERSONAL_MANAGER")
        // Remove quotes if present (standard JSON string response)
        final roleString = response.body.trim().replaceAll('"', '');
        return _mapRoleToUser(roleString);
      } else {
        // Authentication failed
        return null;
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in login: $e');
      return null;
    }
  }

  /// Resets password for a user using director's code
  /// 
  /// Returns true if reset was successful, false otherwise
  /// Throws exception on network errors
  static Future<bool> resetPassword(String directorsCode, String username, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'directorsCode': directorsCode,
          'username': username,
          'newPassword': newPassword,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return true;
      } else {
        // Director's code invalid or user not found
        return false;
      }
    } on TimeoutException {
      throw Exception('Request timed out. Server may be starting up, please try again.');
    } catch (e) {
      print('Error in resetPassword: $e');
      throw Exception('Error resetting password: $e');
    }
  }

  /// Gets the display name for a given username
  static String? getDisplayName(String username) {
    return _displayNames[username.trim()];
  }

  /// Validates if a username exists (for UI validation)
  static bool userExists(String username) {
    return _displayNames.containsKey(username.trim());
  }

  /// Gets the list of valid usernames for the dropdown
  static List<Map<String, String>> getAvailableUsers() {
    return [
      {'username': 'pm', 'displayName': 'Personnel Manager'},
      {'username': 'agent', 'displayName': 'Agent'},
      {'username': 'asm', 'displayName': 'Archive Manager'},
    ];
  }
}
