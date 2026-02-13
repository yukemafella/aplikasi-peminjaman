import 'package:flutter/material.dart';
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'package:flutter_application_1/petugas_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'petugas_beranda_page.dart';
import 'admin_dashboard_page.dart';
import 'dashboard_peminjam_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  Future<void> _handleLogin() async {
    setState(() {
      _emailError =
          _emailController.text.isEmpty ? "Email tidak boleh kosong!" : null;
      _passwordError =
          _passwordController.text.isEmpty ? "Password tidak boleh kosong!" : null;
    });

    if (_emailError != null || _passwordError != null) return;

    try {
      setState(() => _isLoading = true);

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        throw Exception("User tidak ditemukan");
      }

      if (!mounted) return;

      final userId = user.id;
      final email = user.email?.toLowerCase() ?? "";

      // ================= ROLE BASED EMAIL =================
      if (email.contains('petugas')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PetugasDashboard(
              petugasId: userId,
            ),
          ),
        );
      } else if (email.contains('peminjam')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPeminjam(
              peminjamId: userId,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboardPage(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login gagal: Email atau password salah"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_person_rounded,
                  size: 100, color: Colors.blue[900]),
              const SizedBox(height: 10),
              Text(
                "Siraseta Brantas",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const Text(
                "Sekolah Pintar",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // EMAIL
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email")),
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

              // PASSWORD
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password")),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "Password anda",
                  errorText: _passwordError,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}