import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

void main() async {
  // 1. Inisialisasi binding Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://uddtkqdljfgenjibxrwv.supabase.co', 
    // PERINGATAN: AnonKey di bawah ini salah format. 
    // Cari di Dashboard Supabase yang dimulai dengan 'eyJ...'
    anonKey: 'sb_publishable_xeuY8wNysgeJF9D4noNCGw_aMxWD_I6', 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}