import 'package:flutter/material.dart';
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_pinjam_page.dart';
import 'peminjam_kembali_page.dart';
// Impor file login Anda di sini
import 'login_page.dart'; 

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  // Fungsi untuk menampilkan dialog konfirmasi logout sesuai gambar
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah anda yakin keluar dari akun ini !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Hijau (Iya) - Logout dan kembali ke halaman Login
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke halaman login dan menghapus semua tumpukan halaman sebelumnya
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                        
                        // Menampilkan snackbar sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil Logout")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF62D24A), // Warna hijau sesuai gambar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Iya", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  // Tombol Merah (Tidak) - Menutup Dialog saja
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Menutup dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE54D4D), // Warna merah sesuai gambar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Tidak", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "pengaturan",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar Profil
            const Center(
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.black,
              ),
            ),
            const Text(
              "Yuke",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Petugas",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // Form Fields (ReadOnly sesuai gambar)
            _buildTextField("Nama", "Yuke"),
            const SizedBox(height: 15),
            _buildTextField("Email", "Yuke@gmail.com"),
            const SizedBox(height: 15),
            _buildTextField("Password", "**********", isPassword: true),
            const SizedBox(height: 15),
            _buildTextField("Sebagai", "Peminjaman"),
            
            const SizedBox(height: 40),
            
            // Tombol Logout Biru
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context); // Tampilkan dialog saat klik
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E86C1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 4, // Pengaturan Aktif
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPeminjam()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PersetujuanPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PinjamPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KembaliPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Persetujuan'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pinjam'),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Kembali'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  // Widget Helper untuk Text Field
  Widget _buildTextField(String label, String initialValue, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: initialValue,
          obscureText: isPassword,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(),
            suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
          ),
        ),
      ],
    );
  }
}