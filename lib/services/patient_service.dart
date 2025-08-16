import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maternal_app/models/patient.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

class PatientService {
  final String baseUrl = 'http://10.0.2.2:7092/api';

  Future<Patient> createPatient(Patient patient) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Patient/AddPatient'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patient.toJson()),
    );

    if (kDebugMode) {
      print('Create Patient Response Status: ${response.statusCode}');
      print('Create Patient Response Body: ${response.body}');
      print('Create Patient Location Header: ${response.headers['location']}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final createdPatient = Patient.fromJson(jsonData);

        if (createdPatient.patientId.isEmpty) {
          final location = response.headers['location'];
          if (location != null && location.isNotEmpty) {
            final id = location.split('/').last;
            if (id.isNotEmpty) {
              createdPatient.patientId = id;
              if (kDebugMode) {
                print('Extracted Patient ID from Location header: $id');
              }
            }
          }
        }

        if (createdPatient.patientId.isEmpty &&
            patient.nationalID != null &&
            patient.nationalID!.isNotEmpty) {
          if (kDebugMode) {
            print('Fallback to getByNationalID for patientId');
          }
          return await getByNationalID(patient.nationalID!);
        }

        if (createdPatient.patientId.isEmpty) {
          throw Exception('Patient created but patientId is empty.');
        }

        return createdPatient;
      } catch (e) {
        throw Exception('Failed to parse created patient: $e');
      }
    } else {
      throw Exception(
        'Failed to create patient: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Patient> getByNationalID(String nationalID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Patient/GetByNationalID/$nationalID'),
    );

    if (kDebugMode) {
      print('GetByNationalID Response Status: ${response.statusCode}');
      print('GetByNationalID Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final patient = Patient.fromJson(jsonData);
      if (patient.patientId.isEmpty) {
        throw Exception('Patient found but patientId is empty.');
      }
      return patient;
    } else {
      throw Exception(
        'Failed to get patient by nationalID: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Patient> getByPatientId(String patientId) async {
    final response = await http.get(Uri.parse('$baseUrl/Patient/$patientId'));

    if (kDebugMode) {
      print('GetByPatientId Response Status: ${response.statusCode}');
      print('GetByPatientId Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final patient = Patient.fromJson(jsonData);
      if (patient.patientId.isEmpty) {
        throw Exception('Patient found but patientId is empty.');
      }
      return patient;
    } else {
      throw Exception(
        'Failed to get patient by patientId: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
