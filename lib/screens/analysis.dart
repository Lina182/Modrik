import 'package:flutter/material.dart';
import 'package:modik_pages/widgets/header_section.dart';
import '../widgets/analysis_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../theme/app_colors.dart';
import 'individual_upload.dart';
import 'cross_upload.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Stack(
        children: [
          /// HEADER
          const HeaderSection(title: "", bigTitle: "", subtitle: ""),

          /// CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 140),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          color: Colors.black.withOpacity(0.08),
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Select how you want to\nanalyze your genetic data.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// SINGLE
                        buildOptionCard(
                          icon: Icons.person_outline,
                          title: "Individual Analysis",
                          subtitle:
                              "Analyze one VCF file for a single individual.",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IndividualUploadScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        /// CROSS
                        buildOptionCard(
                          icon: Icons.group_outlined,
                          title: "Cross Analysis",
                          subtitle:
                              "Analyze two VCF files to compare shared or inherited variants.",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CrossUploadScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
        decoration: BoxDecoration(
          color: AppColors.softPurple,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: const Color(0xFF5E5CE6)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
