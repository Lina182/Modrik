import 'package:flutter/material.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  _SettingsProfileScreenState createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  // المتغيرات للإعدادات
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedMode = 'Dark Mode';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.purple,  // لون شريط التطبيق
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // وظائف إضافية للإعدادات يمكن إضافتها هنا
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // إعدادات اللغة
            ListTile(
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: <String>['English', 'Arabic']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // إعدادات الوضع
            ListTile(
              title: const Text('Mode'),
              trailing: DropdownButton<String>(
                value: _selectedMode,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMode = newValue!;
                  });
                },
                items: <String>['Light Mode', 'Dark Mode']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // إعدادات الإشعارات
            ListTile(
              title: const Text('Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // إعدادات الخصوصية
            const ListTile(
              title: Text('Privacy'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 20),

            // إعدادات "About us"
            const ListTile(
              title: Text('About us'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 20),

            // إعدادات "Contact us"
            const ListTile(
              title: Text('Contact us'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}