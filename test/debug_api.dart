import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Test both endpoints
  final endpoint = 'https://hr-server-3s0m.onrender.com/api/pm/employees';

  
    final url = Uri.parse(endpoint);
    print('\n========================================');
    print('Fetching from $url...');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      );
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          print('Received a List of ${decoded.length} items.');
          if (decoded.isNotEmpty) {
            print('First item: ${decoded[0]}');
          }
        } else {
          print('Received data is not a List: $decoded');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  
}
