import 'package:flutter/material.dart';
import 'package:flutter_application_1/Dashboard_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart' hide DashboardPage; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String? _emailError;
  String? _passwordError;

  Future<void> _handleLogin() async {
    // 1. Validasi lokal
    setState(() {
      _emailError = _emailController.text.isEmpty ? "Email anda salah!" : null;
      _passwordError = _passwordController.text.isEmpty ? "Password anda salah!" : null;
    });

    if (_emailError != null || _passwordError != null) return;

    try {
      // 2. Proses Login ke Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 3. Navigasi jika sukses
      if (response.user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Gagal: Periksa kembali akun anda")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon/Logo
              Icon(Icons.lock_person_rounded, size: 100, color: Colors.blue[900]),
              const SizedBox(height: 10),
              Text(
                "Siraseta Brantas",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blue[900]
                ),
              ),
              const Text("Sekolah Pintar", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              // Input Email
              const Align(alignment: Alignment.centerLeft, child: Text("Email")),
              const SizedBox(height: 5),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email anda",
                  errorText: _emailError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Input Password
              const Align(alignment: Alignment.centerLeft, child: Text("Pasword")),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "Password anda",
                  errorText: _passwordError,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Login
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // Penutup class _LoginPageState sudah benar di sini