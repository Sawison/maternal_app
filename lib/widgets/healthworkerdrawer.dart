import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maternal_app/pages/health_worker_screen/enrollment_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';

class HealthWorkerDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const HealthWorkerDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  Future<void> _showBroadcastMessage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final message =
        prefs.getString('broadcast_message') ??
        'No broadcast message available.';
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Broadcast Message',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Close', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    int index, {
    VoidCallback? customOnTap,
    int? badgeCount,
  }) {
    Widget leadingWidget = Icon(icon, color: const Color(0xFF3B82F6), size: 26);
    if (badgeCount != null && badgeCount > 0) {
      leadingWidget = Stack(
        children: [
          leadingWidget,
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    return ListTile(
          leading: leadingWidget,
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1F2937),
            ),
          ),
          onTap:
              customOnTap ??
              () {
                onItemTapped(index);
                Navigator.pop(context);
              },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: selectedIndex == index
              ? const Color(0xFF3B82F6).withOpacity(0.1)
              : null,
          splashColor: const Color(0xFF3B82F6).withOpacity(0.2),
        )
        .animate()
        .fadeIn(duration: (400 + index * 50).ms)
        .slideX(begin: -0.2, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(24),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    'MatCare SL',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                ),
                _buildDrawerItem(
                  context,
                  Icons.home,
                  'Home',
                  0,
                  customOnTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthWorkScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.person_add,
                  'Enrollment',
                  1,
                  customOnTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnrollmentFormScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.child_care,
                  'Infant',
                  2,
                  customOnTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfantEnrollmentForm(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.baby_changing_station,
                  'Neonatal',
                  3,
                ),
                _buildDrawerItem(context, Icons.pregnant_woman, 'Antenatal', 4),
                _buildDrawerItem(
                  context,
                  Icons.person,
                  'Profile',
                  -1,
                  customOnTap: () {
                    Navigator.pop(context);
                    // Navigate to profile
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ProfileScreen()),
                    // );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  'Logout',
                  -1,
                  customOnTap: () {
                    Navigator.pop(context);
                    // Handle logout
                    // e.g., Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LoginScreen()),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
