import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../l10n/app_localizations.dart';

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

  bool _obscureNewPassword = true;
  bool _obscureCurrentPassword = true;

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

    setState(() => isLoading = true);

    try {
      final uid = user!.uid;

      if ((email.text != user!.email || password.text.isNotEmpty) &&
          currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error)),
        );
        setState(() => isLoading = false);
        return;
      }

      if (email.text != user!.email || password.text.isNotEmpty) {
        await reAuthenticate();
      }

      await user!.updateDisplayName(name.text.trim());

      if (email.text != user!.email) {
        await user!.verifyBeforeUpdateEmail(email.text.trim());
      }

      if (password.text.isNotEmpty) {
        await user!.updatePassword(password.text.trim());
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name.text.trim(),
        'email': email.text.trim(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.manageAccount)),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.somethingWentWrong)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFE),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          t.editProfile,
          style: const TextStyle(
            color: Color(0xFF1A1C43),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C43)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF635BFF)),
            onPressed: updateProfile,
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ===== USER CARD (نفس البنفسجي الأصلي) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEDEFFF), Color(0xFFF4F3FF)],
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: Color(0xFF635BFF),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1C43),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? "",
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color(0xFF1A1C43).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _field(t.editProfile, t.manageAccount, name, Icons.person),
            const SizedBox(height: 20),

            _field(t.email, t.manageAccount, email, Icons.mail_outline),
            const SizedBox(height: 20),

            _field(
              t.newPassword,
              t.manageAccount,
              password,
              Icons.lock_outline,
              isPassword: true,
              obscureText: _obscureNewPassword,
              onToggle: () {
                setState(() => _obscureNewPassword = !_obscureNewPassword);
              },
            ),

            const SizedBox(height: 20),

            _field(
              t.currentPassword,
              t.manageAccount,
              currentPassword,
              Icons.lock_outline,
              isPassword: true,
              obscureText: _obscureCurrentPassword,
              onToggle: () {
                setState(() =>
                    _obscureCurrentPassword = !_obscureCurrentPassword);
              },
            ),

            const SizedBox(height: 15),

            /// ===== INFO TEXT =====
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F1FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFF635BFF), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.yourDataPrivate,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF1A1C43).withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// ===== DELETE ACCOUNT (رجع مثل قبل تحت) =====
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEEFEF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_outline,
                        color: Color(0xFFDC2626), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      t.logout,
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String title,
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF635BFF)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: onToggle,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}