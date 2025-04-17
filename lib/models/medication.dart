// lib/models/medication.dart
import 'package:flutter/foundation.dart'; // For @required annotation

class Medication {
  final String id;         // Unique identifier
  final String name;       // e.g., "Furosemide", "Vetmedin"
  final String? dosage;    // e.g., "40mg", "5mg" (optional)
  final bool isAm;         // Does it need to be given in the AM?
  final bool isPm;         // Does it need to be given in the PM?
  // Optional: Add TimeOfDay fields if you need specific times later
  // final TimeOfDay? timeAm;
  // final TimeOfDay? timePm;
  final String? notes;     // Any additional instructions (optional)

  Medication({
    required this.id,
    required this.name,
    this.dosage,
    required this.isAm,
    required this.isPm,
    // this.timeAm,
    // this.timePm,
    this.notes,
  });

  // TODO: Add methods for copying, JSON serialization/deserialization if needed later
}