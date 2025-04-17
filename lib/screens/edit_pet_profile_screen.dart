import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPetProfileScreen extends StatefulWidget {
  final String? initialName;
  final String? initialImagePath;

  const EditPetProfileScreen({Key? key, this.initialName, this.initialImagePath}) : super(key: key);

  @override
  State<EditPetProfileScreen> createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  File? _image;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
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

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('petName', _name!);
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
    );
  }
}