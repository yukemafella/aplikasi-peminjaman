import 'package:flutter/material.dart';

class PeminjamanModal extends StatefulWidget {
  const PeminjamanModal({super.key});

  @override
  State<PeminjamanModal> createState() => _PeminjamanModalState();
}

class _PeminjamanModalState extends State<PeminjamanModal> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController barangController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Peminjaman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${namaController.text}"),
            Text("Barang: ${barangController.text}"),
            Text("Jumlah: ${jumlahController.text}"),
            Text("Tanggal: ${tanggalController.text}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Peminjaman berhasil diajukan'),
                ),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Barang'),
        backgroundColor: const Color(0xFF2F80B7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _inputField(
              controller: namaController,
              label: 'Nama Peminjam',
              icon: Icons.person,
            ),
            _inputField(
              controller: barangController,
              label: 'Nama Barang',
              icon: Icons.inventory,
            ),
            _inputField(
              controller: jumlahController,
              label: 'Jumlah',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            _inputField(
              controller: tanggalController,
              label: 'Tanggal Peminjaman',
              icon: Icons.date_range,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  tanggalController.text =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80B7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showConfirmDialog,
                child: const Text(
                  'AJUKAN PEMINJAMAN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
