import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'individual_upload.dart';
import 'cross_upload.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  static const Color mainPurple = Color(0xFF9DA3D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: Stack(
        children: [

          // ===== الخلفية البنفسجية مع الصورة =====
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
              "assets/header_pattern.png",   // حطي صورة الخطوط هنا
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

                  const SizedBox(height: 10),

                  const Text(
                    "Please select how you want to\nanalyze your genetic data.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: [

                      Expanded(
                        child: buildOptionCard(
  icon: Icons.person_outline,
  text: "Analyze one VCF file\nfor a single individual.",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IndividualUploadScreen(),
      ),
    );
  },
),
                      ),

                      const SizedBox(width: 20),

Expanded(
  child: buildOptionCard(
    icon: Icons.group_outlined,
    text: "two files to compare\nshared or inherited\nvariants.",
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CrossUploadScreen(),
        ),
      );
    },
  ),
),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== Bottom Navigation =====
     bottomNavigationBar: Container(
  height: 70,
  decoration: const BoxDecoration(
    color: mainPurple,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [

      // ===== HOME =====
      GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.home_outlined,
          color: Colors.black,
        ),
      ),

      const Icon(Icons.description_outlined, color: Colors.black),
      const Icon(Icons.bubble_chart_outlined, color: Colors.black),
      const Icon(Icons.person_outline, color: Colors.black),
    ],
  ),
),
    );
  }

 Widget buildOptionCard({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 170,
      decoration: BoxDecoration(
        color: mainPurple,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.black),
          const SizedBox(height: 15),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
}