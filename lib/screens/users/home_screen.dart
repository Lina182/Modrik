import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/header_section.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'analysis.dart';
import 'AI_chat_screen.dart';
import 'my_consultations.dart';
import 'saved_reports_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER
              HeaderSection(
                title: "Welcome to",
                bigTitle: "Modrik",
                subtitle: "Understand your DNA better",
              ),

              const SizedBox(height: 10),

              /// HERO CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A7FFF), Color(0xFF5E5CE6)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Analyze Your DNA",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Upload your VCF file and get clear insights.",
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AnalysisScreen(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("Start Analysis →"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.insert_drive_file,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// EXPLORE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Explore more",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// CARDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    /// 🔵 CHAT CARD
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          /// 🔥 مهم: نخزن context الأب
                          final parentContext = context;

                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),

                            /// 🔥 غيرنا الاسم هنا
                            builder: (sheetContext) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Choose chat type",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    /// 🧬 REPORT
                                    ListTile(
                                      leading: const Icon(Icons.description),
                                      title: const Text("Ask about a report"),
                                      subtitle: const Text(
                                        "Select from saved reports",
                                      ),
                                      onTap: () {
                                        Navigator.pop(
                                          sheetContext,
                                        ); // يقفل البوتوم شيت
                                        openReportSelection(
                                          parentContext,
                                        ); // يستخدم الأب
                                      },
                                    ),

                                    /// 💬 GENERAL
                                    ListTile(
                                      leading: const Icon(Icons.chat),
                                      title: const Text(
                                        "General genetic question",
                                      ),
                                      subtitle: const Text(
                                        "Ask anything about genetics",
                                      ),
                                      onTap: () {
                                        Navigator.pop(sheetContext);

                                        Navigator.push(
                                          parentContext,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AIChatScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: buildSmallCard(
                          Icons.smart_toy_outlined,
                          "Chat",
                          "Ask AI about your genetics",
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// EXPERT
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Expertchat()),
                          );
                        },
                        child: buildSmallCard(
                          Icons.person,
                          "Expert",
                          "Consult with our experts",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SECURITY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEEFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        color: AppColors.primary,
                        size: 50,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your data is private",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Your data is processed only for analysis and not stored.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 اختيار التقرير
  void openReportSelection(BuildContext context) async {
    final Map<String, dynamic>? selectedReport = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SavedReportsScreen(selectionMode: true),
      ),
    );

    if (!context.mounted) return;

    if (selectedReport != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AIChatScreen(reportData: selectedReport),
        ),
      );
    }
  }

  /// UI CARD
  static Widget buildSmallCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }
}
