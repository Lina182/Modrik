import 'package:flutter/material.dart';
import 'profile.dart';
import 'AI_chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color mainPurple = Color(0xFF9DA3D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== الجزء العلوي =====
          Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: mainPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_outline,
                      size: 42,
                      color: mainPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
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

          const SizedBox(height: 24),

          // ===== النص البيضاوي =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: mainPurple.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'We transform your genetic data into clear and reliable information.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ===== الأزرار =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  buildHomeButton(Icons.analytics, 'Analysis'),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AIChatScreen(),
                        ),
                      );
                    },
                    child: buildHomeButton(Icons.chat_bubble_outline, 'Chat'),
                  ),

                  const SizedBox(height: 20),
                  buildHomeButton(Icons.description_outlined, 'Reports'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHomeButton(IconData icon, String text) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: mainPurple,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: mainPurple, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
