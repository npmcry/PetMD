import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ** Import Provider **

// Import necessary local files
import '../providers/medication_provider.dart'; // ** Import Provider **
import '../models/medication.dart'; // ** Import Model **
import '../utils/colors.dart'; // Optional: for styling consistency
import './add_edit_medication_screen.dart'; // Add this line

// Placeholder imports (Uncomment as you create screens)
// import './add_edit_medication_screen.dart';

class ManageMedicationsScreen extends StatelessWidget {
  const ManageMedicationsScreen({super.key});

  // --- Placeholder Navigation ---
  void _navigateToAddEditScreen(BuildContext context,
      {Medication? medication}) {
    // If medication is passed, it's for editing, otherwise adding.
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => AddEditMedicationScreen(medication: medication)
    // ));
    // ADD this Navigator.push call:
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditMedicationScreen(
                medication:
                    medication) // Pass medication object (null for Add, populated for Edit)
            )).then((_) {
      // Optional: Refresh list after returning from Add/Edit screen
      // This assumes Add/Edit screen pops back. If it uses pushReplacement,
      // this .then() might not be reached as expected.
      // You might not need this if using Provider correctly, as the list
      // should update automatically via context.watch.
      // setState(() {}); // Only works if ManageMedicationsScreen is StatefulWidget
      print("Returned from Add/Edit screen");
    });
  }

  // --- Helper to build subtitle string ---
  String _buildFrequencyString(Medication med) {
    String frequency = '';
    if (med.isAm) frequency += 'AM';
    if (med.isAm && med.isPm) frequency += ' & '; // Separator if both
    if (med.isPm) frequency += 'PM';
    if (frequency.isEmpty) frequency = 'No schedule set'; // Fallback

    // Combine with dosage if present
    if (med.dosage != null && med.dosage!.isNotEmpty) {
      return '${med.dosage} - $frequency';
    } else {
      return frequency;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get access to the provider instance
    // Use watch for build method to rebuild on changes
    final medicationProvider = context.watch<MedicationProvider>();
    final List<Medication> medications = medicationProvider.allMedications;

    // Use a theme color or define one for list icons
    final iconColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Medications'),
        // Optional: Add '+' icon button here instead of FAB
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add_circle_outline),
        //     tooltip: 'Add Medication',
        //     onPressed: () => _navigateToAddEditScreen(context),
        //   ),
        // ],
      ),
      body: medications.isEmpty
          // --- Display if list is empty ---
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No medications added yet.\nTap the "+" button to add one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          // --- Display list if not empty ---
          : ListView.builder(
              itemCount: medications.length,
              itemBuilder: (ctx, index) {
                final med = medications[index];

                // ** Wrap ListTile with Dismissible for Swipe-to-Delete **
                return Dismissible(
                  key: ValueKey(med.id), // Use unique ID for key
                  direction: DismissDirection.endToStart, // Swipe left only

                  // Background shown during swipe
                  background: Container(
                    color: Colors.red.shade400,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete_sweep_outlined,
                        color: Colors.white),
                  ),

                  // Action performed after swipe completes
                  onDismissed: (direction) {
                    // Use context.read inside callbacks/event handlers
                    context.read<MedicationProvider>().deleteMedication(med.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${med.name} deleted."),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red.shade400,
                      ),
                    );
                  },
                  // TODO: Implement confirmDismiss later to add dialog confirmation

                  // The actual list item content
                  child: ListTile(
                    leading: Icon(Icons.medication_outlined,
                        color: iconColor, size: 30),
                    title: Text(med.name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(_buildFrequencyString(med)),
                    // Optional: Add trailing edit button or handle tap
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined,
                          color: Colors.grey.shade600),
                      tooltip: 'Edit Medication',
                      onPressed: () =>
                          _navigateToAddEditScreen(context, medication: med),
                    ),
                    // Or make the whole tile tappable for editing:
                    // onTap: () => _navigateToAddEditScreen(context, medication: med),
                  ),
                ); // End Dismissible
              },
            ),
      // --- Button to Add New Medications ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(
            context), // Navigate without passing medication (for Add)
        tooltip: 'Add Medication',
        backgroundColor:
            Theme.of(context).colorScheme.primary, // Use theme color
        foregroundColor:
            Theme.of(context).colorScheme.onPrimary, // Use theme color
        child: const Icon(Icons.add),
      ),
    );
  }
}
