import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPetugas extends StatefulWidget {
  const DashboardPetugas({super.key});

  @override
  State<DashboardPetugas> createState() => _DashboardPetugasState();
}

class _DashboardPetugasState extends State<DashboardPetugas> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String? currentUserRole;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // Fungsi inisialisasi awal
  Future<void> _init() async {
    try {
      // Menjalankan kedua fungsi secara paralel agar lebih cepat
      await Future.wait([
        _getCurrentUserRole(),
        _fetchUsers(),
      ]);
      _listenRealtimeUsers();
    } catch (e) {
      debugPrint("Init Error: $e");
    } finally {
      // Memastikan loading berhenti apa pun yang terjadi
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================= GET ROLE LOGIN (FIXED) =================
  Future<void> _getCurrentUserRole() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // Menggunakan maybeSingle() agar tidak stuck jika ID tidak ditemukan
      final data = await supabase
          .from('users')
          .select('role')
          .eq('id_user', user.id)
          .maybeSingle();

      if (mounted && data != null) {
        setState(() {
          currentUserRole = data['role'];
        });
      }
    } catch (e) {
      debugPrint("Error Get Role: $e");
    }
  }

  // ================= FETCH USERS (FIXED) =================
  Future<void> _fetchUsers() async {
    if (!mounted) return;
    // Kita tidak perlu setState loading di sini karena sudah diatur di _init()
    
    try {
      final data = await supabase.from('users').select();
      if (mounted) {
        setState(() {
          users = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint("Error Fetch Users: $e");
    }
    // Variabel isLoading akan diubah di fungsi _init menggunakan finally
  }

  // ================= REALTIME =================
  void _listenRealtimeUsers() {
    supabase.from('users').stream(primaryKey: ['id_user']).listen((data) {
      if (mounted) {
        setState(() {
          users = List<Map<String, dynamic>>.from(data);
        });
      }
    });
  }

  // ================= BUILD UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: const Color(0xFF3488BC),
        actions: [
          // Tambahkan tombol refresh manual jika perlu
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _init,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Tidak ada data user di database"))
              : RefreshIndicator(
                  onRefresh: _init,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(user['nama'] ?? 'Tanpa Nama'),
                          subtitle: Text("Role: ${user['role']}"),
                          trailing: currentUserRole == 'admin'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editRole(user),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteUser(user['id_user']),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: currentUserRole == 'admin'
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add),
              onPressed: _addUserDialog,
            )
          : null,
    );
  }

  // ================= LOGIKA TAMBAH, EDIT, HAPUS (TETAP SAMA) =================
  void _addUserDialog() {
    final namaController = TextEditingController();
    String selectedRole = 'peminjam';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah User Baru"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ['admin', 'petugas', 'peminjam'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
              }).toList(),
              onChanged: (val) => selectedRole = val!,
              decoration: const InputDecoration(labelText: "Pilih Role"),
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty) return;
              try {
                await supabase.from('users').insert({
                  'nama': namaController.text,
                  'role': selectedRole,
                });
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                debugPrint("Insert Error: $e");
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  void _editRole(Map user) {
    String selectedRole = user['role'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Role: ${user['nama']}"),
        content: DropdownButtonFormField<String>(
          value: selectedRole,
          items: ['admin', 'petugas', 'peminjam'].map((role) {
            return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
          }).toList(),
          onChanged: (val) => selectedRole = val!,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              try {
                await supabase
                    .from('users')
                    .update({'role': selectedRole})
                    .eq('id_user', user['id_user']);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                debugPrint("Update Error: $e");
              }
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  Future<void> _deleteUser(String id) async {
    try {
      await supabase.from('users').delete().eq('id_user', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User berhasil dihapus")),
        );
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }
}