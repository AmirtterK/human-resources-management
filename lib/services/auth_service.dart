import 'package:hr_management/classes/types.dart';

/// Authentication service for validating user credentials
/// 
/// This service provides hardcoded credentials for three user roles.
/// In production, this should be replaced with backend API authentication.
class AuthService {
  // Hardcoded user credentials for development/testing
  static final Map<String, Map<String, dynamic>> _users = {
    'pm_admin': {
      'password': 'pm123456',
      'role': User.pm,
      'displayName': 'Personnel Manager',
    },
    'agent': {
      'password': 'agent123',
      'role': User.agent,
      'displayName': 'Agent',
    },
    'archiver': {
      'password': 'archive123',
      'role': User.archiver,
      'displayName': 'Archive Manager',
    },
  };

  /// Authenticates a user with username and password
  /// 
  /// Returns the User role enum if credentials are valid, null otherwise
  static User? authenticate(String username, String password) {
    // Remove any whitespace
    username = username.trim();
    password = password.trim();

    // Check if user exists and password matches
    if (_users.containsKey(username)) {
      if (_users[username]!['password'] == password) {
        return _users[username]!['role'] as User;
      }
    }

    return null;
  }

  /// Gets the display name for a given username
  static String? getDisplayName(String username) {
    if (_users.containsKey(username)) {
      return _users[username]!['displayName'];
    }
    return null;
  }

  /// Validates if a username exists
  static bool userExists(String username) {
    return _users.containsKey(username.trim());
  }
}
