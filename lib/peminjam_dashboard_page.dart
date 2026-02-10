import 'package:flutter/material.dart';
import 'peminjam_persetujuan_page.dart'; 
import 'peminjam_pinjam_page.dart';
import 'peminjam_kembali_page.dart';
import 'peminjam_pengaturan_page.dart'; // Import halaman pengaturan

class DashboardPeminjam extends StatelessWidget {
  const DashboardPeminjam({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // --- Card Total Peminjaman ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Total Peminjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        minHeight: 12,
                        backgroundColor: Colors.blue[50],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[200]!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // --- Status Boxes (Selesai & Terlambat) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatusBox(const Color(0xFF28A745), Icons.check, "1 Selesai"),
                  const SizedBox(width: 15),
                  _buildStatusBox(const Color(0xFFEF5350), Icons.warning_amber_rounded, "2 Terlambat"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // --- List Status Peminjaman ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status Peminjaman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Icon(Icons.assignment_outlined, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _buildListItem("Bola Basket", "Kembali dalam: 5 hari"),
                    _buildListItem("Bola futsal", "Kembali dalam: 5 hari"),
                    _buildListItem("Gitar", "Kembali dalam: 5 hari"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // --- BOTTOM NAVIGATION BAR UPDATED ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E86C1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0, 
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PersetujuanPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PinjamPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const KembaliPage()),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PengaturanPage()),
            );
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

  // Widget Helper Kotak Status
  Widget _buildStatusBox(Color color, IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Widget Helper List Item
  Widget _buildListItem(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.green, fontSize: 12)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFB0BEC5).withOpacity(0.5), 
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Di Pinjam", 
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}