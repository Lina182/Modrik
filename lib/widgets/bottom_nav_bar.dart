import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/users/home_screen.dart';
import '../screens/users/analysis.dart';
import '../screens/users/saved_reports_screen.dart';
import '../screens/users/profile.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const SavedReportsScreen();
        break;
      case 2:
        page = const AnalysisScreen();
        break;
      case 3:
        page = const ProfileScreen();
        break;
      default:
        page = const HomeScreen();
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
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
          _item(context, Icons.home, 0),
          _item(context, Icons.description_outlined, 1),
          _item(context, Icons.biotech, 2),
          _item(context, Icons.person_outline, 3),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, int i) {
    final active = currentIndex == i;

    return GestureDetector(
      onTap: () => _go(context, i),
      child: Icon(
        icon,
        size: 26,
        color: active ? AppColors.primary : Colors.grey,
      ),
    );
  }
}
