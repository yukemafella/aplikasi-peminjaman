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

  Future<void> _init() async {
    await _getCurrentUserRole();
    await _fetchUsers();
    _listenRealtimeUsers();
  }

  // ================= GET ROLE LOGIN =================
  Future<void> _getCurrentUserRole() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('users')
        .select('role')
        .eq('id_user', user.id)
        .single();

    setState(() {
      currentUserRole = data['role'];
    });
  }

  // ================= FETCH USERS =================
  Future<void> _fetchUsers() async {
    setState(() => isLoading = true);

    final data = await supabase.from('users').select();

    setState(() {
      users = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  // ================= REALTIME =================
  void _listenRealtimeUsers() {
    supabase.from('users').stream(primaryKey: ['id_user']).listen((data) {
      setState(() {
        users = List<Map<String, dynamic>>.from(data);
      });
    });
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: const Color(0xFF3488BC),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Tidak ada user"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      child: ListTile(
                        title: Text(user['nama'] ?? ''),
                        subtitle: Text("Role: ${user['role']}"),
                        trailing: currentUserRole == 'admin'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => _editRole(user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteUser(user['id_user']),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
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

  // ================= ADD USER =================
  void _addUserDialog() {
    final namaController = TextEditingController();
    String selectedRole = 'peminjam';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: const [
                DropdownMenuItem(value: 'admin', child: Text("Admin")),
                DropdownMenuItem(value: 'petugas', child: Text("Petugas")),
                DropdownMenuItem(value: 'peminjam', child: Text("Peminjam")),
              ],
              onChanged: (value) {
                selectedRole = value!;
              },
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (namaController.text.isEmpty) return;

              try {
                await supabase.from('users').insert({
                  'nama': namaController.text,
                  'role': selectedRole,
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User berhasil ditambahkan")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  // ================= EDIT ROLE =================
  void _editRole(Map user) {
    String selectedRole = user['role'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Role"),
        content: DropdownButtonFormField<String>(
          value: selectedRole,
          items: const [
            DropdownMenuItem(value: 'admin', child: Text("Admin")),
            DropdownMenuItem(value: 'petugas', child: Text("Petugas")),
            DropdownMenuItem(value: 'peminjam', child: Text("Peminjam")),
          ],
          onChanged: (value) {
            selectedRole = value!;
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await supabase
                    .from('users')
                    .update({'role': selectedRole})
                    .eq('id_user', user['id_user']);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Role berhasil diupdate")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  // ================= DELETE =================
  Future<void> _deleteUser(String id) async {
    try {
      await supabase.from('users').delete().eq('id_user', id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
