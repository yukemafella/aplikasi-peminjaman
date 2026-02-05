import 'package:flutter/material.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  // Controller untuk menangkap input di Search Bar
  final TextEditingController _searchController = TextEditingController();
  
  String selectedCategory = "All";
  String searchQuery = "";

  // Data Alat awal
  List<Map<String, dynamic>> allTools = [
    {"id": 1, "name": "Bola basket", "status": "Tersedia", "color": Colors.green, "icon": Icons.sports_basketball, "category": "Olahraga"},
    {"id": 2, "name": "Raket", "status": "Tersedia", "color": Colors.red, "icon": Icons.sports_tennis, "category": "Olahraga"},
    {"id": 3, "name": "Gitar", "status": "Tersedia", "color": Colors.green, "icon": Icons.music_note, "category": "Seni"},
    {"id": 4, "name": "Seruling", "status": "Tidak tersedia", "color": Colors.blue, "icon": Icons.music_video, "category": "Seni"},
    {"id": 5, "name": "Canon EOS", "status": "Tersedia", "color": Colors.green, "icon": Icons.camera_alt, "category": "Camera"},
    {"id": 6, "name": "Bola futsal", "status": "Tidak tersedia", "color": Colors.red, "icon": Icons.sports_soccer, "category": "Olahraga"},
  ];

  // Logika Filter Ganda: Berdasarkan Kategori DAN Nama (Search)
  List<Map<String, dynamic>> get filteredTools {
    return allTools.where((tool) {
      bool matchesCategory = selectedCategory == "All" || tool['category'] == selectedCategory;
      bool matchesSearch = tool['name'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah anda yakin hapus alat ini !",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        allTools.removeWhere((tool) => tool['id'] == id);
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Iya", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Tidak", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Header Tetap (Search & Category)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar yang berfungsi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Cari.....",
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Navigasi Kategori
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ["All", "Olahraga", "Seni", "Camera"].map((cat) => _buildCategoryItem(cat)).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Grid Alat (Scrollable)
            Expanded(
              child: filteredTools.isEmpty 
              ? const Center(child: Text("Alat tidak ditemukan"))
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9, // Menyesuaikan proporsi card
                  ),
                  itemCount: filteredTools.length,
                  itemBuilder: (context, index) {
                    final tool = filteredTools[index];
                    return _buildItemCard(
                      tool['id'],
                      tool['name'],
                      tool['status'],
                      tool['color'],
                      tool['icon'],
                    );
                  },
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            onPressed: () {},
            backgroundColor: const Color(0xFF3488BC),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            onPressed: () {},
            backgroundColor: const Color(0xFF3488BC),
            child: const Icon(Icons.category, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3488BC) : Colors.white,
          border: Border.all(color: const Color(0xFF3488BC)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)),
      ),
    );
  }

  Widget _buildItemCard(int id, String name, String status, Color statusColor, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Stack(
        children: [
          // Tombol Hapus
          Positioned(
            top: 5,
            left: 5,
            child: InkWell(
              onTap: () => _showDeleteConfirmation(context, id),
              child: const Icon(Icons.delete, color: Colors.red, size: 22),
            ),
          ),
          // Tag Status
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(5)),
              child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
            ),
          ),
          // Konten
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Icon(icon, size: 55, color: Colors.brown[400]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFF3488BC), borderRadius: BorderRadius.circular(12)),
                  child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 4),
                const Text("Stok : 5 Unit", style: TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}