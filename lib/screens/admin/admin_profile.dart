import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/login_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

import '../../main.dart'; // مهم عشان appLocale

class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  State<ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: Column(
        children: [
          /// ===== HEADER =====
          Container(
            height: 170,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 24, right: 24, top: 60),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientStart,
                  AppColors.heroGradient1,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.account, // 🔥 هنا التعديل فقط
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.manageAdminAccount,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                /// 🔙 back button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      appLocale.value.languageCode == 'ar'
                          ? Icons.arrow_back_ios_new
                          : Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ===== BODY =====
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -18, 0),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

              child: ListView(
                padding: EdgeInsets.zero,
                children: [

                  /// ===== USER CARD =====
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.softPurple,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'No Username',
                                style: AppTextStyles.title,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? 'No Email',
                                style: AppTextStyles.subtitle,
                              ),
                              const SizedBox(height: 10),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  t.administrator,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// ===== ACCOUNT SECTION =====
                  _sectionTitle(t.account),

                  _card(
                    child: Column(
                      children: [
                        _rowItem(
                          icon: Icons.email_outlined,
                          title: t.email,
                          trailing: Text(user?.email ?? ""),
                        ),

                        const _line(),

                        _rowItem(
                          icon: Icons.verified_user,
                          title: t.role,
                          trailing: Text(t.admin),
                        ),

                        const _line(),

                        _rowItem(
                          icon: Icons.language,
                          title: t.language,
                          trailing: DropdownButton<Locale>(
                            value: appLocale.value,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: Locale('en'),
                                child: Text("English"),
                              ),
                              DropdownMenuItem(
                                value: Locale('ar'),
                                child: Text("العربية"),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              appLocale.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),const SizedBox(height: 18),

                  /// ===== ABOUT =====
                  _sectionTitle(t.about),

                  _card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(t.adminPanelDescription),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ===== LOG OUT =====
                  _card(
                    child: InkWell(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.logout, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(
                              t.logout,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rowItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.softPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

class _line extends StatelessWidget {
  const _line();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.8,
      indent: 64,
      endIndent: 16,
      color: Color(0xFFEDEEF3),
    );
  }
}