import 'package:flutter/material.dart';

class AnalysisHeader extends StatelessWidget {
  const AnalysisHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE6E7FF), Color(0xFFC8CDFF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}
