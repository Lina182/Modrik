import 'package:flutter/material.dart';
import 'ExpertProfile.dart';
import 'EpertSettings.dart';
import '../chat/chat_screen.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  int selectedTab = 0;

  final List<Map<String, String>> pending = [
    {"title": "Pending 1", "date": "2026-04-18"},
    {"title": "Pending 2", "date": "2026-04-19"},
  ];

  final List<Map<String, String>> processing = [
    {"title": "Processing 1", "date": "2026-04-20"},
    {"title": "Processing 2", "date": "2026-04-21"},
  ];

  final List<Map<String, String>> approved = [
    {"title": "Done 1", "date": "2026-04-15"},
    {"title": "Done 2", "date": "2026-04-16"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentList;
    String headerTitle;
    String headerSubtitle;
    Color statusColor;

    if (selectedTab == 0) {
      currentList = pending;
      headerTitle = "Pending";
      headerSubtitle = "Review the tasks that are\nwaiting for your action.";
      statusColor = Colors.orange;
    } else if (selectedTab == 1) {
      currentList = processing;
      headerTitle = "Processing";
      headerSubtitle = "Review the requests that\nare currently in progress.";
      statusColor = Colors.red;
    } else {
      currentList = approved;
      headerTitle = "Done";
      headerSubtitle = "Completed tasks that\nhave been processed.";
      statusColor = Colors.green;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Stack(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE0E2FF), Color(0xFFFBFBFF)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIcon(Icons.person, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileExpertScreen()),
                        );
                      }),
                      _circleIcon(Icons.settings_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsProfileScreen()),
                        );
                      }),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerTitle,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        headerSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.6),
                          height: 1.4,
                        ),
                      ),
                    ],),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // ⭐⭐⭐ هذا فقط التعديل ⭐⭐⭐
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                title: currentList[index]["title"]!,
                              ),
                            ),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.04),
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentList[index]["title"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          currentList[index]["date"]!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xFF6C63FF),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),),

                _buildBottomNavBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: const Color(0xFF6C63FF)),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem("Pending", Icons.access_time, 0),
          _navItem("Processing", Icons.assignment_outlined, 1),
          _navItem("Done", Icons.check_circle_outline, 2),
        ],
      ),
    );
  }

  Widget _navItem(String label, IconData icon, int index) {
    bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEDEBFF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF6C63FF)
                  : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}