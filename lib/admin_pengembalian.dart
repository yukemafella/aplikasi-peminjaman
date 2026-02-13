import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianAdminPage extends StatefulWidget {
  const PengembalianAdminPage({super.key});

  @override
  State<PengembalianAdminPage> createState() => _PengembalianAdminPageState();
}

class _PengembalianAdminPageState extends State<PengembalianAdminPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dataPengembalian = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('pengembalian')
          .select()
          .order('id_pengembalian', ascending: false);
      
      setState(() {
        dataPengembalian = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error: $e");
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      await supabase.from('pengembalian').delete().eq('id_pengembalian', id);
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil dihapus"), behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      debugPrint("Gagal hapus: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Warna background lebih soft
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4285B4),
        title: const Text(
          "Riwayat Pengembalian",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _fetchData,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4285B4)))
          : dataPengembalian.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: dataPengembalian.length,
                  itemBuilder: (context, index) {
                    return _buildEnhancedCard(dataPengembalian[index]);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("Belum ada data pengembalian", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEnhancedCard(Map<String, dynamic> item) {
    final idPrimary = item['id_pengembalian'];
    final bool hasDenda = (item['denda'] ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Garis warna samping sebagai indikator status denda
              Container(
                width: 6,
                color: hasDenda ? Colors.orangeAccent : Colors.greenAccent[700],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "ID Peminjaman #${item['id_peminjaman']}",
                              style: const TextStyle(
                                color: Color(0xFF4285B4),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            item['tanggal_dikembalikan'] ?? "-",
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            radius: 20,
                            child: Icon(Icons.inventory_2_outlined, color: Colors.grey[700], size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Status Pengembalian",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hasDenda ? "Terlambat / Denda" : "Tepat Waktu",
                                  style: TextStyle(
                                    color: hasDenda ? Colors.orange[800] : Colors.green[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Denda", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                              Text(
                                "Rp ${item['denda']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: hasDenda ? Colors.red[700] : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _confirmDelete(idPrimary),
                            icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                            label: const Text("Hapus"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red[700],
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Hapus Data?"),
        content: const Text("Data pengembalian ini akan dihapus permanen dari sistem."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteData(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}