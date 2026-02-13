import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// IMPORT HALAMAN LOGIN ANDA DI SINI
// import 'package:nama_projek_kamu/login_page.dart'; 

class PetugasPengaturanPage extends StatefulWidget {
  const PetugasPengaturanPage({super.key});

  @override
  State<PetugasPengaturanPage> createState() => _PetugasPengaturanPageState();
}

class _PetugasPengaturanPageState extends State<PetugasPengaturanPage> {
  final supabase = Supabase.instance.client;

  String email = '';
  String nama = 'Yuke'; 
  String role = 'Petugas';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    final user = supabase.auth.currentUser;
    setState(() {
      email = user?.email ?? 'Yuke@gmail.com';
    });
  }

  // ================= FUNGSI PROSES LOGOUT =================
  Future<void> prosesLogoutKeLogin() async {
    try {
      await supabase.auth.signOut();
      
      if (mounted) {
        // MENGGUNAKAN MATERIALPAGEROUTE AGAR TIDAK ERROR "ROUTE NOT FOUND"
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()), 
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal Logout: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ================= DIALOG KONFIRMASI (image_0d8162.png) =================
  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Apakah anda yakin\nkeluar dari akun ini !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // TOMBOL IYA (WARNA HIJAU)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Tutup dialog
                        prosesLogoutKeLogin(); // Jalankan logout
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF63D15E),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Iya",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // TOMBOL TIDAK (WARNA MERAH)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE55353),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Tidak",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.account_circle, size: 100, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(role, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 30),
              _buildInputField("Nama", nama),
              const SizedBox(height: 15),
              _buildInputField("Email", email),
              const SizedBox(height: 15),
              _buildInputField("Password", "**********", isPassword: true),
              const SizedBox(height: 15),
              _buildInputField("Sebagai", role),
              const SizedBox(height: 40),
              SizedBox(
                width: 160,
                height: 45,
                child: ElevatedButton(
                  onPressed: showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4292C6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String value, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: value),
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}