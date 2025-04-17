import 'package:flutter/material.dart';

// A reusable stateless widget for the main action buttons
class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final ButtonStyle style;
  final VoidCallback onPressed;
  final Widget? leadingWidget; // Optional widget before text (e.g., for dots)

  // Constructor requiring all necessary properties
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.style,
    required this.onPressed,
    this.leadingWidget, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    // ElevatedButton provides the standard Material Design button appearance
    return ElevatedButton(
      style: style, // Apply the specific style passed in
      onPressed: onPressed, // Assign the tap action passed in
      // Row holds the button's content (text, icons)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push content to opposite ends
        children: [
          // Inner Row groups the optional leading widget and the main text label
          Row(
            mainAxisSize: MainAxisSize.min, // Keep this inner row compact
            children: [
              // Display the leading widget only if it's provided
              if (leadingWidget != null) leadingWidget!, // Add null check operator !
              // The main text label of the button
              Text(
                label,
                // Use const for TextStyle as its properties are fixed here
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          // The icon displayed on the right side of the button
          // Icon color is determined by the 'foregroundColor' in the ButtonStyle
          Icon(icon, size: 24),
        ],
      ),
    );
  }
}