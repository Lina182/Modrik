import 'package:flutter/material.dart';
import 'profile.dart';  // استيراد صفحة ProfileScreen من مجلد screens

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // الجزء العلوي باللون البنفسجي الفاتح مع الزوايا الدائرية
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // الانتقال إلى صفحة ProfileScreen عند الضغط على الأيقونة
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome in Modrik',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // الحاوية البيضاوية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'We transform your genetic data into clear and reliable information.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // الأزرار العمودية
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildHomeButton(Icons.analytics, 'Analysis'),
                  const SizedBox(height: 20),
                  buildHomeButton(Icons.chat, 'Chat'),
                  const SizedBox(height: 20),
                  buildHomeButton(Icons.insert_chart, 'Reports'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء زر Home
  Widget buildHomeButton(IconData icon, String text) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: Colors.purple,
              size: 24,
              ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}