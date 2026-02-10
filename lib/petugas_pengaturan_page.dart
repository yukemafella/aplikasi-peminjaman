import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPengaturanPage extends StatefulWidget {
  const PetugasPengaturanPage({super.key});

  @override
  State<PetugasPengaturanPage> createState() =>
      _PetugasPengaturanPageState();
}

class _PetugasPengaturanPageState
    extends State<PetugasPengaturanPage> {

  final supabase = Supabase.instance.client;

  String email = '';
  String role = 'petugas';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    final user = supabase.auth.currentUser;
    setState(() {
      email = user?.email ?? '-';
    });
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await supabase.auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const Placeholder(), // ganti ke LoginPage kamu
      ),
    );
  }

  // ================= GANTI PASSWORD =================
  Future<void> changePassword(String newPassword) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password berhasil diubah"),
        ),
      );
    } catch (e) {
      debugPrint("Error change password: $e");
    }
  }

  void showChangePasswordDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ganti Password"),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Masukkan password baru",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                changePassword(
                    controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            )
          ],
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor:
            const Color(0xFF2E86C1),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              "Informasi Akun",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading:
                  const Icon(Icons.email),
              title:
                  const Text("Email"),
              subtitle: Text(email),
            ),

            ListTile(
              leading:
                  const Icon(Icons.person),
              title:
                  const Text("Role"),
              subtitle: Text(role),
            ),

            const Divider(height: 40),

            ListTile(
              leading:
                  const Icon(Icons.lock),
              title: const Text(
                  "Ganti Password"),
              onTap:
                  showChangePasswordDialog,
            ),

            ListTile(
              leading:
                  const Icon(Icons.logout,
                      color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(
                    color: Colors.red),
              ),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
