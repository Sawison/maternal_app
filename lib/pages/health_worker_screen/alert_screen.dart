import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart'; // Add uuid package to pubspec.yaml for Guid generation
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';

class AlertForm extends StatefulWidget {
  const AlertForm({super.key});

  @override
  _AlertFormState createState() => _AlertFormState();
}

class _AlertFormState extends State<AlertForm> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _alertTypeController = TextEditingController();
  final _messageController = TextEditingController();
  final _statusController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _userInitialsController = TextEditingController();

  int _selectedIndex = 0; // Assuming Alert is accessed from dashboard (Home)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HealthWorkScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EnrollmentFormScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfantEnrollmentForm()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfantVitalsForm()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AntenatalVisitForm()),
      );
    }
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _alertTypeController.dispose();
    _messageController.dispose();
    _statusController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _userInitialsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle submission, e.g., save to database or API using the variables
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alert recorded successfully!')),
      );
      // Reset form or navigate away
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'MatCare SL',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Navigate to notifications or reminders screen
              },
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      drawer: HealthWorkerDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // PatientId
              TextFormField(
                controller: _patientIdController,
                decoration: const InputDecoration(labelText: 'Patient ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Patient ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // AlertType
              TextFormField(
                controller: _alertTypeController,
                decoration: const InputDecoration(labelText: 'Alert Type'),
              ),
              const SizedBox(height: 16),
              // Message
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Status
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 16),
              // Latitude
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Longitude
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // UserInitials
              TextFormField(
                controller: _userInitialsController,
                decoration: const InputDecoration(labelText: 'User Initials'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Record Alert'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildHealthWorkerBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
      ),
    );
  }
}
