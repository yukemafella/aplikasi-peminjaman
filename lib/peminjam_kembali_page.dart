import 'package:flutter/material.dart';
// Import halaman navigasi agar fungsi perpindahan layar (Navigator) tidak error
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'dashboard_peminjam_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_pinjam_page.dart';
import 'peminjam_pengaturan_page.dart'; 

// Stateless karena halaman ini hanya menampilkan data (view only) 
// dan tidak ada perubahan state internal yang rumit di layar ini
class KembaliPage extends StatelessWidget {
  const KembaliPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set latar belakang putih bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Menghilangkan bayangan garis di bawah AppBar
        automaticallyImplyLeading: false, // Menghilangkan tombol 'back' otomatis
        centerTitle: true, // Judul diletakkan di tengah
        title: const Text(
          "Pengembalian",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      // SingleChildScrollView agar konten bisa di-scroll jika layar HP kecil
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20), // Memberi jarak di sekeliling konten
        child: Column(
          children: [
            // --- BOX 1: DAFTAR ALAT YANG SEDANG DIPINJAM ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black), // Garis pinggir hitam
                borderRadius: BorderRadius.circular(10), // Sudut melengkung
              ),
              child: Column(
                children: [
                  // Memanggil fungsi helper _buildAlatItem untuk menampilkan tiap baris alat
                  _buildAlatItem("Bola Futsal", "06-10 Januari 2026", "Menunggu", Colors.red[400]!),
                  const Divider(height: 1, color: Colors.black), // Garis pemisah antar item
                  _buildAlatItem("Bola Basket", "14-16 Januari 2026", "Disetujui", Colors.green[400]!),
                  const Divider(height: 1, color: Colors.black),
                  
                  // Bagian Footer di dalam kotak (Total Alat)
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
            const SizedBox(height: 30), // Spasi antar box

            // --- BOX 2: INFORMASI DETAIL PEMINJAMAN ---
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
                  const Divider(color: Colors.black), // Garis pemisah judul
                  
                  // Detail baris informasi menggunakan fungsi _buildDetailRow
                  _buildDetailRow("Tanggal Pinjam", "06 Januari 2026"),
                  const Divider(color: Colors.black26),
                  _buildDetailRow("Kembali", "09 Januari 2026"),
                  const Divider(color: Colors.black26),
                  _buildDetailRow("Tanggal Tenggat", "10 Januari 2026"),
                  const Divider(color: Colors.black26),
                  
                  const SizedBox(height: 5),
                  // Label Status Terlambat (Kanan Bawah)
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

            // --- TOMBOL KEMBALIKAN ---
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // Di sini tempat menaruh logika submit ke database nantinya
                  print("Proses Pengembalian Ditekan");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E86C1), // Warna biru
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
      
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menampilkan semua label ikon
        backgroundColor: const Color(0xFF2E86C1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 3, // Mengunci status aktif pada index ke-3 (Kembali)
        onTap: (index) {
          // Logika perpindahan halaman berdasarkan index yang diklik
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPeminjam()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PersetujuanPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PinjamPage()));
          } else if (index == 4) {
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

  // --- HELPER WIDGET: ITEM ALAT ---
  // Menampilkan informasi ringkas alat, tanggal, dan statusnya
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
          // Label "Tersedia" kecil
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
              // Label Status (Menunggu / Disetujui)
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

  // --- HELPER WIDGET: BARIS DETAIL ---
  // Membuat baris teks Kiri-Kanan (Label - Nilai) agar sejajar rapi
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