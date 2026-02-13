import 'package:flutter/material.dart';
import 'package:flutter_application_1/peminjam_dashboard_page.dart';
import 'package:flutter_application_1/petugas_pratinjau_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import halaman navigasi Anda
import 'dashboard_peminjam_page.dart';
import 'peminjam_persetujuan_page.dart';
import 'peminjam_kembali_page.dart'; 
import 'peminjam_pengaturan_page.dart';

class PinjamPage extends StatefulWidget {
  const PinjamPage({super.key});

  @override
  State<PinjamPage> createState() => _PinjamPageState();
}

class _PinjamPageState extends State<PinjamPage> {
  final supabase = Supabase.instance.client;

  // Stream data real-time dari tabel 'peminjaman'
  final Stream<List<Map<String, dynamic>>> _pinjamanStream = Supabase.instance.client
      .from('peminjaman')
      .stream(primaryKey: ['id_peminjaman'])
      .order('id_peminjaman', ascending: false);

  // --- LOGIKA SUPABASE: BATALKAN PESANAN ---
  Future<void> _batalkanPeminjaman(int id) async {
    try {
      await supabase.from('peminjaman').delete().eq('id_peminjaman', id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Peminjaman berhasil dibatalkan")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal membatalkan: $e")),
      );
    }
  }

  // --- LOGIKA SUPABASE: KEMBALIKAN ALAT ---
  Future<void> _kembalikanAlat(int id) async {
    try {
      await supabase
          .from('peminjaman')
          .update({'status': 'kembali'}).eq('id_peminjaman', id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Status berhasil diperbarui ke Kembali")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Daftar Pinjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _pinjamanStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Tidak ada data peminjaman."));

          final daftarPinjaman = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: daftarPinjaman.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final item = daftarPinjaman[index];
              final idAlat = item['id_alat'];

              return FutureBuilder<Map<String, dynamic>>(
                future: supabase.from('alat').select().eq('id_alat', idAlat).single(),
                builder: (context, alatSnapshot) {
                  String namaAlat = "Memuat...";
                  String? urlGambar;

                  if (alatSnapshot.hasData) {
                    namaAlat = alatSnapshot.data!['nama_alat'] ?? "Alat ID: $idAlat";
                    urlGambar = alatSnapshot.data!['gambar_url'];
                  }

                  String statusRaw = item['status']?.toString() ?? "menunggu";
                  String statusDisplay = statusRaw.isNotEmpty 
                      ? statusRaw[0].toUpperCase() + statusRaw.substring(1) 
                      : "Menunggu";
                  
                  Color statusColor = statusRaw.toLowerCase() == 'disetujui' 
                      ? Colors.green[400]! 
                      : Colors.red[400]!;

                  return GestureDetector(
                    onTap: () => _showRiwayatSetujuDialog(context, item, namaAlat, urlGambar),
                    child: _buildPinjamCard(
                      title: namaAlat,
                      date: "${item['tanggal_pinjam'] ?? ''} s/d ${item['tanggal_kembali'] ?? ''}",
                      statusText: statusDisplay,
                      statusColor: statusColor,
                      imageUrl: urlGambar,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation())),
        backgroundColor: const Color(0xFF2E86C1),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E86C1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPeminjam(peminjamId: '')));
          // ignore: curly_braces_in_flow_control_structures
          else if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
          else if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KembaliPage()));
          else if (index == 4) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PengaturanPage()));
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

  Widget _buildPinjamCard({required String title, required String date, required String statusText, required Color statusColor, String? imageUrl}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image)))
                      : const Icon(Icons.inventory_2, size: 40, color: Colors.blueGrey),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(children: [const Icon(Icons.calendar_month, size: 14, color: Color(0xFF2E86C1)), const SizedBox(width: 5), Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54))]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total: 1 alat", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(5)),
                  child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showRiwayatSetujuDialog(BuildContext context, Map<String, dynamic> item, String namaAlat, String? imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModalDetailCard(namaAlat, item),
              const SizedBox(height: 15),
              const Align(alignment: Alignment.centerLeft, child: Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold))),
              const Divider(),
              _buildInfoRow("Tanggal Pinjam", item['tanggal_pinjam']),
              _buildInfoRow("Tanggal Kembali", item['tanggal_kembali']),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showPersetujuanDetailDialog(context, item, namaAlat);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Menunggu Persetujuan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text("Petugas sedang memproses pengajuanmu. Klik untuk detail.", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton("Tutup", Colors.white, Colors.black, () => Navigator.pop(context)),
                  _buildActionButton("Batal", Colors.blueGrey.shade300, Colors.white, () => _batalkanPeminjaman(item['id_peminjaman'])),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPersetujuanDetailDialog(BuildContext context, Map<String, dynamic> item, String namaAlat) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Riwayat tunggu", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 10),
                _buildModalDetailCard(namaAlat, item),
                const SizedBox(height: 10),
                const Align(alignment: Alignment.centerLeft, child: Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold))),
                const Divider(),
                _buildInfoRow("Tanggal Pinjam", item['tanggal_pinjam']),
                _buildInfoRow("Tanggal Kembali", item['tanggal_kembali']),
                _buildInfoRow("Tanggal Tenggat", item['tanggal_kembali']),
                const SizedBox(height: 10),
                const Text("Jam Ambil: 06.00 - 16.00", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 40),
                      Text("Disetujui", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Pengajuan kamu sudah disetujui petugas. Silakan ambil alat sesuai jadwal.", textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton("Tutup", Colors.white, Colors.black, () => Navigator.pop(context)),
                    _buildActionButton("Kembalikan", Colors.blueGrey.shade300, Colors.white, () => _kembalikanAlat(item['id_peminjaman'])),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalDetailCard(String namaAlat, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(namaAlat, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${item['tanggal_pinjam']} - ${item['tanggal_kembali']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(5)),
            child: const Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 10)),
          ),
          const Divider(),
          const Align(alignment: Alignment.centerRight, child: Text("Total: 1 alat", style: TextStyle(fontSize: 10))),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
              child: const Text("Disetujui", style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value?.toString() ?? "-", style: const TextStyle(fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildActionButton(String label, Color bg, Color text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: bg, side: bg == Colors.white ? const BorderSide(color: Colors.black12) : null, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(label, style: TextStyle(color: text)),
    );
  }
}

class CustomBottomNav {
  const CustomBottomNav({required int currentIndex});
}