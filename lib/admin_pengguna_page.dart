import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Bagian ini mendefinisikan halaman Manajemen Pengguna untuk Admin
class AdminPenggunaPage extends StatefulWidget {
  const AdminPenggunaPage({super.key});

  @override
  State<AdminPenggunaPage> createState() => _AdminPenggunaPageState();
}

class _AdminPenggunaPageState extends State<AdminPenggunaPage> {
  // Mengambil instance client Supabase yang sudah diinisialisasi di main.dart
  final supabase = Supabase.instance.client;

  // List untuk menyimpan data pengguna yang ditarik dari tabel database
  List<Map<String, dynamic>> dataPengguna = [];
  // Status untuk menampilkan loading spinner saat proses ambil data
  bool isLoading = true;

  // Controller untuk menangkap teks input dari user di formulir (Nama, Email, Password)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Variabel penampung pilihan Role (Admin/Petugas/Peminjam)
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi fetch data pertama kali saat halaman dibuka
    _fetchUsers();
  }

  // --- 1. Fungsi Ambil Data (READ) ---
  Future<void> _fetchUsers() async {
    print("--- 🔍 Mencoba menyambung ke Supabase ---"); 
    setState(() => isLoading = true); // Mulai menampilkan loading
    try {
      // Melakukan query ke tabel 'users', mengambil semua kolom, dan urutkan berdasarkan nama
      final response = await supabase
          .from('users') 
          .select()
          .order('nama', ascending: true);
      
      print("✅ KONEKSI BERHASIL!");
      print("📦 Data dari Supabase: $response");

      setState(() {
        // Memasukkan hasil query ke dalam list dataPengguna
        dataPengguna = List<Map<String, dynamic>>.from(response);
        isLoading = false; // Matikan loading
      });
    } catch (e) {
      print("❌ KONEKSI GAGAL!");
      print("⚠️ Pesan Error: $e");

      // Menampilkan notifikasi merah jika terjadi kegagalan sistem/koneksi
      _showSnackBar("Gagal mengambil data: $e", Colors.red);
      setState(() => isLoading = false);
    }
  }

  // --- 2. Fungsi Tambah Pengguna (CREATE) ---
  Future<void> _addUser() async {
    // Validasi: pastikan nama tidak kosong dan role sudah dipilih
    if (nameController.text.isNotEmpty && selectedRole != null) {
      try {
        print("--- ➕ Menambahkan pengguna baru... ---");
        // Melakukan insert data ke tabel 'users' di Supabase
        await supabase.from('users').insert({
          'nama': nameController.text, // Mengambil teks dari controller nama
          'email': emailController.text,
          'role': selectedRole, // Mengambil nilai dari dropdown role
        });
        print("✅ Berhasil tambah data ke database");
        _fetchUsers(); // Refresh daftar pengguna agar data baru muncul
        Navigator.pop(context); // Tutup dialog tambah pengguna
        _showSnackBar("Pengguna berhasil ditambahkan", Colors.green);
      } catch (e) {
        print("❌ Gagal tambah data: $e");
        _showSnackBar("Gagal menambah data: $e", Colors.red);
      }
    }
  }

  // --- 3. Fungsi Edit Pengguna (UPDATE) ---
  Future<void> _editUser(int id) async {
    if (nameController.text.isNotEmpty && selectedRole != null) {
      try {
        print("--- 📝 Mengedit pengguna ID: $id ---");
        // Melakukan update data berdasarkan ID pengguna yang spesifik
        await supabase.from('users').update({
          'nama': nameController.text,
          'role': selectedRole,
        }).match({'id': id}); // Mencocokkan baris data yang akan diupdate melalui ID
        
        print("✅ Update data berhasil");
        _fetchUsers(); // Refresh data
        Navigator.pop(context); // Tutup dialog edit
        _showSnackBar("Data berhasil diperbarui", Colors.blue);
      } catch (e) {
        print("❌ Update data gagal: $e");
        _showSnackBar("Gagal memperbarui data: $e", Colors.red);
      }
    }
  }

  // --- 4. Fungsi Hapus Pengguna (DELETE) ---
  Future<void> _deleteUser(int id) async {
    try {
      print("--- 🗑️ Menghapus pengguna ID: $id ---");
      // Menghapus data dari tabel 'users' yang ID-nya cocok
      await supabase.from('users').delete().match({'id': id});
      print("✅ Hapus data berhasil");
      _fetchUsers(); // Refresh data agar tampilan terhapus
      _showSnackBar("Pengguna berhasil dihapus", Colors.orange);
    } catch (e) {
      print("❌ Hapus data gagal: $e");
      _showSnackBar("Gagal menghapus data: $e", Colors.red);
    }
  }

  // Fungsi utilitas untuk memunculkan pesan singkat (SnackBar) di bawah layar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // --- UI Logic (Bagian Dialog/Pop-up) ---

  // Dialog Konfirmasi Hapus: Memastikan admin tidak sengaja menghapus data
  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Agar ukuran dialog pas dengan isi
            children: [
              const Text("Apakah anda yakin\nhapus pengguna ini !", textAlign: TextAlign.center),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Konfirmasi Hapus
                  ElevatedButton(
                    onPressed: () {
                      _deleteUser(id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6EDC54)),
                    child: const Text("Iya", style: TextStyle(color: Colors.black)),
                  ),
                  // Tombol Pembatalan
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE54A4A)),
                    child: const Text("Tidak", style: TextStyle(color: Colors.black)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // Dialog Edit User: Form yang sudah terisi data lama untuk diubah
  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
    nameController.text = user["nama"] ?? ""; // Isi field nama dengan data yang ada
    selectedRole = user["role"]; // Set role lama ke dropdown
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama"),
                TextField(controller: nameController, decoration: const InputDecoration(border: OutlineInputBorder())),
                const SizedBox(height: 15),
                const Text("Sebagai"),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ["Peminjam", "Petugas", "Admin"].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                  onChanged: (val) => selectedRole = val,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _editUser(user['id']),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F7FA6)),
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

  // Dialog Tambah User: Form kosong untuk memasukkan pengguna baru
  void _showAddUserDialog(BuildContext context) {
    nameController.clear(); // Bersihkan field sebelum dibuka
    selectedRole = null;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama"),
                TextField(controller: nameController, decoration: const InputDecoration(hintText: "Masukan nama", border: OutlineInputBorder())),
                const SizedBox(height: 15),
                const Text("Sebagai"),
                DropdownButtonFormField<String>(
                  hint: const Text("Pilih role"),
                  items: ["Peminjam", "Petugas", "Admin"].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                  onChanged: (val) => selectedRole = val,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addUser,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F7FA6)),
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
      backgroundColor: Colors.grey[200], // Warna latar belakang aplikasi
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F7FA6), // Warna biru tema utama
        title: const Text("Pengguna"),
        centerTitle: true,
        actions: [IconButton(onPressed: _fetchUsers, icon: const Icon(Icons.refresh))], // Tombol refresh data
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Bar Pencarian Pengguna
            TextField(
              decoration: InputDecoration(
                hintText: "Cari...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            // Daftar Pengguna (List View)
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator()) // Tampilkan loading spinner
                  : dataPengguna.isEmpty
                      ? const Center(child: Text("Tidak ada data pengguna")) // Jika database kosong
                      : ListView.builder(
                          itemCount: dataPengguna.length,
                          itemBuilder: (context, index) {
                            final user = dataPengguna[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: Row(
                                children: [
                                  // Menampilkan Nama Pengguna
                                  Expanded(
                                    child: Text(user["nama"] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  // Label Role Pengguna
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(6)),
                                    child: Text(user["role"] ?? "-", style: const TextStyle(fontSize: 11)),
                                  ),
                                  const SizedBox(width: 10),
                                  // Tombol Ikon Edit
                                  GestureDetector(
                                    onTap: () => _showEditUserDialog(context, user),
                                    child: const Icon(Icons.edit, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  // Tombol Ikon Hapus
                                  GestureDetector(
                                    onTap: () => _showDeleteConfirmationDialog(context, user['id']),
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
      // Tombol Mengambang (FAB) untuk menambah pengguna baru
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F7FA6),
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}