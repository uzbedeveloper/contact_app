import 'package:contact_app/presentation/screens/splash.dart';
import 'package:flutter/material.dart';
import 'data/source/local/my_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Contacts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE85D5D)),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}