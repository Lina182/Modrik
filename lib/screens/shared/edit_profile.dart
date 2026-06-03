import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'login_screen.dart';
import '../../main.dart';
import 'package:modik_pages/l10n/app_localizations.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noChanges)),
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
            content: Text(AppLocalizations.of(context)!.enterCurrentPassword),
          ),
        );
        return;
      }

      if (isEmailChanged || isPasswordChanged) {
        await reAuthenticate();
      }

      await user!.updateDisplayName(name.text.trim());

      if (isEmailChanged) {
        await user!.verifyBeforeUpdateEmail(email.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.confirmEmail)),
        );
      }

      if (isPasswordChanged) {
        await user!.updatePassword(password.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
        );
      }

      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': user!.displayName,
        'email': user!.email,
      }, SetOptions(merge: true));

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = AppLocalizations.of(context)!.errorUpdate;

      if (e.code == 'requires-recent-login') {
        msg = AppLocalizations.of(context)!.unexpectedError;
      } else if (e.code == 'wrong-password') {
        msg = AppLocalizations.of(context)!.wrongPassword;
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
          SnackBar(content: Text(AppLocalizations.of(context)!.deletePassword)),
        );
        return;
      }

      await reAuthenticate();

      final token = await user!.getIdToken();

      if (token == null) {
        throw Exception("Failed to get token");
      }

      await AuthService.deleteUser(token);

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
    final t = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: appLocale.value.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(t.editProfile, style: AppTextStyles.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
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
                  child: const Icon(Icons.check, color: Colors.white),
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

              /// ===== PROFILE CARD (بدون كاميرا) =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
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
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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

              _field(t.fullName, t.enterName, name, icon: Icons.person),
              const SizedBox(height: 22),
              _field(t.email, t.enterEmail, email, icon: Icons.email_outlined),
              const SizedBox(height: 22),
              _field(
                t.newPassword,
                t.leaveEmpty,
                password,
                isPassword: true,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 22),
              _field(
                t.currentPassword,
                t.requiredPassword,
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
                child: Text(
                  t.securityNotice,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 13),
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
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    t.deleteAccount,
                    style: const TextStyle(
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
        Text(title, style: AppTextStyles.title.copyWith(fontSize: 15)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}
