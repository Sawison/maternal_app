import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';
import 'package:maternal_app/models/pregnancy.dart';
import 'package:maternal_app/services/pregnacy_service.dart';
import 'package:intl/intl.dart';
import 'package:maternal_app/models/infant.dart';
import 'package:maternal_app/services/infant_service.dart';

class InfantEnrollmentForm extends StatefulWidget {
  const InfantEnrollmentForm({super.key});
  @override
  _InfantEnrollmentFormState createState() => _InfantEnrollmentFormState();
}

class _InfantEnrollmentFormState extends State<InfantEnrollmentForm> {
  String? _currentPatientId;
  List<Pregnancy> _pregnancies = [];
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

  Future<void> _fetchPregnancies(String patientId) async {
    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      // Assume PregnancyService has getPregnanciesByPatient method
      final pregnancies = await PregnancyService().getPregnanciesByPatient(
        patientId,
      );
      setState(() {
        _currentPatientId = patientId;
        _pregnancies = pregnancies;
      });
      Navigator.of(context).pop(); // Close loader
    } catch (e) {
      Navigator.of(context).pop(); // Close loader
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching pregnancies: $e')));
    }
  }

  void _showPatientIdDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Enter Patient ID',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Patient ID',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final id = controller.text.trim();
                if (id.isNotEmpty) {
                  Navigator.pop(context);
                  _fetchPregnancies(id);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showInfantForm({String? pregnancyId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InfantForm(
              pregnancyId: pregnancyId,
              onSubmit: () {
                Navigator.pop(context);
                // Optionally refresh or show success
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Infant Enrollment',
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
          centerTitle: true,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentPatientId != null)
              Text(
                'Pregnancies for Patient: $_currentPatientId',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _pregnancies.isEmpty
                  ? Center(
                      child: Text(
                        _currentPatientId == null
                            ? 'Search for a patient to view pregnancies'
                            : 'No pregnancies found for this patient',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _pregnancies.length,
                      itemBuilder: (context, index) {
                        final preg = _pregnancies[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'LMP Date: ${preg.lastmenstructionperiod ?? 'N/A'}',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            subtitle: Text(
                              'Due Date: ${preg.dueDate ?? 'N/A'}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            onTap: () => _showInfantForm(
                              pregnancyId: preg.pregnancyId.toString(),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPatientIdDialog,
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.search, color: Colors.white),
      ),
      bottomNavigationBar: buildHealthWorkerBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
      ),
    );
  }
}

class InfantForm extends StatefulWidget {
  final String? pregnancyId;
  final VoidCallback onSubmit;
  const InfantForm({super.key, this.pregnancyId, required this.onSubmit});
  @override
  _InfantFormState createState() => _InfantFormState();
}

class _InfantFormState extends State<InfantForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedGender;
  final _weightController = TextEditingController();
  String? _selectedDeliveryMethod;
  bool _isAlive = true;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _weightController.clear();
    _notesController.clear();
    setState(() {
      _selectedDate = null;
      _selectedGender = null;
      _selectedDeliveryMethod = null;
      _isAlive = true;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show loader card
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Enrolling Infant...',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      try {
        // Create Infant object
        Infant infant = Infant(
          pregnancyId: widget.pregnancyId ?? '',
          birthDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
          infantGender: _selectedGender!,
          weight: double.parse(_weightController.text),
          deliveryMethod: _selectedDeliveryMethod!,
          alive: _isAlive,
          notes: _notesController.text,
        );
        // Call service to create infant
        await InfantService().createInfant(infant);
        Navigator.of(context).pop(); // Close loader
        // Show success dialog (card)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Infant Enrolled!',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        // Automatically close dialog after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context).pop(); // Close success dialog
        _resetForm();
        widget.onSubmit();
      } catch (e) {
        Navigator.of(context).pop(); // Close loader
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error enrolling infant: $e')));
      }
    }
  }

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
              DropdownMenuItem(value: 'C-Section', child: Text('C-Section')),
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
          ElevatedButton(onPressed: _submitForm, child: const Text('Enroll')),
        ],
      ),
    );
  }
}
