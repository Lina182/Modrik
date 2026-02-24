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

  // ===== States for expandable tiles =====
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
                color: bgPurple.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            children: [
              _languageTile(),
              _modeTile(),
              _switchTile('Notifications'),
              _expandableTile(
                title: 'Privacy',
                description: '''
The Modrik app is committed to protecting user privacy
Genetic data and personal information are handled with the utmost confidentiality and using high security standards
Data is not shared with any third party without the user's consent
By using the app, you agree to the Privacy Policy.
''',
                expanded: privacyExpanded,
                onTap: () => setState(() => privacyExpanded = !privacyExpanded),
              ),
              _expandableTile(
                title: 'Contact Us',
                description: '''
We welcome your inquiries, suggestions, or technical support requests.
📧 Email: supportmodrik@gmail.com
We will respond as soon as possible.
''',
                expanded: contactExpanded,
                onTap: () => setState(() => contactExpanded = !contactExpanded),
              ),
              _expandableTile(
                title: 'About App',
                description: '''
Modrik is an app that helps users understand genetic test results in a simple and easy way
It uses artificial intelligence to analyze genetic data and transform it into clear reports that support health awareness and preventative decision-making
The app also allows users to compare results between parents to estimate the likelihood of inheriting certain genetic diseases.
''',
                expanded: aboutExpanded,
                onTap: () => setState(() => aboutExpanded = !aboutExpanded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget_tile(String title) {
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
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }Widget _switchTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        color: mainPurple,borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Switch(
            value: notifications,
            onChanged: (v) {
              setState(() => notifications = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _languageTile() {
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
          const Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: language,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'English', child: Text('English')),
              DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => language = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _modeTile() {
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
          const Text('Mode', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: mode,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'Light', child: Text('Light')),
              DropdownMenuItem(value: 'Dark', child: Text('Dark')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => mode = value);
            },
          ),
        ],
      ),
    );
  }

  // ===== Expandable Tile Widget =====
  Widget _expandableTile({
    required String title,
    required String description,
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}