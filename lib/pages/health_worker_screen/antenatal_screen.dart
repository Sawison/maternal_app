import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';
import 'package:maternal_app/models/pregnancy.dart';
import 'package:maternal_app/services/pregnacy_service.dart';
import 'package:intl/intl.dart';
import 'package:maternal_app/models/antenatal.dart';
import 'package:maternal_app/services/antenatal_service.dart';

class AntenatalVisitForm extends StatefulWidget {
  const AntenatalVisitForm({super.key});
  @override
  _AntenatalVisitFormState createState() => _AntenatalVisitFormState();
}

class _AntenatalVisitFormState extends State<AntenatalVisitForm> {
  String? _currentPatientId;
  List<Pregnancy> _pregnancies = [];
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

  void _showAntenatalForm({String? pregnancyId}) {
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
            child: AntenatalForm(
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
            'Antenatal Visit',
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
                            onTap: () => _showAntenatalForm(
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

class AntenatalForm extends StatefulWidget {
  final String? pregnancyId;
  final VoidCallback onSubmit;
  const AntenatalForm({super.key, this.pregnancyId, required this.onSubmit});
  @override
  _AntenatalFormState createState() => _AntenatalFormState();
}

class _AntenatalFormState extends State<AntenatalForm> {
  final _formKey = GlobalKey<FormState>();
  final _bpController = TextEditingController();
  final _hbLevelController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthNotesController = TextEditingController();
  final _visitNumberController = TextEditingController();
  DateTime? _selectedVisitDate;
  DateTime? _selectedNextVisitDate;

  @override
  void dispose() {
    _bpController.dispose();
    _hbLevelController.dispose();
    _weightController.dispose();
    _healthNotesController.dispose();
    _visitNumberController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _bpController.clear();
    _hbLevelController.clear();
    _weightController.clear();
    _healthNotesController.clear();
    _visitNumberController.clear();
    setState(() {
      _selectedVisitDate = null;
      _selectedNextVisitDate = null;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedVisitDate != null) {
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
                      'Recording Visit...',
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
        // Create AntenatalVisit object
        AntenatalVisit antenatal = AntenatalVisit(
          pregnancyId: widget.pregnancyId ?? '',
          visitDate: DateFormat('yyyy-MM-dd').format(_selectedVisitDate!),
          bp: _bpController.text,
          hbLevel: double.parse(_hbLevelController.text),
          weight: double.parse(_weightController.text),
          healthNotes: _healthNotesController.text,
          nextVisitDate: _selectedNextVisitDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedNextVisitDate!)
              : '',
          visitNumber: int.parse(_visitNumberController.text),
        );
        // Call service to create antenatal visit
        await AntenatalService().createAntenatalVisit(antenatal);
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
                        'Visit Recorded!',
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
        ).showSnackBar(SnackBar(content: Text('Error recording visit: $e')));
      }
    } else if (_selectedVisitDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a visit date')),
      );
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            decoration: const InputDecoration(labelText: 'Hemoglobin Level'),
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
    );
  }
}
