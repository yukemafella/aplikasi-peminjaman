import 'package:flutter/material.dart';

class DashboardPetugasPage extends StatelessWidget {
  const DashboardPetugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("dashboard petugas", style: TextStyle(color: Colors.grey, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Icon(Icons.account_circle, size: 60),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Yuke", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Petugas", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            
            const Text("Grafik alat yang sering di pinjam", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            
            // Placeholder Grafik (Gunakan Image.network atau Container)
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _bar(80, Colors.grey.shade100),
                  _bar(100, Colors.blue.shade700),
                  _bar(60, Colors.grey.shade100),
                  _bar(120, Colors.blue.shade700),
                  _bar(50, Colors.grey.shade100),
                  _bar(90, Colors.blue.shade700),
                ],
              ),
            ),
            
            const Divider(),
            
            // List Alat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Alat yang di Pinjam", style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, elevation: 0),
                    child: const Text("Detail", style: TextStyle(color: Colors.black, fontSize: 12)),
                  )
                ],
              ),
            ),
            
            _itemAlat("Bola basket", "Olahraga", Icons.sports_basketball),
            _itemAlat("Gitar", "Musik", Icons.music_note),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: "Persetujuan"),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: "Pengembalian"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Pengaturan"),
        ],
      ),
    );
  }

  Widget _bar(double height, Color color) {
    return Container(height: height, width: 20, color: color);
  }

  Widget _itemAlat(String nama, String kategori, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.orange),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(kategori, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Text("1 unit", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}