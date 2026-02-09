import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriCrud extends StatefulWidget {
  const KategoriCrud({super.key});

  @override
  State<KategoriCrud> createState() => _KategoriCrudState();
}

class _KategoriCrudState extends State<KategoriCrud> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> kategoriList = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  // 🔥 READ DATA
  Future<void> fetchKategori() async {
    setState(() => isLoading = true);

    final response =
        await supabase.from('kategori').select().order('id_kategori');

    setState(() {
      kategoriList = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  // 🔥 CREATE
  Future<void> tambahKategori(String nama) async {
    await supabase.from('kategori').insert({
      'nama_kategori': nama,
    });

    fetchKategori();
  }

  // 🔥 UPDATE
  Future<void> updateKategori(int id, String nama) async {
    await supabase
        .from('kategori')
        .update({'nama_kategori': nama})
        .eq('id_kategori', id);

    fetchKategori();
  }

  // 🔥 DELETE
  Future<void> deleteKategori(int id) async {
    await supabase.from('kategori').delete().eq('id_kategori', id);
    fetchKategori();
  }

  // 🔥 DIALOG FORM
  void showKategoriDialog({int? id, String? nama}) {
    final controller = TextEditingController(text: nama ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? "Tambah Kategori" : "Edit Kategori"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Nama kategori",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (id == null) {
                tambahKategori(controller.text);
              } else {
                updateKategori(id, controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = kategoriList
        .where((k) => k['nama_kategori']
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Daftar Kategori"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔍 SEARCH
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Cari.....",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // ➕ TAMBAH BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () => showKategoriDialog(),
                      child: const Text("Tambah kategori"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📦 LIST KATEGORI
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final kategori = filteredList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                kategori['nama_kategori'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  // EDIT
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () =>
                                        showKategoriDialog(
                                      id: kategori['id_kategori'],
                                      nama: kategori['nama_kategori'],
                                    ),
                                    child: const Text("edit"),
                                  ),
                                  const SizedBox(width: 8),

                                  // DELETE
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => deleteKategori(
                                        kategori['id_kategori']),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
