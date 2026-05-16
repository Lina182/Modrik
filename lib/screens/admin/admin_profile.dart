import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/login_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  State<ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  static const Color lightPurple = Color(0xFFC4C8EA);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: Column(
        children: [
          /// ===== HEADER =====
          Container(
            height: 170,
            width: double.infinity,

            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 60,
            ),

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

            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
  Text(
  "Account",

  style: TextStyle(
    color: AppColors.primary,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ),
),

                SizedBox(height: 8),

               Text(
  "Manage admin account and preferences",

  style: TextStyle(
    color: Colors.black87,
    fontSize: 15,
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

              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                0,
              ),

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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Text(
                                user?.displayName ?? 'No Username',
                                style: AppTextStyles.title,),

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

                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),

                                child: const Text(
                                  "Administrator",

                                  style: TextStyle(
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

                  /// ===== ACCOUNT =====
                  _sectionTitle("Account"),

                  _card(
                    child: Column(
                      children: [
                        _rowItem(
                          icon: Icons.email_outlined,
                          title: "Email",

                          trailing: Text(
                            user?.email ?? "",
                            style: AppTextStyles.subtitle,
                          ),
                        ),

                        const _line(),

                        _rowItem(
                          icon: Icons.verified_user,
                          title: "Role",

                          trailing: const Text("Admin"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ===== ABOUT =====
                  _sectionTitle("About"),

                  _card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),

                      child: Text(
                        "Modrik Admin Panel allows administrators to monitor the platform and manage system operations securely.",

                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ===== LOG OUT =====
                  _card(
                    child: InkWell(
                      onTap: () async {
                        try {
                          // Firebase sign out
                          await FirebaseAuth.instance.signOut();

                          // navigate to login
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          debugPrint("Admin logout error: $e");
                        }
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),child: Row(
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

                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),

                            const Spacer(),

                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
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
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 8,
      ),

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
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),

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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: AppColors.softPurple,
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: AppColors.primary,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),

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