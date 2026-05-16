import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final currentPassword = TextEditingController();

  User? user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;

    name.text = user?.displayName ?? '';
    email.text = user?.email ?? '';
  }

  Future<void> reAuthenticate() async {
    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPassword.text.trim(),
    );

    await user!.reauthenticateWithCredential(credential);
  }

  Future<void> updateProfile() async {
    if (user == null) return;

    final isEmailChanged = email.text.trim() != user!.email;
    final isPasswordChanged = password.text.isNotEmpty;
    final isNameChanged = name.text.trim() != (user!.displayName ?? '');

    if (!isEmailChanged &&
        !isPasswordChanged &&
        !isNameChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No changes detected"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final uid = user!.uid;

      if ((isEmailChanged || isPasswordChanged) &&
          currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Enter current password to change email or password",
            ),
          ),
        );

        return;
      }

      if (isEmailChanged || isPasswordChanged) {
        await reAuthenticate();
      }

      // ===== UPDATE NAME =====
      await user!.updateDisplayName(
        name.text.trim(),
      );

      // ===== UPDATE EMAIL =====
      if (isEmailChanged) {
        await user!.verifyBeforeUpdateEmail(
          email.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Check your new email to confirm 📩",
            ),
          ),
        );
      }

      // ===== UPDATE PASSWORD =====
      if (isPasswordChanged) {
        await user!.updatePassword(
          password.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password updated successfully 🔒",
            ),
          ),
        );
      }

      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      // ===== UPDATE FIRESTORE =====
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'name': user!.displayName,
        'email': user!.email,
      }, SetOptions(merge: true));

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile updated successfully ✅",
          ),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = "Error updating profile";

      if (e.code == 'requires-recent-login') {
        msg = "Please login again to continue";
      } else if (e.code == 'wrong-password') {
        msg = "Current password is incorrect";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteAccount() async {
    if (user == null) return;try {
      if (currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Enter current password to delete account",
            ),
          ),
        );

        return;
      }

      await reAuthenticate();

      final token = await user!.getIdToken();

      await http.post(
        Uri.parse(
          "http://172.237.116.141:8003/delete-user",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "token": token,
        }),
      );

      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Delete account error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: const Text(
          'Edit Profile',
          style: AppTextStyles.title,
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 14,
            ),
            child: GestureDetector(
              onTap: isLoading ? null : updateProfile,
              child: Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [
                      AppColors.heroGradient1,
                      AppColors.heroGradient2,
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 10),

            // ===== PROFILE CARD =====

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                ),

                borderRadius: BorderRadius.circular(28),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 82,
                        height: 82,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),

                        child: const Icon(
                          Icons.person,
                          size: 42,
                          color: AppColors.primary,
                        ),
                      ),Positioned(
                        bottom: 0,
                        right: 0,

                        child: Container(
                          padding: const EdgeInsets.all(6),

                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,

                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),

                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          user?.displayName ?? "Username",

                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          user?.email ?? "",

                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _field(
              'Full Name',
              'Enter your name',
              name,
              icon: Icons.person,
            ),

            const SizedBox(height: 22),

            _field(
              'Email',
              'Enter your email',
              email,
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 22),

            _field(
              'New Password',
              'Leave empty if no change',
              password,
              isPassword: true,
              icon: Icons.lock_outline,
            ),

            const SizedBox(height: 22),

            _field(
              'Current Password',
              'Required for email/password changes',
              currentPassword,
              isPassword: true,
              icon: Icons.lock,
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: AppColors.gradientStart,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'For your security, please enter your current password before saving any changes.',

                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              height: 58,

              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),

                borderRadius: BorderRadius.circular(18),
              ),

              child: TextButton.icon(
                onPressed: deleteAccount,

                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),

                label: const Text(
                  'Delete Account',

                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String title,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: AppTextStyles.title.copyWith(
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: isPassword,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: AppTextStyles.subtitle,

            filled: true,
            fillColor: Colors.white,

            prefixIcon: Icon(
              icon,
              color: AppColors.primary,
            ),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),

              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.08),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),

              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}