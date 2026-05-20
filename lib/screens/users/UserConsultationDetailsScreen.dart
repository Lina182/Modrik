import 'package:flutter/material.dart';
import '../../services/consultation_service.dart';
import '../shared/chat_screen.dart';
import '../users/individual_report_screen.dart';
import '../users/cross_report_screen.dart';
import '../../models/individual_report_item.dart';
import '../../models/cross_report_item.dart';

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
                        "Details",
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
                          ? "Waiting"
                          : isActive
                              ? "Active"
                              : "Completed",

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
              const Text(
                "Report",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                            ? const Color(0xFFFFF3E6)
                            : isActive
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
                            consultation["report_name"] ?? "Report",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "Case #${consultation["id"]}",
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
                      child: const Text("View Report"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ================= QUESTION =================
             const Text(
                "My Question",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              /// QUESTION BOX
              Container(
                width: double.infinity,
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
                      consultation["user_question"] ?? "No question provided",
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
              const Text(
                "Notes",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            ? "Please wait patiently while an expert reviews your request."
                            : isActive
                                ? "This consultation is active. Now you can chat with the expert."
                                : "This consultation is already completed.",
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

                  consultationId: consultation["id"],
                  title: consultation["report_name"] ?? "",
                  status: consultation["status"] ?? "",
                  reportData: consultation,
                  isCompleted: consultation["status"] == "completed",
                  expertName:
                      consultation["expert_name"] ?? "Expert",
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
      isCompleted ? "View Chat" : "Open Chat",
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