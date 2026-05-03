import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart';
import 'login_screen.dart';
import '../widgets/header_section.dart';
import '../widgets/bottom_nav_bar.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;
  String language = 'English';
  String mode = 'Light';

  bool privacyExpanded = false;
  bool contactExpanded = false;
  bool aboutExpanded = false;

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          /// ===== HEADER =====
          const HeaderSection(
            title: "",
            bigTitle: "Account",
            subtitle: "Manage your account and preferences",
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
                            Icons.person,
                            size: 40,
                            color: const Color(0xFF6C63FF),
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
                                      Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: const Color(0xFF6C63FF),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          color: const Color(0xFF6C63FF),
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
                  _sectionTitle("General"),
                  _card(
                    child: Column(
                      children: [
                        _rowItem(
                          icon: Icons.language,
                          title: "Language",
                          trailing: const Text("English"),
                        ),

                        const _line(),
                        _rowItem(
                          icon: Icons.notifications,
                          title: "Notifications",
                          trailing: Switch(
                            value: notifications,
                            onChanged: (v) => setState(() => notifications = v),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ===== PRIVACY =====
                  _sectionTitle("Privacy"),
                  _card(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() => privacyExpanded = !privacyExpanded);
                          },
                          child: _rowItem(
                            icon: Icons.verified_user,
                            title: "Privacy",
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
                              "Your genetic data is processed only for analysis and is not stored on our servers.\n"
                              "We do not share your data with any third parties.\n"
                              "All analysis is handled securely and privately.",
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
                  _sectionTitle("Support"),
                  _card(
                    child: Column(
                      children: [
                        /// CONTACT
                        GestureDetector(
                          onTap: () {
                            setState(() => contactExpanded = !contactExpanded);
                          },
                          child: _rowItem(
                            icon: Icons.headphones,
                            title: "Contact Us",
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
                              "Email: supportmodrik@gmail.com\n"
                              "We are here to help you anytime.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),

                        const _line(),

                        /// ABOUT
                        GestureDetector(
                          onTap: () {
                            setState(() => aboutExpanded = !aboutExpanded);
                          },
                          child: _rowItem(
                            icon: Icons.info,
                            title: "About App",
                            trailing: Icon(
                              aboutExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                            ),
                          ),
                        ),

                        if (aboutExpanded)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Text(
                              "Modrik helps you understand your genetic data in a simple and clear way.\n"
                              "We analyze your DNA file and provide easy-to-read insights using AI.\n"
                              "Your data remains private and is not stored after analysis.",
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

                  /// ===== LOG OUT =====
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
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Log out",
                              style: TextStyle(color: Colors.red, fontSize: 14),
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
            child: Icon(icon, color: AppColors.primary, size: 18),
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
