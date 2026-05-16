import 'dart:convert';
import 'package:flutter/material.dart';

import '../../services/db_service.dart';
import '../../models/individual_report_item.dart';
import '../../models/cross_report_item.dart';

import 'individual_report_screen.dart';
import 'cross_report_screen.dart';

import '../../widgets/analysis_header.dart';
import '../../widgets/bottom_nav_bar.dart';

import '../../l10n/app_localizations.dart';

class SavedReportsScreen extends StatefulWidget {
  final bool selectionMode;

  const SavedReportsScreen({
    super.key,
    this.selectionMode = false,
  });

  @override
  State<SavedReportsScreen> createState() =>
      _SavedReportsScreenState();
}

class _SavedReportsScreenState
    extends State<SavedReportsScreen> {
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    final data = await DBService.getReports();

    setState(() {
      reports = data;
    });
  }

  String detectType(
    Map<String, dynamic> item,
    List jsonData,
  ) {
    final savedType = item['type'];

    if (savedType != null) {
      return savedType.toString();
    }

    if (jsonData.isNotEmpty) {
      final firstItem = jsonData.first;

      if (firstItem is Map &&
          (firstItem.containsKey('affectedRisk') ||
              firstItem.containsKey('carrierRisk') ||
              firstItem.containsKey('healthyRisk') ||
              firstItem.containsKey('sectionTitle'))) {
        return 'cross';
      }
    }

    return 'individual';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),

      body: Column(
        children: [
          /// HEADER
          Stack(
            children: const [
              AnalysisHeader(),
            ],
          ),

          /// CONTENT
          Expanded(
            child: Container(
              transform:
                  Matrix4.translationValues(0, -120, 0),

              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                5,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: reports.isEmpty

                  /// EMPTY
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),

                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context)
                                      .size
                                      .height *
                                  0.55,

                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.folder_open_outlined,
                                size: 90,
                                color: Colors.grey.shade400,
                              ),

                              const SizedBox(height: 20),

                              Text(
                                t.noSavedReports,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                t.savedReportsDesc,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),],
                          ),
                        ),
                      ],
                    )

                  /// LIST
                  : ListView.builder(
                      itemCount: reports.length,

                      itemBuilder: (context, index) {
                        final item = reports[index];

                        final title =
                            item['title']?.toString() ??
                                t.savedReport;

                        final jsonData =
                            jsonDecode(item['data']
                                .toString());

                        final type =
                            detectType(item, jsonData);

                        /// ================= INDIVIDUAL =================
                        if (type == 'individual') {
                          List<IndividualReportItem>
                              reportItems = [];

                          for (var r in jsonData) {
                            reportItems.add(
                              IndividualReportItem(
                                gene:
                                    r['gene']
                                            ?.toString() ??
                                        t.notAvailable,

                                disease:
                                    r['disease']
                                            ?.toString() ??
                                        t.notAvailable,

                                clinicalSignificance:
                                    r['clinicalSignificance']
                                            ?.toString() ??
                                        t.notAvailable,

                                inheritance:
                                    r['inheritance']
                                            ?.toString() ??
                                        t.notAvailable,

                                confidenceLevel:
                                    r['confidenceLevel']
                                            ?.toString() ??
                                        t.notAvailable,
                              ),
                            );
                          }

                          return _buildCard(
                            icon: Icons.person,
                            title: title,
                            subtitle: t.genesCount(
                              reportItems.length,
                            ),

                            onTap: () {
                              /// اختيار للشات
                              if (widget.selectionMode) {
                                Navigator.pop(
                                  context,
                                  item,
                                );
                                return;
                              }

                              /// الوضع العادي
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      IndividualReportScreen(
                                    reportItems:
                                        reportItems,

                                    fileName: title,
                                    showDownload:
                                        false,
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        /// ================= CROSS =================
                        else {
                          List<CrossReportItem>
                              reportItems = [];

                          for (var r in jsonData) {
                            reportItems.add(
                              CrossReportItem(
                                sectionTitle:r['sectionTitle']
                                            ?.toString() ??
                                        '',

                                disease:
                                    r['disease']
                                            ?.toString() ??
                                        t.unknown,

                                gene:
                                    r['gene']
                                            ?.toString() ??
                                        t.unknown,

                                inheritance:
                                    r['inheritance']
                                            ?.toString() ??
                                        t.unknown,

                                clinicalSignificance:
                                    r['clinicalSignificance']
                                            ?.toString() ??
                                        t.unknown,

                                affectedRisk:
                                    r['affectedRisk']
                                            ?.toString() ??
                                        '0%',

                                carrierRisk:
                                    r['carrierRisk']
                                            ?.toString() ??
                                        '0%',

                                healthyRisk:
                                    r['healthyRisk']
                                            ?.toString() ??
                                        '0%',

                                explainRisk:
                                    r['explainRisk']
                                            ?.toString() ??
                                        t.noExplanation,
                              ),
                            );
                          }

                          return _buildCard(
                            icon:
                                Icons.family_restroom,

                            title: title,

                            subtitle:
                                t.conditionsCount(
                              reportItems.length,
                            ),

                            onTap: () {
                              /// اختيار للشات
                              if (widget.selectionMode) {
                                final parsedData =
                                    jsonDecode(
                                  item['data'],
                                );

                                Navigator.pop(
                                  context,
                                  {
                                    "title":
                                        item['title'],
                                    "data":
                                        parsedData,
                                  },
                                );

                                return;
                              }

                              /// الوضع العادي
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CrossReportScreen(
                                    reports:
                                        reportItems,

                                    fileName: title,
                                    showDownload:
                                        false,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
            ),
          ),
        ],
      ),

      bottomNavigationBar:
          const BottomNavBar(currentIndex: 1),
    );
  }

  /// CARD UI
  Widget _buildCard({
    required IconData icon,
    required String title,required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: const Color(0xFFC8CDFF),
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),

      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF6C63FF),
        ),

        title: Text(title),

        subtitle: Text(subtitle),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        onTap: onTap,
      ),
    );
  }
}