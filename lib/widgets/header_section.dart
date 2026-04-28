import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';
import '../screens/settings_profile.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? bigTitle; // زي "Modrik" (اختياري)

  const HeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.bigTitle,
  });

  static const Color mainPurple = Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: size.height * 0.20,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE6E7FF), Color(0xFFF7F8FF)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),

        /// DNA
        Positioned(
          right: -40,
          top: size.height * 0.15 - 170,
          child: Transform.rotate(
            angle: 0.6,
            child: FaIcon(
              FontAwesomeIcons.dna,
              size: 270,
              color: mainPurple.withOpacity(0.15),
            ),
          ),
        ),

        /// SETTINGS
        Positioned(
          top: 16,
          right: 16,
          child: Icon(Icons.settings_outlined, size: 24),
        ),

        /// TEXT
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.1,
                ),
              ),

              if (bigTitle != null)
                Text(
                  bigTitle!,
                  style: TextStyle(
                    fontSize: size.width * 0.14,
                    fontWeight: FontWeight.bold,
                    color: mainPurple,
                    height: 1.1,
                  ),
                ),

              const SizedBox(height: 4),

              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
