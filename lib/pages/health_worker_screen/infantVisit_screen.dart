import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';
import 'package:maternal_app/models/pregnancy.dart';
import 'package:maternal_app/services/pregnacy_service.dart';
import 'package:maternal_app/models/infant.dart';
import 'package:maternal_app/services/infant_service.dart';
import 'package:intl/intl.dart';
import 'package:maternal_app/models/infantVisit.dart';

class InfantVitalsForm extends StatefulWidget {
  const InfantVitalsForm({super.key});

  @override
  _InfantVitalsFormState createState() => _InfantVitalsFormState();
}

class _InfantVitalsFormState extends State<InfantVitalsForm> {
  String? _currentPatientId;
  List<Pregnancy> _pregnancies = [];
  String? _selectedPregnancyId;
  List<Infant> _infants = [];
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
        _selectedPregnancyId = null;
        _infants = [];
      });
      Navigator.of(context).pop(); // Close loader
    } catch (e) {
      Navigator.of(context).pop(); // Close loader
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching pregnancies: $e')));
    }
  }

  Future<void> _fetchInfants(String pregnancyId) async {
    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      // Assume InfantService has getInfantsByPregnancy method
      final infants = await InfantService().getInfantsByPregnancy(pregnancyId);
      setState(() {
        _selectedPregnancyId = pregnancyId;
        _infants = infants;
      });
      Navigator.of(context).pop(); // Close loader
    } catch (e) {
      Navigator.of(context).pop(); // Close loader
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching infants: $e')));
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

  void showVitalsForm({required String birthId}) {
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
            child: InfantVitalsEntryForm(
              birthId: birthId,
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
            'Infant Vitals',
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
            if (_currentPatientId != null && _selectedPregnancyId == null)
              Text(
                'Pregnancies for Patient: $_currentPatientId',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_selectedPregnancyId != null)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedPregnancyId = null;
                        _infants = [];
                      });
                    },
                  ),
                  Text(
                    'Infants for Pregnancy',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _currentPatientId == null
                  ? Center(
                      child: Text(
                        'Search for a patient to view pregnancies',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    )
                  : _selectedPregnancyId == null
                  ? _pregnancies.isEmpty
                        ? Center(
                            child: Text(
                              'No pregnancies found for this patient',
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
                                  onTap: () => _fetchInfants(
                                    preg.pregnancyId.toString(),
                                  ),
                                ),
                              );
                            },
                          )
                  : _infants.isEmpty
                  ? Center(
                      child: Text(
                        'No infants found for this pregnancy',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _infants.length,
                      itemBuilder: (context, index) {
                        final infant = _infants[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'Birth Date: ${infant.birthDate ?? 'N/A'}',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            subtitle: Text(
                              'Gender: ${infant.infantGender ?? 'N/A'}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            onTap: () => showVitalsForm(
                              birthId: infant.birthId.toString(),
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

class InfantVitalsEntryForm extends StatefulWidget {
  final String birthId;
  final VoidCallback onSubmit;

  const InfantVitalsEntryForm({
    super.key,
    required this.birthId,
    required this.onSubmit,
  });

  @override
  _InfantVitalsEntryFormState createState() => _InfantVitalsEntryFormState();
}

class _InfantVitalsEntryFormState extends State<InfantVitalsEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _illnessController = TextEditingController();
  final _vaccinationInfoController = TextEditingController();
  final _visitNumberController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _weightController.dispose();
    _illnessController.dispose();
    _vaccinationInfoController.dispose();
    _visitNumberController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _weightController.clear();
    _illnessController.clear();
    _vaccinationInfoController.clear();
    _visitNumberController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
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
                      'Recording Vitals...',
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
        // Create InfantVisit object
        InfantVisit infantVisit = InfantVisit(
          birthId: widget.birthId,
          checkupDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
          weight: double.parse(_weightController.text),
          illness: _illnessController.text,
          vaccinationInfo: _vaccinationInfoController.text,
          visitNumber: int.parse(_visitNumberController.text),
        );
        // Call service to create infant visit
        await InfantService().createInfantVisit(infantVisit);
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
                        'Vitals Recorded!',
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
        ).showSnackBar(SnackBar(content: Text('Error recording vitals: $e')));
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a checkup date')),
      );
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
          // BirthId display (read-only)
          Text(
            'Birth ID: ${widget.birthId}',
            style: GoogleFonts.poppins(fontSize: 16),
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
            decoration: const InputDecoration(labelText: 'Vaccination Info'),
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
    );
  }
}
