import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PregnancyFormScreen extends StatefulWidget {
  const PregnancyFormScreen({super.key});

  @override
  State<PregnancyFormScreen> createState() => _PregnancyFormScreenState();
}

class _PregnancyFormScreenState extends State<PregnancyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _lmpDate;
  DateTime? _dueDate;
  int _gestationWeeks = 0;

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
                onPressed: () {
                  if (_formKey.currentState!.validate() && _lmpDate != null) {
                    // Submit pregnancy details logic (e.g., API call)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pregnancy Details Submitted!'),
                      ),
                    );
                  }
                },
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
    );
  }
}
