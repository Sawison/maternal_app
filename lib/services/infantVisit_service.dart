// lib/services/infant_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maternal_app/models/infant.dart';
import 'package:maternal_app/models/infantVisit.dart';

class InfantService {
  final String baseUrl = 'http://10.0.2.2:7092/api';

  Future<List<Infant>> getInfantsByPregnancy(String pregnancyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/infant/by-pregnancy/$pregnancyId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Infant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load infants');
    }
  }

  Future<void> createInfantVisit(InfantVisit infantVisit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/infantvisit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(infantVisit.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create infant visit: ${response.body}');
    }
  }
}
