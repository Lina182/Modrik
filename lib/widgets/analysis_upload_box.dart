import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AnalysisUploadBox extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final List<Widget>? children;

  const AnalysisUploadBox({
    super.key,
    required this.title,
    required this.onTap,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 45,
            color: Color(0xFF6C63FF),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            t.supportedFormatVc,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 15),

          if (children != null)
            ...children!
          else
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC3C6F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(t.chooseFile),
            ),
        ],
      ),
    );
  }
}