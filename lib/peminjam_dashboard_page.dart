import 'package:flutter/material.dart';
import 'package:flutter_application_1/petugas_pratinjau_page.dart';
// Import halaman-halaman lain agar navigasi (perpindahan layar) bisa berfungsi
import 'peminjam_persetujuan_page.dart'; 
import 'peminjam_pinjam_page.dart';
import 'peminjam_kembali_page.dart';
import 'peminjam_pengaturan_page.dart';

class DashboardPeminjam extends StatelessWidget {
  const DashboardPeminjam({super.key, required String peminjamId}); 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mengatur warna latar belakang halaman
      appBar: AppBar(
        backgroundColor: Colors.grey[300], // Warna abu-abu terang untuk bar atas
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        automaticallyImplyLeading: false, // Menghilangkan tombol 'back' otomatis (biasanya setelah login)
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      // SingleChildScrollView: Supaya halaman bisa di-scroll jika kontennya melebihi tinggi layar
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30), // Memberi jarak kosong vertikal

            // --- BAGIAN 1: CARD TOTAL PEMINJAMAN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    // Memberikan efek bayangan lembut di sekitar kartu
                    BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Teks kiri dan kanan menjauh
                      children: const [
                        Text("Total Peminjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // LinearProgressIndicator: Menampilkan bar kemajuan/progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.7, // Nilai progress (0.0 sampai 1.0)
                        minHeight: 12, // Ketebalan bar
                        backgroundColor: Colors.blue[50],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[200]!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- BAGIAN 2: STATUS BOXES (SELESAI & TERLAMBAT) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Memanggil fungsi helper _buildStatusBox agar kode tidak berulang
                  _buildStatusBox(const Color(0xFF28A745), Icons.check, "1 Selesai"),
                  const SizedBox(width: 15),
                  _buildStatusBox(const Color(0xFFEF5350), Icons.warning_amber_rounded, "2 Terlambat"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- BAGIAN 3: LIST STATUS PEMINJAMAN (TABEL MINI) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!), // Garis pinggir tipis
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
                    const Divider(height: 1), // Garis pembatas horizontal
                    // Memanggil fungsi helper untuk membuat baris item barang
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

      // --- BOTTOM NAVIGATION BAR (NAVIGASI BAWAH) ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menjaga posisi ikon agar tetap (tidak bergeser saat diklik)
        backgroundColor: const Color(0xFF2E86C1), // Warna dasar biru navigasi
        selectedItemColor: Colors.white, // Warna ikon yang sedang dipilih
        unselectedItemColor: Colors.white70, // Warna ikon yang tidak dipilih
        currentIndex: 0, // Indeks yang aktif (0 = Beranda)
        onTap: (index) {
          // Logika Navigasi: Pindah halaman sesuai index yang diklik
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AlatPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PinjamPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KembaliPage()));
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

  // --- FUNGSI HELPER: KOTAK STATUS (Hijau/Merah) ---
  // Dibuat terpisah agar rapi karena tampilannya mirip (tinggal ganti warna & ikon)
  Widget _buildStatusBox(Color color, IconData icon, String label) {
    return Expanded( // Membagi ruang secara merata dalam Row
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

  // --- FUNGSI HELPER: ITEM LIST BARANG ---
  // Digunakan untuk menampilkan baris nama barang dan status "Di Pinjam"
  Widget _buildListItem(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.green, fontSize: 12)),
      trailing: Container( // Widget di ujung kanan baris
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