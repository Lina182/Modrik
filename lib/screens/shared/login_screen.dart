import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../l10n/app_localizations.dart';
import 'create_account_screen.dart';
import 'forget_password_screen.dart';
import '../users/home_screen.dart';
import '../admin/admin_dash.dart';
import '../expert/ExpertHomeScreen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final t = AppLocalizations.of(context)!;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pleaseFillFields)),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signOut();

      final Prefs = await SharedPreferences.getInstance();
      await Prefs.clear();
      
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user == null) throw Exception(t.userNull);

      final idToken = await user.getIdToken();

      final fcmToken = await FirebaseMessaging.instance.getToken();

      await http.post(
        Uri.parse("http://172.237.116.141:8003/save-fcm-token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": user.uid,
          "fcm_token": fcmToken,
        }),
      );

      await FirebaseFirestore.instance.collection('login_activity').add({
        'userId': user.uid,
        'email': user.email ?? emailController.text.trim(),
        'timestamp': Timestamp.now(),
      });

      final response = await http.post(
        Uri.parse("http://172.237.116.141:8003/verify-token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user_id = data['user_id'];
        final uid = data['uid'];
        final role =
            (data['role'] ?? 'user').toString().trim().toLowerCase();

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('firebase_uid', uid);
        await prefs.setString('user_role', role);

        if (user_id != null) {
          await prefs.setString('user_id', user_id.toString());

            print("SAVED USER ID = $user_id");
            print("SAVED ROLE = $role");
        }

        final logResponse = await http.post(
          Uri.parse("http://172.237.116.141:8003/login-log"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"token": idToken}),
        );

        if (!mounted) return;

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
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.tokenVerificationFailed)),
        );
      }
    } on FirebaseAuthException catch (e) {
      final t = AppLocalizations.of(context)!;
      String msg = t.loginFailed;

      if (e.code == 'user-not-found') {
        msg = t.noUserFound;
      } else if (e.code == 'wrong-password') {
        msg = t.wrongPassword;
      } else if (e.code == 'invalid-email') {
        msg = t.invalidEmail;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.unexpectedError)),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.background),

            Positioned(
              top: -180,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gradientStart,
                      AppColors.gradientEnd,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: 50,
              right: 0,
              child: CustomPaint(
                size: const Size(200, 100),
                painter: TopCurvePainter(),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 120),

                    Text(
                      t.login,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 30,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      t.welcomeBack,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),

                    const SizedBox(height: 50),

                    TextField(
                      controller: emailController,
                      focusNode: emailFocus,
                      decoration: InputDecoration(
                        hintText: t.email,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: AppColors.card.withOpacity(0.55),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      obscureText: true,
                      decoration: InputDecoration(hintText: t.password,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: AppColors.card.withOpacity(0.55),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          t.forgotPassword,
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    _loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _login,
                              child: Text(
                                t.logIn,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: Text(
                        t.dontHaveAccount,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}