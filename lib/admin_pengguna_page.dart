import 'package:flutter/material.dart';

class AdminPenggunaPage extends StatefulWidget {
  const AdminPenggunaPage({super.key});

  @override
  State<AdminPenggunaPage> createState() => _AdminPenggunaPageState();
}

class _AdminPenggunaPageState extends State<AdminPenggunaPage> {
  // Data pengguna dalam State
  final List<Map<String, String>> dataPengguna = [
    {"nama": "Adit", "role": "Peminjam"},
    {"nama": "Sanjaya", "role": "Petugas"},
  ];

  // Controller untuk inputan
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;

  // --- 1. Fungsi Dialog Hapus ---
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah anda yakin\nhapus pengguna ini !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          dataPengguna.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6EDC54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text("Iya", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE54A4A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text("Tidak", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // --- 2. Fungsi Dialog Edit ---
  void _showEditUserDialog(BuildContext context, int index) {
    // Isi controller dengan data yang sudah ada
    nameController.text = dataPengguna[index]["nama"]!;
    selectedRole = dataPengguna[index]["role"];
    emailController.clear(); // Email/Password biasanya dikosongkan saat edit untuk keamanan/opsional
    passwordController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Sebagai", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ["Peminjam", "Petugas", "Admin"]
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) {
                    selectedRole = value;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && selectedRole != null) {
                        setState(() {
                          // Update data pada index yang sesuai
                          dataPengguna[index] = {
                            "nama": nameController.text,
                            "role": selectedRole!,
                          };
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F7FA6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 3. Fungsi Dialog Tambah ---
  void _showAddUserDialog(BuildContext context) {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    selectedRole = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Masukan nama",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Email", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Masukan email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Password", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "masukan password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Sebagai", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  hint: const Text("Pilih role"),
                  items: ["Peminjam", "Petugas", "Admin"]
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) {
                    selectedRole = value;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && selectedRole != null) {
                        setState(() {
                          dataPengguna.add({
                            "nama": nameController.text,
                            "role": selectedRole!,
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F7FA6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Tambah pengguna", style: TextStyle(color: Colors.white)),
                  ),
                ),
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
            TextField(
              decoration: InputDecoration(
                hintText: "Cari...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user["nama"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        // Tombol Edit
                        GestureDetector(
                          onTap: () => _showEditUserDialog(context, index),
                          child: const Icon(Icons.edit, size: 18),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Hapus
                        GestureDetector(
                          onTap: () => _showDeleteConfirmationDialog(context, index),
                          child: const Icon(Icons.delete, size: 18, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F7FA6),
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}