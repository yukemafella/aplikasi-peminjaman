import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPage extends StatefulWidget {
  const PetugasPage({super.key});

  @override
  State<PetugasPage> createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  final supabase = Supabase.instance.client;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER PROFIL (Sesuai Gambar Petugas)
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle, size: 60, color: Colors.black),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supabase.auth.currentUser?.userMetadata?['full_name'] ?? 'Yuke',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text("Petugas", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Grafik alat yang sering di pinjam",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 25),

              // GRAFIK DENGAN LABEL ANGKA (Sesuai Gambar Petugas)
              _buildPetugasChart(),

              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.black12),

              // SECTION LIST ALAT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Alat yang di Pinjam",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text("Detail", style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ),
                  ],
                ),
              ),

              // DAFTAR ITEM (Bola & Gitar)
              _buildItemTile("Bola basket", "Olahraga", "1 unit", Icons.sports_basketball),
              _buildItemTile("Gitar", "Musik", "1 unit", Icons.music_note),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // BOTTOM NAVIGATION BIRU (5 MENU)
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // WIDGET GRAFIK KHUSUS PETUGAS
  Widget _buildPetugasChart() {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Label Y-Axis
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("200", style: TextStyle(fontSize: 10)),
              Text("150", style: TextStyle(fontSize: 10)),
              Text("100", style: TextStyle(fontSize: 10)),
              Text("50", style: TextStyle(fontSize: 10)),
              Text("0", style: TextStyle(fontSize: 10)),
            ],
          ),
          const SizedBox(width: 10),
          // Area Bar
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Garis Horizontal
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (_) => const Divider(height: 0, thickness: 0.5)),
                ),
                // Batang Grafik
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _bar(130, false),
                    _bar(100, true),
                    _bar(60, false),
                    _bar(120, true),
                    _bar(50, false),
                    _bar(90, true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double h, bool isBlue) => Container(
    width: 20, height: h,
    decoration: BoxDecoration(
      color: isBlue ? const Color(0xFF3489B9) : Colors.grey[100],
      borderRadius: BorderRadius.circular(2),
    ),
  );

  // WIDGET ITEM LIST
  Widget _buildItemTile(String name, String cat, String qty, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.brown[400]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(cat, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
            child: Text(qty, style: const TextStyle(fontSize: 11)),
          )
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION SESUAI GAMBAR PETUGAS
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF3489B9),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Persetujuan"),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Pengembalian"),
        BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: "Laporan"),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Pengaturan"),
      ],
    );
  }
}