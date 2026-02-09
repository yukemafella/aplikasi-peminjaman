import 'package:flutter/material.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  // Data dummy awal
  List<Map<String, String>> dataPeminjam = [
    {
      "nama": "Sanjaya",
      "barang": "Bola futsal",
      "tanggal": "06, Jan 2026 - 09, Jan 2026",
      "status": "Dipinjam"
    },
    {
      "nama": "Adit",
      "barang": "Bola Basket",
      "tanggal": "06, Jan 2026 - 09, Jan 2026",
      "status": "Dipinjam"
    },
    {
      "nama": "Elingga",
      "barang": "Seruling",
      "tanggal": "1, Jan 2026 - 5, Jan 2026",
      "status": "Dipinjam"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285B4),
        centerTitle: true,
        elevation: 0,
        title: const Text("Halaman Peminjaman", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.grey[200],
            child: const Column(
              children: [
                Text("Data Peminjam", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 10),
                Icon(Icons.account_circle, size: 80, color: Colors.black),
                SizedBox(height: 5),
                Text("Yukemafella@gmail.com", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: dataPeminjam.length + 1,
              itemBuilder: (context, index) {
                if (index == dataPeminjam.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TambahPeminjamanPage()),
                          );

                          if (result != null) {
                            setState(() {
                              dataPeminjam.add(result);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text(
                          "Tambah data peminjam",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }

                return _buildBorrowCard(
                  context,
                  index,
                  dataPeminjam[index]["nama"]!,
                  dataPeminjam[index]["barang"]!,
                  dataPeminjam[index]["tanggal"]!,
                  dataPeminjam[index]["status"]!,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF4285B4),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 4,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Alat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Pengguna"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Aktivitas"),
          BottomNavigationBarItem(icon: Icon(Icons.handshake), label: "Peminjaman"),
        ],
      ),
    );
  }

  Widget _buildBorrowCard(BuildContext context, int index, String nama, String barang, String tanggal, String status) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPeminjamanPage(
                                nama: nama,
                                barang: barang,
                                tanggal: tanggal,
                                status: status,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              dataPeminjam[index]["nama"] = result["nama"];
                              dataPeminjam[index]["barang"] = result["barang"];
                              dataPeminjam[index]["tanggal"] = result["tanggal"];
                              dataPeminjam[index]["status"] = result["status"];
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Text(barang, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(tanggal, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.orange[50],
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(status, style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () {
                          // --- POP UP KONFIRMASI HAPUS ---
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 60),
                                    const SizedBox(height: 10),
                                    const Text("Hapus Riwayat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 5),
                                    const Text("Riwayat ini akan dihapus", textAlign: TextAlign.center),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context), // Tutup dialog tanpa hapus
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: const Text("Batal", style: TextStyle(color: Colors.black)),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              dataPeminjam.removeAt(index);
                                            });
                                            Navigator.pop(context); // Tutup dialog
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: const Text("Ya,Hapus", style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red[50], border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5)),
                          child: const Text("Hapus", style: TextStyle(color: Colors.red, fontSize: 10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPeminjamanPage extends StatefulWidget {
  final String nama;
  final String barang;
  final String tanggal;
  final String status;

  const EditPeminjamanPage({
    super.key,
    required this.nama,
    required this.barang,
    required this.tanggal,
    required this.status,
  });

  @override
  State<EditPeminjamanPage> createState() => _EditPeminjamanPageState();
}

class _EditPeminjamanPageState extends State<EditPeminjamanPage> {
  late TextEditingController namaController;
  late TextEditingController barangController;
  late TextEditingController tanggalController;
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    barangController = TextEditingController(text: widget.barang);
    tanggalController = TextEditingController(text: widget.tanggal);
    selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Data Peminjam", style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Peminjam", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: barangController,
                decoration: const InputDecoration(labelText: "Alat", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: tanggalController,
                decoration: const InputDecoration(labelText: "Tanggal Peminjaman", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ["Dipinjam", "Dikembalikan", "terlambat"].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (val) => setState(() => selectedStatus = val!),
                decoration: const InputDecoration(labelText: "Status", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context), 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    child: const Text("Batal", style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, {
                      "nama": namaController.text,
                      "barang": barangController.text,
                      "tanggal": tanggalController.text,
                      "status": selectedStatus,
                    }),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4285B4)),
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TambahPeminjamanPage extends StatefulWidget {
  const TambahPeminjamanPage({super.key});

  @override
  State<TambahPeminjamanPage> createState() => _TambahPeminjamanPageState();
}

class _TambahPeminjamanPageState extends State<TambahPeminjamanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController barangController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  String selectedStatus = "Dipinjam";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Tambah Data Peminjam", style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nama Peminjam", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Masukkan Nama peminjam"),
              ),
              const SizedBox(height: 15),
              const Text("Alat", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: barangController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Masukkan alat yang dipinjam"),
              ),
              const SizedBox(height: 15),
              const Text("Tanggal Peminjaman", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: tanggalController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "e.g. 06, Jan 2026 - 09, Jan 2026"),
              ),
              const SizedBox(height: 15),
              const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ["Dipinjam", "Dikembalikan", "terlambat"].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => setState(() => selectedStatus = val!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    child: const Text("Batal", style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "nama": namaController.text,
                        "barang": barangController.text,
                        "tanggal": tanggalController.text.isEmpty ? "06, Jan 2026" : tanggalController.text,
                        "status": selectedStatus,
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4285B4)),
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}