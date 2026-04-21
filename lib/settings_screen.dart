import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wegoagain/main.dart'; // Import main.dart to access ThemeProvider and notification functions

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay _notificationTime = const TimeOfDay(hour: 10, minute: 0);
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    final int? hour = _prefs?.getInt('notificationHour');
    final int? minute = _prefs?.getInt('notificationMinute');

    if (hour != null && minute != null) {
      setState(() {
        _notificationTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  Future<void> _saveNotificationTime(TimeOfDay newTime) async {
    setState(() {
      _notificationTime = newTime;
    });
    await _prefs?.setInt('notificationHour', newTime.hour);
    await _prefs?.setInt('notificationMinute', newTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = FTheme.of(context);

    return FScaffold(
      header: FHeader(
        title: const Text('Settings'),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FItemGroup(
            children: [
              FItem(
                title: Text('Dark Mode', style: theme.typography.md),
                suffix: FSwitch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChange: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              FItem(
                title: Text('Daily Quote Time', style: theme.typography.md),
                suffix: FButton(
                  onPress: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _notificationTime,
                    );
                    if (picked != null && picked != _notificationTime) {
                      await _saveNotificationTime(picked);
                    }
                  },
                  child: Text(_notificationTime.format(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
