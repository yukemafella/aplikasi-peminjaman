import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPengembalianPage extends StatefulWidget {
  const PetugasPengembalianPage({super.key});

  @override
  State<PetugasPengembalianPage> createState() => _PetugasPengembalianPageState();
}

class _PetugasPengembalianPageState extends State<PetugasPengembalianPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- FUNGSI SIMPAN KE SUPABASE ---
  Future<void> _updateDenda(int idPengembalian, int nominalBaru) async {
    try {
      await supabase
          .from('pengembalian')
          .update({'denda': nominalBaru})
          .match({'id_pengembalian': idPengembalian}); // Mencocokkan ID
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Denda Rp $nominalBaru Berhasil Disimpan!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- DIALOG INPUT DENDA ---
  void _showDendaDialog(int idPengembalian, dynamic dendaSekarang) {
    // Controller untuk mengambil teks dari TextField
    final TextEditingController dendaController = 
        TextEditingController(text: dendaSekarang.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Input Denda Manual", 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Masukkan nominal denda baru untuk peminjaman ini.",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 15),
            TextField(
              controller: dendaController,
              keyboardType: TextInputType.number, // Memunculkan keyboard angka
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Nominal Denda",
                prefixText: "Rp ",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal", style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4292C6)),
            onPressed: () {
              // Validasi input: Pastikan hanya angka
              final int? nominal = int.tryParse(dendaController.text);
              if (nominal != null) {
                _updateDenda(idPengembalian, nominal); // PANGGIL FUNGSI SIMPAN
                Navigator.pop(context); // Tutup Dialog
              } else {
                // Notifikasi jika input bukan angka
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Masukkan angka yang valid!")),
                );
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            color: const Color(0xFFE0E0E0),
            width: double.infinity,
            child: const Center(
              child: Text("Data Pengembalian Alat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          // Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              children: [
                Expanded(child: _buildTabItem("Proses", 0)),
                const SizedBox(width: 5),
                Expanded(child: _buildTabItem("Selesai", 1)),
                const SizedBox(width: 5),
                Expanded(child: _buildTabItem("Denda", 2)),
              ],
            ),
          ),
          // List Data
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('pengembalian')
                  .stream(primaryKey: ['id_pengembalian'])
                  .order('tanggal_dikembalikan', ascending: false),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allData = snapshot.data ?? [];
                final filteredData = allData.where((item) {
                  if (_tabController.index == 1) return item['denda'] == 0;
                  if (_tabController.index == 2) return item['denda'] > 0;
                  return true;
                }).toList();

                if (filteredData.isEmpty) {
                  return const Center(child: Text("Tidak ada data."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final returnItem = filteredData[index];
                    return FutureBuilder(
                      future: supabase
                          .from('peminjaman')
                          .select()
                          .eq('id_peminjaman', returnItem['id_peminjaman'])
                          .single(),
                      builder: (context, AsyncSnapshot pinjamSnapshot) {
                        if (!pinjamSnapshot.hasData) return const SizedBox(height: 100);
                        final pinjamItem = pinjamSnapshot.data!;

                        return _buildReturnCard(
                          id: returnItem['id_pengembalian'],
                          nama: "User ID: ${pinjamItem['id_user'].toString().substring(0, 8)}",
                          denda: returnItem['denda'],
                          alat: "ID Alat: ${pinjamItem['id_alat']}",
                          tglPinjam: pinjamItem['tanggal_pinjam'] ?? '-',
                          tglTenggat: pinjamItem['tanggal_kembali'] ?? '-',
                          tglKembali: returnItem['tanggal_dikembalikan'] ?? '-',
                          fotoUrl: pinjamItem['foto'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4292C6) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnCard({
    required int id,
    required String nama,
    required dynamic denda,
    required String alat,
    required String tglPinjam,
    required String tglTenggat,
    required String tglKembali,
    String? fotoUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFF1F1F1),
                child: Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      denda > 0 ? "Denda: Rp $denda" : "Tanpa Denda",
                      style: TextStyle(
                        fontSize: 12,
                        color: denda > 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // TOMBOL KLIK EDIT
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') _showDendaDialog(id, denda);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit Denda Manual")),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              Container(
                width: 45, height: 45,
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: fotoUrl != null
                      ? Image.network(fotoUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                      : const Icon(Icons.inventory, color: Colors.orange),
                ),
              ),
              const SizedBox(width: 10),
              Text(alat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: denda > 0 ? Colors.orange : Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  denda > 0 ? "PENALTY" : "SUCCESS",
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDateRow("Tanggal Pinjam", tglPinjam),
          _buildDateRow("Tanggal Tenggat", tglTenggat),
          _buildDateRow("Dikembalikan", tglKembali),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Text(": $date", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}