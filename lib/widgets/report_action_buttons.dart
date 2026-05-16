import 'package:flutter/material.dart';
const Color mainPurple = Color(0xFF6C63FF);
class ReportActionButtons extends StatelessWidget {
  final VoidCallback? onDownloadPdf;
  final VoidCallback onAskAi;
  final Function(String question) onConsultExpert;
  final String pdfLabel;
  final String aiLabel;
  final bool isExpertView;

  const ReportActionButtons({
    super.key,
    this.onDownloadPdf,
    required this.onAskAi,
    required this.onConsultExpert,
    required this.pdfLabel,
    required this.aiLabel,
    this.isExpertView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onDownloadPdf != null)
          _MainActionButton(
            icon: Icons.download_rounded,
            label: pdfLabel,
            onPressed: onDownloadPdf!,
          ),

        const SizedBox(height: 12),

        if (!isExpertView)
          Row(
            children: [
              Expanded(
                child: _SecondaryActionButton(
                  icon: Icons.smart_toy_outlined,
                  label: aiLabel,
                  onPressed: onAskAi,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _SecondaryActionButton(
                  icon: Icons.medical_services_outlined,
                  label: 'Consult Expert',
                  onPressed: () {
                    final questionController = TextEditingController();

                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          title: const Text(
                            'Ask the Expert',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          content: TextField(
                            controller: questionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Write your question here...',
                              filled: true,
                              fillColor: const Color(0xFFF7F8FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E6F5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: mainPurple,
                                  width: 1.4,
                                ),
                              ),
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
                                final question =
                                    questionController.text.trim();

                                if (question.isEmpty) {
                                  return;
                                }

                                onConsultExpert(question);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Send'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

        const SizedBox(height: 8),
      ],
    );
  }
}

class _MainActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MainActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 23),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFEDEBFF),
          foregroundColor: mainPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SecondaryActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 21),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: mainPurple,
          side: const BorderSide(
            color: Color(0xFFE3E0FF),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}