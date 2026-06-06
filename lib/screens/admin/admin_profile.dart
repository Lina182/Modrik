import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/login_screen.dart';
import '../shared/edit_profile.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../../main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          Stack(
            children: [
              Container(
                height: 170,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE0E2FF), Color(0xFFF3F4FF)],
                  ),
                ),
              ),

              Positioned(
                right: appLocale.value.languageCode == 'ar' ? null : 10,
                left: appLocale.value.languageCode == 'ar' ? 10 : null,
                top: 10,
                child: Transform.rotate(
                  angle: 0.2,
                  child: FaIcon(
                    FontAwesomeIcons.screwdriverWrench,
                    size: 130,
                    color: const Color(0xFF6C63FF).withOpacity(0.15),
                  ),
                ),
              ),

              /// Back Button
              Positioned(
                left: appLocale.value.languageCode == 'ar' ? null : 10,
                right: appLocale.value.languageCode == 'ar' ? 10 : null,
                top: 33,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 25,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              /// Title
              Positioned(
                left: appLocale.value.languageCode == 'ar' ? null : 40,
                right: appLocale.value.languageCode == 'ar' ? 40 : null,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.account,
                      style: const TextStyle(
                        fontSize: 30,
                        color: const Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      t.manageAdminAccount,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
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
                    ),
                    child: Row(
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

                              const SizedBox(height: 10),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const EditProfileScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        t.editProfile,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
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
                            onChanged: (value) async {
                              if (value == null) return;

                              appLocale.value = value;

                              final uid =
                                  FirebaseAuth.instance.currentUser?.uid;

                              if (uid != null) {
                                await AuthService.updateLanguage(
                                  uid: uid,
                                  language: value.languageCode,
                                );
                              }

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
