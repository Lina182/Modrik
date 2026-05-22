import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

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
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        // DOWNLOAD BUTTON
        if (onDownloadPdf != null)
          _MainActionButton(
            icon: Icons.download_rounded,
            label: pdfLabel,
            onPressed: onDownloadPdf!,
          ),
        const SizedBox(height: 12),
        // AI + EXPERT
        if (!isExpertView)
          Row(
            children: [
              // ASK AI
              Expanded(
                child: _SecondaryActionButton(
                  icon: Icons.smart_toy_outlined,
                  label: t.askAiAboutReport,
                  onPressed: onAskAi,
                ),
              ),
              const SizedBox(width: 12),
              // CONSULT EXPERT
              Expanded(
                child: _SecondaryActionButton(
                  icon: Icons.medical_services_outlined,
                  label: t.consultExpert,
                  onPressed: () {
                    final questionController = TextEditingController();
                    showDialog(
                      context: context,

                      builder: (_) {
                        bool isAgreed = false;

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),

                              title: Text(
                                t.askTheExpert,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26,
                                  color: mainPurple,
                                ),
                              ),

                              content: Column(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  /// QUESTION FIELD
                                  TextField(
                                    controller: questionController,

                                    maxLines: 4,

                                    decoration: InputDecoration(
                                      hintText: t.writeQuestionHere,

                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9B9BB3),
                                        fontWeight: FontWeight.w500,
                                      ),

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

                                  const SizedBox(height: 16),

                                  /// DISCLAIMER
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Checkbox(
                                        value: isAgreed,

                                        activeColor: mainPurple,

                                        onChanged: (value) {
                                          setState(() {
                                            isAgreed = value ?? false;
                                          });
                                        },
                                      ),

                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                          ),

                                          child: Text(
                                            t.consultationDisclaimer,

                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              actionsPadding: const EdgeInsets.fromLTRB(
                                18,
                                0,
                                18,
                                18,
                              ),

                              actions: [
                                Row(
                                  children: [
                                    /// CANCEL
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },

                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),

                                        child: Text(
                                          t.cancel,

                                          style: const TextStyle(
                                            color: Color(0xFF7B61FF),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    /// SEND BUTTON
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: isAgreed
                                            ? () {
                                                final question =
                                                    questionController.text
                                                        .trim();

                                                if (question.isEmpty) {
                                                  return;
                                                }

                                                onConsultExpert(question);

                                                Navigator.pop(context);
                                              }
                                            : null,

                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,

                                          backgroundColor: Colors.transparent,

                                          shadowColor: Colors.transparent,

                                          disabledBackgroundColor:
                                              Colors.transparent,

                                          padding: EdgeInsets.zero,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),

                                        child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),

                                            color: isAgreed
                                                ? null
                                                : Colors.grey.shade400,

                                            gradient: isAgreed
                                                ? const LinearGradient(
                                                    colors: [
                                                      Color(0xFF8B6BFF),
                                                      Color(0xFF6C63FF),
                                                    ],
                                                  )
                                                : null,
                                          ),

                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),

                                            alignment: Alignment.center,

                                            child: Text(
                                              t.send,

                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
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

// MAIN BUTTON
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
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
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

// SECONDARY BUTTON
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
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: mainPurple,
          side: const BorderSide(color: Color(0xFFE3E0FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
