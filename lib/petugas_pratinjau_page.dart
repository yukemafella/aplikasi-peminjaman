import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersetujuanPage extends StatefulWidget {
  const PersetujuanPage({super.key});

  @override
  State<PersetujuanPage> createState() => _PersetujuanPageState();
}

class _PersetujuanPageState extends State<PersetujuanPage> {
  String selectedCategory = "Perlu disetujui";
  final Map<String, String> categoryToStatus = {
    "Perlu disetujui": "pending",
    "Disetujui": "disetujui",
    "Ditolak": "ditolak",
  };

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Persetujuan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton("Perlu disetujui"),
                _buildFilterButton("Disetujui"),
                _buildFilterButton("Ditolak"),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              // PERBAIKAN: Menggunakan id_peminjaman sebagai primaryKey
              stream: supabase
                  .from('peminjaman')
                  .stream(primaryKey: ['id_peminjaman'])
                  .eq('status', categoryToStatus[selectedCategory]!)
                  .order('tanggal_pinjam', ascending: false), // PERBAIKAN: tanggal_pinjam
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Tidak ada data."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return _buildItemCard(
                      id: item['id_peminjaman'], // Menggunakan id_peminjaman
                      // Sementara menampilkan ID karena nama ada di tabel lain
                      nama: "Peminjam ID: ${item['id_user'].toString().substring(0, 5)}", 
                      email: "User ID: ${item['id_user'].toString().substring(0, 8)}...",
                      alat: "ID Alat: ${item['id_alat']}",
                      tgl: item['tanggal_pinjam'] ?? '-',
                      status: item['status'] == 'pending' ? null : item['status'],
                      fotoUrl: item['foto'], // Mengambil kolom foto
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

  Widget _buildFilterButton(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4292C6) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Fungsi update menggunakan id_peminjaman
  Future<void> updateStatus(int id, String newStatus) async {
    try {
      await supabase
          .from('peminjaman')
          .update({'status': newStatus})
          .match({'id_peminjaman': id});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status berhasil diubah ke $newStatus"))
      );
    } catch (e) {
      print("Error update: $e");
    }
  }

  Widget _buildItemCard({
    required int id,
    required String nama,
    required String email,
    required String alat,
    required String tgl,
    String? status,
    String? fotoUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFF5F5F5),
                child: Icon(Icons.person, size: 20, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(email, style: const TextStyle(color: Colors.blue, fontSize: 11, decoration: TextDecoration.underline)),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'disetujui', child: Text("Setujui")),
                  const PopupMenuItem(value: 'ditolak', child: Text("Tolak")),
                  const PopupMenuItem(value: 'pending', child: Text("Kembalikan ke Pending")),
                ],
                onSelected: (value) => updateStatus(id, value.toString()),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(thickness: 0.5),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MENAMPILKAN FOTO DARI DATABASE
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: fotoUrl != null && fotoUrl.isNotEmpty
                      ? Image.network(fotoUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                      : const Icon(Icons.inventory, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("Pinjam: $tgl", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == "disetujui" ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}