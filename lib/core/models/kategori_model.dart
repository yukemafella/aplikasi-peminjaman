import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  bool isLoading = true;
  bool isShowForm = false;
  int? editingId; // Menyimpan ID kategori yang sedang diedit
  List<Map<String, dynamic>> kategoriList = [];
  final TextEditingController _namaKategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  // Ambil Data dari Supabase
  Future<void> fetchKategori() async {
    try {
      setState(() => isLoading = true);
      final response = await Supabase.instance.client
          .from('kategori')
          .select()
          .order('id_kategori', ascending: true);
      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch: $e');
      setState(() => isLoading = false);
    }
  }

  // Logika Simpan (Tambah & Update)
  Future<void> _simpanKategori() async {
    final nama = _namaKategoriController.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama kategori tidak boleh kosong")),
      );
      return;
    }

    try {
      if (editingId == null) {
        // PROSES TAMBAH (INSERT)
        await Supabase.instance.client
            .from('kategori')
            .insert({'nama_kategori': nama});
      } else {
        // PROSES EDIT (UPDATE)
        // .eq memastikan kita hanya mengubah baris dengan ID yang sesuai
        await Supabase.instance.client
            .from('kategori')
            .update({'nama_kategori': nama})
            .eq('id_kategori', editingId!);
      }

      // Reset State
      _namaKategoriController.clear();
      setState(() {
        isShowForm = false;
        editingId = null;
      });
      
      fetchKategori(); // Refresh data
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil disimpan"), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint('Gagal menyimpan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // Logika Hapus dengan Konfirmasi
  Future<void> _hapusKategori(int id) async {
    try {
      await Supabase.instance.client.from('kategori').delete().eq('id_kategori', id);
      fetchKategori();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal hapus: Data mungkin sedang digunakan di tabel lain")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kategori Alat", style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                color: Colors.grey.shade200,
                child: const Center(child: Text("Daftar Kategori", style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              
              // Search & Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari kategori...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            editingId = null; // Reset ID agar dianggap "Tambah"
                            _namaKategoriController.clear();
                            isShowForm = true;
                          });
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Tambah Kategori"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
              ),

              // List Data
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: kategoriList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final item = kategoriList[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(item['nama_kategori'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        editingId = item['id_kategori']; // Ambil ID asli dari DB
                                        _namaKategoriController.text = item['nama_kategori'];
                                        isShowForm = true;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _hapusKategori(item['id_kategori']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // OVERLAY FORM (ADD/EDIT)
          if (isShowForm)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(editingId == null ? "Tambah Kategori" : "Edit Kategori",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _namaKategoriController,
                        decoration: const InputDecoration(
                          labelText: "Nama Kategori",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => isShowForm = false),
                            child: const Text("Batal"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _simpanKategori,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: Text(editingId == null ? "Tambah" : "Simpan"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}