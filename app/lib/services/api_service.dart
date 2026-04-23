import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android emulator to access localhost, or actual IP for physical device
  static const String baseUrl = 'http://127.0.0.1:5000';

  static Future<Map<String, dynamic>> startScan(String target, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'target': target, 'type': type}),
    );

    if (response.statusCode == 202) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to start scan');
    }
  }

  static Future<Map<String, dynamic>> getScanResults(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/results/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load results');
    }
  }

  static Future<List<dynamic>> getRecentScans() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recent_scans'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching recent scans: $e');
    }
    return [];
  }
}
