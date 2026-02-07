import 'package:flutter/material.dart';

class DashboardPetugas extends StatefulWidget {
  const DashboardPetugas({super.key});

  @override
  State<DashboardPetugas> createState() => _DashboardPetugasState();
}

class _DashboardPetugasState extends State<DashboardPetugas> {
  // Index aktif untuk navigasi bawah
  int _currentIndex = 0;

  // List halaman untuk ditampilkan berdasarkan navigasi
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildBeranda(),      // Index 0: Tampilan Dashboard (Grafik & List)
      _buildPersetujuan(),  // Index 1: Tampilan Persetujuan (Sesuai Gambar Baru)
      const Center(child: Text("Halaman Pengembalian")), // Index 2
      const Center(child: Text("Halaman Laporan")),      // Index 3
      const Center(child: Text("Halaman Pengaturan")),   // Index 4
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: "Persetujuan"),
          BottomNavigationBarItem(icon: Icon(Icons.keyboard_return), label: "Pengembalian"),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: "Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Pengaturan"),
        ],
      ),
    );
  }

  // --- LOGIKA HALAMAN BERANDA (DATA ANDA SEBELUMNYA) ---
  Widget _buildBeranda() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black12,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Yuke", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Petugas", style: TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text("Grafik alat yang sering di pinjam", 
              style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 20),
          Container(
            height: 150,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(130, Colors.grey.shade100),
                _buildBar(100, Colors.blue.shade400),
                _buildBar(80, Colors.grey.shade100),
                _buildBar(120, Colors.blue.shade400),
                _buildBar(60, Colors.grey.shade100),
                _buildBar(90, Colors.blue.shade400),
              ],
            ),
          ),
          const Divider(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Alat yang di Pinjam", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(backgroundColor: Colors.grey.shade200),
                child: const Text("Detail", style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _itemPinjam("Bola basket", "Olahraga", Icons.sports_basketball, "1 unit"),
          _itemPinjam("Gitar", "Musik", Icons.music_note, "1 unit"),
        ],
      ),
    );
  }

  // --- LOGIKA HALAMAN PERSETUJUAN (SESUAI GAMBAR BARU) ---
  Widget _buildPersetujuan() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16),
          child: const Text("Persetujuan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterTab("Perlu disetujui", true),
              _buildFilterTab("Disetujui", false),
              _buildFilterTab("Ditolak", false),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              _buildCardPersetujuan("Aditya", "aditya@gmail.com", "Bola Basket", "06/01/2026"),
              _buildCardPersetujuan("Sanjaya", "sanjaya@gmail.com", "Gitar", "06/01/2026"),
            ],
          ),
        )
      ],
    );
  }

  // --- HELPER WIDGETS (LOGIKA ANDA TETAP SAMA) ---

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _itemPinjam(String nama, String kategori, IconData icon, String unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, color: Colors.orange.shade800),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(kategori, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
            child: Text(unit, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3488BC) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.black, fontSize: 12)),
    );
  }

  Widget _buildCardPersetujuan(String name, String email, String item, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, child: Icon(Icons.person)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(email, style: const TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert)
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Icon(Icons.sports_basketball, color: Colors.orange, size: 40),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}