import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_page.dart';
import 'package:flutter_application_1/admin_pengguna_page.dart';
import 'package:flutter_application_1/peminjaman_page.dart';
import 'package:flutter_application_1/pengembalian_admin_page.dart';
import 'login_page.dart';
import 'alat_page.dart';
import 'aktivitas_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                _buildDisabledField("Nama", "Yuke"),
                _buildDisabledField("Email", "Yuke@gmail.com"),
                _buildDisabledField("Password", "****", isPassword: true),
                _buildDisabledField("Sebagai", "Admin"),
                const SizedBox(height: 30),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Iya", style: TextStyle(color: Colors.white)),
                  ),
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
              GestureDetector(
                onTap: () => _showProfileDialog(context),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.person_outline, size: 40, color: Colors.black),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Yuke", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("Petugas", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text("Grafik alat yang sering di pinjam",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              ),
              const SizedBox(height: 20),
              Container(
                height: 150,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(140, Colors.grey.shade100),
                    _buildBar(110, const Color(0xFF3488BC)),
                    _buildBar(80, Colors.grey.shade100),
                    _buildBar(125, const Color(0xFF3488BC)),
                    _buildBar(60, Colors.grey.shade100),
                    _buildBar(100, const Color(0xFF3488BC)),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Alat yang di Pinjam",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text("Detail", style: TextStyle(fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 15),
              _buildBorrowedItem("Bola basket", "Olahraga", "1 unit", Icons.sports_basketball),
              _buildBorrowedItem("Gitar", "Musik", "1 unit", Icons.music_note),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.8),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AktivitasPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlatPage()),
            );
          }else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminPenggunaPage()),
            );
          }else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PengembalianAdminPage()),
            );
          }else if (index == 5) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PeminjamanPage()),
            );
          }
          // Logika navigasi index lainnya bisa ditambahkan di sini
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Alat'), // Ikon Keranjang
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_outlined), label: 'Pengembalian'),
          BottomNavigationBarItem(icon: Icon(Icons.handshake_outlined), label: 'Peminjaman'), // Ikon Peminjaman Baru
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 35,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildBorrowedItem(String name, String category, String unit, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(category, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(unit, style: const TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}