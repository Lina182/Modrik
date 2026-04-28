import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final Color lavender = const Color(0xFF9DA3D9);

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

  // ✅ رسالة موحدة
  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ✅ تحقق من الإيميل
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
    super.dispose();
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.55),
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
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMsg("Please fill all fields");
      return;
    }

    // ✅ تحقق من الإيميل
    if (!isValidEmail(emailController.text.trim())) {
      showMsg("Enter a valid email format");
      return;
    }

    // ✅ تحقق من الباسورد
    if (passwordController.text.length < 6) {
      showMsg("Password must be at least 6 characters");
      return;
    }

    // ✅ تطابق الباسورد
    if (passwordController.text != confirmPasswordController.text) {
      showMsg("Passwords don't match");
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

      // Firebase Auth display name (اختياري)
      await user?.updateDisplayName(nameController.text.trim());

      // 🔥 حفظ البيانات في Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'uid': user.uid,
        'role': 'user',
        'createdAt': Timestamp.now(),
      });

      final idToken = await user.getIdToken();
      print("TOKEN: $idToken");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully ✅")),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Something went wrong";

      if (e.code == 'invalid-email') msg = "This email is invalid";
      if (e.code == 'weak-password') msg = "Password is too weak";
      if (e.code == 'email-already-in-use') {
        msg = "Email already in use. Try logging in.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lavender,
      body: Stack(
        children: [
          Container(color: lavender),
          Positioned(
            top: -180,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
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
                  const SizedBox(height: 110),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create your account\nand get started!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 40),

                  TextField(
                    focusNode: nameFocus,
                    controller: nameController,
                    decoration: inputDecoration("Name", Icons.person_outline),
                  ),
                  const SizedBox(height: 18),

                  TextField(
                    focusNode: emailFocus,
                    controller: emailController,
                    decoration: inputDecoration("Email", Icons.email_outlined),
                  ),
                  const SizedBox(height: 18),

                  TextField(
                    focusNode: passwordFocus,
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputDecoration("Password", Icons.lock_outline),
                  ),
                  const SizedBox(height: 18),

                  TextField(
                    focusNode: confirmPasswordFocus,
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: inputDecoration(
                      "Confirm Password",
                      Icons.lock_outline,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _signUp,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Already have an account? Log in",
                      style: TextStyle(color: Colors.black),
                    ),
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
