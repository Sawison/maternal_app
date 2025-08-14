import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildBottomNavigationBar(
  BuildContext context,
  int selectedIndex,
  Function(int) onItemTapped,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: const Color(0xFF6B7280),
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 13,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ).animate().scale(duration: 300.ms, begin: const Offset(0.85, 0.85)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_add,
          ).animate().scale(duration: 300.ms, begin: const Offset(0.85, 0.85)),
          label: 'Enrollment',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.warning,
          ).animate().scale(duration: 300.ms, begin: const Offset(0.85, 0.85)),
          label: 'Emergency',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.description,
          ).animate().scale(duration: 300.ms, begin: const Offset(0.85, 0.85)),
          label: 'Records',
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
  );
}
