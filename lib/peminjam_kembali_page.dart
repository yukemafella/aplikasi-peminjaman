import 'package:flutter/material.dart';
// Import halaman navigasi Anda (pastikan file ini ada di project Anda)
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'dashboard_peminjam_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_pinjam_page.dart';
import 'peminjam_pengaturan_page.dart';

class KembaliPage extends StatefulWidget {
  const KembaliPage({super.key});

  @override
  State<KembaliPage> createState() => _KembaliPageState();
}

class _KembaliPageState extends State<KembaliPage> {
  // Kontrol tampilan halaman
  bool isSuccess = false;     // Untuk memunculkan centang hijau
  bool isDendaVisible = false; // Untuk memunculkan rincian denda

  @override
  Widget build(BuildContext context) {
    // Jika user mengklik centang hijau, tampilkan rincian denda
    if (isDendaVisible) {
      return _buildDendaPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (isSuccess) {
              setState(() => isSuccess = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        centerTitle: true,
        title: Text(
          isSuccess ? "Pengajuan Berhasil" : "Pengembalian",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- BOX 1: DAFTAR ALAT ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildAlatItem("Bola Futsal", "06-10 Januari 2026", "Menunggu", Colors.red[400]!),
                  const Divider(height: 1),
                  _buildAlatItem("Bola Basket", "14-16 Januari 2026", "Disetujui", Colors.green[400]!),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total: 2 alat", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "Total denda: 5.000",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- BOX 2: INFORMASI PENGEMBALIAN ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informasi Pengembalian", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Tanggal Kembali", style: TextStyle(color: Colors.black87)),
                      Text("10 Januari 2026", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- LOGIKA TOMBOL / NOTIFIKASI SUKSES ---
            if (!isSuccess)
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isSuccess = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E86C1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Kembalikan", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )
            else
              // Kotak Sukses (Bisa diklik untuk ke halaman denda)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDendaVisible = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("Disetujui", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      const Icon(Icons.check_circle, color: Colors.green, size: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "Terimakasih telah meminjam\nalat di pinjam.yuk",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // --- HALAMAN RINCIAN DENDA ---
  Widget _buildDendaPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => isDendaVisible = false),
        ),
        centerTitle: false,
        title: const Text("denda", style: TextStyle(color: Colors.grey, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card Daftar Alat
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Daftar Alat:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildSimpleItem("BolaBasket"),
                  const SizedBox(height: 20),
                  _buildSimpleItem("Gitar"),
                  const Divider(),
                  _buildTextRow("Tanggal Pinjam", "06 Januari 2026"),
                  _buildTextRow("Tanggal Kembali", "10 Januari 2026"),
                  _buildTextRow("Tanggal Pengembalian", "09 Januari 2026"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Banner Alert Denda
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Denda", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "Denda akibat keterlambatan dan kerusakan alat. Silakan lakukan pembayaran segera sesuai rincian berikut.",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Ringkasan Pembayaran
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ringkasan Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildTextRow("Denda Telat", "Rp 5.000"),
                  const Divider(),
                  _buildTextRow("TOTAL", "Rp 5.000", isBold: true),
                  const Divider(),
                  _buildTextRow("Metode", "Tunai"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Bayar
            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika bayar di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3489BC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("bayar", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSimpleItem(String name) {
    return Center(
      child: Column(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 12, color: Colors.green),
                SizedBox(width: 4),
                Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(String left, String right, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(right, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildAlatItem(String title, String date, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16, color: Color(0xFF2E86C1)),
              const SizedBox(width: 5),
              Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 12, color: Colors.green),
                SizedBox(width: 4),
                Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total: 1 alat", style: TextStyle(fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF2E86C1),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: 3,
      onTap: (index) {
        if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPeminjam(peminjamId: '',)));
        if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AlatPage()));
        if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PinjamPage()));
        if (index == 4) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PengaturanPage()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Persetujuan'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pinjam'),
        BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Kembali'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
      ],
    );
  }
}