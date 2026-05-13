import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const mainPurple = Color(0xFFC4C8EA);
const bgPurple = Color(0xFF9DA3D9);

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

    if (!isEmailChanged && !isPasswordChanged && !isNameChanged) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No changes detected")));
      return;
    }
    setState(() => isLoading = true);

    try {
      final uid = user!.uid;

      final isEmailChanged = email.text.trim() != user!.email;
      final isPasswordChanged = password.text.isNotEmpty;

      if ((isEmailChanged || isPasswordChanged) &&
          currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Enter current password to change email or password"),
          ),
        );
        return;
      }

      if (isEmailChanged || isPasswordChanged) {
        await reAuthenticate();
      }

      // ===== NAME =====
      await user!.updateDisplayName(name.text.trim());

      // ===== EMAIL =====
      if (isEmailChanged) {
        await user!.verifyBeforeUpdateEmail(email.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Check your new email to confirm 📩")),
        );
      }

      // ===== PASSWORD =====
      if (isPasswordChanged) {
        await user!.updatePassword(password.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully 🔒")),
        );
      }

      // 🔥 IMPORTANT FIX
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      // 🔥 SYNC WITH FIRESTORE
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': user!.displayName,
        'email': user!.email,
      }, SetOptions(merge: true));

      setState(() {}); // تحديث UI

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully ✅")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = "Error updating profile";

      if (e.code == 'requires-recent-login') {
        msg = "Please login again to continue";
      } else if (e.code == 'wrong-password') {
        msg = "Current password is incorrect";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteAccount() async {
    if (user == null) return;

    try {
      if (currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Enter current password to delete account"),
          ),
        );
        return;
      }

      await reAuthenticate();

      final uid = user!.uid;

      // ⭐ هنا تحطيه
      final token = await user!.getIdToken();

      await http.post(
        Uri.parse("http://172.237.116.141:8003/delete-account"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      // بعد ما الباك يحذف من MySQL

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await user!.delete();
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
      backgroundColor: Colors.white, // ✅ رجعناه زي القديم

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: isLoading ? null : updateProfile,
          ),
        ],
      ),

      body: Stack(
        children: [
          Positioned(
            top: -220,
            right: -220,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                color: bgPurple.withOpacity(0.25), // ✅ زي القديم
                shape: BoxShape.circle,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // ===== USER CARD =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: mainPurple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 35),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? "No Username",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? "No Email",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                _field('Name', 'Enter your new name', name),
                const SizedBox(height: 20),

                _field('Email', 'Enter your new email', email),
                const SizedBox(height: 20),

                _field(
                  'New Password',
                  'Leave empty if no change',
                  password,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                _field(
                  'Current Password',
                  'Required for email/password changes',
                  currentPassword,
                  isPassword: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainPurple,
                    ),
                    child: const Text(
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
        ],
      ),
    );
  }

  Widget _field(
    String title,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: mainPurple,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
