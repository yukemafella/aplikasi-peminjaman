import 'package:flutter/material.dart';
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'dashboard_peminjam_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_pinjam_page.dart';
import 'peminjam_pengaturan_page.dart'; // Tambahkan import ini

class KembaliPage extends StatelessWidget {
  const KembaliPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Pengembalian",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Container Daftar Alat
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildAlatItem("Bola Futsal", "06-10 Januari 2026", "Menunggu", Colors.red[400]!),
                  const Divider(height: 1, color: Colors.black),
                  _buildAlatItem("Bola Basket", "14-16 Januari 2026", "Disetujui", Colors.green[400]!),
                  const Divider(height: 1, color: Colors.black),
                  // Total Alat
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Total: 2 alat",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Informasi Peminjaman
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informasi Peminjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.black),
                  _buildDetailRow("Tanggal Pinjam", "06 Januari 2026"),
                  const Divider(color: Colors.black26),
                  _buildDetailRow("Kembali", "09 Januari 2026"),
                  const Divider(color: Colors.black26),
                  _buildDetailRow("Tanggal Tenggat", "10 Januari 2026"),
                  const Divider(color: Colors.black26),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Terlambat 1 hr",
                        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Tombol Kembalikan
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika kembalikan di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E86C1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Kembalikan",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E86C1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 3, // Menu Kembali Aktif
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPeminjam()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PersetujuanPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PinjamPage()));
          } else if (index == 4) { // NAVIGASI PENGATURAN
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PengaturanPage()));
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

  Widget _buildAlatItem(String title, String date, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16, color: Color(0xFF2E86C1)),
              const SizedBox(width: 5),
              Text(date, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(5)),
            child: const Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 11)),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total: 1 alat", style: TextStyle(fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}