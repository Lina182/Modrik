import 'package:flutter/material.dart';
import '../../screens/expert/ExpertProfile.dart';
import '../../screens/expert/ExpertHomeScreen.dart';
import '../../l10n/app_localizations.dart';

class ExpertBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const ExpertBottomNavBar({super.key, required this.currentIndex});

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;

    /// PROFILE
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Expertprofile()),
      );
      return;
    }

    /// HOME WITH TAB
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExpertHomeScreen(initialTab: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(context, Icons.hourglass_top, t.waiting, 0),
          _item(context, Icons.work_history, t.active, 1),
          _item(context, Icons.check_circle_rounded, t.completed, 2),
          _item(context, Icons.person, t.profile, 3),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final active = currentIndex == index;

    return GestureDetector(
      onTap: () => _go(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: active ? const Color(0xFF6C63FF) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              color: active ? const Color(0xFF6C63FF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}