import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maternal_app/models/pregnancy.dart';

class PregnancyService {
  final String baseUrl = 'http://10.0.2.2:7092/api';

  Future<Pregnancy> createPregnancy(Pregnancy pregnancy) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Pregnancy'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pregnancy.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Pregnancy.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to create pregnancy: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<Pregnancy>> getPregnanciesByPatient(String patientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Pregnancy/patient/$patientId'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((item) => Pregnancy.fromJson(item)).toList();
      } else if (jsonResponse is Map &&
          jsonResponse.containsKey('Pregnancies')) {
        return (jsonResponse['Pregnancies'] as List)
            .map((item) => Pregnancy.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Patient not found');
    } else {
      throw Exception(
        'Failed to fetch pregnancies: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
