import 'package:flutter/material.dart';

class PengembalianAdminPage extends StatelessWidget {
  const PengembalianAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataPengembalian = [
      {
        "nama": "Sanjaya",
        "barang": "Bola Futsal",
        "tanggal": "06 Jan 2026 - 09 Jan 2026",
        "status": "Aman",
        "isAman": true,
      },
      {
        "nama": "Adit",
        "barang": "Bola Basket",
        "tanggal": "06 Jan 2026 - 09 Jan 2026",
        "status": "Aman",
        "isAman": true,
      },
      {
        "nama": "Elingga",
        "barang": "Seruling",
        "tanggal": "01 Jan 2026 - 05 Jan 2026",
        "status": "Rusak ringan",
        "isAman": false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ✅ NAVBAR ATAS
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285B4),
        title: const Text(
          "Data Pengembalian Admin",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,

        // ✅ TOMBOL KEMBALI
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: dataPengembalian.length,
        itemBuilder: (context, index) =>
            _buildCard(dataPengembalian[index]),
      ),
    );
  }

  // ================= CARD =================

  Widget _buildCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  size: 35,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["nama"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item["barang"],
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item["tanggal"],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.edit, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatus(item["status"], item["isAman"]),
              const Text(
                "Hapus",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= STATUS BADGE =================

  Widget _buildStatus(String status, bool isAman) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAman ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isAman ? Colors.green[800] : Colors.orange[800],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
