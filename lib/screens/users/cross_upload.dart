import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../models/cross_report_item.dart';
import 'cross_report_screen.dart';

// widgets
import '../../widgets/analysis_header.dart';
import '../../widgets/analysis_upload_box.dart';
import '../../widgets/analysis_button.dart';
import '../../widgets/analysis_loading.dart';

class CrossUploadScreen extends StatefulWidget {
  const CrossUploadScreen({super.key});

  @override
  State<CrossUploadScreen> createState() => _CrossUploadScreenState();
}

class _CrossUploadScreenState extends State<CrossUploadScreen> {
  PlatformFile? maleFile;
  PlatformFile? femaleFile;

  final String apiUrl = "http://172.237.116.141:8003/analyze_cross/";

  // اختيار الأب
  Future<void> pickMaleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['vcf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        maleFile = result.files.single;
      });
    }
  }

  // اختيار الأم
  Future<void> pickFemaleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['vcf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        femaleFile = result.files.single;
      });
    }
  }

  // التحليل (بدون تعديل)
  Future<void> analyzeCrossFiles() async {
    if (maleFile == null || femaleFile == null) return;

    AnalysisLoading.show(context);

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.files.add(
        http.MultipartFile.fromBytes(
          'male_file',
          maleFile!.bytes!,
          filename: maleFile!.name,
        ),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'female_file',
          femaleFile!.bytes!,
          filename: femaleFile!.name,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      AnalysisLoading.hide(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final crossResults = data['cross_results'];

        List<CrossReportItem> reports = [];

        for (var item in crossResults['autosomal_dominant']) {
          reports.add(
            CrossReportItem.fromJson(item, "Autosomal Dominant Risks"),
          );
        }

        for (var item in crossResults['autosomal_recessive']) {
          reports.add(
            CrossReportItem.fromJson(item, "Autosomal Recessive Risks"),
          );
        }

        for (var item in crossResults['x_linked_recessive']) {
          reports.add(
            CrossReportItem.fromJson(item, "X-Linked Recessive Risks"),
          );
        }

        for (var item in crossResults['x_linked_dominant']) {
          reports.add(
            CrossReportItem.fromJson(item, "X-Linked Dominant Risks"),
          );
        }

        for (var item in crossResults['both_uncertain']) {
          reports.add(
            CrossReportItem.fromJson(item, "Uncertain / Both Pattern Risks"),
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CrossReportScreen(reports: reports, fileName: "Cross Report"),
          ),
        );
      } else {
        showError("Failed to analyze files");
      }
    } catch (e) {
      AnalysisLoading.hide(context);
      showError("Something went wrong");
    }
  }

  // الخطأ
  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),

      body: Column(
        children: [
          /// ===== HEADER =====
          Stack(
            children: [
              const AnalysisHeader(),

              SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// BODY
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -40, 0),
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                children: [
                  const Text(
                    "Cross Upload",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Upload two VCF files to compare shared or inherited variants.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  AnalysisUploadBox(
                    title: "Select your VCF files",
                    onTap: () {},

                    children: [
                      /// الأب
                      OutlinedButton(
                        onPressed: pickMaleFile,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                maleFile == null
                                    ? "Choose Father File"
                                    : maleFile!.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (maleFile != null)
                              const Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// الأم
                      OutlinedButton(
                        onPressed: pickFemaleFile,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                femaleFile == null
                                    ? "Choose Mother File"
                                    : femaleFile!.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (femaleFile != null)
                              const Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  ///  BUTTON
                  AnalysisButton(
                    text: "Continue",
                    onPressed: (maleFile == null || femaleFile == null)
                        ? null
                        : analyzeCrossFiles,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
