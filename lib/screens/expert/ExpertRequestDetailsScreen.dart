import 'package:flutter/material.dart';
import '../../services/consultation_service.dart';
import '../../l10n/app_localizations.dart';
import '../../services/expert_consultation_service.dart';
import '../../services/consultation_service.dart'; // ✔️ مهم جدًا (getUserId)
import '../users/individual_report_screen.dart';
import '../users/cross_report_screen.dart';
import '../../models/individual_report_item.dart';
import '../../models/cross_report_item.dart';
import '../shared/chat_screen.dart';

class ExpertRequestDetailsScreen extends StatelessWidget {
  final Map consultation;

  const ExpertRequestDetailsScreen({
    super.key,
    required this.consultation,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final isWaiting = consultation["status"] == "waiting";
    final isActive = consultation["status"] == "active";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ===== TOP BAR =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),

                  Text(
                    t.requestDetails,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isWaiting
                          ? Colors.orange.withOpacity(0.12)
                          : isActive
                              ? const Color(0xFFEDEBFF)
                              : Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      consultation["status"],
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

              /// ===== REPORT =====
              Text(
                t.report,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
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
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEBFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Color(0xFF6C63FF),
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            consultation["report_name"] ?? t.notAvailable,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
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
                        final reportData = consultation["report_data"];

                        if (reportData == null) return;

                        if (consultation["report_type"] == "cross") {
                          final reports = (reportData as List)
                              .map(
                                (e) => CrossReportItem.fromJson(
                                  Map<String, dynamic>.from(e),
                                  consultation["report_name"] ?? "",
                                ),
                              )
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CrossReportScreen(
                                reports: reports,
                                fileName:
                                    consultation["report_name"] ??
                                    "Cross Report",
                                showDownload: false,
                                isExpertView: true,
                              ),
                            ),
                          );
                        } else {
                          final reports = (reportData as List)
                              .map(
                                (e) => IndividualReportItem.fromJson(
                                  Map<String, dynamic>.from(e),
                                  null,
                                ),
                              )
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => IndividualReportScreen(
                                reportItems: reports,
                                fileName:
                                    consultation["report_name"] ??
                                    "Individual Report",
                                showDownload: false,
                                isExpertView: true,
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

              Text(
                t.userQuestion,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EEFF),
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Text(
                  consultation["user_question"] ?? t.noQuestion,
                  style: const TextStyle(fontSize: 14, height: 1.7),),
              ),

              const Spacer(),

              /// ===== ACCEPT BUTTON =====
              if (isWaiting)
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () async {
                      final expertId = await getUserId();

                      final success =
                          await ExpertConsultationService.acceptConsultation(
                        consultationId: consultation["id"],
                        expertId: expertId,
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.acceptRequest)),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(t.acceptRequest),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}