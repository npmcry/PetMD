// ** STEP 0: Ensure dart:io is compatible if running on mobile (not web) **
import 'dart:io'; // Required for File

import 'package:flutter/material.dart';
// ** STEP 1: Add image_picker to pubspec.yaml and run `flutter pub get` **
// ** STEP 2: Configure platform permissions (iOS Info.plist / AndroidManifest) **
// ** See image_picker documentation on pub.dev **
import 'package:image_picker/image_picker.dart'; // Import after adding dependency

// Import necessary local files
import '../utils/colors.dart';
import './dashboard_screen.dart';

// Import placeholder screen types (uncomment as you create them)
import './edit_pet_profile_screen.dart';
import './manage_medications_screen.dart';
import './settings_screen.dart';
import './vet_info_screen.dart';
import './manual_log_screen.dart';
import './history_screen.dart';


class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  // --- State Variables ---
  final String petName = "Chloe"; // Placeholder
  String? _petImagePath; // Null means no image uploaded yet

  @override
  void initState() {
    super.initState();
    // TODO: Load _petImagePath from persistent storage here if available
  }


  // --- Image Picker Logic ---
  Future<void> _pickImage() async {
    // Ensure image_picker dependency and permissions are set up first!
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && mounted) { // Check mounted after await
        setState(() {
          _petImagePath = pickedFile.path;
        });
        // TODO: Save the _petImagePath persistently
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated!"), duration: Duration(seconds: 2)),
        );
      } else if (pickedFile == null) {
        print("Image picking cancelled.");
      }
    } catch (e) {
       print("Error picking image: $e");
       if (mounted){
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Could not pick image: $e"), duration: const Duration(seconds: 2)),
         );
       }
    }
  }

  // --- Placeholder Navigation Functions ---
  void _navigateToEditProfile(BuildContext context) {
     // Check if mounted before navigating if called after async gap
     if (!mounted) return;
     Navigator.push(context, MaterialPageRoute(
       // Pass necessary data to the edit screen
       builder: (context) => EditPetProfileScreen(/* initialName: petName, initialImagePath: _petImagePath */)
     )).then((didSaveChanges) {
       // Optional: Refresh data if changes were made on edit screen
       if (didSaveChanges == true) {
         // TODO: Reload pet profile data here if needed
         // setState(() {});
       }
     });
     print("Navigate to Edit Pet Profile");
  }

  void _navigateToManageMedications(BuildContext context) {
     if (!mounted) return;
     Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageMedicationsScreen()));
     print("Navigate to Manage Medications");
  }

  void _navigateToSettings(BuildContext context) {
     if (!mounted) return;
     Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
     print("Navigate to Settings");
  }

  void _navigateToVetInfo(BuildContext context) {
     if (!mounted) return;
     Navigator.push(context, MaterialPageRoute(builder: (context) => const VetInfoScreen()));
     print("Navigate to Vet Info");
  }

  void _navigateToManualLog(BuildContext context) {
     if (!mounted) return;
     Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualLogScreen()));
     print("Navigate to Add Manual Log");
  }

  void _navigateToHistory(BuildContext context) {
     if (!mounted) return;
     Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
     print("Navigate to History");
  }

  // Navigate back to the Dashboard
  void _navigateToDashboard(BuildContext context) {
     if (!mounted) return;
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
     );
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconColor = Theme.of(context).colorScheme.secondary;
    final bool imageExists = _petImagePath != null && _petImagePath!.isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              // --- Profile Section ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (imageExists) {
                            _navigateToEditProfile(context);
                          } else {
                            _pickImage();
                          }
                        },
                        borderRadius: BorderRadius.circular(60),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          // Use a ternary for cleaner conditional logic
                          backgroundImage: imageExists
                              ? FileImage(File(_petImagePath!)) as ImageProvider
                              : null,
                          onBackgroundImageError: imageExists ? (e, s) {
                               print('Error loading profile image: $e');
                               // Handle error, maybe clear the path if file is invalid
                               // setState(() => _petImagePath = null);
                               } : null,
                          child: imageExists
                              ? null // No child when image is shown
                              : Icon(Icons.pets, size: 60, color: Colors.grey.shade600), // Placeholder
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        petName,
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(thickness: 1, indent: 16, endIndent: 16),

              // --- Options List ---
              ListTile(
                leading: Icon(Icons.edit_outlined, color: iconColor),
                title: const Text('Edit Pet Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToEditProfile(context),
              ),
              ListTile(
                leading: Icon(Icons.medication_outlined, color: iconColor),
                title: const Text('Manage Medications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToManageMedications(context),
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined, color: iconColor),
                title: const Text('App Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToSettings(context),
              ),
               ListTile(
                leading: Icon(Icons.medical_information_outlined, color: iconColor),
                title: const Text('Vet & Emergency Info'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToVetInfo(context),
              ),
               ListTile(
                 // ** Corrected Icon **
                leading: Icon(Icons.playlist_add, color: iconColor),
                title: const Text('Add Manual Log Entry'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToManualLog(context),
              ),
               ListTile(
                leading: Icon(Icons.history_outlined, color: iconColor),
                title: const Text('View Full History'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToHistory(context),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Adjust as needed
              child: InkWell(
                onTap: () => _navigateToDashboard(context),
                borderRadius: BorderRadius.circular(30),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: pinkPawButtonBg,
                  child: Icon(Icons.pets, color: pinkPawIconColor, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}