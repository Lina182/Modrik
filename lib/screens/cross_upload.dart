import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/cross_report_item.dart';
import 'cross_report_screen.dart';

class CrossUploadScreen extends StatefulWidget {
  const CrossUploadScreen({super.key});

  @override
  State<CrossUploadScreen> createState() => _CrossUploadScreenState();
}

class _CrossUploadScreenState extends State<CrossUploadScreen> {
  static const Color mainPurple = Color(0xFF9DA3D9);

  PlatformFile? maleFile;
  PlatformFile? femaleFile;

  final String apiUrl = "http://172.237.116.141:8003/analyze_cross/";

  // =========================
  // اختيار ملف الأب
  // =========================
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

  // =========================
  // اختيار ملف الأم
  // =========================
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

  // =========================
  // نافذة اللودنق
  // =========================
  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) {
        return Center(
          child: Container(
            width: 220,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 18),
                Text(
                  "Analyzing couple files...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // تحليل الملفين وإرسالهم للباك
  // =========================
  Future<void> analyzeCrossFiles() async {
    if (maleFile == null || femaleFile == null) return;

    showLoading();

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

      Navigator.pop(context); // يقفل اللودنق

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final crossResults = data['cross_results'];

        List<CrossReportItem> reports = [];

        /// =========================
        /// Autosomal Dominant
        /// =========================
        for (var item in crossResults['autosomal_dominant']) {
          reports.add(
            CrossReportItem.fromJson(item, "Autosomal Dominant Risks"),
          );
        }

        /// =========================
        /// Autosomal Recessive
        /// =========================
        for (var item in crossResults['autosomal_recessive']) {
          reports.add(
            CrossReportItem.fromJson(item, "Autosomal Recessive Risks"),
          );
        }

        /// =========================
        /// X-Linked Recessive
        /// =========================
        for (var item in crossResults['x_linked_recessive']) {
          reports.add(
            CrossReportItem.fromJson(item, "X-Linked Recessive Risks"),
          );
        }

        /// =========================
        /// X-Linked Dominant
        /// =========================
        for (var item in crossResults['x_linked_dominant']) {
          reports.add(
            CrossReportItem.fromJson(item, "X-Linked Dominant Risks"),
          );
        }

        /// =========================
        /// Both Uncertain
        /// =========================
        for (var item in crossResults['both_uncertain']) {
          reports.add(
            CrossReportItem.fromJson(item, "Uncertain / Both Pattern Risks"),
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CrossReportScreen(reports: reports),
          ),
        );
      } else {
        showError("Failed to analyze files");
      }
    } catch (e) {
      Navigator.pop(context); // يقفل اللودنق إذا صار خطأ
      showError("Something went wrong");
    }
  }

  // =========================
  // نافذة الخطأ
  // =========================
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

  // =========================
  // واجهة الصفحة
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          /// =========================
          /// الهيدر البنفسجي
          /// =========================
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: mainPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: Image.asset("assets/header_pattern.png", fit: BoxFit.cover),
          ),

          /// =========================
          /// الكارد الأبيض
          /// =========================
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  /// =========================
                  /// رجوع + عنوان
                  /// =========================
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: Text(
                          "Cross Upload",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// =========================
                  /// مربع رفع الملفين
                  /// =========================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 🔥 هذا حل الشريط الأصفر
                      children: [
                        const Icon(Icons.cloud_upload_outlined, size: 50),
                        const SizedBox(height: 12),
                        const Text(
                          "Select your VCF files",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// زر ملف الأب
                        OutlinedButton(
                          onPressed: pickMaleFile,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            maleFile == null
                                ? "Choose Father File"
                                : maleFile!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// زر ملف الأم
                        OutlinedButton(
                          onPressed: pickFemaleFile,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            femaleFile == null
                                ? "Choose Mother File"
                                : femaleFile!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// =========================
                  /// الأزرار تحت
                  /// =========================
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (maleFile == null || femaleFile == null)
                              ? null
                              : analyzeCrossFiles,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F4F6F),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Continue"),
                        ),
                      ),
                    ],
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
