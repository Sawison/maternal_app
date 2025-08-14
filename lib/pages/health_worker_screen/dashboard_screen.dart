import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/alert_screen.dart';

class HealthWorkScreen extends StatefulWidget {
  const HealthWorkScreen({super.key});

  @override
  State<HealthWorkScreen> createState() => _HealthWorkScreenState();
}

class _HealthWorkScreenState extends State<HealthWorkScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation logic based on selected index
    if (index == 0) {
      // Navigate to Home (MorbidityScreen)
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
    } else if (index == 5) {
      // Alert navigation (if needed for drawer)
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AlertScreen()),
      // );
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
      body: _buildDashboardTab(),
      bottomNavigationBar: buildHealthWorkerBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Collection & Reporting',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Enrollment',
            description:
                'Enroll new patients into the maternal and infant monitoring system.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EnrollmentFormScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Infant',
            description:
                'Collect and report data on infant health and morbidity.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfantEnrollmentForm()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Neonatal',
            description:
                'Report neonatal care data, including birth defects and infections.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfantVitalsForm()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Antenatal',
            description:
                'Track antenatal care visits, gestational diabetes, and high blood pressure.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AntenatalVisitForm()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Alert',
            description:
                'Manage emergency alerts for postpartum hemorrhage and other critical conditions.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlertForm()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.15),
                    const Color(0xFF60A5FA).withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.health_and_safety,
                color: Color(0xFF3B82F6),
                size: 30,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            subtitle: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}
