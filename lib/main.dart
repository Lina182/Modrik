import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/start_screen.dart';
import 'l10n/app_localizations.dart';

/// متغير اللغة العام
ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appLocale,

      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          locale: locale,

          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            fontFamily: 'Sans-serif',
          ),

          home: const StartScreen(),
        );
      },
    );
  }
}