import 'package:flutter/material.dart';

class AnalysisButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AnalysisButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? Colors.grey.shade300
              : const Color(0xFF6C63FF),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        child: Text(
          text,
          style: TextStyle(
            color: onPressed == null
                ? const Color.fromARGB(255, 0, 0, 0)
                : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
