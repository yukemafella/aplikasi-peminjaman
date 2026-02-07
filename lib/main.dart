import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

void main() async {
  // 1. Pastikan binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase (Perbaikan URL dan String)
  try {
    await Supabase.initialize(
      // Pastikan URL bersih dari karakter '&#39;' (petik tunggal dalam format HTML)
      url: 'https://uddtkqdljfgenjibxrwv.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkZHRrcWRsamZnZW5qaWJ4cnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODIzMTIsImV4cCI6MjA4NDE1ODMxMn0.vHKA2q91ByXYmgte9bjQi4_21SJaSxOqrHhsSJZ6kbI',
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
    return MaterialApp( // Hapus 'const' di sini jika LoginPage tidak konstan
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Alat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), 
    );
  }
}