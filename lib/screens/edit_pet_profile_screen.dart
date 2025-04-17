import 'package:flutter/material.dart';

class EditPetProfileScreen extends StatelessWidget {
  // Optional: Accept initial data if needed
  // final String initialName;
  // final String? initialImagePath;

  const EditPetProfileScreen({
    super.key,
    // required this.initialName,
    // this.initialImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Profile'),
      ),
      body: const Center(
        child: Text('Edit Pet Profile Screen - Coming Soon!'),
      ),
    );
  }
}