import 'package:flutter/material.dart';

const Color mainPurple = Color(0xFF9DA3D9);

class ReportActionButtons extends StatelessWidget {
  final VoidCallback? onDownloadPdf;

  final VoidCallback onAskAi;

  // 🔥 صار يستقبل السؤال
  final Function(String question) onConsultExpert;

  final String pdfLabel;

  final String aiLabel;

  const ReportActionButtons({
    super.key,

    this.onDownloadPdf,

    required this.onAskAi,

    required this.onConsultExpert,

    required this.pdfLabel,

    required this.aiLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔥 زر التحميل
        if (onDownloadPdf != null)
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
            /// 🤖 AI BUTTON
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAskAi,

                icon: const Icon(Icons.smart_toy_outlined),

                label: Text(aiLabel),

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

            const SizedBox(width: 10),

            /// 👨‍⚕️ CONSULT EXPERT
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  final questionController = TextEditingController();

                  showDialog(
                    context: context,

                    builder: (_) {
                      return AlertDialog(
                        title: const Text('Ask the Expert'),

                        content: TextField(
                          controller: questionController,

                          maxLines: 4,

                          decoration: const InputDecoration(
                            hintText: 'Write your question here...',

                            border: OutlineInputBorder(),
                          ),
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: const Text('Cancel'),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              onConsultExpert(questionController.text);
                              Navigator.pop(context);
                            },

                            child: const Text('Send'),
                          ),
                        ],
                      );
                    },
                  );
                },

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
