import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uddtkqdljfgenjibxrwv.supabase.co',
    anonKey:  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkZHRrcWRsamZnZW5qaWJ4cnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODIzMTIsImV4cCI6MjA4NDE1ODMxMn0.vHKA2q91ByXYmgte9bjQi4_21SJaSxOqrHhsSJZ6kbI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // LOGIN → nanti pindah ke HomePage
    );
  }
}
