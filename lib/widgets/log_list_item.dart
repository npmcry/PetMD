import 'package:flutter/material.dart';

// A reusable stateless widget to display a single row in the log list
class LogListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;

  // Constructor requiring the data needed for display
  const LogListItem({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // The visual structure of one log entry row
    return Padding(
      // Use const for EdgeInsets
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Log entry icon
          // Icon itself cannot be const because icon and iconColor are parameters
          Icon(icon, size: 22, color: iconColor),
          // Use const for SizedBox
          const SizedBox(width: 12),
          // Use Expanded to allow text to wrap if it's too long
          Expanded(
            // Text widget content and style depend on parameters, cannot be const
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}