import 'package:flutter/material.dart';

class AdminPenggunaPage extends StatelessWidget {
  const AdminPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataPengguna = [
      {"nama": "Adit", "role": "Peminjam"},
      {"nama": "Sanjaya", "role": "Petugas"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: const Color(0xFF3F7FA6),
        title: const Text("Pengguna"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Search
            TextField(
              decoration: InputDecoration(
                hintText: "Cari...",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// List
            Expanded(
              child: ListView.builder(
                itemCount: dataPengguna.length,
                itemBuilder: (context, index) {
                  final user = dataPengguna[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user["nama"]!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user["role"]!,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),

                        const SizedBox(width: 10),
                        const Icon(Icons.edit, size: 18),
                        const SizedBox(width: 8),
                        const Icon(Icons.delete,
                            size: 18, color: Colors.red),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F7FA6),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
