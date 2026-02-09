import 'package:flutter/material.dart';

class PengembalianAdminPage extends StatefulWidget {
  const PengembalianAdminPage({super.key});

  @override
  State<PengembalianAdminPage> createState() => _PengembalianAdminPageState();
}

class _PengembalianAdminPageState extends State<PengembalianAdminPage> {
  // Data list utama
  List<Map<String, dynamic>> dataPengembalian = [
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

  // Fungsi memperbarui data
  void _updateData(int index, Map<String, dynamic> newData) {
    setState(() {
      dataPengembalian[index] = newData;
    });
  }

  // Fungsi menambah data
  void _addData(Map<String, dynamic> newData) {
    setState(() {
      dataPengembalian.add(newData);
    });
  }

  // Fungsi menghapus data dengan Dialog Konfirmasi
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 80),
                const SizedBox(height: 10),
                const Text(
                  "Hapus Riwayat",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Riwayat ini akan dihapus",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() {
                            dataPengembalian.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Ya, Hapus", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285B4),
        title: const Text("Data Pengembalian Admin", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: dataPengembalian.length,
        itemBuilder: (context, index) => _buildCard(dataPengembalian[index], index),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4285B4),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahPengembalianPage()),
          );
          if (result != null) _addData(result);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.inventory_2, size: 35, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item["nama"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(item["barang"], style: const TextStyle(color: Colors.grey)),
                    Text(item["tanggal"], style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditPengembalianPage(item: item)),
                  );
                  if (result != null) _updateData(index, result);
                },
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatus(item["status"], item["isAman"]),
              GestureDetector(
                onTap: () => _showDeleteDialog(index),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatus(String status, bool isAman) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAman ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(
              color: isAman ? Colors.green[800] : Colors.orange[800],
              fontWeight: FontWeight.bold,
              fontSize: 12)),
    );
  }
}

// ================= HALAMAN TAMBAH =================
class TambahPengembalianPage extends StatefulWidget {
  const TambahPengembalianPage({super.key});

  @override
  State<TambahPengembalianPage> createState() => _TambahPengembalianPageState();
}

class _TambahPengembalianPageState extends State<TambahPengembalianPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedStatus = 'Dipinjam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Data Pengembalian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _inputField("Nama Peminjam", nameController),
              _inputField("Alat", itemController),
              _inputField("Tanggal Peminjaman", dateController),
              const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                items: ['Dipinjam', 'Dikembalikan', 'Terlambat']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => selectedStatus = v!),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "nama": nameController.text,
                        "barang": itemController.text,
                        "tanggal": dateController.text,
                        "status": selectedStatus == 'Dikembalikan' ? 'Aman' : selectedStatus,
                        "isAman": selectedStatus != 'Terlambat',
                      });
                    },
                    child: const Text("Tambah"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(controller: controller, decoration: const InputDecoration(isDense: true)),
        const SizedBox(height: 10),
      ],
    );
  }
}

// ================= HALAMAN EDIT =================
class EditPengembalianPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const EditPengembalianPage({super.key, required this.item});

  @override
  State<EditPengembalianPage> createState() => _EditPengembalianPageState();
}

class _EditPengembalianPageState extends State<EditPengembalianPage> {
  late TextEditingController nameController;
  late TextEditingController itemController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item["nama"]);
    itemController = TextEditingController(text: widget.item["barang"]);
    statusController = TextEditingController(text: widget.item["status"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Data")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: itemController, decoration: const InputDecoration(labelText: "Alat")),
            TextField(controller: statusController, decoration: const InputDecoration(labelText: "Kondisi")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "nama": nameController.text,
                  "barang": itemController.text,
                  "tanggal": widget.item["tanggal"],
                  "status": statusController.text,
                  "isAman": statusController.text.toLowerCase() == "aman",
                });
              },
              child: const Text("Simpan Perubahan"),
            )
          ],
        ),
      ),
    );
  }
}