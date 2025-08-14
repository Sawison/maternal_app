import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/userDrawer.dart';
import 'package:maternal_app/widgets/userBottomNavigation.dart';
import 'package:maternal_app/pages/screens/enrollment_screen.dart';

class MorbidityScreen extends StatefulWidget {
  const MorbidityScreen({super.key});

  @override
  State<MorbidityScreen> createState() => _MorbidityScreenState();
}

class _MorbidityScreenState extends State<MorbidityScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic based on selected index
    // Home (index 0) maintains the current MorbidityScreen, so no navigation
    if (index == 0) {
      // Do nothing or optionally pop to root if needed, but staying here as per requirement
      return;
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EnrollmentFormScreen()),
      );
    } else if (index == 2) {
      // Emergency screen navigation
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => EmergencyScreen()), // TODO: Define EmergencyScreen
      // );
    } else if (index == 3) {
      // Records (Health Records) screen navigation
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HealthRecordsScreen()), // TODO: Define HealthRecordsScreen
      // );
    } else if (index == 4) {
      // Reminders screen navigation (from drawer)
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => RemindersScreen()), // TODO: Define RemindersScreen
      // );
    } else if (index == -1) {
      // Handle special cases like Profile or Logout in drawer customOnTap
      // No global navigation here; handled in drawer
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
                // Navigate to reminders screen
              },
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      drawer: Userdrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: _buildInformationTab(),
      bottomNavigationBar: buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
      ),
    );
  }

  Widget _buildInformationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Maternal Morbidity',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'High Blood Pressure',
            description:
                'Includes conditions like preeclampsia, which can affect organs and lead to serious complications during pregnancy.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Postpartum Hemorrhage',
            description:
                'Excessive bleeding during or after childbirth, which can be life-threatening if not managed promptly.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Infections',
            description:
                'Such as sepsis or other infections that can occur during pregnancy, delivery, or postpartum period.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Cardiovascular Diseases',
            description:
                'Heart-related issues that may worsen during pregnancy, including cardiomyopathy.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Gestational Diabetes',
            description:
                'Diabetes that develops during pregnancy, increasing risks for both mother and baby.',
          ),
          const SizedBox(height: 32),
          Text(
            'Infant Morbidity',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Preterm Birth Complications',
            description:
                'Issues arising from babies born before 37 weeks, including respiratory distress and developmental delays.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Low Birth Weight',
            description:
                'Babies born weighing less than 5.5 pounds, often leading to health problems like infections and breathing issues.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Infections',
            description:
                'Including pneumonia, sepsis, and other neonatal infections that can be serious in newborns.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Birth Defects',
            description:
                'Congenital anomalies such as heart defects, neural tube defects, or cleft palate.',
          ),
          const SizedBox(height: 16),
          _buildMorbidityCard(
            title: 'Sudden Infant Death Syndrome (SIDS)',
            description:
                'Unexpected death of an apparently healthy infant, usually during sleep.',
          ),
        ],
      ),
    );
  }

  Widget _buildMorbidityCard({
    required String title,
    required String description,
  }) {
    return Card(
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
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}
