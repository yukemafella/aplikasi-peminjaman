import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dataPeminjam = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // 1. FUNGSI AMBIL DATA (Sesuai kolom tabel kamu)
  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('peminjaman')
          .select()
          .order('id_peminjaman', ascending: false); // Pakai id_peminjaman
      
      setState(() {
        dataPeminjam = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar("Gagal memuat: $e");
    }
  }

  // 2. FUNGSI TAMBAH DATA (Sesuai kolom tabel kamu)
  Future<void> _addData(int idAlat) async {
    try {
      await supabase.from('peminjaman').insert({
        // Sesuaikan nama key dengan nama kolom di tabel kamu
        'id_user': '5fc4909b-611c-419a-b80e-4082eff4c410', // Contoh UUID valid dari datamu
        'id_alat': idAlat,
        'tanggal_pinjam': DateTime.now().toIso8601String().split('T')[0],
        'status': 'disetujui'
      });

      _showSnackBar("Data Berhasil Ditambahkan!");
      _fetchData(); // Supaya hasilnya langsung muncul di UI
    } catch (e) {
      _showSnackBar("Gagal Menambah: $e");
    }
  }

  // 3. FUNGSI HAPUS
  Future<void> _deleteData(int id) async {
    try {
      await supabase.from('peminjaman').delete().eq('id_peminjaman', id);
      _fetchData();
    } catch (e) {
      _showSnackBar("Gagal menghapus: $e");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Peminjaman"),
        backgroundColor: const Color(0xFF4285B4),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataPeminjam.length,
              itemBuilder: (context, index) {
                final item = dataPeminjam[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("Alat ID: ${item['id_alat']}"), // Pakai id_alat
                    subtitle: Text("Status: ${item['status']}"), // Pakai status
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteData(item['id_peminjaman']),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Pinjaman"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Masukkan ID Alat"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addData(int.parse(controller.text));
                Navigator.pop(context);
              }
            }, 
            child: const Text("Simpan")
          )
        ],
      ),
    );
  }
}