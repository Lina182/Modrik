import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../l10n/app_localizations.dart';
import 'cross_report_screen.dart';
import '../../services/analysis_service.dart';
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

  Future<void> analyzeCrossFiles() async {
    if (maleFile == null || femaleFile == null) return;

    AnalysisLoading.show(context);

    try {
      final reports = await AnalysisService.analyzeCross(
        maleBytes: maleFile!.bytes!,
        maleName: maleFile!.name,
        femaleBytes: femaleFile!.bytes!,
        femaleName: femaleFile!.name,
      );

      AnalysisLoading.hide(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CrossReportScreen(reports: reports, fileName: "Cross Report"),
        ),
      );
    } catch (e) {
      AnalysisLoading.hide(context);
      showError("Something went wrong");
    }
  }

  void showError(String message) {
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.ok),
          ),
        ],
      ),
    );
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
                    t.crossUpload,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    t.crossUploadDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  AnalysisUploadBox(
                    title: t.selectFiles,
                    onTap: () {},
                    children: [
                      OutlinedButton(
                        onPressed: pickMaleFile,
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                maleFile == null
                                    ? t.chooseFatherFile
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

                      OutlinedButton(
                        onPressed: pickFemaleFile,
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                femaleFile == null
                                    ? t.chooseMotherFile
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

                  AnalysisButton(
                    text: t.continueBtn,
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
