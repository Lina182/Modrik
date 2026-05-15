import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/individual_report_item.dart';
import 'individual_report_screen.dart';

import '../widgets/analysis_header.dart';
import '../widgets/analysis_upload_box.dart';
import '../widgets/analysis_button.dart';
import '../widgets/analysis_loading.dart';

import '../l10n/app_localizations.dart';

class IndividualUploadScreen extends StatefulWidget {
  const IndividualUploadScreen({super.key});

  @override
  State<IndividualUploadScreen> createState() =>
      _IndividualUploadScreenState();
}

class _IndividualUploadScreenState extends State<IndividualUploadScreen> {
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['vcf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.single;
      });
    }
  }

  Future<List<IndividualReportItem>> uploadFile() async {
    var uri = Uri.parse("http://172.237.116.141:8003/analyze_vcf/");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('file', selectedFile!.path!),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      final decodedData = jsonDecode(responseBody);

      final List<dynamic> resultsList = decodedData['results'] ?? [];
      final Map<String, dynamic> panelResponses =
          decodedData['panelapp_responses'] ?? {};

      final List<IndividualReportItem> reportItems = resultsList.map((item) {
        final String gene = item['base__hugo']?.toString() ?? '';

        final Map<String, dynamic>? panelInfo =
            panelResponses[gene] as Map<String, dynamic>?;

        return IndividualReportItem.fromJson(item, panelInfo);
      }).toList();

      return reportItems;
    } else {
      throw Exception("Upload failed: ${response.statusCode}");
    }
  }

  Future<void> uploadAndNavigate() async {
    final t = AppLocalizations.of(context)!;

    AnalysisLoading.show(context);

    try {
      final reportItems = await uploadFile();

      AnalysisLoading.hide(context);

      String fileName =
          selectedFile!.name.replaceAll('.vcf', '');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IndividualReportScreen(
            reportItems: reportItems,
            fileName: fileName,
          ),
        ),
      );
    } catch (e) {
      AnalysisLoading.hide(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${t.error}: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),

      body: Column(
        children: [
          Stack(
            children: [
              const AnalysisHeader(),
              SafeArea(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),

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
                  Text(
                    t.individualAnalysis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    t.individualAnalysisText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  AnalysisUploadBox(
                    title: t.selectFiles,
                    onTap: pickFile,
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedFile?.name ?? t.selectFiles,
                          ),
                        ),
                        if (selectedFile != null)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),

                  const Spacer(),

                  AnalysisButton(
                    text: t.continueBtn,
                    onPressed: selectedFile == null
                        ? null
                        : uploadAndNavigate,
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