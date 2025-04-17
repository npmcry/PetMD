import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  ThemeMode _themeMode = ThemeMode.light;
  double _fontSize = 16.0;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _themeMode = (prefs.getString('theme') ?? 'light') == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      int? reminderHour = prefs.getInt('reminderHour');
      int? reminderMinute = prefs.getInt('reminderMinute');
      if (reminderHour != null && reminderMinute != null) {
        _reminderTime = TimeOfDay(hour: reminderHour, minute: reminderMinute);
      }
    });
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setString('theme', _themeMode == ThemeMode.light ? 'light' : 'dark');
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setInt('reminderHour', _reminderTime.hour);
    await prefs.setInt('reminderMinute', _reminderTime.minute);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (pickedTime != null) {
      setState(() {
        _reminderTime = pickedTime;
        _saveSettings();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: Colors.pink[100],
        shape: const RoundedRectangleBorder( // Rounded AppBar
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card( // Rounded Card
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.amber),
                title: const Text('Theme'),
                trailing: DropdownButton<ThemeMode>(
                  value: _themeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _themeMode = value!;
                      _saveSettings();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.redAccent),
                title: const Text('Notifications'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                      _saveSettings();
                    });
                  },
                  activeColor: Colors.pink[200],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.language, color: Colors.green),
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: const [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'Spanish',
                      child: Text('Spanish'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                      _saveSettings();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.format_size, color: Colors.blue),
                title: const Text('Font Size'),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: _fontSize,
                    min: 12.0,
                    max: 24.0,
                    divisions: 4,
                    label: _fontSize.round().toString(),
                    activeColor: Colors.purple[200],
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                        _saveSettings();
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.orange),
                title: const Text('Default Reminder Time'),
                trailing: Text(
                  '${_reminderTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () => _selectTime(context),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.backup, color: Colors.grey),
                title: const Text('Data Backup/Restore'),
                onTap: () {
                  // TODO: Implement backup/restore functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Backup/Restore functionality not implemented yet.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.teal),
                title: const Text('About Us'),
                onTap: () {
                  // TODO: Implement About Us page navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('About Us page not implemented yet.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.support_agent, color: Colors.indigo),
                title: const Text('Contact Support'),
                onTap: () {
                  // TODO: Implement Contact Support functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact Support functionality not implemented yet.')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}