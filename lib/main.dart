import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uddtkqdljfgenjibxrwv.supabase.co',
    anonKey: 'sb_publishable_xeuY8wNysgeJF9D4noNCGw_aMxWD_I6',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> cekKoneksi() async {
    try {
      // Query ringan ke database (tidak perlu login)
      final response = await Supabase.instance.client
          .from('kategori')
          .select('id_kategori')
          .limit(1);

      return response.isNotEmpty
          ? '✅ Supabase terhubung'
          : '⚠️ Terhubung, tapi tabel kosong';
    } catch (e) {
      return '❌ Gagal terhubung ke Supabase';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Connected'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final hasil = await cekKoneksi();

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(hasil),
              ),
            );
          },
          child: const Text('Cek Koneksi Supabase'),
        ),
      ),
    );
  }
}
