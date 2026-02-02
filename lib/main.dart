import 'package:flutter/material.dart';
import 'screens/home.dart';  // استيراد HomeScreen من مجلد screens

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // لإخفاء الشريط العلوي أثناء التطوير
      title: 'Modrik App',
      theme: ThemeData(
        primarySwatch: Colors.purple,  // تغيير اللون الأساسي للتطبيق
      ),
      home: const HomeScreen(),  // تعيين HomeScreen كصفحة رئيسية للتطبيق
    );
  }
}