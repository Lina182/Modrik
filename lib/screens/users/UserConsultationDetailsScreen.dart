import 'package:flutter/material.dart';
import '../../services/consultation_service.dart';
import '../shared/chat_screen.dart';
import '../users/individual_report_screen.dart';
import '../users/cross_report_screen.dart';
import '../../models/individual_report_item.dart';
import '../../models/cross_report_item.dart';
import '../../l10n/app_localizations.dart';
class UserConsultationDetailsScreen extends StatelessWidget {
  final Map consultation;

  const UserConsultationDetailsScreen({
    super.key,
    required this.consultation,
  });

  bool get isWaiting => consultation["status"] == "waiting";
  bool get isActive => consultation["status"] == "active";
  bool get isCompleted => consultation["status"] == "completed";

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final reportData = consultation["report_data"];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= TOP BAR =================
              Row(
                children: [

                  /// BACK BUTTON
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),

                  /// TITLE
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        t.details,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  /// STATUS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: isWaiting
                          ? const Color(0xFFFFF3E6)
                          : isActive
                              ? const Color(0xFFEDEBFF)
                              : const Color(0xFFEAF8EE),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      isWaiting
                          ? t.waiting
                          : isActive
                              ? t.active
                              : t.completed,

                      style: TextStyle(
                        color: isWaiting
                            ? Colors.orange
                            : isActive
                                ? const Color(0xFF6C63FF)
                                : Colors.green,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ================= REPORT =================
              Text(
                t.report,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [

/// ICON
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: isWaiting
                            ? const Color(0xFFFFF3E6): isActive
                                ? const Color(0xFFEDEBFF)
                                : const Color(0xFFEAF8EE),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: isWaiting
                            ? Colors.orange
                            : isActive
                                ? const Color(0xFF6C63FF)
                                : Colors.green,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// TEXTS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            consultation["report_name"] ?? t.report,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "${t.caseText} #${consultation["id"]}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    OutlinedButton(
                      onPressed: () {
                        if (reportData == null) return;

                        if (consultation["report_type"] == "cross") {
                          final reports = (reportData as List)
                              .map((e) => CrossReportItem.fromJson(
                                    Map<String, dynamic>.from(e),
                                    consultation["report_name"] ?? "",
                                  ))
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CrossReportScreen(
                                reports: reports,
                                fileName: consultation["report_name"] ?? "",
                                showDownload: false,
                                isExpertView: false,
                              ),
                            ),
                          );
                        } else {
                          final reports = (reportData as List)
                              .map((e) => IndividualReportItem.fromJson(
                                    Map<String, dynamic>.from(e),
                                    null,
                                  ))
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => IndividualReportScreen(
                                reportItems: reports,
                                fileName: consultation["report_name"] ?? "",
                                showDownload: false,
                                isExpertView: false,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(t.viewReport),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

/// ================= QUESTION =================
              Text(
                t.myQuestion,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              /// QUESTION BOX
              Container(width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEBFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// QUOTE ICON INSIDE BOX
                    const Icon(
                      Icons.format_quote_rounded,
                      color: Color(0xFF6C63FF),
                      size: 30,
                    ),

                    const SizedBox(height: 10),

                    /// QUESTION TEXT
                    Text(
                      consultation["user_question"] ?? t.noQuestion,
                      style: const TextStyle(
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// DATE INSIDE BOX
                    Text(
                      consultation["created_at"]?.toString() ?? "",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ================= NOTES =================
              Text(
                t.notes,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF6C63FF),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        isWaiting
                            ? t.waitingNote
                            : isActive
                                ? t.activeNote
                                : t.completedNote,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

/// ================= CHAT =================
if (isActive || isCompleted)
Center(
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            title: consultation["title"] ?? "",
            consultationId: consultation["id"],
            status: consultation["status"],
            reportData: consultation,
            isCompleted: isCompleted,
            expertName: consultation["expert_name"] ?? "Expert",
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6C63FF),
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    child: Text(
      isCompleted ? t.viewChat : t.openChat,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}