import 'package:flutter/material.dart';
import 'dart:async'; // For the splash screen timer

// Import the dashboard screen to navigate to it
import './dashboard_screen.dart'; // Adjust path if your folder structure is different

// --- Open Screen / Splash Screen ---
class OpenScreen extends StatefulWidget {
  const OpenScreen({super.key});
  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToDashboard(); // Start timer on initialization
  }

  // Navigate to dashboard after a delay
  void _navigateToDashboard() {
    Timer(const Duration(seconds: 3), () { // Wait for 3 seconds
      if (mounted) { // Check if widget is still mounted before navigating
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const DashboardScreen(), // Navigate here
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/open_screen.png"), // Splash background
            fit: BoxFit.cover,
          ),
        ),
        child: const Center( // Center the title
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
                 Text(
                  'PetMD',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                     shadows: <Shadow>[ // Add shadow for contrast
                       Shadow(
                         offset: Offset(1.0, 1.0),
                         blurRadius: 3.0,
                         color: Color.fromARGB(150, 0, 0, 0),
                       ),
                     ],
                  ),
                ),
             ],
          ),
        ),
      ),
    );
  }
}