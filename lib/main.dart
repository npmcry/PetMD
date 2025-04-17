import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ** 1. Import provider **

// Import the first screen and the new provider
import 'screens/open_screen.dart';
import 'providers/medication_provider.dart'; // ** 2. Import the provider **

void main() {
  // ** 3. Wrap the app with ChangeNotifierProvider **
  runApp(
    ChangeNotifierProvider(
      // ** 4. Create an instance of the provider **
      // This makes MedicationProvider available to widgets below it in the tree
      create: (context) => MedicationProvider(),
      child: const PetMDApp(), // Your existing app widget remains the child
    ),
  );
}

class PetMDApp extends StatelessWidget {
  const PetMDApp({super.key});

  @override
  Widget build(BuildContext context) {
    // No changes needed inside PetMDApp itself for this step
    return MaterialApp(
      title: 'PetMD',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF629A95)), // Example seed color
        // fontFamily: 'YourCustomFont', // Define if needed
      ),
      debugShowCheckedModeBanner: false,
      home: const OpenScreen(), // Start with OpenScreen
    );
  }
}