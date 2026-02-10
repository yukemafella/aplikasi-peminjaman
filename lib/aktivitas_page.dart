import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_dashboard_page.dart';
import 'package:flutter_application_1/admin_pengguna_page.dart';
import 'package:flutter_application_1/alat_page.dart';
import 'package:flutter_application_1/peminjaman_page.dart';
import 'package:flutter_application_1/pengembalian_admin_page.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  int selectedFilterIndex = 0;
  final List<String> filters = ["Semua", "Dipinjam", "Kembali", "Terlambat"];

  // DATA SOURCE
  List<Map<String, dynamic>> riwayatData = [
    {
      "name": "Sanjaya",
      "item": "Bola futsal",
      "date": "06, jan 2026 - 09, jan 2026",
      "status": "Dipinjam",
      "image": Icons.sports_soccer,
    },
    {
      "name": "Adit",
      "item": "Bola Basket",
      "date": "06, jan 2026 - 09, jan 2026",
      "status": "Kembali", // Disamakan dengan teks filter agar logika filter jalan
      "image": Icons.sports_basketball,
    },
    {
      "name": "Elingga",
      "item": "Seruling",
      "date": "1, jan 2026 - 5, jan 2026",
      "status": "Terlambat",
      "image": Icons.music_note,
    },
  ];

  // LOGIKA FILTER: Mengambil data sesuai kategori yang dipilih
  List<Map<String, dynamic>> get filteredData {
    if (selectedFilterIndex == 0) {
      return riwayatData; // Jika "Semua", tampilkan semua
    } else {
      // Filter berdasarkan status yang sama dengan teks di tombol filter
      return riwayatData
          .where((element) => element["status"] == filters[selectedFilterIndex])
          .toList();
    }
  }

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
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(filters.length, (index) {
                return _buildFilterButton(index);
              }),
            ),
          ),
          
          // List View yang sudah di-filter
          Expanded(
            child: filteredData.isEmpty 
              ? const Center(child: Text("Tidak ada data untuk kategori ini"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final data = filteredData[index];
                    // Mencari index asli di riwayatData agar saat hapus tidak salah hapus
                    int originalIndex = riwayatData.indexOf(data);

                    return _buildHistoryCard(
                      index: originalIndex, 
                      name: data["name"],
                      item: data["item"],
                      date: data["date"],
                      status: data["status"],
                      image: data["image"],
                    );
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
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AlatPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPenggunaPage()));
          } else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PengembalianAdminPage()));
          } else if (index == 5) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PeminjamanPage()));
          }
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

  Widget _buildHistoryCard({
    required int index,
    required String name,
    required String item,
    required String date,
    required String status,
    required IconData image,
  }) {
    Color statusColor;
    String labelStatus = status;

    // Menentukan warna label
    if (status == "Dipinjam") {
      statusColor = Colors.orange.shade100;
    } else if (status == "Kembali" || status == "Dikembalikan") {
      statusColor = Colors.green.shade100;
      labelStatus = "Dikembalikan"; // Agar tampilan tetap "Dikembalikan" meski data "Kembali"
    } else {
      statusColor = Colors.red.shade100;
    }

    Color textColor = status == "Dipinjam" ? Colors.orange.shade900 : (status == "Kembali" || status == "Dikembalikan" ? Colors.green.shade900 : Colors.red.shade900);

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
            child: Icon(image, color: Colors.brown, size: 35),
          ),
          const SizedBox(width: 15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Icon(labelStatus == "Dikembalikan" ? Icons.check_circle : Icons.info, size: 12, color: textColor),
                          const SizedBox(width: 4),
                          Text(labelStatus, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(index),
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

  void _showDeleteDialog(int index) {
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
                  onPressed: () {
                    setState(() {
                      riwayatData.removeAt(index);
                    });
                    Navigator.pop(context);
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