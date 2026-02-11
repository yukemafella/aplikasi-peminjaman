import 'package:flutter/material.dart';
// Mengimpor halaman lain agar fungsi perpindahan layar (Navigator) dapat berjalan
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'dashboard_peminjam_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_pinjam_page.dart';
import 'peminjam_kembali_page.dart';
import 'login_page.dart'; // Penting: Digunakan untuk mengarahkan user setelah logout

// Menggunakan StatelessWidget karena halaman pengaturan ini hanya menampilkan data profil statis
class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  // --- FUNGSI: MENAMPILKAN DIALOG KONFIRMASI LOGOUT ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Mengatur sudut lengkung jendela pop-up
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Agar tinggi kotak mengikuti isi saja
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
                  // TOMBOL IYA (Warna Hijau)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushAndRemoveUntil: Pindah ke login & hapus semua histori halaman sebelumnya
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false, // Menghilangkan semua tumpukan route (user tidak bisa klik back)
                        );
                        
                        // Menampilkan notifikasi singkat di bawah layar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil Logout")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF62D24A), // Warna hijau sukses
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Iya", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  // TOMBOL TIDAK (Warna Merah)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Menutup dialog saja, tidak jadi logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE54D4D), // Warna merah peringatan
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
            // --- BAGIAN FOTO PROFIL ---
            const Center(
              child: Icon(
                Icons.account_circle, // Ikon profil bawaan
                size: 100,
                color: Colors.black,
              ),
            ),
            const Text(
              "Yuke", // Nama Pengguna
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Petugas", // Jabatan Pengguna
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // --- BAGIAN FORM INFORMASI (HANYA BACA/READ-ONLY) ---
            _buildTextField("Nama", "Yuke"),
            const SizedBox(height: 15),
            _buildTextField("Email", "Yuke@gmail.com"),
            const SizedBox(height: 15),
            _buildTextField("Password", "**********", isPassword: true),
            const SizedBox(height: 15),
            _buildTextField("Sebagai", "Peminjaman"),
            
            const SizedBox(height: 40),
            
            // --- TOMBOL LOGOUT UTAMA (Warna Biru) ---
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context); // Memicu munculnya dialog konfirmasi
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
        currentIndex: 4, // Menandakan bahwa ikon ke-5 (Pengaturan) sedang aktif
        onTap: (index) {
          // Logika navigasi berdasarkan urutan ikon di bawah
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

  // --- HELPER WIDGET: UNTUK MEMBUAT INPUT FIELD DENGAN CEPAT ---
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
          obscureText: isPassword, // Jika true, teks akan disensor (bintang-bintang)
          readOnly: true, // User tidak bisa mengetik ulang di field ini
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(), // Garis kotak standar
            suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null, // Ikon mata jika password
          ),
        ),
      ],
    );
  }
}