import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maternal_app/models/antenatal.dart';

class AntenatalService {
  // Replace with your actual base API URL
  static const String baseUrl = 'http://10.0.2.2:7092/api';

  Future<void> createAntenatalVisit(AntenatalVisit visit) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/PrenatalVisit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(visit.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to create antenatal visit: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }
}
