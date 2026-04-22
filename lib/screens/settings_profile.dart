import 'package:flutter/material.dart';

const Color mainPurple = Color(0xFFC4C8EA);
const Color bgPurple = Color(0xFF9DA3D9);

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  bool notifications = true;
  String language = 'English';
  String mode = 'Light';

  bool privacyExpanded = false;
  bool contactExpanded = false;
  bool aboutExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -220,
            right: -220,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                color: bgPurple.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            children: [
              _tile(
                title: 'Language',
                child: DropdownButton<String>(
                  value: language,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
                  ],
                  onChanged: (v) => setState(() => language = v!),
                ),
              ),
              _tile(
                title: 'Mode',
                child: DropdownButton<String>(
                  value: mode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'Light', child: Text('Light')),
                    DropdownMenuItem(value: 'Dark', child: Text('Dark')),
                  ],
                  onChanged: (v) => setState(() => mode = v!),
                ),
              ),
              _tile(
                title: 'Notifications',
                child: Switch(
                  value: notifications,
                  onChanged: (v) => setState(() => notifications = v),
                ),
              ),
              _expandTile(
                title: 'Privacy',
                expanded: privacyExpanded,
                onTap: () =>
                    setState(() => privacyExpanded = !privacyExpanded),
                text: '''
The Modrik app is committed to protecting user privacy
Genetic data and personal information are handled with the utmost confidentiality and using high security standards
Data is not shared with any third party without the user's consent
By using the app, you agree to the Privacy Policy.
''',
              ),
              _expandTile(
                title: 'Contact Us',
                expanded: contactExpanded,
                onTap: () =>
                    setState(() => contactExpanded = !contactExpanded),
                text: '''
We welcome your inquiries, suggestions, or technical support requests.
📧 Email: supportmodrik@gmail.com
We will respond as soon as possible.
''',
              ),
              _expandTile(
                title: 'About App',
                expanded: aboutExpanded,
                onTap: () => setState(() => aboutExpanded = !aboutExpanded),
                text: '''
Modrik is an app that helps users understand genetic test results in a simple and easy wayIt uses artificial intelligence to analyze genetic data and transform it into clear reports that support health awareness and preventative decision-making
The app also allows users to compare results between parents to estimate the likelihood of inheriting certain genetic diseases.
''',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tile({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        color: mainPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          child,
        ],
      ),
    );
  }

  Widget _expandTile({
    required String title,
    required String text,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mainPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Icon(expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontSize: 13, height: 1.4)),
          ],
        ],
      ),
    );
  }
}