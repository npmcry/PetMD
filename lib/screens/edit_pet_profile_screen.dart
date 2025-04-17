import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EditPetProfileScreen extends StatefulWidget {
  final String? initialName;
  final String? initialImagePath;
  final String? initialBreed;
  final String? initialGender;
  final String? initialBirthday;

  const EditPetProfileScreen({Key? key, this.initialName, this.initialImagePath, this.initialBreed, this.initialGender, this.initialBirthday}) : super(key: key);

  @override
  State<EditPetProfileScreen> createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  File? _image;
  String? _breed;
  String? _gender;
  DateTime? _birthday;
  TextEditingController _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _breed = widget.initialBreed;
    _gender = widget.initialGender;
    if (widget.initialBirthday != null) {
      _birthday = DateTime.tryParse(widget.initialBirthday!);
      _birthdayController.text = widget.initialBirthday!;
    }
    if (widget.initialImagePath != null) {
      _image = File(widget.initialImagePath!);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthday = pickedDate;
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(_birthday!);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('petName', _name!);
      await prefs.setString('petBreed', _breed ?? '');
      await prefs.setString('petGender', _gender ?? '');
      await prefs.setString('petBirthday', _birthdayController.text);
      if (_image != null) {
        await prefs.setString('petImagePath', _image!.path);
      } else {
        await prefs.remove('petImagePath');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving Pet Profile...')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Profile'),
        backgroundColor: Colors.pink[100], // Cute color
        shape: const RoundedRectangleBorder( // Rounded AppBar
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 0, // Remove shadow for a flatter look
      ),
      backgroundColor: Colors.pink[50], // Pastel background
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Increased padding
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70, // Slightly larger
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[400]) // Larger icon
                            : null,
                      ),
                      Positioned( // Add a cute "edit" icon
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.pink[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Increased spacing
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Pet Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0), // Rounded input
                      borderSide: BorderSide.none, // Remove border line
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.pets, color: Colors.pinkAccent), // Cute icon
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pet\'s name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _breed,
                  decoration: InputDecoration(
                    labelText: 'Breed',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.pets, color: Colors.pinkAccent),
                  ),
                  onSaved: (value) {
                    _breed = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.pets, color: Colors.pinkAccent),
                  ),
                  onSaved: (value) {
                    _gender = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.cake, color: Colors.pinkAccent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                      onPressed: () => _selectBirthday(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectBirthday(context),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder( // Rounded button
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5, // Add a subtle shadow
                  ),
                  onPressed: _saveProfile,
                  child: const Text('Save Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}