import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final Color lightPurple = const Color(0xFFEBEFFF);

  @override
  void initState() {
    super.initState();
    checkUserSession();
  }

  Future<void> checkUserSession() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // نحاول نعمل reload (نكتشف لو الباسورد اتغير)
        await user.reload();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      // 🔥 هنا لو الباسورد اتغير
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(color: Colors.white),

          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: lightPurple,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Image.asset(
              'assets/modrik.jpg',
              width: MediaQuery.of(context).size.width * 0.55,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
