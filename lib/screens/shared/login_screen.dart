import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Firestore
import 'create_account_screen.dart';
import 'forget_password_screen.dart';
import '../users/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => _loading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) throw Exception("User is null");

      final idToken = await user.getIdToken();
      print("Firebase ID Token: $idToken");

      // 🔹 تسجيل دخول المستخدم في Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('login_activity').add({
          'userId': user.uid,
          'email': user.email ?? emailController.text.trim(),
          'timestamp': Timestamp.now(),
        });

        debugPrint("✅ Login recorded in Firestore for ${user.email}");
      }

      //verify token,set role, and navigate
      final response = await http.post(
        Uri.parse("http://172.237.116.141:8003/verify-token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": idToken}),
      );

      print("VERIFY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user_id = data['user_id'];
        final uid = data['uid'];
        final role = (data['role'] ?? 'user').toString().trim().toLowerCase();
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('firebase_uid', uid);
        await prefs.setString('role', (data['role'] ?? 'user').toString().trim().toLowerCase());
        if (user_id != null) {
            await prefs.setString('user_id', user_id.toString(),);}

        print("firebase uid: $uid");
        print("role: $role");


        final logResponse= await http.post(
          Uri.parse("http://172.237.116.141:8003/login-log"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"token": idToken}),
        );
        print(logResponse.statusCode);
        print("Login log response: ${logResponse.body}");

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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token verification failed")),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Login failed";

      if (e.code == 'user-not-found') {
        msg = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        msg = "Wrong password";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email format";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      debugPrint("❌ Login error: ${e.code}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unexpected error occurred")),
      );
      debugPrint("❌ Unexpected error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // استخدام اللون المحدد
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.background), // الخلفية

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
                      AppColors.gradientStart, // التدرج الفاتح الأول
                      AppColors.gradientEnd, // التدرج الفاتح الثاني
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
                      "Login",
                      style: AppTextStyles.title.copyWith(
                        fontSize: 30, // تكبير حجم الخط
                        color: AppColors.primary, // استخدام اللون الأساسي
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome back you've\nbeen missed!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textGrey,
                      ), // استخدام اللون الرمادي للنص
                    ),
                    const SizedBox(height: 50),

                    TextField(
                      controller: emailController,
                      focusNode: emailFocus,
                      decoration: InputDecoration(
                        hintText: "Email",
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
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
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: AppColors.primary),
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
                                backgroundColor:
                                    AppColors.primary, // استخدام اللون الأساسي
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _login,
                              child: const Text(
                                "Log in",
                                style: TextStyle(
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
                      child: const Text(
                        "Don’t have an account ? Sign Up",
                        style: TextStyle(
                          color: AppColors.primary,
                        ), // استخدام اللون الأساسي
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
