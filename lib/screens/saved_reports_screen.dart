import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/individual_report_item.dart';
import '../screens/individual_report_screen.dart';

class SavedReportsScreen extends StatefulWidget {
  const SavedReportsScreen({super.key});

  @override
  State<SavedReportsScreen> createState() => _SavedReportsScreenState();
}

class _SavedReportsScreenState extends State<SavedReportsScreen> {
  // 👇 قائمة وحدة فقط
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    final db = await openDatabase('reports.db');

    final data = await db.query('reports');

    setState(() {
      reports = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Reports')),

      body: reports.isEmpty
          ? const Center(child: Text('No saved reports'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final item = reports[index];

                // 👇 الاسم من الداتابيس
                final title = item['title'] ?? 'Saved Report';

                // 👇 نحول JSON إلى List
                final jsonData = jsonDecode(item['data']);

                List<IndividualReportItem> reportItems = [];

                for (var r in jsonData) {
                  reportItems.add(
                    IndividualReportItem(
                      gene: r['gene'],
                      disease: r['disease'],
                      clinicalSignificance: r['clinicalSignificance'],
                      inheritance: r['inheritance'],
                      confidenceLevel: r['confidenceLevel'],
                    ),
                  );
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.description),

                    // 👇 الاسم الحقيقي
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
              },
            ),
    );
  }
}
