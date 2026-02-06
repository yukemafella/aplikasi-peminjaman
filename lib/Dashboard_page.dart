import 'package:flutter/material.dart';
import 'login_page.dart'; // Pastikan di-import untuk navigasi balik

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Fungsi untuk menampilkan Pop-up Pengaturan & Logout
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("pengaturan", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, size: 50, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text("Yuke", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text("Petugas", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                
                // Form Field (Read Only sesuai desain)
                _buildDisabledField("Nama", "Yuke"),
                _buildDisabledField("Email", "Yuke@gmail.com"),
                _buildDisabledField("Password", "****", isPassword: true),
                _buildDisabledField("Sebagai", "Admin"),
                
                const SizedBox(height: 30),
                
                // Tombol Logout Utama
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutConfirmation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3488BC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text("Logout", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi Konfirmasi Logout (Gambar Kanan)
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah anda yakin keluar dari akun ini !",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Iya (Hijau) -> Kembali ke Login
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Iya", style: TextStyle(color: Colors.white)),
                  ),
                  // Tombol Tidak (Merah)
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Tidak", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // Widget Helper untuk Field di Dialog
  Widget _buildDisabledField(String label, String value, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          TextField(
            controller: TextEditingController(text: value),
            enabled: false,
            obscureText: isPassword,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil (DIBERIKAN GESTURE DETECTOR)
              GestureDetector(
                onTap: () => _showProfileDialog(context),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Yuke", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Admin!", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- Bagian Statistik & Grafik Tetap Sama ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Total alat", "10"),
                  _buildStatCard("Pinjaman aktif", "8"),
                  _buildStatCard("Barang rusak", "3"),
                ],
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text("Grafik alat yang sering di pinjam", 
                  style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 10),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(100, Colors.black12),
                    _buildBar(80, Colors.blue),
                    _buildBar(50, Colors.black12),
                    _buildBar(120, Colors.blue),
                    _buildBar(40, Colors.black12),
                    _buildBar(70, Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildActivityItem("Sanjaya", "30/01/2026", "Peminjam", Colors.grey),
              _buildActivityItem("Clara", "30/01/2026", "Petugas", Colors.blue.shade300),
              _buildActivityItem("Aisya", "30/01/2026", "Peminjam", Colors.grey),
              _buildActivityItem("Rara", "30/01/2026", "Petugas", Colors.blue.shade300),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Aktivitas'),
        ],
      ),
    );
  }

  // --- Widget Helpers (StatCard, Bar, ActivityItem) tetap sama ---
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildActivityItem(String name, String date, String role, Color roleColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama : $name"),
              Text("Tanggal : $date"),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: roleColor, borderRadius: BorderRadius.circular(20)),
            child: Text(role, style: const TextStyle(color: Colors.white, fontSize: 10)),
          )
        ],
      ),
    );
  }
}