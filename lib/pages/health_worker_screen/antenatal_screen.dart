import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';

class AntenatalVisitForm extends StatefulWidget {
  const AntenatalVisitForm({super.key});

  @override
  _AntenatalVisitFormState createState() => _AntenatalVisitFormState();
}

class _AntenatalVisitFormState extends State<AntenatalVisitForm> {
  final _formKey = GlobalKey<FormState>();
  final _pregnancyIdController = TextEditingController();
  DateTime? _selectedVisitDate;
  final _bpController = TextEditingController();
  final _hbLevelController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthNotesController = TextEditingController();
  DateTime? _selectedNextVisitDate;
  final _visitNumberController = TextEditingController();

  int _selectedIndex = 4; // Assuming Antenatal is index 4 based on bottom nav

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
      // Already on Antenatal
    }
  }

  @override
  void dispose() {
    _pregnancyIdController.dispose();
    _bpController.dispose();
    _hbLevelController.dispose();
    _weightController.dispose();
    _healthNotesController.dispose();
    _visitNumberController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Antenatal Visit recorded successfully!')),
      );
      // Reset form or navigate away
    }
  }

  Future<void> _pickVisitDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedVisitDate) {
      setState(() {
        _selectedVisitDate = picked;
      });
    }
  }

  Future<void> _pickNextVisitDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedNextVisitDate) {
      setState(() {
        _selectedNextVisitDate = picked;
      });
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
              // PregnancyId
              TextFormField(
                controller: _pregnancyIdController,
                decoration: const InputDecoration(labelText: 'Pregnancy ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pregnancy ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // VisitDate
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedVisitDate == null
                          ? 'Select Visit Date'
                          : 'Visit Date: ${_selectedVisitDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickVisitDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Bp
              TextFormField(
                controller: _bpController,
                decoration: const InputDecoration(
                  labelText: 'Blood Pressure (e.g., 120/80)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter blood pressure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // HbLevel
              TextFormField(
                controller: _hbLevelController,
                decoration: const InputDecoration(
                  labelText: 'Hemoglobin Level',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hemoglobin level';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // HealthNotes
              TextFormField(
                controller: _healthNotesController,
                decoration: const InputDecoration(labelText: 'Health Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // NextVisitDate
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedNextVisitDate == null
                          ? 'Select Next Visit Date'
                          : 'Next Visit Date: ${_selectedNextVisitDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickNextVisitDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // VisitNumber
              TextFormField(
                controller: _visitNumberController,
                decoration: const InputDecoration(labelText: 'Visit Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter visit number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Record Visit'),
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
