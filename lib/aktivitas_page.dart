import 'package:flutter/material.dart';
// Mengimpor halaman-halaman lain untuk kebutuhan navigasi (pindah halaman)
import 'package:flutter_application_1/admin_dashboard_page.dart';
import 'package:flutter_application_1/user_crud_page.dart';
import 'package:flutter_application_1/alat_page.dart';
import 'package:flutter_application_1/peminjaman_page.dart';
import 'package:flutter_application_1/admin_pengembalian.dart';

// Definisi kelas AktivitasPage sebagai StatefulWidget karena ada perubahan state (filter & hapus data)
class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  // Variabel untuk menyimpan index filter yang sedang aktif (0: Semua, 1: Dipinjam, dst)
  int selectedFilterIndex = 0;
  
  // Daftar teks kategori filter yang akan ditampilkan di tombol-tombol atas
  final List<String> filters = ["Semua", "Dipinjam", "Kembali", "Terlambat"];

  // DATA SOURCE: Sumber data statis berupa List of Maps untuk simulasi riwayat
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
      "status": "Kembali", // Status disesuaikan dengan teks filter agar logika .where berjalan
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

  // LOGIKA FILTER: Getter ini akan menghasilkan list baru yang sudah disaring berdasarkan kategori terpilih
  List<Map<String, dynamic>> get filteredData {
    if (selectedFilterIndex == 0) {
      return riwayatData; // Jika yang dipilih "Semua", kembalikan seluruh data original
    } else {
      // Menyaring data berdasarkan key "status" yang isinya sama dengan teks filter yang diklik
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
        backgroundColor: const Color(0xFFE0E0E0), // Warna background abu-abu terang
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        automaticallyImplyLeading: false, // Mematikan tombol back otomatis
        title: const Text(
          "Riwayat",
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          // Filter Row: Wadah untuk tombol-tombol filter di bagian atas
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(filters.length, (index) {
                // Memanggil fungsi helper untuk membangun masing-masing tombol filter
                return _buildFilterButton(index);
              }),
            ),
          ),
          
          // List View: Bagian daftar riwayat yang bisa di-scroll
          Expanded(
            child: filteredData.isEmpty 
              // Tampilan jika data yang di-filter ternyata kosong
              ? const Center(child: Text("Tidak ada data untuk kategori ini"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final data = filteredData[index];
                    // Mencari index asli di list riwayatData agar saat hapus tidak salah item
                    int originalIndex = riwayatData.indexOf(data);

                    // Memanggil fungsi helper untuk membangun kartu riwayat
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
      // Navigasi Bawah: Menu utama aplikasi
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menampilkan semua label item
        backgroundColor: const Color(0xFF3488BC), // Warna biru dasar navigasi
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, // Menu 'Aktivitas' ditandai sebagai menu aktif
        onTap: (index) {
          // Logika pindah halaman menggunakan Navigator.pushReplacement
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AlatPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserCrudPage()));
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

  // Helper Widget: Fungsi untuk membangun tombol filter tunggal
  Widget _buildFilterButton(int index) {
    bool isSelected = selectedFilterIndex == index; // Cek apakah tombol ini sedang aktif
    return GestureDetector(
      // Saat diklik, perbarui selectedFilterIndex dan build ulang UI (setState)
      onTap: () => setState(() => selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3488BC) : const Color(0xFFE0E0E0), // Warna berubah jika terpilih
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

  // Helper Widget: Fungsi untuk membangun tampilan kartu riwayat satu per satu
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

    // Logika pewarnaan Label Status berdasarkan teks status data
    if (status == "Dipinjam") {
      statusColor = Colors.orange.shade100;
    } else if (status == "Kembali" || status == "Dikembalikan") {
      statusColor = Colors.green.shade100;
      labelStatus = "Dikembalikan"; // Mengubah teks "Kembali" menjadi "Dikembalikan" agar lebih formal
    } else {
      statusColor = Colors.red.shade100; // Untuk status Terlambat
    }

    // Pewarnaan teks di dalam label status
    Color textColor = status == "Dipinjam" ? Colors.orange.shade900 : (status == "Kembali" || status == "Dikembalikan" ? Colors.green.shade900 : Colors.red.shade900);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Efek bayangan halus di bawah kartu
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Bagian Icon: Menampilkan icon alat (misal bola/musik) dalam lingkaran
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(image, color: Colors.brown, size: 35),
          ),
          const SizedBox(width: 15),
          // Bagian Informasi: Nama peminjam, barang, dan tanggal
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
                // Bagian Baris Status & Tombol Hapus
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Label Status (Badge)
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
                    // Tombol Hapus: Memunculkan Dialog Konfirmasi
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

  // Fungsi untuk menampilkan Dialog konfirmasi hapus
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Dialog mengikuti ukuran konten (kecil)
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
                // Tombol Batal
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                // Tombol Konfirmasi Hapus
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Menghapus data dari list utama berdasarkan index yang dikirim
                      riwayatData.removeAt(index);
                    });
                    Navigator.pop(context); // Menutup dialog setelah hapus
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