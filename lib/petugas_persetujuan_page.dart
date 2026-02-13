import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPersetujuanPage extends StatefulWidget {
  const PetugasPersetujuanPage({super.key});

  @override
  State<PetugasPersetujuanPage> createState() => _PetugasPersetujuanPageState();
}

class _PetugasPersetujuanPageState extends State<PetugasPersetujuanPage>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late TabController _tabController;

  List<Map<String, dynamic>> listPersetujuan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        fetchPersetujuan();
      }
    });
    fetchPersetujuan();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ================= AMBIL DATA BERDASARKAN TAB =================
  Future<void> fetchPersetujuan() async {
    setState(() => isLoading = true);
    String filterStatus = 'menunggu';
    if (_tabController.index == 1) filterStatus = 'disetujui';
    if (_tabController.index == 2) filterStatus = 'ditolak';

    try {
      final response = await supabase
          .from('peminjaman')
          .select()
          .eq('status', filterStatus)
          .order('created_at', ascending: false);

      setState(() {
        listPersetujuan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch: $e');
      setState(() => isLoading = false);
    }
  }

  // ================= UPDATE STATUS =================
  Future<void> updateStatus(int id, String statusBaru) async {
    try {
      await supabase
          .from('peminjaman')
          .update({'status': statusBaru})
          .eq('id_peminjaman', id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Peminjaman berhasil $statusBaru")),
        );
      }
      fetchPersetujuan();
    } catch (e) {
      debugPrint('Error update: $e');
    }
  }

  // ================= UI COMPONENTS =================

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
          child: Text(
            label,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Judul
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            color: const Color(0xFFE0E0E0),
            width: double.infinity,
            child: const Center(
              child: Text(
                "Persetujuan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Tab Bar Custom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              children: [
                Expanded(child: _buildTabItem("Perlu disetujui", 0)),
                const SizedBox(width: 5),
                Expanded(child: _buildTabItem("Disetujui", 1)),
                const SizedBox(width: 5),
                Expanded(child: _buildTabItem("Ditolak", 2)),
              ],
            ),
          ),

          // Konten Utama
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : listPersetujuan.isEmpty
                    ? const Center(child: Text("Tidak ada data"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: listPersetujuan.length,
                        itemBuilder: (context, index) {
                          final item = listPersetujuan[index];
                          return _buildPersetujuanCard(item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersetujuanCard(Map<String, dynamic> item) {
    String status = item['status'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(
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
                    Text(
                      "User ID: ${item['id_user']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "user@email.com", // Ganti dengan field email jika ada di DB
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  if (status == 'menunggu') ...[
                    const PopupMenuItem(value: 'setuju', child: Text("Setujui")),
                    const PopupMenuItem(value: 'tolak', child: Text("Tolak")),
                  ]
                ],
                onSelected: (value) {
                  if (value == 'setuju') updateStatus(item['id_peminjaman'], 'disetujui');
                  if (value == 'tolak') updateStatus(item['id_peminjaman'], 'ditolak');
                },
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              const Icon(Icons.inventory_2, color: Colors.orange, size: 40),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Barang Pinjaman", // Ganti dengan field nama barang jika ada
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['tanggal_pinjam'] ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              if (status == 'disetujui')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Setuju",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              if (status == 'ditolak')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Tolak",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}