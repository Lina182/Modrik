import 'dart:convert';
import 'package:flutter/material.dart';

import '../services/db_service.dart';

import '../models/individual_report_item.dart';
import '../models/cross_report_item.dart';

import '../screens/individual_report_screen.dart';
import '../screens/cross_report_screen.dart';

class SavedReportsScreen extends StatefulWidget {
  const SavedReportsScreen({super.key});

  @override
  State<SavedReportsScreen> createState() => _SavedReportsScreenState();
}

class _SavedReportsScreenState extends State<SavedReportsScreen> {
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

  String detectType(Map<String, dynamic> item, List jsonData) {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Reports')),

      body: reports.isEmpty
          ? const Center(child: Text('No saved reports yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final item = reports[index];

                final title = item['title']?.toString() ?? 'Saved Report';

                final jsonData = jsonDecode(item['data'].toString());

                final type = detectType(item, jsonData);

                if (type == 'individual') {
                  List<IndividualReportItem> reportItems = [];

                  for (var r in jsonData) {
                    reportItems.add(
                      IndividualReportItem(
                        gene: r['gene']?.toString() ?? 'Not available',
                        disease: r['disease']?.toString() ?? 'Not available',
                        clinicalSignificance:
                            r['clinicalSignificance']?.toString() ??
                            'Not available',
                        inheritance:
                            r['inheritance']?.toString() ?? 'Not available',
                        confidenceLevel:
                            r['confidenceLevel']?.toString() ?? 'Not available',
                      ),
                    );
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(title),
                      subtitle: Text('${reportItems.length} genes'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => IndividualReportScreen(
                              reportItems: reportItems,
                              fileName: title,
                              showDownload: false,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  List<CrossReportItem> reportItems = [];

                  for (var r in jsonData) {
                    reportItems.add(
                      CrossReportItem(
                        sectionTitle: r['sectionTitle']?.toString() ?? '',
                        disease: r['disease']?.toString() ?? 'Unknown',
                        gene: r['gene']?.toString() ?? 'Unknown',
                        inheritance: r['inheritance']?.toString() ?? 'Unknown',
                        clinicalSignificance:
                            r['clinicalSignificance']?.toString() ?? 'Unknown',
                        affectedRisk: r['affectedRisk']?.toString() ?? '0%',
                        carrierRisk: r['carrierRisk']?.toString() ?? '0%',
                        healthyRisk: r['healthyRisk']?.toString() ?? '0%',
                        explainRisk:
                            r['explainRisk']?.toString() ??
                            'No explanation available',
                      ),
                    );
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.family_restroom),
                      title: Text(title),
                      subtitle: Text('${reportItems.length} conditions'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CrossReportScreen(
                              reports: reportItems,
                              fileName: title,
                              showDownload: false,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
    );
  }
}
