import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'edit_profile.dart';
import 'login_screen.dart';
import '../widgets/header_section.dart';
import '../widgets/bottom_nav_bar.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../locale_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;
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

  void _changeLang(String langCode) {
    Provider.of<LocaleProvider>(context, listen: false)
        .setLocale(Locale(langCode));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
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
            child: ListView(
              children: [
                /// USER CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.softPurple,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.displayName ?? t.noUsername),
                            Text(user?.email ?? t.noEmail),

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
                                child: Text(t.editProfile),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// GENERAL
                _sectionTitle(t.general),

                _card(
                  child: Column(
                    children: [
                      /// LANGUAGE
                      _rowItem(
                        icon: Icons.language,title: t.language,
                        trailing: DropdownButton<String>(
                          value: Localizations.localeOf(context).languageCode,
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text("English"),
                            ),
                            DropdownMenuItem(
                              value: 'ar',
                              child: Text("العربية"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _changeLang(value);
                            }
                          },
                        ),
                      ),

                      const Divider(),

                      /// NOTIFICATIONS
                      _rowItem(
                        icon: Icons.notifications,
                        title: t.notifications,
                        trailing: Switch(
                          value: notifications,
                          onChanged: (v) {
                            setState(() {
                              notifications = v;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// PRIVACY
                _sectionTitle(t.privacy),

                _card(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            privacyExpanded = !privacyExpanded;
                          });
                        },
                        child: _rowItem(
                          icon: Icons.verified_user,
                          title: t.privacy,
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),

                      if (privacyExpanded)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(t.privacyText),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// SUPPORT
                _sectionTitle(t.support),

                _card(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            contactExpanded = !contactExpanded;
                          });
                        },
                        child: _rowItem(
                          icon: Icons.headphones,
                          title: t.contactUs,
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),

                      if (contactExpanded)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(t.contactText),
                        ),

                      const Divider(),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            aboutExpanded = !aboutExpanded;
                          });
                        },
                        child: _rowItem(
                          icon: Icons.info,
                          title: t.aboutApp,
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),

                      if (aboutExpanded)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(t.aboutText),),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// LOGOUT
                _card(
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(t.logout),
                    onTap: () => _logout(context),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(text),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _rowItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(title),
        const Spacer(),
        trailing,
      ],
    );
  }
}