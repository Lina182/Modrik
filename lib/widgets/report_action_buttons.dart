import 'package:flutter/material.dart';

const Color mainPurple = Color(0xFF9DA3D9);

class ReportActionButtons extends StatelessWidget {
  final VoidCallback onDownloadPdf;
  final VoidCallback onAskAi;
  final VoidCallback onConsultExpert;
  final String pdfLabel;
  final String aiLabel;

  const ReportActionButtons({
    super.key,
    required this.onDownloadPdf,
    required this.onAskAi,
    required this.onConsultExpert,
    required this.pdfLabel,
    required this.aiLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔥 زر PDF (بنفسجي)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onDownloadPdf,
            icon: const Icon(
              Icons.download,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            label: Text(
              pdfLabel,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4EFFA),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            /// 🤖 زر الشات
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAskAi,
                icon: const Icon(Icons.smart_toy_outlined),
                label: Text(aiLabel),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4EFFA), // 🔥 أبيض
                  foregroundColor: const Color.fromARGB(
                    255,
                    0,
                    0,
                    0,
                  ), // 🔥 النص + الأيقونة بنفسجي
                  side: BorderSide(color: mainPurple), // 🔥 البوردر
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 👨‍⚕️ زر الخبير
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onConsultExpert,
                icon: const Icon(Icons.medical_services_outlined),
                label: const Text('Consult Expert'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4EFFA),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  side: BorderSide(color: mainPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
