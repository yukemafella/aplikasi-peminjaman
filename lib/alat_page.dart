import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  String selectedCategory = 'All';
  bool isLoading = true;

  List<Map<String, dynamic>> alatList = [];

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  // 🔥 AMBIL DATA DARI SUPABASE
  Future<void> fetchAlat() async {
    try {
      final response = await Supabase.instance.client
          .from('alat')
          .select()
          .order('id_alat', ascending: true);

      setState(() {
        alatList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ERROR SUPABASE: $e');
      setState(() => isLoading = false);
    }
  }

  // 🔎 FILTER
  List<Map<String, dynamic>> get filteredAlat {
    if (selectedCategory == 'All') return alatList;

    int kategoriId = selectedCategory == 'Olahraga' ? 1 : 2;
    return alatList.where((a) => a['id_kategori'] == kategoriId).toList();
  }

  Widget categoryButton(String title) {
    final isActive = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.blue,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 🔍 SEARCH (UI SAJA)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari.....',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔘 FILTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          categoryButton('All'),
                          categoryButton('Olahraga'),
                          categoryButton('Seni'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 📦 GRID ALAT
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredAlat.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final alat = filteredAlat[index];
                          final bool tersedia =
                              alat['status'] == 'Tersedia';

                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: tersedia
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      alat['status'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: alat['foto'] != null
                                      ? Image.network(
                                          alat['foto'],
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.image),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  alat['nama_alat'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Stok : ${alat['stok']} Unit',
                                  style:
                                      const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),

      // ➕ FLOATING BUTTON
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'tambah',
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'kategori',
            onPressed: () {},
            child: const Icon(Icons.category),
          ),
        ],
      ),
    );
  }
}