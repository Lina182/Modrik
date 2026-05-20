import 'package:flutter/material.dart';
import 'dart:async';
import '../../l10n/app_localizations.dart';
import '../../widgets/header_section.dart';
import '../../widgets/ExpertBottomNavBar.dart';
import '../../services/expert_consultation_service.dart';
import 'ExpertRequestDetailsScreen.dart';
import '../../services/consultation_service.dart';

class ExpertHomeScreen extends StatefulWidget {
  final int initialTab;

  const ExpertHomeScreen({super.key, this.initialTab = 0});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  late int selectedTab;

  List consultations = [];

  bool isLoading = true;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
    loadConsultations();
    refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadConsultations();
    });
  }

  Future loadConsultations() async {
    setState(() {
      isLoading = true;
    });

    try {
      final expertId = await getUserId();

      /// WAITING
      if (selectedTab == 0) {
        consultations =
            await ExpertConsultationService.getWaitingConsultations();
      }

      /// ACTIVE
      else if (selectedTab == 1) {
        consultations = await ExpertConsultationService.getActiveConsultations(
          expertId,
        );
      }

      /// COMPLETED
      else {
        consultations =
            await ExpertConsultationService.getCompletedConsultations(expertId);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    List currentList = consultations;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: Column(
        children: [
          /// ===== HEADER =====
          HeaderSection(
            title: "",

            bigTitle: selectedTab == 0
                ? t.newRequests
                : selectedTab == 1
                    ? t.activeConsultations
                    : t.completedConsultations,

            subtitle: selectedTab == 0
                ? t.reviewRequests
                : selectedTab == 1
                    ? t.continueConsultations
                    : t.viewCompletedConsultations,

            bigTitleSize: 30,

            subtitleSize: 15,

            headerHeight: 170,

            customPadding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 60,
            ),
          ),

          const SizedBox(height: 22),

          /// ===== BODY =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),

              itemCount: isLoading ? 1 : currentList.length,

              itemBuilder: (context, index) {
                /// 🔥 LOADING
                if (isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),

                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                bool isWaiting = selectedTab == 0;

                bool isActive = selectedTab == 1;

                var item = currentList[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpertRequestDetailsScreen(
                          consultation: item,
                        ),
                      ),
                    );

                    loadConsultations();
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 18),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.04),

                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        /// ===== TOP ROW =====
                        Row(
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

                              child: Center(
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
                            ),

                            const SizedBox(width: 14),

                            /// ===== TEXTS =====
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  /// CASE ID
                                  Text(
                                    "${t.caseNumber} #${item["id"]}",

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  /// REPORT TYPE
                                  Text(
                                    item["report_type"] == "cross"
                                        ? t.crossAnalysisReport
                                        : t.individualAnalysis,

                                    style: const TextStyle(
                                      color: Color(0xFF6C63FF),

                                      fontWeight: FontWeight.w600,

                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  /// DATE
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,

                                        size: 13,

                                        color: Colors.grey.shade500,
                                      ),

                                      const SizedBox(width: 5),

                                      Expanded(
                                        child: Text(
                                          item["created_at"].toString(),

                                          overflow: TextOverflow.ellipsis,

                                          style: TextStyle(
                                            fontSize: 12,

                                            color: Colors.grey.shade600,
                                          ),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// ===== MESSAGE BOX =====
                        if (selectedTab != 2 && item["user_question"] != null) ...[
                          const SizedBox(height: 18),

                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8FC),

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item["user_question"] ??
                                        t.noQuestionProvided,

                                    style: TextStyle(
                                      color: Colors.grey.shade800,

                                      fontSize: 13,

                                      height: 1.4,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Container(
                                  width: 38,
                                  height: 38,

                                  decoration: BoxDecoration(
                                    color: Colors.white,

                                    borderRadius: BorderRadius.circular(14),
                                  ),

                                  child: const Icon(
                                    Icons.chat_bubble_outline,

                                    color: Color(0xFF6C63FF),

                                    size: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: ExpertBottomNavBar(currentIndex: selectedTab),
    );
  }
}