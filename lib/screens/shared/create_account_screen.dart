import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firebase_options.dart';
import '../users/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _loading = false;

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();

    nameFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
    confirmPasswordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.card.withOpacity(0.55),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  Future<void> _signUp() async {
    final t = AppLocalizations.of(context)!;

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMsg(t.pleaseFillFields);
      return;
    }

    if (!isValidEmail(emailController.text.trim())) {
      showMsg(t.invalidEmail);
      return;
    }

    if (passwordController.text.length < 6) {
      showMsg(t.weakPassword);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showMsg(t.passwordsDontMatch);
      return;
    }

    setState(() => _loading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = userCredential.user;

      if (user == null) {
        throw Exception("User creation failed");
      }

      await user.updateDisplayName(nameController.text.trim());

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'uid': user.uid,
        'role': 'user',
        'createdAt': Timestamp.now(),
      });

      final idToken = await user.getIdToken();

      await http.post(
        Uri.parse("http://172.237.116.141:8003/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": user.uid,
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "role": "user",
          "token": idToken,
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.accountCreated)),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = t.somethingWentWrong;

      if (e.code == 'invalid-email') {
        msg = t.invalidEmail;
      } else if (e.code == 'weak-password') {
        msg = t.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        msg = t.emailInUse;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
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
                      t.createAccount,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 30,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      t.createAccountSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),

                    const SizedBox(height: 50),

                    TextField(
                      focusNode: nameFocus,
                      controller: nameController,
                      decoration: inputDecoration(t.fullName, Icons.person_outline),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      focusNode: emailFocus,
                      controller: emailController,
                      decoration: inputDecoration(t.email, Icons.email_outlined),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      focusNode: passwordFocus,
                      controller: passwordController,
                      obscureText: true,
                      decoration: inputDecoration(t.password, Icons.lock_outline),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      focusNode: confirmPasswordFocus,
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration:
                          inputDecoration(t.confirmPassword, Icons.lock_outline),
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
                              onPressed: _signUp,
                              child: Text(
                                t.signUp,
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
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        t.alreadyHaveAccount,
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

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}