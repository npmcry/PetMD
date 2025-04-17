import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VetInfoScreen extends StatefulWidget {
  const VetInfoScreen({Key? key}) : super(key: key);

  @override
  State<VetInfoScreen> createState() => _VetInfoScreenState();
}

class _VetInfoScreenState extends State<VetInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  // State variables to hold the vet information
  String? _vetName;
  String? _vetAddress;
  String? _vetPhoneNumber;
  String? _emergencyContactName;
  String? _emergencyContactPhoneNumber;

  @override
  void initState() {
    super.initState();
    _loadVetInfo();
  }

  // Load vet info from SharedPreferences
  Future<void> _loadVetInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vetName = prefs.getString('vetName') ?? '';
      _vetAddress = prefs.getString('vetAddress') ?? '';
      _vetPhoneNumber = prefs.getString('vetPhoneNumber') ?? '';
      _emergencyContactName = prefs.getString('emergencyContactName') ?? '';
      _emergencyContactPhoneNumber = prefs.getString('emergencyContactPhoneNumber') ?? '';
    });
  }

  // Save vet info to SharedPreferences
  Future<void> _saveVetInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('vetName', _vetName!);
      await prefs.setString('vetAddress', _vetAddress!);
      await prefs.setString('vetPhoneNumber', _vetPhoneNumber!);
      await prefs.setString('emergencyContactName', _emergencyContactName!);
      await prefs.setString('emergencyContactPhoneNumber', _emergencyContactPhoneNumber!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vet & Emergency Info Saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet & Emergency Info'),
        backgroundColor: Colors.lightBlue[100], // Pastel blue
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.lightBlue[50], // Pastel background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView( // Use ListView to prevent overflow
            children: <Widget>[
              TextFormField(
                initialValue: _vetName,
                decoration: InputDecoration(
                  labelText: 'Veterinarian Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vet\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _vetName = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _vetAddress,
                decoration: InputDecoration(
                  labelText: 'Veterinarian Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.home, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vet\'s address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _vetAddress = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _vetPhoneNumber,
                decoration: InputDecoration(
                  labelText: 'Veterinarian Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vet\'s phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _vetPhoneNumber = value;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: _emergencyContactName,
                decoration: InputDecoration(
                  labelText: 'Emergency Contact Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.account_box, color: Colors.redAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter emergency contact\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emergencyContactName = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _emergencyContactPhoneNumber,
                decoration: InputDecoration(
                  labelText: 'Emergency Contact Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.local_hospital, color: Colors.redAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter emergency contact\'s phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emergencyContactPhoneNumber = value;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                onPressed: _saveVetInfo,
                child: const Text('Save Vet & Emergency Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}