import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  static const subtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textGrey,
    height: 1.3,
  );

  static const heroTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static const heroSubtitle = TextStyle(color: Colors.white70);
}
