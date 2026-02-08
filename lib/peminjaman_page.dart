import 'package:flutter/material.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ✅ NAVBAR ATAS
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285B4),
        centerTitle: true,
        title: const Text(
          "Halaman Peminjaman",
          style: TextStyle(color: Colors.white),
        ),

        // ✅ TOMBOL KEMBALI
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // ❌ Tidak mengubah isi logika
      body: const Center(
        child: Text(
          "Halaman Peminjaman",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
