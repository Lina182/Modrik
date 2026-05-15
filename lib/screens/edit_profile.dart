import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'login_screen.dart';

const kPrimaryColor = Color(0xFF6C63FF);

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
  bool _obscureNewPass = true;
  bool _obscureCurrPass = true;

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
    final t = AppLocalizations.of(context)!;

    if (user == null) return;

    final isEmailChanged = email.text.trim() != user!.email;
    final isPasswordChanged = password.text.isNotEmpty;
    final isNameChanged =
        name.text.trim() != (user!.displayName ?? '');

    if (!isEmailChanged &&
        !isPasswordChanged &&
        !isNameChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.noChanges),
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
          SnackBar(
            content: Text(
              t.enterCurrentPassword,
            ),
          ),
        );

        setState(() => isLoading = false);
        return;
      }

      if (isEmailChanged || isPasswordChanged) {
        await reAuthenticate();
      }

      await user!.updateDisplayName(
        name.text.trim(),
      );

      if (isEmailChanged) {
        await user!.verifyBeforeUpdateEmail(
          email.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.confirmEmail),
          ),
        );
      }

      if (isPasswordChanged) {
        await user!.updatePassword(
          password.text.trim(),
        );
      }

      await user!.reload();

      user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'name': name.text.trim(),
        'email': email.text.trim(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profileUpdated),
          ),
        );

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String msg = e.code == 'wrong-password'
          ? t.wrongPassword
          : t.errorUpdate;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> deleteAccount() async {
    final t = AppLocalizations.of(context)!;

    if (user == null) return;

    try {
      if (currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.deletePassword),
          ),
        );
        return;
      }

      await reAuthenticate();

      final uid = user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .delete();

      await user!.delete();

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
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final t = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF4A3AFF),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            title: Text(
              t.editProfile,
              style: const TextStyle(
                color: Color(0xFF1E1E2D),
                fontWeight: FontWeight.bold,
              ),
            ),

            centerTitle: true,

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),

                child: CircleAvatar(
                  backgroundColor: kPrimaryColor,

                  child: IconButton(
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),

                    onPressed:
                        isLoading ? null : updateProfile,
                  ),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                _buildUserHeader(),

                const SizedBox(height: 30),

                _buildLabel(t.fullName),

                _buildTextField(
                  name,
                  Icons.person_outline,
                  t.enterName,
                ),

                const SizedBox(height: 20),

                _buildLabel(t.email),

                _buildTextField(
                  email,
                  Icons.mail_outline,
                  t.enterEmail,
                ),

                const SizedBox(height: 20),

                _buildLabel(t.newPassword),

                _buildTextField(
                  password,
                  Icons.lock_outline,
                  t.leaveEmpty,
                  isPassword: true,
                  isObscure: _obscureNewPass,
                  onToggle: () {
                    setState(() {
                      _obscureNewPass =
                          !_obscureNewPass;
                    });
                  },
                ),

                const SizedBox(height: 20),

                _buildLabel(t.currentPassword),

                _buildTextField(
                  currentPassword,
                  Icons.lock_outline,
                  t.requiredPassword,
                  isPassword: true,
                  isObscure: _obscureCurrPass,
                  onToggle: () {
                    setState(() {
                      _obscureCurrPass =
                          !_obscureCurrPass;});
                  },
                ),

                const SizedBox(height: 15),

                _buildSecurityNotice(
                  t.securityNotice,
                ),

                const SizedBox(height: 40),

                _buildDeleteButton(
                  t.deleteAccount,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: const LinearGradient(
          colors: [
            Color(0xFFF3F1FF),
            Color(0xFFE8E5FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,

            child: Opacity(
              opacity: 0.1,

              child: Icon(
                Icons.biotech,
                size: 100,
                color: kPrimaryColor,
              ),
            ),
          ),

          Row(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,

                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF6C63FF),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      user?.displayName ?? "User",

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),

                    Text(
                      user?.email ?? "",

                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 8,
      ),

      child: Text(
        text,

        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hint, {
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: TextField(
        controller: controller,
        obscureText: isObscure,

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),

          prefixIcon: Icon(
            icon,
            color: kPrimaryColor,
            size: 20,
          ),

          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: onToggle,
                )
              : null,

          border: OutlineInputBorder(borderRadius:
                BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          filled: true,
          fillColor: const Color(0xFFF9F9FF),

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNotice(String text) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFF3F1FF),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: kPrimaryColor,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF504A9E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 55,

      child: ElevatedButton(
        onPressed: deleteAccount,

        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFFFFEBEB),

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.delete_outline,
              color: Color(0xFFE53935),
            ),

            const SizedBox(width: 8),

            Text(
              text,

              style: const TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}