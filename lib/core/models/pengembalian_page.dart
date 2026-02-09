import 'package:flutter/material.dart';

// Model sederhana untuk data pengembalian
class DataPengembalian {
  final String nama;
  final String email;
  final String alat;
  final String tanggalPinjam;
  final String tanggalTenggat;
  final String tanggalKembali;
  final String statusTerlambat;
  final String imagePath;

  DataPengembalian({
    required this.nama,
    required this.email,
    required this.alat,
    required this.tanggalPinjam,
    required this.tanggalTenggat,
    required this.tanggalKembali,
    required this.statusTerlambat,
    required this.imagePath,
  });
}

class PengembalianPetugasPage extends StatefulWidget {
  const PengembalianPetugasPage({super.key});

  @override
  State<PengembalianPetugasPage> createState() => _PengembalianPetugasPageState();
}

class _PengembalianPetugasPageState extends State<PengembalianPetugasPage> {
  int activeTabIndex = 0; // 0: Pengembalian, 1: Selesai, 2: Denda
  final List<String> tabs = ["Pengembalian", "Selesai", "Denda"];

  // Data contoh sesuai gambar mockup
  final List<DataPengembalian> listData = [
    DataPengembalian(
      nama: "Aditya",
      email: "aditya@gmail.com",
      alat: "Bola Basket",
      tanggalPinjam: "06/01/2026",
      tanggalTenggat: "08/01/2026",
      tanggalKembali: "09/01/2026",
      statusTerlambat: "Terlambat 1 Hari",
      imagePath: 'assets/bola_basket.png', // Pastikan asset tersedia
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Persetujuan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Row Filter Tab
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tabs.length, (index) {
                bool isSelected = activeTabIndex == index;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFF3488BC) : Colors.grey[400],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: () => setState(() => activeTabIndex = index),
                      child: Text(tabs[index], style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }),
            ),
          ),

          // List Konten
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return _buildCardPengembalian(listData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPengembalian(DataPengembalian data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header User
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.email, style: const TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, size: 18),
            ],
          ),
          const Divider(),

          // Detail Alat
          Row(
            children: [
              // Gambar Alat (Mockup menggunakan icon jika asset tidak ada)
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sports_basketball, color: Colors.orange), 
              ),
              const SizedBox(width: 15),
              Text(data.alat, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              // Status Terlambat
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.statusTerlambat,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Info Tanggal
          _buildInfoRow("Tanggal Pinjam", data.tanggalPinjam),
          _buildInfoRow("Tanggal tenggat", data.tanggalTenggat),
          _buildInfoRow("Tanggal Kembali", data.tanggalKembali),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(": $value", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}