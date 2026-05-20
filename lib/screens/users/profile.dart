import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import '../shared/edit_profile.dart';
import '../shared/login_screen.dart';
import '../../widgets/header_section.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:modik_pages/l10n/app_localizations.dart';
import 'package:app_settings/app_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;

  Locale language = appLocale.value;

  bool privacyExpanded = false;
  bool contactExpanded = false;
  bool aboutExpanded = false;

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final t = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: appLocale.value.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,

      child: Scaffold(
        backgroundColor: AppColors.background,

        body: Column(
          children: [
            HeaderSection(
              title: "",
              bigTitle: t.account,
              subtitle: t.manageAccount,
            ),

            const SizedBox(height: 20),

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
                            child: Icon(Icons.person,
                                size: 40,
                                color: Color(0xFF6C63FF)),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? t.noUsername,
                                  style: AppTextStyles.title,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? t.noEmail,
                                  style: AppTextStyles.subtitle,
                                ),

                                const SizedBox(height: 10),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) =>
                                            const EditProfileScreen(),
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
                                        const Icon(Icons.edit,
                                            size: 16,
                                            color: Color(0xFF6C63FF)),
                                        const SizedBox(width: 6),
                                        Text(
                                          t.editProfile,
                                          style: const TextStyle(
                                            color: Color(0xFF6C63FF),
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

                    /// ===== GENERAL =====
                    _sectionTitle(t.general),
                    _card(
                      child: Column(
                        children: [

                          /// LANGUAGE
                          _rowItem(
                            icon: Icons.language,
                            title: t.language,
                            trailing: DropdownButton<Locale>(
                              value: language,
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

                                setState(() {
                                  language = value;
                                });

                                appLocale.value = value;
                              },
                            ),
                          ),

                          const Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 64,
                            endIndent: 16,
                            color: Color(0xFFEDEEF3),
                          ),

                          _rowItem(
                            icon: Icons.notifications,
                            title: t.notifications,
                            trailing: Switch(
  value: notifications,
  onChanged: (v) {

    setState(() => notifications = v);

    AppSettings.openAppSettings(
      type: AppSettingsType.notification,
    );
  },
),
                          ),
                        ],
                      ),),

                    const SizedBox(height: 18),

                    /// ===== PRIVACY =====
                    _sectionTitle(t.privacy),
                    _card(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() =>
                                  privacyExpanded = !privacyExpanded);
                            },
                            child: _rowItem(
                              icon: Icons.verified_user,
                              title: t.privacy,
                              trailing: Icon(
                                privacyExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                              ),
                            ),
                          ),

                          if (privacyExpanded)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Text(
                                t.privacyText,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// ===== SUPPORT =====
                    _sectionTitle(t.support),
                    _card(
                      child: Column(
                        children: [

                          GestureDetector(
                            onTap: () {
                              setState(() =>
                                  contactExpanded = !contactExpanded);
                            },
                            child: _rowItem(
                              icon: Icons.headphones,
                              title: t.contactUs,
                              trailing: Icon(
                                contactExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                              ),
                            ),
                          ),

                          if (contactExpanded)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Text(
                                t.contactText,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),

                          const Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 64,
                            endIndent: 16,
                            color: Color(0xFFEDEEF3),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() =>
                                  aboutExpanded = !aboutExpanded);
                            },
                            child: _rowItem(
                              icon: Icons.info,
                              title: t.aboutApp,
                              trailing: Icon(
                                aboutExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,),
                            ),
                          ),

                          if (aboutExpanded)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Text(
                                t.aboutText,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// ===== LOGOUT =====
                    _card(
                      child: InkWell(
                        onTap: () => _logout(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.logout,
                                  color: Colors.red, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                t.logout,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
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

        bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
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
            decoration: BoxDecoration(
              color: AppColors.softPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}