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

  // --- REİS TOKEN'I BURADA YAZDIRIYORUZ ---
  try {
    final token = await FirebaseAppCheck.instance.getToken();
    print("--------------------------------------------------");
    print("--- REİS TOKEN BURADA ---");
    print(token);
    print("--------------------------------------------------");
  } catch (e) {
    print("Token alınırken hata oluştu: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mevcut kullanıcıyı kontrol ediyoruz
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'App3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: user == null ? const LoginView() : const MainWrapper(),
    );
  }
}