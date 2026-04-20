import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; 
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'login_view.dart';
import 'main_wrapper.dart';

Future<void> main() async {
  // Flutter widget ağacını başlatıyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlatıyoruz
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check Debug Provider aktivasyonu
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // --- REİS TOKEN'I BURADA ALIYORUZ ---
  try {
    await FirebaseAppCheck.instance.getToken();
  } catch (_) {
    // ignore: avoid_print
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut kullanıcıyı kontrol ediyoruz
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'App3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F3EE),
        primaryColor: const Color(0xFFFF8C00),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8C00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFFFF8C00),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE0DDD6), width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE0DDD6), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF8C00), width: 1.5),
          ),
          labelStyle: const TextStyle(color: Color(0xFF757575)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: user == null ? const LoginView() : const MainWrapper(),
    );
  }
}