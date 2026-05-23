import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AnalysisLoading {
  static void show(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.25),

      builder: (_) {
        return Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Color(0xFF6C63FF),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  t.analyzingDna,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  t.pleaseWait,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}