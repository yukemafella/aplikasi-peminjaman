import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

void main() async {
  // 1. Pastikan binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase
  try {
    await Supabase.initialize(
      url: 'https://uddtkqdljfgenjibxrwv.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkZHRrcWRsamZnZW5qaWJ4cnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODIzMTIsImV4cCI6MjA4NDE1ODMxMn0.vHKA2q91ByXYmgte9bjQi4_21SJaSxOqrHhsSJZ6kbI',
    );
  } catch (e) {
    debugPrint('Error saat inisialisasi Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Alat',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Tambahkan ini agar Navigator.pushNamed('/login') berfungsi
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
