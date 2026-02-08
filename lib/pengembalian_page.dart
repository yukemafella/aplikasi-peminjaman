import 'package:flutter/material.dart';

class PengembalianPage extends StatelessWidget {
  const PengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataPengembalian = [
      {
        "nama": "Sanjaya",
        "barang": "Bola futsal",
        "tanggal": "06, jan 2026 - 09, jan 2026",
        "status": "Aman",
        "img": "assets/bola_futsal.png", 
        "isAman": true,
      },
      {
        "nama": "Adit",
        "barang": "Bola Basket",
        "tanggal": "06, jan 2026 - 09, jan 2026",
        "status": "Aman",
        "img": "assets/bola_basket.png",
        "isAman": true,
      },
      {
        "nama": "Elingga",
        "barang": "Seruling",
        "tanggal": "1, jan 2026 - 5, jan 2026",
        "status": "Rusak ringan",
        "img": "assets/seruling.png",
        "isAman": false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: const Text("Data Pengembalian", style: TextStyle(color: Colors.black, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Yukemafella@gmail.com", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataPengembalian.length,
              itemBuilder: (context, index) => _buildReturnCard(dataPengembalian[index]),
            ),
            const SizedBox(height: 100), // Ruang ekstra agar tidak tertutup navbar
          ],
        ),
      ),
    );
  }

  Widget _buildReturnCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Proteksi jika gambar tidak ditemukan
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Image.asset(
                  item['img'],
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['barang'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(item['tanggal'], style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.edit_note),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(item['status'], item['isAman']),
              const Text("Hapus", style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBadge(String status, bool isAman) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAman ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status, style: TextStyle(fontSize: 10, color: isAman ? Colors.green[800] : Colors.orange[800])),
    );
  }
}