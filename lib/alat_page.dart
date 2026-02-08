import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pengguna_page.dart';
import 'package:flutter_application_1/peminjaman_page.dart';
import 'package:flutter_application_1/pengembalian_admin_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart';
import 'aktivitas_page.dart'; // Pastikan file ini ada

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
      setState(() => isLoading = true);
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

  // 🔎 FILTER LOGIC
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
          color: isActive ? const Color(0xFF3488BC) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3488BC)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF3488BC),
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
                      // SEARCH BAR
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
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // CATEGORY FILTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          categoryButton('All'),
                          categoryButton('Olahraga'),
                          categoryButton('Seni'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // GRID DAFTAR ALAT
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredAlat.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final alat = filteredAlat[index];
                          final bool tersedia = alat['status'] == 'Tersedia';

                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: tersedia ? Colors.green : Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      alat['status'],
                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: alat['foto'] != null
                                      ? Image.network(alat['foto'], fit: BoxFit.contain)
                                      : const Icon(Icons.image, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  alat['nama_alat'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Stok : ${alat['stok']} Unit',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
      // FLOATING ACTION BUTTONS
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'tambah',
            backgroundColor: const Color(0xFF3488BC),
            onPressed: () {},
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'kategori',
            backgroundColor: Colors.orange,
            onPressed: () {},
            child: const Icon(Icons.category, color: Colors.white),
          ),
        ],
      ),
      // 🔥 NAVBAR DENGAN NAVIGASI AKTIF
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2, // Halaman Alat (Index 2)
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const  AktivitasPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPenggunaPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const  PengembalianAdminPage()),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const  PeminjamanPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_outlined), label: 'Pengembalian'),
          BottomNavigationBarItem(icon: Icon(Icons.handshake_outlined), label: 'Peminjaman'),
        ],
      ),
    );
  }
}