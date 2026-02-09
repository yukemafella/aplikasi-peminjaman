import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HalamanPersetujuanPetugas()));

class HalamanPersetujuanPetugas extends StatefulWidget {
  @override
  _HalamanPersetujuanPetugasState createState() => _HalamanPersetujuanPetugasState();
}

class _HalamanPersetujuanPetugasState extends State<HalamanPersetujuanPetugas> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi 3 tab sesuai gambar
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text("Persetujuan", style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: "Pengembalian"),
                  Tab(text: "Selesai"),
                  Tab(text: "Denda"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListPeminjaman("Terlambat", Colors.red),
          _buildListPeminjaman("Selesai", Colors.green),
          _buildListPeminjaman("Validasi Pembayaran", Colors.lightBlue),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, // Fokus pada menu Persetujuan
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Persetujuan"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Pengembalian"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Pengaturan"),
        ],
      ),
    );
  }

  Widget _buildListPeminjaman(String statusLabel, Color statusColor) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 1, // Contoh 1 data sesuai gambar
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Aditya", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("aditya@gmail.com", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
                Divider(height: 30),
                Row(
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/887/887380.png', // Placeholder Bola Basket
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 15),
                    Text("Bola Basket", style: TextStyle(fontWeight: FontWeight.w500)),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                _buildDateRow("Tanggal Pinjam", "06/01/2026"),
                _buildDateRow("Tanggal Tenggat", "08/01/2026"),
                _buildDateRow("Tanggal Kembali", "09/01/2026"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateRow(String label, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Text(": $date", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}