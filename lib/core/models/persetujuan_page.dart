import 'package:flutter/material.dart';

class DashboardPetugas extends StatefulWidget {
  const DashboardPetugas({super.key});

  @override
  State<DashboardPetugas> createState() => _DashboardPetugasState();
}

class _DashboardPetugasState extends State<DashboardPetugas> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // IndexedStack menjaga state halaman agar tidak reload saat berpindah tab
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBerandaBody(),    // Index 0
          const PersetujuanPage(), // Index 1 (Kode Persetujuan Anda)
          const Center(child: Text("Halaman Pengembalian")),
          const Center(child: Text("Halaman Laporan")),
          const Center(child: Text("Halaman Pengaturan")),
        ],
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

  // --- LOGIKA BERANDA (DIAMBIL DARI KODE ASLI ANDA) ---
  Widget _buildBerandaBody() {
    return SafeArea(
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
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
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(unit, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// --- KODE PERSETUJUAN ANDA (TANPA PERUBAHAN LOGIKA) ---
class PersetujuanPage extends StatefulWidget {
  const PersetujuanPage({super.key});

  @override
  State<PersetujuanPage> createState() => _PersetujuanPageState();
}

class _PersetujuanPageState extends State<PersetujuanPage> {
  int _activeTab = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        automaticallyImplyLeading: false, // Menghapus tombol back otomatis
        title: const Text("Persetujuan", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                _buildTabButton("Perlu disetujui", 0),
                _buildTabButton("Disetujui", 1),
                _buildTabButton("Ditolak", 2),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: _buildListContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3488BC) : Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListContent() {
    if (_activeTab == 0) {
      return [
        _buildCardPersetujuan("Aditya", "aditya@gmail.com", "Bola Basket", "06/01/2026", null),
        _buildCardPersetujuan("Sanjaya", "sanjaya@gmail.com", "Gitar", "06/01/2026", null),
      ];
    } else if (_activeTab == 1) {
      return [
        _buildCardPersetujuan("Aditya", "aditya@gmail.com", "Bola Basket", "06/01/2026", "Setuju"),
      ];
    } else {
      return [
        _buildCardPersetujuan("Sanjaya", "sanjaya@gmail.com", "Gitar", "06/01/2026", "Tolak"),
      ];
    }
  }

  Widget _buildCardPersetujuan(String nama, String email, String alat, String tanggal, String? status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.black12, child: Icon(Icons.person, color: Colors.black)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(email, style: const TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
          const Divider(height: 25),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(10)),
                child: Icon(alat.contains("Bola") ? Icons.sports_basketball : Icons.music_note, color: Colors.orange[800]),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alat, style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(tanggal, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: status == "Setuju" ? Colors.green : Colors.red,
                  child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}