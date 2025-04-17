import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class ManualLogScreen extends StatefulWidget {
  const ManualLogScreen({Key? key}) : super(key: key);

  @override
  State<ManualLogScreen> createState() => _ManualLogScreenState();
}

class _ManualLogScreenState extends State<ManualLogScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _medicationController = TextEditingController();
  TextEditingController _dosageController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime);
        });
      }
    }
  }

  @override
  void dispose() {
    _medicationController.dispose();
    _dosageController.dispose();
    _dateTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Manual Log Entry'),
        backgroundColor: Colors.pink[100], // Pastel color
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _medicationController,
                    decoration: const InputDecoration(
                      labelText: 'Medication Name',
                      border: InputBorder.none, // Remove the default border
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the medication name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelText: 'Dosage',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the dosage';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _dateTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Date and Time',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDateTime(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date and time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[100], // Pastel color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the data (replace with your data storage logic)
                    print('Medication: ${_medicationController.text}');
                    print('Dosage: ${_dosageController.text}');
                    print('Date/Time: ${_dateTimeController.text}');
                    print('Notes: ${_notesController.text}');

                    // Optionally, clear the form
                    _medicationController.clear();
                    _dosageController.clear();
                    _dateTimeController.clear();
                    _notesController.clear();
                  }
                },
                child: const Text(
                  'Save Log Entry',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}