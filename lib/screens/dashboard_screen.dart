import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date/time formatting
import 'package:provider/provider.dart'; // ** Import provider **
import 'dart:ui'; // Import dart:ui for Color
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome

// Import necessary local files
import '../utils/colors.dart';
import '../widgets/action_button.dart';
import '../widgets/log_list_item.dart';
import '../models/medication.dart'; // ** Import Medication model **
import '../providers/medication_provider.dart'; // ** Import Medication provider **
import './profile_menu_screen.dart'; // ** Import Profile Menu screen **

// --- Dashboard Screen ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- Data & State ---
  final String petName = "Chloe";
  final String userName = "Tyler";
  final List<Map<String, dynamic>> _logEntries = [];
  final DateFormat _logDateFormat = DateFormat('MMM d, h:mm a');

  // Define a list of pastel colors
  final List<Color> _pastelColors = [
    const Color(0xFFBBDEFB), // Light Blue
    const Color(0xFFC8E6C9), // Light Green
    const Color(0xFFD1C4E9), // Light Purple
    const Color(0xFFF0F4C3), // Light Yellow
    const Color(0xFFF48FB1), // Light Pink
    const Color(0xFFB2EBF2), // Light Cyan
    const Color(0xFFFFCCBC), // Light Orange
  ];

  // --- Helper function to generate a color index from a string ---
  int _getColorIndex(String text) {
    int hash = text.hashCode;
    return hash % _pastelColors.length;
  }

  // --- Method to Log Actions ---
  void _logAction(String actionBaseName, IconData logIcon) {
    final now = DateTime.now();
    final String timestamp = _logDateFormat.format(now);
    final bool isAm = now.hour < 12;
    String logLabel = actionBaseName;

    if (actionBaseName == 'Feed') {
      logLabel = 'Fed $petName';
    } else if (actionBaseName == 'Walk') {
      logLabel = 'Walked $petName';
    }

    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'icon': logIcon,
      'text': '$logLabel - $timestamp'
    };
    setState(() {
      _logEntries.insert(0, newEntry);
    });
  }

  // --- Delete Confirmation Dialog ---
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, String logText) async {
    const Color dialogBgColor = Color(0xFFFFF8DC);
    const Color titleColor = Color(0xFF696969);
    const Color cancelButtonColor = Color(0xFFB0C4DE);
    const Color deleteButtonBgColor = Color(0xFFFFB6C1);
    const Color deleteButtonTextColor = Colors.white;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            "Delete Log?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleColor,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Really delete this log?\n\n\"$logText\"",
            style: TextStyle(color: titleColor, fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.only(right: 15, bottom: 10),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: cancelButtonColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: deleteButtonBgColor,
                foregroundColor: deleteButtonTextColor,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  // --- Helper function to darken a color ---
  Color _darkenColor(Color color, [double amount = .2]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isAm = now.hour < 12;

    // ** STEP 1: Get Medication Data from Provider **
    final medicationProvider = context.watch<MedicationProvider>();
    final List<Medication> medsToShow = isAm
        ? medicationProvider.amMedications
        : medicationProvider.pmMedications;

    // --- Select Theme Elements ---
    final String greeting = isAm ? "Morning, $userName!" : "Evening, $userName!";
    final String backgroundImage =
        isAm ? "assets/images/bg_am.png" : "assets/images/bg_pm.png";
    final Color primaryTextColor =
        isAm ? amPrimaryTextColor : pmPrimaryTextColor;
    final Color secondaryTextColor =
        isAm ? amSecondaryTextColor : pmSecondaryTextColor;
    final Color listIconColor = isAm ? amListIconColor : pmListIconColor;
    final Color walkIconBg = isAm ? amWalkIconBg : pmWalkIconBg;
    final Color walkIconColor = isAm ? amWalkIconColor : pmWalkIconColor;

    // --- Define Button Styles ---
    final BorderRadius buttonBorderRadius = BorderRadius.circular(30.0);
    const double amButtonStrokeWidth = 1.0;
    const double pmButtonStrokeWidth = 3.0;

    // --- Specific Style for the Static "Feed" Button ---
    final ButtonStyle feedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: isAm ? amFeedButtonBg : pmFeedButtonBg,
      foregroundColor:
          isAm ? amFeedButtonContent : pmFeedButtonStroke,
      shape: RoundedRectangleBorder(
        borderRadius: buttonBorderRadius,
        side: BorderSide(
          color: isAm ? amFeedButtonContent : pmFeedButtonStroke,
          width: isAm ? amButtonStrokeWidth : pmButtonStrokeWidth,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      elevation: 1,
      fixedSize: isAm ? null : const Size(253, 64),
    );

    // --- Build the UI ---
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Greeting Text ---
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
                  child: Text(
                    greeting,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      shadows: !isAm
                          ? [
                              const Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black54,
                              )
                            ]
                          : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // --- Action Buttons Section ---
                // Static Feed Button
                ActionButton(
                  label: 'Feed $petName',
                  icon: Icons.restaurant,
                  style: feedButtonStyle,
                  onPressed: () => _logAction('Feed', Icons.restaurant),
                ),
                const SizedBox(height: 42),

                // ** STEP 2: Dynamically Generate Medication Buttons **
                ...medsToShow.map((med) {
                  final int colorIndex = _getColorIndex(med.name);
                  final Color medicationColor = _pastelColors[colorIndex];
                  // ** Darken the color for the stroke **
                  final Color strokeColor = _darkenColor(medicationColor, 0.3);
                  // ** Darken the color for the text **
                  final Color textColor = _darkenColor(medicationColor, 0.4);

                  final ButtonStyle medButtonStyle = ElevatedButton.styleFrom(
                    backgroundColor: medicationColor,
                    foregroundColor: textColor, // Use the darkened color for the text
                    shape: RoundedRectangleBorder(
                      borderRadius: buttonBorderRadius,
                      side: BorderSide(
                        color: strokeColor, // Use the darkened color for the stroke
                        width: isAm ? amButtonStrokeWidth : pmButtonStrokeWidth,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                    elevation: 1,
                    fixedSize: isAm ? null : const Size(253, 64),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 42.0),
                    child: ActionButton(
                      label: med.name,
                      icon: FontAwesomeIcons.pills, // Use pill icon
                      style: medButtonStyle,
                      onPressed: () =>
                          _logAction(med.name, FontAwesomeIcons.pills), // Log using pill icon
                    ),
                  );
                }).toList(),

                if (medsToShow.isNotEmpty) const SizedBox(height: 3),
                if (medsToShow.isEmpty) const SizedBox(height: 45),

                // --- Walk Section ---
                Column(
                  children: [
                    InkWell(
                      onTap: () => _logAction("Walk", FontAwesomeIcons.dog), // Use FontAwesome icon
                      borderRadius: BorderRadius.circular(40),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: const Color(0xFFB2DFDB), // Pastel Teal
                        child: Icon(
                          FontAwesomeIcons.dog, // Use FontAwesome icon
                          size: 40,
                          color: const Color(0xFF4DB6AC), // Even Darker Pastel Teal for the ICON
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Walk $petName',
                      style: TextStyle(
                        fontSize: 17,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w500,
                        shadows: !isAm
                            ? [
                                const Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                  color: Colors.black45,
                                )
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 45),

                // --- Event Log List Section ---
                Expanded(
                  child: ListView.builder(
                    itemCount: _logEntries.length,
                    itemBuilder: (context, index) {
                      final logEntry = _logEntries[index];
                      final IconData logIcon =
                          logEntry['icon'] as IconData? ?? Icons.error_outline;
                      final String logText =
                          logEntry['text'] as String? ?? 'Log entry error';
                      final String logId =
                          logEntry['id'] as String? ?? index.toString();

                      return Dismissible(
                        key: ValueKey(logId),
                        background: Container(
                          color: Colors.red.shade300,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await _showDeleteConfirmationDialog(
                              context, logText);
                        },
                        onDismissed: (direction) {
                          final itemIndex = _logEntries.indexWhere(
                              (item) => item['id'] == logId);
                          if (itemIndex != -1) {
                            setState(() {
                              _logEntries.removeAt(itemIndex);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("\"$logText\" deleted."),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red.shade400,
                              ),
                            );
                          }
                        },
                        child: LogListItem(
                          icon: logIcon,
                          text: logText,
                          iconColor: listIconColor,
                          textColor: secondaryTextColor,
                        ),
                      );
                    },
                  ),
                ),

                // --- Pink Paw Button Section ---
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileMenuScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundColor: pinkPawButtonBg,
                        child: Icon(
                          Icons.pets,
                          color: pinkPawIconColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}