import 'package:flutter/material.dart';
import 'shared/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'users/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'admin/admin_dash.dart';
import 'expert/ExpertHomeScreen.dart';

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

      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }

      final token = await user.getIdToken();

      final response = await http.post(
        Uri.parse("http://172.237.116.141:8003/verify-token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = (data['role'] ?? 'user').toLowerCase();

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashScreen()),
          );
        } else if (role == 'expert') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ExpertHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
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
