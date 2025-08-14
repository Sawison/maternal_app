import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';

class InfantEnrollmentForm extends StatefulWidget {
  const InfantEnrollmentForm({super.key});

  @override
  _InfantEnrollmentFormState createState() => _InfantEnrollmentFormState();
}

class _InfantEnrollmentFormState extends State<InfantEnrollmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _pregnancyIdController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final _weightController = TextEditingController();
  String? _selectedDeliveryMethod;
  bool _isAlive = true;
  final _notesController = TextEditingController();

  int _selectedIndex = 2; // Assuming Infant is index 2 based on bottom nav

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
      // Already on Infant
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
    _pregnancyIdController.dispose();
    _weightController.dispose();
    _notesController.dispose();
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
              // BirthDate
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select Birth Date'
                          : 'Birth Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // InfantGender
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Infant Gender'),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender';
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
              // DeliveryMethod
              DropdownButtonFormField<String>(
                value: _selectedDeliveryMethod,
                decoration: const InputDecoration(labelText: 'Delivery Method'),
                items: const [
                  DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  DropdownMenuItem(
                    value: 'C-Section',
                    child: Text('C-Section'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDeliveryMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select delivery method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Alive
              SwitchListTile(
                title: const Text('Alive'),
                value: _isAlive,
                onChanged: (bool value) {
                  setState(() {
                    _isAlive = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enroll'),
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
