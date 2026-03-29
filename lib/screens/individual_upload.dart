import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/individual_report_item.dart';
import 'individual_report_screen.dart';

class IndividualUploadScreen extends StatefulWidget {
  const IndividualUploadScreen({super.key});

  @override
  State<IndividualUploadScreen> createState() => _IndividualUploadScreenState();
}

class _IndividualUploadScreenState extends State<IndividualUploadScreen> {
  static const Color mainPurple = Color(0xFF9DA3D9);

  PlatformFile? selectedFile;

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text("Analyzing..."),
              ],
            ),
          ),
        );
      },
    );
  }

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

      print("🔥 RAW RESPONSE:");
      print(responseBody);

      final decodedData = jsonDecode(responseBody);

      /// 🔥 هذا اللي فيه قائمة الفاريانتس
      final List<dynamic> resultsList = decodedData['results'] ?? [];

      /// 🔥 هذا اللي فيه معلومات PanelApp لكل جين
      final Map<String, dynamic> panelResponses =
          decodedData['panelapp_responses'] ?? {};

      final List<IndividualReportItem> reportItems = resultsList.map((item) {
        final String gene = item['base__hugo']?.toString() ?? '';

        /// نجيب معلومات الجين من panelapp_responses
        final Map<String, dynamic>? panelInfo =
            panelResponses[gene] as Map<String, dynamic>?;

        return IndividualReportItem.fromJson(item, panelInfo);
      }).toList();

      return reportItems;
    } else {
      throw Exception("Upload failed: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
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
                          "Individual Upload",
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

                  InkWell(
                    onTap: pickFile,
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_upload_outlined, size: 50),
                          const SizedBox(height: 12),
                          const Text(
                            "Select your VCF file",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                const Icon(Icons.insert_drive_file_outlined),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    selectedFile?.name ?? "No file selected",
                                  ),
                                ),
                                if (selectedFile != null)
                                  const Icon(Icons.check, color: Colors.green),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedFile == null
                              ? null
                              : () async {
                                  showLoading(context);

                                  try {
                                    final reportItems = await uploadFile();

                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => IndividualReportScreen(
                                          reportItems: reportItems,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Upload failed: $e"),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F4F6F),
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
