import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maternal_app/pages/health_worker_screen/pregnancy_screen.dart';
import 'package:maternal_app/widgets/healthworkerBottom.dart';
import 'package:maternal_app/widgets/healthworkerdrawer.dart';
import 'package:maternal_app/pages/health_worker_screen/infantEnrollment.dart';
import 'package:maternal_app/pages/health_worker_screen/infantVisit_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/antenatal_screen.dart';
import 'package:maternal_app/pages/health_worker_screen/dashboard_screen.dart';
import 'package:maternal_app/models/patient.dart';
import 'package:maternal_app/services/patient_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class EnrollmentFormScreen extends StatefulWidget {
  const EnrollmentFormScreen({Key? key}) : super(key: key);

  @override
  State createState() => _EnrollmentFormScreenState();
}

class _EnrollmentFormScreenState extends State with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _districtController = TextEditingController();
  final _regionController = TextEditingController();
  final _nationalIDController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  DateTime? _selectedDate;
  int _selectedIndex = 1; // Assuming Enrollment is index 1 based on bottom nav

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

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _regionController.dispose();
    _nationalIDController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showPreviewDialog() {
    final outerContext = context; // Capture the outer context
    showDialog(
      context: outerContext,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview Enrollment Data',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPreviewItem(
                            'National ID',
                            _nationalIDController.text,
                          ),
                          _buildPreviewItem(
                            'First Name',
                            _fNameController.text,
                          ),
                          _buildPreviewItem('Last Name', _lNameController.text),
                          _buildPreviewItem(
                            'Date of Birth',
                            _selectedDate != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_selectedDate!)
                                : 'Not selected',
                          ),
                          _buildPreviewItem(
                            'Phone Number',
                            _phoneNumberController.text,
                          ),
                          _buildPreviewItem('Address', _addressController.text),
                          _buildPreviewItem(
                            'District',
                            _districtController.text,
                          ),
                          _buildPreviewItem('Region', _regionController.text),
                          _buildPreviewItem(
                            'Latitude',
                            _latitudeController.text,
                          ),
                          _buildPreviewItem(
                            'Longitude',
                            _longitudeController.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'Back',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3B82F6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          // Show loader
                          showDialog(
                            context: outerContext,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          // Create Patient object from form data
                          Patient newPatient = Patient(
                            patientId: '', // Backend will generate
                            nationalID: _nationalIDController.text.isEmpty
                                ? null
                                : _nationalIDController.text,
                            fName: _fNameController.text.isEmpty
                                ? null
                                : _fNameController.text,
                            lName: _lNameController.text.isEmpty
                                ? null
                                : _lNameController.text,
                            dateOfBirth: _selectedDate != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(_selectedDate!)
                                : null,
                            phoneNumber: _phoneNumberController.text.isEmpty
                                ? null
                                : _phoneNumberController.text,
                            address: _addressController.text.isEmpty
                                ? null
                                : _addressController.text,
                            district: _districtController.text.isEmpty
                                ? null
                                : _districtController.text,
                            region: _regionController.text.isEmpty
                                ? null
                                : _regionController.text,
                            latitude: _latitudeController.text.isEmpty
                                ? null
                                : _latitudeController.text,
                            longitude: _longitudeController.text.isEmpty
                                ? null
                                : _longitudeController.text,
                          );
                          try {
                            Patient createdPatient = await PatientService()
                                .createPatient(newPatient);
                            if (!mounted) return;
                            if (createdPatient.patientId == null ||
                                createdPatient.patientId!.isEmpty) {
                              throw Exception(
                                'Patient creation succeeded but returned empty patientId',
                              );
                            }
                            // Optional: Debug print to check the ID
                            if (kDebugMode) {
                              print(
                                'Created Patient ID: ${createdPatient.patientId}',
                              );
                            }
                            // Close loader
                            Navigator.of(outerContext).pop();
                            // Show success dialog (centered card)
                            showDialog(
                              context: outerContext,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 60,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Enrollment Submitted!',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            // Automatically close dialog after 2 seconds and navigate to PregnancyFormScreen
                            await Future.delayed(const Duration(seconds: 2));
                            if (!mounted) return;
                            Navigator.of(
                              outerContext,
                            ).pop(); // Close success dialog
                            Navigator.push(
                              outerContext,
                              MaterialPageRoute(
                                builder: (context) => PregnancyFormScreen(
                                  patientId: createdPatient.patientId!,
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            // Close loader
                            Navigator.of(outerContext).pop();
                            ScaffoldMessenger.of(outerContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error submitting enrollment: $e',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _fNameController.clear();
    _lNameController.clear();
    _phoneNumberController.clear();
    _addressController.clear();
    _districtController.clear();
    _regionController.clear();
    _nationalIDController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  void _showSearchDialog() {
    final outerContext = context;
    final TextEditingController _searchNationalIDController =
        TextEditingController();
    final TextEditingController _searchPatientIDController =
        TextEditingController();
    showDialog(
      context: outerContext,
      builder: (BuildContext dialogContext) {
        return DefaultTabController(
          length: 2,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const TabBar(
              tabs: [
                Tab(text: 'National ID'),
                Tab(text: 'Patient ID'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 200,
              child: TabBarView(
                children: [
                  // National ID Tab
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _searchNationalIDController,
                        decoration: InputDecoration(
                          labelText: 'Enter National ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          String nationalID = _searchNationalIDController.text;
                          if (nationalID.isNotEmpty) {
                            try {
                              Patient patient = await PatientService()
                                  .getByNationalID(nationalID);
                              if (patient.patientId == null ||
                                  patient.patientId!.isEmpty) {
                                throw Exception(
                                  'Patient fetch succeeded but returned empty patientId',
                                );
                              }
                              if (kDebugMode) {
                                print(
                                  'Fetched Patient ID by National ID: ${patient.patientId}',
                                );
                              }
                              Navigator.pop(
                                outerContext,
                              ); // Close search dialog
                              // Show success dialog
                              showDialog(
                                context: outerContext,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 60,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Patient Found!',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              if (!mounted) return;
                              Navigator.of(
                                outerContext,
                              ).pop(); // Close success dialog
                              _showPatientDetailsDialog(patient);
                            } catch (e) {
                              ScaffoldMessenger.of(outerContext).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Search',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  // Patient ID Tab
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _searchPatientIDController,
                        decoration: InputDecoration(
                          labelText: 'Enter Patient ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          String patientId = _searchPatientIDController.text;
                          if (patientId.isNotEmpty) {
                            try {
                              Patient patient = await PatientService()
                                  .getByPatientId(patientId);
                              if (patient.patientId == null ||
                                  patient.patientId!.isEmpty) {
                                throw Exception(
                                  'Patient fetch succeeded but returned empty patientId',
                                );
                              }
                              if (kDebugMode) {
                                print(
                                  'Fetched Patient ID by Patient ID: ${patient.patientId}',
                                );
                              }
                              Navigator.pop(
                                outerContext,
                              ); // Close search dialog
                              // Show success dialog
                              showDialog(
                                context: outerContext,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 60,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Patient Found!',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              if (!mounted) return;
                              Navigator.of(
                                outerContext,
                              ).pop(); // Close success dialog
                              _showPatientDetailsDialog(patient);
                            } catch (e) {
                              ScaffoldMessenger.of(outerContext).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Search',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPatientDetailsDialog(Patient patient) {
    final outerContext = context;
    Completer<GoogleMapController> _mapController =
        Completer<GoogleMapController>();
    double? lat = double.tryParse(patient.latitude ?? '0.0') ?? 0.0;
    double? lng = double.tryParse(patient.longitude ?? '0.0') ?? 0.0;
    showDialog(
      context: outerContext,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Details',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPreviewItem(
                            'Patient ID',
                            patient.patientId ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'National ID',
                            patient.nationalID ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'First Name',
                            patient.fName ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'Last Name',
                            patient.lName ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'Date of Birth',
                            patient.dateOfBirth ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'Phone Number',
                            patient.phoneNumber ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'Address',
                            patient.address ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'District',
                            patient.district ?? 'N/A',
                          ),
                          _buildPreviewItem('Region', patient.region ?? 'N/A'),
                          _buildPreviewItem(
                            'Latitude',
                            patient.latitude ?? 'N/A',
                          ),
                          _buildPreviewItem(
                            'Longitude',
                            patient.longitude ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'Close',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3B82F6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (patient.latitude != null && patient.longitude != null)
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: outerContext,
                              builder: (BuildContext mapContext) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SizedBox(
                                    height: 300,
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(lat, lng),
                                        zoom: 14.0,
                                      ),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                            _mapController.complete(controller);
                                          },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Map',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (patient.patientId == null ||
                              patient.patientId!.isEmpty) {
                            ScaffoldMessenger.of(outerContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Patient ID is empty. Cannot proceed.',
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.of(dialogContext).pop();
                          Navigator.push(
                            outerContext,
                            MaterialPageRoute(
                              builder: (context) => PregnancyFormScreen(
                                patientId: patient.patientId!,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Start',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nationalIDController,
                decoration: InputDecoration(
                  labelText: 'National ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter national ID';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 750.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && mounted) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 550.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter district';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 650.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _regionController,
                decoration: InputDecoration(
                  labelText: 'Region',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter region';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Get Current Location',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ).animate().fadeIn(duration: 750.ms).scale(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.my_location),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.my_location),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 850.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showSearchDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Search',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _selectedDate != null) {
                          _showPreviewDialog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Enroll',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
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
