import 'package:flutter/material.dart';
import 'package:maternal_app/models/pregnancy.dart';
import 'package:maternal_app/services/pregnacy_service.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';

class PregnancyFormScreen extends StatefulWidget {
  final String patientId; // Patient ID received here (used as foreign key)
  const PregnancyFormScreen({super.key, required this.patientId});

  @override
  State<PregnancyFormScreen> createState() => _PregnancyFormScreenState();
}

class _PregnancyFormScreenState extends State<PregnancyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _lmpDate;
  DateTime? _dueDate;
  int _gestationWeeks = 0;

  int _selectedIndex = 1;

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
      // Already on Enrollment
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

  void _calculateDueDateAndGestation() {
    if (_lmpDate != null) {
      setState(() {
        // Calculate due date: LMP + 280 days
        _dueDate = _lmpDate!.add(const Duration(days: 280));
        // Calculate gestation weeks: (Current date - LMP) in weeks
        final now = DateTime.now();
        final difference = now.difference(_lmpDate!);
        _gestationWeeks = (difference.inDays / 7).floor();
      });
    }
  }

  Future<void> _submitPregnancyDetails() async {
    if (_formKey.currentState!.validate() && _lmpDate != null) {
      // Show loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      // Create Pregnancy object with patientId as foreign key
      Pregnancy newPregnancy = Pregnancy(
        patientId: widget.patientId,
        lastmenstructionperiod: DateFormat('yyyy-MM-dd').format(_lmpDate!),
        gestationWeeks: _gestationWeeks,
        dueDate: _dueDate != null
            ? DateFormat('yyyy-MM-dd').format(_dueDate!)
            : null,
        pregnancyStatus:
            'Active', // Assuming a default status; adjust as needed
      );
      try {
        await PregnancyService().createPregnancy(newPregnancy);
        if (!mounted) return;
        // Close loader
        Navigator.of(context).pop();
        // Show success dialog (centered card)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Pregnancy Submitted',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ],
              ),
            );
          },
        );
        // Automatically close dialog after 2 seconds and navigate to home screen
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context).pop(); // Close success dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HealthWorkScreen(),
          ), // Adjust to your home screen
        );
      } catch (e) {
        if (!mounted) return;
        // Close loader
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting pregnancy details: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select LMP date')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Pregnancy Details',
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _lmpDate = pickedDate;
                    });
                    _calculateDueDateAndGestation();
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Last Menstrual Period (LMP)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _lmpDate == null
                        ? 'Select Date'
                        : DateFormat('dd/MM/yyyy').format(_lmpDate!),
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Gestation Weeks',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.timelapse),
                ),
                controller: TextEditingController(
                  text: _gestationWeeks.toString(),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.calendar_month),
                ),
                controller: TextEditingController(
                  text: _dueDate != null
                      ? DateFormat('dd/MM/yyyy').format(_dueDate!)
                      : 'Not calculated',
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitPregnancyDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Submit Pregnancy Details',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ).animate().fadeIn(duration: 900.ms).scale(),
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
