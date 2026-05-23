import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? bigTitle;
  final double? headerHeight;

  /// NEW
  final double? titleSize;
  final double? subtitleSize;
  final double? bigTitleSize;

  final EdgeInsetsGeometry? customPadding;

  const HeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.bigTitle,
    this.headerHeight,

    /// NEW
    this.titleSize,
    this.subtitleSize,
    this.bigTitleSize,

    this.customPadding,
  });

  static const Color mainPurple = Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: headerHeight ?? size.height * 0.20,
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
          right:
              Directionality.of(context) == TextDirection.ltr ? -40 : null,

          left:
              Directionality.of(context) == TextDirection.rtl ? -40 : null,

          top: size.height * 0.15 - 170,

          child: Transform.rotate(
            angle: 0.6,

            child: FaIcon(
              FontAwesomeIcons.dna,

              size: 270,

              color: const Color(0xFF6C63FF).withOpacity(0.15),
            ),
          ),
        ),

        /// TEXT
        Padding(
          padding: customPadding ?? const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 8),

              /// TITLE
              Text(
                title,

                style: TextStyle(
                  fontWeight: FontWeight.bold,

                  fontSize: titleSize ?? 18,

                  height: 1.1,
                ),
              ),

              /// BIG TITLE
              if (bigTitle != null)
                Text(
                  bigTitle!,

                  style: TextStyle(
                    fontSize: bigTitleSize ?? size.width * 0.14,

                    fontWeight: FontWeight.bold,

                    color: const Color(0xFF6C63FF),

                    height: 1.1,
                  ),
                ),

              const SizedBox(height: 4),

              /// SUBTITLE
              Text(
                subtitle,
                style: TextStyle(fontSize: subtitleSize ?? 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}