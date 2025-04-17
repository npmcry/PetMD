import 'dart:io'; // Required for FileImage (Mobile only)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import necessary local files
import '../models/medication.dart';
import '../providers/medication_provider.dart';

class AddEditMedicationScreen extends StatefulWidget {
  const AddEditMedicationScreen({super.key, this.medication});

  final Medication? medication; // Nullable: null for Add, populated for Edit

  @override
  _AddEditMedicationScreenState createState() => _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  // --- Form Key ---
  final _formKey = GlobalKey<FormState>();

  // --- Local State for Form Fields ---
  String _name = '';
  String? _dosage;
  bool _isAm = false;
  bool _isPm = false;
  String? _notes;

  // Flag to check if it's edit mode
  bool get _isEditing => widget.medication != null;

  @override
  void initState() {
    super.initState();
    // --- Populate fields if editing ---
    if (_isEditing) {
      _name = widget.medication!.name;
      _dosage = widget.medication!.dosage;
      _isAm = widget.medication!.isAm;
      _isPm = widget.medication!.isPm;
      _notes = widget.medication!.notes;
    }
  }

  // --- Save Form logic ---
  void _saveForm() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return; // Don't save if form is invalid
    }
    _formKey.currentState!.save(); // Trigger onSaved for all fields

    final provider = context.read<MedicationProvider>();

    final newMedication = Medication(
      id: widget.medication?.id ?? DateTime.now().toString(), // Use existing ID if editing
      name: _name,
      dosage: _dosage,
      isAm: _isAm,
      isPm: _isPm,
      notes: _notes,
    );

    if (_isEditing) {
      provider.updateMedication(widget.medication!.id, newMedication);
    } else {
      provider.addMedication(newMedication);
    }

    if (mounted) {
      Navigator.of(context).pop(); // Close screen after saving
    }
  }
  // --- End of _saveForm ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Medication' : 'Add Medication'),
      ),
      // Use GestureDetector to dismiss keyboard when tapping background
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView( // Use ListView to ensure scrolling if content overflows
              children: <Widget>[
                // --- Name ---
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Medication Name *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Consistent rounding
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) { return 'Please enter a medication name'; }
                    return null;
                  },
                  onSaved: (value) => _name = value ?? '',
                ),
                const SizedBox(height: 16),

                // --- Dosage ---
                TextFormField(
                  initialValue: _dosage,
                  decoration: InputDecoration(
                    labelText: 'Dosage (e.g., 40mg, 1 tablet)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Consistent rounding
                    ),
                  ),
                  onSaved: (value) => _dosage = value,
                ),
                const SizedBox(height: 20),

                // --- AM/PM Schedule ---
                Card(
                  elevation: 0.5, margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Theme.of(context).dividerColor)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(' Schedule:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // AM Checkbox Row
                            Row( mainAxisSize: MainAxisSize.min, children: [
                              Checkbox(
                                value: _isAm,
                                onChanged: (value) => setState(() => _isAm = value!),
                                activeColor: Colors.lightBlue[200], // Pastel Blue
                              ),
                              const Icon(Icons.wb_sunny_outlined, size: 20, color: Colors.orangeAccent),
                              const SizedBox(width: 4),
                              const Text('AM')
                            ]),
                            // PM Checkbox Row
                            Row( mainAxisSize: MainAxisSize.min, children: [
                              Checkbox(
                                value: _isPm,
                                onChanged: (value) => setState(() => _isPm = value!),
                                activeColor: Colors.lightBlue[200], // Pastel Blue
                              ),
                              const Icon(Icons.nightlight_round, size: 20, color: Colors.indigoAccent),
                              const SizedBox(width: 4),
                              const Text('PM')
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Notes ---
                TextFormField(
                  initialValue: _notes,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'e.g., Give with food',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Consistent rounding
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  onSaved: (value) => _notes = value,
                ),
                const SizedBox(height: 30), // Spacing before save button

                // --- ** ADDED Save Button at the bottom ** ---
                ElevatedButton(
                  onPressed: _saveForm, // Trigger the save logic
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), // Make button taller
                    minimumSize: const Size(double.infinity, 50), // Make button wide
                    backgroundColor: Colors.lightBlue[200], // Your desired pastel color
                    foregroundColor: Colors.white, // Text color that contrasts well with primary
                  ),
                  child: Text(
                    _isEditing ? 'Update Medication' : 'Add Medication',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // Add some padding at the very bottom if needed
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}