import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState
    extends State<ForgetPasswordScreen> {

  final TextEditingController emailController =
      TextEditingController();

  bool _loading = false;

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reset link sent to your email ✅"),
        ),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      String msg = "Something went wrong";

      if (e.code == 'user-not-found') {
        msg = "No account found with this email";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email format";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [

            // نفس خلفية اللوق إن
            Container(
              color: AppColors.background,
            ),

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

            // نفس الـ curve
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [

                    const SizedBox(height: 120),

                    Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 30,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),const Text(
                      "Enter your email and we will\nsend you a reset link.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textGrey,
                      ),
                    ),

                    const SizedBox(height: 50),

                    TextField(
                      controller: emailController,
                      decoration: inputDecoration(
                        "Email",
                        Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _loading
                        ? const Center(
                            child:
                                CircularProgressIndicator(),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primary,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          14),
                                ),
                              ),
                              onPressed: resetPassword,
                              child: const Text(
                                "Reset Password",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
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

    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      size.height,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) =>
      false;
}