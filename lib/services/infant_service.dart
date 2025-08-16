import 'package:http/http.dart' as http;
import 'package:maternal_app/models/infant.dart';
import 'dart:convert';
import 'package:maternal_app/models/infantVisit.dart';

class InfantService {
  final String baseUrl = 'http://10.0.2.2:7092/api';

  Future<Infant> createInfant(Infant infant) async {
    final response = await http.post(
      Uri.parse('$baseUrl/infant'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(infant.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Infant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to create infant: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<Infant>> getInfantsByPregnancy(String pregnancyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/infant/by-pregnancy/$pregnancyId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Infant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load infants');
    }
  }

  Future<void> createInfantVisit(InfantVisit infantVisit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/infantvisit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(infantVisit.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Failed to create infant visit: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
