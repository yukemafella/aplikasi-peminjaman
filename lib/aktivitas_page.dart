import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_page.dart';
import 'package:flutter_application_1/admin_pengguna_page.dart';
import 'package:flutter_application_1/peminjaman_page.dart';
import 'package:flutter_application_1/pengembalian_admin_page.dart';
import 'dashboard_page.dart';
import 'alat_page.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  // Index untuk filter kategori
  int selectedFilterIndex = 0;
  final List<String> filters = ["Semua", "Dipinjam", "Kembali", "Terlambat"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Riwayat",
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          // Row Filter (Semua, Dipinjam, dll)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(filters.length, (index) {
                return _buildFilterButton(index);
              }),
            ),
          ),
         
          // List Item Riwayat
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildHistoryCard(
                  name: "Sanjaya",
                  item: "Bola futsal",
                  date: "06, jan 2026 - 09, jan 2026",
                  status: "Dipinjam",
                  image: Icons.sports_soccer, // Ganti dengan Image.network jika ada URL
                ),
                _buildHistoryCard(
                  name: "Adit",
                  item: "Bola Basket",
                  date: "06, jan 2026 - 09, jan 2026",
                  status: "Dikembalikan",
                  image: Icons.sports_basketball,
                ),
                _buildHistoryCard(
                  name: "Elingga",
                  item: "Seruling",
                  date: "1, jan 2026 - 5, jan 2026",
                  status: "Terlambat",
                  image: Icons.music_note,
                ),
              ],
            ),
          ),
        ],
      ),
     
      // Bottom Navbar sesuai mockup
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, // Aktivitas/Riwayat aktif
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AlatPage()));
          }else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPenggunaPage()));
          }else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PengembalianAdminPage()));
          }else if (index == 5) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PeminjamanPage()));
          }
          // Tambahkan navigasi index lain di sini
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_outlined), label: 'Pengembalian'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Peminjaman'),
        ],
      ),
    );
  }

  // Widget Tombol Filter
  Widget _buildFilterButton(int index) {
    bool isSelected = selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3488BC) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          filters[index],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Widget Kartu Riwayat
  Widget _buildHistoryCard({
    required String name,
    required String item,
    required String date,
    required String status,
    required IconData image,
  }) {
    Color statusColor;
    // ignore: curly_braces_in_flow_control_structures
    if (status == "Dipinjam") statusColor = Colors.orange.shade100;
    else if (status == "Dikembalikan") statusColor = Colors.green.shade100;
    else statusColor = Colors.red.shade100;

    Color textColor = status == "Dipinjam" ? Colors.orange.shade900 : (status == "Dikembalikan" ? Colors.green.shade900 : Colors.red.shade900);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Gambar Ilustrasi
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(image, color: Colors.brown, size: 35),
          ),
          const SizedBox(width: 15),
          // Info Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(item, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                // Label Status & Tombol Hapus
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Icon(status == "Dikembalikan" ? Icons.check_circle : Icons.info, size: 12, color: textColor),
                          const SizedBox(width: 4),
                          Text(status, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: const [
                            Icon(Icons.delete, size: 12, color: Colors.red),
                            SizedBox(width: 4),
                            Text("Hapus", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Konfirmasi Hapus sesuai mockup
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 50),
            const SizedBox(height: 15),
            const Text(
              "Hapus Riwayat?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "Data riwayat akan dihapus permanen",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Ya, Hapus", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}