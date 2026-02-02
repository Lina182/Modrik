import 'package:flutter/material.dart';
import 'edit_profile.dart';  // استيراد صفحة EditProfileScreen
import 'settings_profile.dart';  // استيراد صفحة SettingsProfileScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.purple,  // لون شريط التطبيق
        actions: [
          // إضافة أيقونة الإعدادات
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // عند الضغط على أيقونة الإعدادات، الانتقال إلى صفحة SettingsProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // محاذاة العناصر بشكل مركزي
          crossAxisAlignment: CrossAxisAlignment.center,  // محاذاة العناصر بشكل مركزي أفقي
          children: [
            // المربع الذي يحتوي على الأيقونة والاسم
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,  // عرض المربع ليشغل العرض بالكامل
              decoration: BoxDecoration(
                color: Color(0xFFC4C8EA),  // اللون المطلوب
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Username',  // اسم المستخدم
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'useremail@gmail.com',  // البريد الإلكتروني
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // الانتقال إلى صفحة تعديل البروفايل عند الضغط على "Edit Profile"
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC4C8EA), // اللون المطلوب
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // زر تسجيل الخروج
            ElevatedButton(
              onPressed: () {
                // إضافة أي منطق لتسجيل الخروج
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // لون الزر
              ),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(currentIndex: 3, // تعيين الأيقونة الحالية (Profile)
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // يمكنك إضافة منطق التنقل هنا حسب الأيقونة
          switch (index) {
            case 0:
              // الانتقال إلى الصفحة الرئيسية
              break;
            case 1:
              // الانتقال إلى صفحة المستندات
              break;
            case 2:
              // الانتقال إلى صفحة التحليل
              break;
            case 3:
              // نحن في صفحة البروفايل بالفعل
              break;
          }
        },
        selectedItemColor: Colors.purple,  // تغيير اللون عند تحديد العنصر
        unselectedItemColor: Colors.grey,  // اللون عند عدم تحديد العنصر
        type: BottomNavigationBarType.fixed,  // لجعل العناصر مرئية بشكل دائم
      ),
    );
  }
}