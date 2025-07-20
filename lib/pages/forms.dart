import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationFormScreen extends StatefulWidget {
  @override
  _RegistrationFormScreenState createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIDController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _languagePrefController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _districtController = TextEditingController();
  final _regionController = TextEditingController();

  @override
  void dispose() {
    _nationalIDController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _languagePrefController.dispose();
    _bloodTypeController.dispose();
    _districtController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFFCE93D8), // Soft purple
              brightness: Brightness.light,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFCE93D8)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFCE93D8), // Soft purple
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontSizeFactor: 1.1, fontFamily: 'Roboto'),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Registration',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nationalIDController,
                            decoration: InputDecoration(
                              labelText: 'National ID',
                              prefixIcon: Icon(Icons.person),
                              helperText: 'Enter national ID number',
                              errorMaxLines: 2,
                              suffixIcon: _nationalIDController.text.isEmpty
                                  ? Icon(Icons.error, color: Colors.red)
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter national ID';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(
                                () {},
                              ); // Update UI to show/hide error icon
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _dateOfBirthController,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth (YYYY-MM-DD)',
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Tap to select date',
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select date of birth';
                              }
                              if (!RegExp(
                                r'^\d{4}-\d{2}-\d{2}$',
                              ).hasMatch(value)) {
                                return 'Enter date in YYYY-MM-DD format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              helperText: 'Enter 10-digit number',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.home),
                              helperText: 'Enter full address',
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _languagePrefController,
                            decoration: InputDecoration(
                              labelText: 'Language Preference',
                              prefixIcon: Icon(Icons.language),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter language preference';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _bloodTypeController,
                            decoration: InputDecoration(
                              labelText: 'Blood Type (e.g., A+, O-)',
                              prefixIcon: Icon(Icons.bloodtype),
                              helperText: 'Enter valid blood type',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter blood type';
                              }
                              if (!RegExp(
                                r'^(A|B|AB|O)[+-]$',
                              ).hasMatch(value)) {
                                return 'Enter a valid blood type (e.g., A+, O-)';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _districtController,
                            decoration: InputDecoration(
                              labelText: 'District',
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter district';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _regionController,
                            decoration: InputDecoration(
                              labelText: 'Region',
                              prefixIcon: Icon(Icons.map),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter region';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewPregnancyFormScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 8),
                          Text(
                            'Submit',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewPregnancyFormScreen extends StatefulWidget {
  @override
  _NewPregnancyFormScreenState createState() => _NewPregnancyFormScreenState();
}

class _NewPregnancyFormScreenState extends State<NewPregnancyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lmpController = TextEditingController();
  final _eddController = TextEditingController();
  final _parityController = TextEditingController();
  String? _riskLevel;

  @override
  void dispose() {
    _lmpController.dispose();
    _eddController.dispose();
    _parityController.dispose();
    super.dispose();
  }

  Future<void> _selectLMP(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFFCE93D8), // Soft purple
              brightness: Brightness.light,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFCE93D8)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _lmpController.text = DateFormat('yyyy-MM-dd').format(picked);
        // Calculate EDD: LMP + 280 days
        final edd = picked.add(Duration(days: 280));
        _eddController.text = DateFormat('yyyy-MM-dd').format(edd);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFCE93D8), // Soft purple
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontSizeFactor: 1.1, fontFamily: 'Roboto'),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'New Pregnancy',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _lmpController,
                            decoration: InputDecoration(
                              labelText: 'Last Menstrual Period (YYYY-MM-DD)',
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Tap to select date',
                            ),
                            readOnly: true,
                            onTap: () => _selectLMP(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select last menstrual period';
                              }
                              if (!RegExp(
                                r'^\d{4}-\d{2}-\d{2}$',
                              ).hasMatch(value)) {
                                return 'Enter date in YYYY-MM-DD format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _eddController,
                            decoration: InputDecoration(
                              labelText: 'Estimated Due Date (YYYY-MM-DD)',
                              prefixIcon: Icon(Icons.date_range),
                              helperText: 'Auto-calculated from LMP',
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please ensure LMP is selected to calculate EDD';
                              }
                              if (!RegExp(
                                r'^\d{4}-\d{2}-\d{2}$',
                              ).hasMatch(value)) {
                                return 'Enter date in YYYY-MM-DD format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _parityController,
                            decoration: InputDecoration(
                              labelText: 'Parity (Number of Previous Births)',
                              prefixIcon: Icon(Icons.child_care),
                              helperText: 'Enter number of previous births',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter parity';
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) < 0) {
                                return 'Enter a valid non-negative number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _riskLevel,
                            decoration: InputDecoration(
                              labelText: 'Risk Level',
                              prefixIcon: Icon(Icons.warning),
                              helperText: 'Select risk level',
                            ),
                            items: ['Low', 'Medium', 'High'].map((
                              String level,
                            ) {
                              return DropdownMenuItem<String>(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _riskLevel = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select risk level';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AntenatalFormScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 8),
                          Text(
                            'Submit',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AntenatalFormScreen extends StatefulWidget {
  @override
  _AntenatalFormScreenState createState() => _AntenatalFormScreenState();
}

class _AntenatalFormScreenState extends State<AntenatalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visitDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodPressureController = TextEditingController();

  @override
  void dispose() {
    _visitDateController.dispose();
    _weightController.dispose();
    _bloodPressureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFCE93D8), // Soft purple
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontSizeFactor: 1.1, fontFamily: 'Roboto'),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Antenatal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _visitDateController,
                            decoration: InputDecoration(
                              labelText: 'Visit Date (YYYY-MM-DD)',
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Enter date in YYYY-MM-DD format',
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter visit date';
                              }
                              if (!RegExp(
                                r'^\d{4}-\d{2}-\d{2}$',
                              ).hasMatch(value)) {
                                return 'Enter date in YYYY-MM-DD format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _weightController,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              prefixIcon: Icon(Icons.fitness_center),
                              helperText: 'Enter weight in kilograms',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter weight';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Enter a valid weight';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _bloodPressureController,
                            decoration: InputDecoration(
                              labelText: 'Blood Pressure (e.g., 120/80)',
                              prefixIcon: Icon(Icons.favorite),
                              helperText:
                                  'Enter in format systolic/diastolic (e.g., 120/80)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter blood pressure';
                              }
                              if (!RegExp(
                                r'^\d{2,3}/\d{2,3}$',
                              ).hasMatch(value)) {
                                return 'Enter in format systolic/diastolic (e.g., 120/80)';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Antenatal data submitted'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 8),
                          Text(
                            'Submit',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
