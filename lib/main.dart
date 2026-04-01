//import 'screens/individual_report_screen.dart';
import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/cross_report_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
      //home: const CrossReportScreen(),
      theme: ThemeData(fontFamily: 'Sans-serif'),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'screens/admin/admin_dash.dart'; // تأكد من استيراد صفحة admin_dash.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AdminDashScreen(),  // تغيير StartScreen إلى AdminDash
      theme: ThemeData(
        fontFamily: 'Sans-serif',
      ),
    );
  }
}
*/


//this part to display Expert pages
/*
import 'package:flutter/material.dart';
import 'screens/expert/ExpertHomeScreen.dart'; // تأكد من استيراد صفحة ExpertHomeScreen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExpertHomeScreen(),  // تغيير AdminDashScreen إلى ExpertHomeScreen
      theme: ThemeData(
        fontFamily: 'Sans-serif',
      ),
    );
  }
*/
