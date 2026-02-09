import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_page.dart';
import 'package:flutter_application_1/admin_pengguna_page.dart';
import 'package:flutter_application_1/peminjaman_page.dart';
import 'package:flutter_application_1/pengembalian_admin_page.dart';
import 'dashboard_page.dart';
import 'alat_page.dart';

class Riwayat {
  final String nama;
  final String alat;
  final String tanggal;
  final String status;
  final IconData icon;

  Riwayat({
    required this.nama,
    required this.alat,
    required this.tanggal,
    required this.status,
    required this.icon,
  });
}

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  int selectedFilterIndex = 0;
  final List<String> filters = ["Semua", "Dipinjam", "Kembali", "Terlambat"];

  // Daftar data riwayat
  final List<Riwayat> daftarRiwayat = [
    Riwayat(
      nama: "Sanjaya",
      alat: "Bola futsal",
      tanggal: "06, jan 2026 - 09, jan 2026",
      status: "Dipinjam",
      icon: Icons.sports_soccer,
    ),
    Riwayat(
      nama: "Adit",
      alat: "Bola Basket",
      tanggal: "06, jan 2026 - 09, jan 2026",
      status: "Kembali",
      icon: Icons.sports_basketball,
    ),
    Riwayat(
      nama: "Elingga",
      alat: "Seruling",
      tanggal: "1, jan 2026 - 5, jan 2026",
      status: "Terlambat",
      icon: Icons.music_note,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Riwayat> dataTampil = daftarRiwayat.where((item) {
      if (selectedFilterIndex == 0) return true;
      return item.status == filters[selectedFilterIndex];
    }).toList();

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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(filters.length, (index) {
                return _buildFilterButton(index);
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: dataTampil.length,
              itemBuilder: (context, index) {
                return _buildHistoryCard(dataTampil[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, 
        onTap: (index) {
          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
          if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AlatPage()));
          if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPenggunaPage()));
          if (index == 4) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PengembalianAdminPage()));
          if (index == 5) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PeminjamanPage()));
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

  Widget _buildHistoryCard(Riwayat data) {
    Color statusBgColor;
    Color textColor;
    String labelText = data.status;

    if (data.status == "Dipinjam") {
      statusBgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
    } else if (data.status == "Kembali") {
      statusBgColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      labelText = "Dikembalikan";
    } else {
      statusBgColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
    }

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
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(data.icon, color: Colors.brown, size: 35),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(data.alat, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(data.tanggal, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Icon(data.status == "Kembali" ? Icons.check_circle : Icons.info, size: 12, color: textColor),
                          const SizedBox(width: 4),
                          Text(labelText, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(data), // Kirim data spesifik ke dialog
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

  void _showDeleteDialog(Riwayat item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 50),
            const SizedBox(height: 15),
            const Text("Hapus Riwayat?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text("Data riwayat akan dihapus permanen", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      daftarRiwayat.remove(item); // Menghapus data dari list utama
                    });
                    Navigator.pop(context); // Tutup dialog
                  },
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