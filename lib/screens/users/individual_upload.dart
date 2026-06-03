import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../l10n/app_localizations.dart';
import 'individual_report_screen.dart';
import '../../services/analysis_service.dart';
// widgets
import '../../widgets/analysis_header.dart';
import '../../widgets/analysis_upload_box.dart';
import '../../widgets/analysis_button.dart';
import '../../widgets/analysis_loading.dart';

class IndividualUploadScreen extends StatefulWidget {
  const IndividualUploadScreen({super.key});

  @override
  State<IndividualUploadScreen> createState() => _IndividualUploadScreenState();
}

class _IndividualUploadScreenState extends State<IndividualUploadScreen> {
  PlatformFile? selectedFile;

  /// ===== PICK FILE =====
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

  /// ===== API =====

  /// ===== FLOW =====
  Future<void> uploadAndNavigate() async {
    final t = AppLocalizations.of(context)!;

    AnalysisLoading.show(context);

    try {
      final reportItems = await AnalysisService.analyzeIndividual(
        selectedFile!.path!,
      );

      AnalysisLoading.hide(context);

      String fileName = selectedFile!.name.replaceAll(
        '.vcf',
        '',
      ); // (هذا طبيعي مو مشكلة)

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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${t.uploadFailed}: $e")));
    }
  }

  /// ===== UI =====
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      body: SingleChildScrollView(
        child: Column(
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

            /// ===== BODY =====
            Container(
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
                    t.uploadVCF,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  /// ===== UPLOAD BOX =====
                  AnalysisUploadBox(title: t.selectSingleFile, onTap: pickFile),

                  const SizedBox(height: 15),

                  /// ===== FILE INFO =====
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
                          child: Text(selectedFile?.name ?? t.noFileSelected),
                        ),
                        if (selectedFile != null)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ===== BUTTON =====
                  AnalysisButton(
                    text: t.continueBtn,
                    onPressed: selectedFile == null ? null : uploadAndNavigate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
