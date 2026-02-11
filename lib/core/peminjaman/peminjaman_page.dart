// Import library utama Flutter untuk membuat UI
import 'package:flutter/material.dart';

// Import halaman login dari project (pastikan file login_page.dart ada di folder ini)
import 'package:flutter_application_1/login_page.dart';

// Import library Supabase untuk Flutter, digunakan untuk koneksi backend
import 'package:supabase_flutter/supabase_flutter.dart';

// Import lagi login_page.dart (sebenarnya ini duplikasi, bisa dihapus tapi tetap kita biarkan karena permintaan tidak mengurangi kode)
import 'package:flutter_application_1/login_page.dart';

void main() async {
  // 1. Pastikan binding Flutter sudah diinisialisasi sebelum memanggil async code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase
  try {
    // Cek apakah Supabase sudah diinisialisasi sebelumnya
    if (Supabase.instance.client == null) {
      // Jika belum, lakukan inisialisasi dengan URL dan anonKey Supabase
      await Supabase.initialize(
        url: 'https://uddtkqdljfgenjibxrwv.supabase.co', // URL proyek Supabase
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkZHRrcWRsamZnZW5qaWJ4cnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODIzMTIsImV4cCI6MjA4NDE1ODMxMn0.vHKA2q91ByXYmgte9bjQi4_21SJaSxOqrHhsSJZ6kbI', // Key anonim Supabase
      );
    }
  } catch (e) {
    // Tangkap error jika Supabase gagal diinisialisasi
    debugPrint('Error saat inisialisasi Supabase: $e');
  }

  // 3. Jalankan aplikasi Flutter
  runApp(const MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor default dengan key opsional

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan banner debug di kanan atas
      title: 'Aplikasi Alat', // Judul aplikasi
      theme: ThemeData(primarySwatch: Colors.blue), // Warna tema aplikasi
      home: const LoginPage(), // Halaman utama saat aplikasi dibuka adalah LoginPage
    );
  }
}
