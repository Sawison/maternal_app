import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:maternal_app/pages/account/landingPage.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MatCare_Sl());
}

class MatCare_Sl extends StatelessWidget {
  const MatCare_Sl({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MatCare SL',
      theme: ThemeData(
        primaryColor: const Color(0xFF3B82F6),
        scaffoldBackgroundColor: const Color(0xFFF9FAFC),
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: const Color(0xFF60A5FA),
            ).copyWith(
              primary: const Color(0xFF3B82F6),
              secondary: const Color(0xFF60A5FA),
              background: const Color(0xFFF9FAFC),
            ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.2),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          labelStyle: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
          prefixIconColor: const Color(0xFF6B7280),
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
      ),
      home: const LandingScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
