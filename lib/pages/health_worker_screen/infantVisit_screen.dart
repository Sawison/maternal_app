import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';

class InfantVitalsForm extends StatefulWidget {
  const InfantVitalsForm({super.key});

  @override
  _InfantVitalsFormState createState() => _InfantVitalsFormState();
}

class _InfantVitalsFormState extends State<InfantVitalsForm> {
  final _formKey = GlobalKey<FormState>();
  final _birthIdController = TextEditingController();
  DateTime? _selectedDate;
  final _weightController = TextEditingController();
  final _illnessController = TextEditingController();
  final _vaccinationInfoController = TextEditingController();
  final _visitNumberController = TextEditingController();

  int _selectedIndex = 3; // Assuming Neonatal is index 3 based on bottom nav

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
      // Already on Neonatal
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AntenatalVisitForm()),
      );
    }
  }

  @override
  void dispose() {
    _birthIdController.dispose();
    _weightController.dispose();
    _illnessController.dispose();
    _vaccinationInfoController.dispose();
    _visitNumberController.dispose();
    super.dispose();
  }

  void _submitForm() {}

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
              // BirthId
              TextFormField(
                controller: _birthIdController,
                decoration: const InputDecoration(labelText: 'Birth ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Birth ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // CheckupDate
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select Checkup Date'
                          : 'Checkup Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
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
              // Illness
              TextFormField(
                controller: _illnessController,
                decoration: const InputDecoration(labelText: 'Illness'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // VaccinationInfo
              TextFormField(
                controller: _vaccinationInfoController,
                decoration: const InputDecoration(
                  labelText: 'Vaccination Info',
                ),
                maxLines: 2,
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
                child: const Text('Record Vitals'),
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
