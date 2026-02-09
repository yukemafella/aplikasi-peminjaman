import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PetugasPage extends StatefulWidget {
  const PetugasPage({super.key});

  @override
  State<PetugasPage> createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  final supabase = Supabase.instance.client;
  
  // Variabel Navigasi Utama (Bottom Nav)
  int _selectedIndex = 0; 
  
  // Variabel Filter Tab (Persetujuan)
  String _currentFilter = "Perlu disetujui";

  // Data Dummy untuk simulasi interaksi klik
  final List<Map<String, dynamic>> _listDataPeminjaman = [
    {"nama": "Aditya", "email": "aditya@gmail.com", "barang": "Bola Basket", "tanggal": "06/01/2026", "status": "", "icon": Icons.sports_basketball},
    {"nama": "Sanjaya", "email": "sanjaya@gmail.com", "barang": "Gitar", "tanggal": "06/01/2026", "status": "", "icon": Icons.music_note},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body akan berubah otomatis saat _selectedIndex berubah
      body: _buildCurrentPage(), 
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- LOGIKA HALAMAN UTAMA ---
  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0: return _buildBeranda();
      case 1: return _buildHalamanPersetujuan();
      case 2: return _buildHalamanRiwayat(); // Sesuai image_305da3.png
      default: return _buildBeranda();
    }
  }

  // --- 1. HALAMAN PERSETUJUAN (SESUAI GAMBAR 331112) ---
  Widget _buildHalamanPersetujuan() {
    List<Map<String, dynamic>> filtered = _listDataPeminjaman.where((item) {
      if (_currentFilter == "Perlu disetujui") return item['status'] == "";
      if (_currentFilter == "Disetujui") return item['status'] == "Setuju";
      if (_currentFilter == "Ditolak") return item['status'] == "Tolak";
      return false;
    }).toList();

    return Column(
      children: [
        const SizedBox(height: 50),
        const Text("Persetujuan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        
        // TAB FILTER (Bisa diklik)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Perlu disetujui", "Disetujui", "Ditolak"].map((tab) {
              bool active = _currentFilter == tab;
              return GestureDetector(
                onTap: () => setState(() => _currentFilter = tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF3489B9) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(tab, style: TextStyle(color: active ? Colors.white : Colors.black, fontSize: 12)),
                ),
              );
            }).toList(),
          ),
        ),

        // LIST KARTU
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) => _cardPersetujuan(filtered[index]),
          ),
        ),
      ],
    );
  }

  Widget _cardPersetujuan(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['email']),
            trailing: const Icon(Icons.more_vert),
          ),
          const Divider(),
          Row(
            children: [
              Icon(item['icon'], size: 40, color: Colors.brown),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['barang'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['tanggal'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              if (item['status'] == "") 
                Row(
                  children: [
                    _btnAction("Setuju", Colors.greenAccent, () => setState(() => item['status'] = "Setuju")),
                    const SizedBox(width: 5),
                    _btnAction("Tolak", Colors.redAccent, () => setState(() => item['status'] = "Tolak")),
                  ],
                )
              else 
                Text(item['status'], style: TextStyle(color: item['status'] == "Setuju" ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _btnAction(String l, Color c, VoidCallback t) => GestureDetector(
    onTap: t,
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)), child: Text(l, style: const TextStyle(color: Colors.white, fontSize: 10))),
  );

  // --- 2. HALAMAN RIWAYAT (SESUAI GAMBAR 305da3) ---
  Widget _buildHalamanRiwayat() {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat"), backgroundColor: Colors.white, elevation: 0),
      body: ListView(
        children: [
          _cardRiwayat("Sanjaya", "Bola Futsal", "Dipinjam", Colors.orange),
          _cardRiwayat("Adit", "Bola Basket", "Dikembalikan", Colors.green),
        ],
      ),
    );
  }

  Widget _cardRiwayat(String n, String b, String s, Color c) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.sports_soccer),
        title: Text(n),
        subtitle: Text(b),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
          onPressed: () => _showDialogHapus(), // image_305299.png
          child: const Text("Hapus", style: TextStyle(color: Colors.red, fontSize: 10)),
        ),
      ),
    );
  }

  // --- DIALOG HAPUS (SESUAI GAMBAR 305299) ---
  void _showDialogHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 50),
            const Text("Hapus Riwayat", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Riwayat ini akan dihapus"),
            Row(
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Ya, Hapus")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBeranda() => const Center(child: Text("Halaman Beranda"));

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      backgroundColor: const Color(0xFF3489B9),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black26,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Persetujuan"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: "Laporan"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Pengaturan"),
      ],
    );
  }
}