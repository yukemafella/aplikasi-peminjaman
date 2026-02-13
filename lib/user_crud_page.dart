import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Ganti dengan path file login Anda yang sebenarnya
// import 'login_page.dart'; 

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool loading = false;

  final searchController = TextEditingController();
  final namaController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'peminjam';
  final List<String> roleList = ['admin', 'petugas', 'peminjam'];

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    if (!mounted) return;
    setState(() => loading = true);
    try {
      // Perbaikan: Menggunakan tabel 'users' sesuai hint error image_1788c9.png
      final data = await supabase.from('users').select().order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          users = List<Map<String, dynamic>>.from(data);
          filteredUsers = users;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        debugPrint('Error fetch: $e');
      }
    }
  }

  void filterSearch(String query) {
    setState(() {
      filteredUsers = users.where((user) =>
          user['nama'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  // Fungsi Logout dengan navigasi aman (Perbaikan image_0d8d5f.png)
  Future<void> handleLogout() async {
    await supabase.auth.signOut();
    if (mounted) {
      // Navigator.pushAndRemoveUntil memastikan tidak ada error route generator
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const LoginPage()), 
      //   (route) => false,
      // );
    }
  }

  void showForm({Map<String, dynamic>? user}) {
    if (user != null) {
      namaController.text = user['nama'] ?? '';
      role = user['role'] ?? 'peminjam';
    } else {
      namaController.clear();
      passwordController.clear();
      role = 'peminjam';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(user == null ? 'Tambah User' : 'Edit User'),
        content: SingleChildScrollView( // Mencegah overflow saat keyboard muncul
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Email/Username", hintText: "contoh@mail.com"),
              ),
              if (user == null)
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    helperText: "Minimal 6 karakter", // Perbaikan image_17fa01.png
                  ),
                ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: role,
                items: roleList.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => role = v!),
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              // Validasi Password Lemah (image_17fa01.png)
              if (user == null && passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password minimal 6 karakter!')));
                return;
              }

              try {
                if (user == null) {
                  final res = await supabase.auth.signUp(
                    email: namaController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  // Perbaikan TypeError null (image_178d45.png) dengan pengecekan res.user
                  if (res.user != null) {
                    await supabase.from('users').insert({
                      'id_user': res.user!.id,
                      'nama': namaController.text,
                      'role': role,
                    });
                  }
                } else {
                  await supabase.from('users').update({
                    'nama': namaController.text,
                    'role': role,
                  }).eq('id_user', user['id_user']);
                }
                Navigator.pop(context);
                fetchUser();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        elevation: 0,
        title: const Text('Pengguna', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          // Search Bar (Desain image_17ee67.png)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: "Cari.....",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredUsers.length,
                    itemBuilder: (_, i) {
                      final user = filteredUsers[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            // Expanded mencegah "Garis Kuning" jika teks panjang
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(user['nama'] ?? '', 
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 8),
                                  // Badge Role
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0E0E0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(user['role'] ?? '', style: const TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => showForm(user: user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                // Tambahkan konfirmasi hapus jika perlu
                                deleteUser(user['id_user']);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        backgroundColor: const Color(0xFF3B82B6),
        child: const Icon(Icons.add, size: 30, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3B82B6),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        currentIndex: 2, // Highlight tab Pengguna
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Kas'),
        ],
      ),
    );
  }

  Future<void> deleteUser(String id) async {
    try {
      await supabase.from('users').delete().eq('id_user', id);
      fetchUser();
    } catch (e) {
      debugPrint('Gagal hapus: $e');
    }
  }
}