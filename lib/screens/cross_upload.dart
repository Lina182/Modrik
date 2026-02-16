import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CrossUploadScreen extends StatefulWidget {
  const CrossUploadScreen({super.key});

  @override
  State<CrossUploadScreen> createState() => _CrossUploadScreenState();
}

class _CrossUploadScreenState extends State<CrossUploadScreen> {
  static const Color mainPurple = Color(0xFF9DA3D9);

  List<String> selectedFiles = []; // نخزن اسمين هنا

  // ===== اختيار ملفين =====
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['vcf'],
    );

    if (result != null) {
      setState(() {
        selectedFiles =
            result.files.map((file) => file.name).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          // ===== الهيدر =====
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
            child: Image.asset(
              "assets/header_pattern.png",
              fit: BoxFit.cover,
            ),
          ),

          // ===== الكارد الأبيض =====
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
                  // ===== رجوع + عنوان =====
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

                  // ===== مربع اختيار الملفات =====
                  InkWell(
                    onTap: pickFiles,
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
                            "Select your VCF files",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // عرض الملفات
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: selectedFiles.isEmpty
                                  ? [
                                      const Text("No files selected"),
                                    ]
                                  : selectedFiles
                                      .map(
                                        (file) => Row(
                                          children: [
                                            const Icon(Icons.insert_drive_file_outlined),
                                            const SizedBox(width: 10),
                                            Expanded(child: Text(file)),
                                            const Icon(Icons.check, color: Colors.green),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ===== الأزرار =====
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
                          onPressed: selectedFiles.length < 2
                              ? null
                              : () {},
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