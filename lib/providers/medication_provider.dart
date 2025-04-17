// lib/providers/medication_provider.dart
import 'package:flutter/material.dart'; // Or foundation
import '../models/medication.dart'; // Import the Medication model

class MedicationProvider with ChangeNotifier {
  // Private list of medications - starts empty
  // In a real app, you would load this from storage (database, shared_prefs)
  List<Medication> _medications = [
    // --- Sample Data (Remove later) ---
    Medication(id: 'm1', name: 'Furosemide', dosage: '40mg', isAm: true, isPm: true),
    Medication(id: 'm2', name: 'Vetmedin', dosage: '5mg', isAm: true, isPm: false), // Example: AM only
    Medication(id: 'm3', name: 'Apoquel', dosage: '16mg', isAm: false, isPm: true), // Example: PM only
    // --- End of Sample Data ---
  ];

  // Getter to access the full list (read-only view)
  List<Medication> get allMedications {
    return [..._medications]; // Return a copy
  }

  // Getter for AM medications
  List<Medication> get amMedications {
    return _medications.where((med) => med.isAm).toList();
  }

  // Getter for PM medications
  List<Medication> get pmMedications {
    return _medications.where((med) => med.isPm).toList();
  }

  // --- Methods to Modify Medications ---

  // Find a medication by its ID
  Medication findById(String id) {
    return _medications.firstWhere((med) => med.id == id);
    // Consider adding error handling if not found (e.g., return null or throw)
  }

  // Add a new medication
  void addMedication(Medication newMedication) {
    // Basic add - assumes ID is handled elsewhere or generated
    // In real app, generate unique ID here or upon creation
    _medications.add(newMedication);
    notifyListeners(); // Notify listening widgets to rebuild
    // TODO: Save changes to persistent storage
  }

  // Update an existing medication
  void updateMedication(String id, Medication updatedMedication) {
    final medIndex = _medications.indexWhere((med) => med.id == id);
    if (medIndex >= 0) {
      _medications[medIndex] = updatedMedication;
      notifyListeners(); // Notify listeners
      // TODO: Save changes to persistent storage
    }
  }

  // Delete a medication by ID
  void deleteMedication(String id) {
    final initialLength = _medications.length;
    _medications.removeWhere((med) => med.id == id);
    // Only notify if something was actually removed
    if (_medications.length != initialLength) {
      notifyListeners(); // Notify listeners
      // TODO: Save changes to persistent storage
    }
  }

  // TODO: Add method to load medications from storage when app starts
  // Future<void> loadMedications() async { ... }
}