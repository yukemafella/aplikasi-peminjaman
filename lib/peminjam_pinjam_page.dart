import 'package:flutter/material.dart';
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'dashboard_peminjam_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_kembali_page.dart';
import 'peminjam_pengaturan_page.dart';

class PinjamPage extends StatelessWidget {
  const PinjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Daftar Pinjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Card 1: Bola Futsal (Status Menunggu)
          GestureDetector(
            onTap: () => _showRiwayatTungguDialog(context),
            child: _buildPinjamCard(
              title: "Bola Futsal",
              date: "06-10 Januari 2026",
              statusText: "Menunggu",
              statusColor: Colors.red[400]!,
              showImage: false,
            ),
          ),
          const SizedBox(height: 20),
          // Card 2: Bola Basket (Status Disetujui)
          GestureDetector(
            onTap: () => _showRiwayatSetujuDialog(context), // Klik untuk dialog disetujui
            child: _buildPinjamCard(
              title: "Bola Basket",
              date: "14-16 Januari 2026",
              statusText: "Disetujui",
              statusColor: Colors.green[400]!,
              showImage: true,
            ),
          ),
        ],
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E86C1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPeminjam()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PersetujuanPage()),
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

  // --- DIALOG STATUS DISETUJUI (Baru, Sesuai Gambar) ---
  void _showRiwayatSetujuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _buildDialogItemRow("Bola Futsal", "06-10 Januari 2026", "Menunggu", Colors.red[400]!),
                        const Divider(height: 20),
                        _buildDialogItemRow("Bola Basket", "14-16 Januari 2026", "Disetujui", Colors.green[400]!),
                        const Divider(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Total: 2 alat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const Divider(),
                        _buildInfoRow("Tanggal Pinjam", "14 Januari 2026"),
                        const Divider(),
                        _buildInfoRow("Tanggal Kembali", "16 Januari 2026"),
                        const Divider(),
                        _buildInfoRow("Tanggal Tenggat", "15 Januari 2026"),
                        const Divider(),
                        _buildInfoRow("Jam Ambil: 06.00 - 16.00", ""),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Alert Box Disetujui
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Disetujui", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(
                                "Pengajuan kamu sudah disetujui petugas. Silahkan ambil alat sesuai jadwal.",
                                style: TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black12),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Tutup", style: TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context), // Kembali ke halaman pinjam
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF94A3B8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Kembalikan", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- DIALOG STATUS MENUNGGU ---
  void _showRiwayatTungguDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _buildDialogItemRow("Bola Futsal", "06-10 Januari 2026", "Menunggu", Colors.red[400]!),
                        const Divider(height: 20),
                        _buildDialogItemRow("Bola Basket", "14-16 Januari 2026", "Disetujui", Colors.green[400]!),
                        const Divider(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Total: 2 alat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const Divider(),
                        _buildInfoRow("Tanggal Pinjam", "06 Januari 2026"),
                        const Divider(),
                        _buildInfoRow("Tanggal Kembali", "09 Januari 2026"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Menunggu Persetujuan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(
                                "Petugas sedang memproses pengajuanmu. Harap tunggu persetujuan lebih lanjut.",
                                style: TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black12),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Tutup", style: TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF94A3B8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Batal", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogItemRow(String name, String date, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Color(0xFF2E86C1)),
                const SizedBox(width: 5),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
              child: const Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("Total: 1 alat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            )
          ],
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPinjamCard({
    required String title,
    required String date,
    required String statusText,
    required Color statusColor,
    required bool showImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showImage)
                  Container(
                    width: 80, height: 80,
                    margin: const EdgeInsets.only(right: 15),
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/889/889455.png', 
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  const SizedBox(width: 20),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, size: 18, color: Color(0xFF2E86C1)),
                          const SizedBox(width: 5),
                          Text(date, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle, size: 14, color: Colors.green),
                            SizedBox(width: 5),
                            Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total: 1 alat", style: TextStyle(fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(5)),
                  child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}