import 'package:flutter/material.dart';
import 'package:flutter_application_1/petugas_pengaturan_page.dart';
import 'package:flutter_application_1/petugas_pengembalian_page.dart';
import 'petugas_beranda_page.dart';
import 'petugas_pratinjau_page.dart';
import 'petugas_laporan_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key, required String petugasId});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  int _currentIndex = 0;

  // ✅ AMBIL USER ID DARI SUPABASE
  String userId = Supabase.instance.client.auth.currentUser?.id ?? '';

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // ✅ INISIALISASI SCREEN
    // Karena UI baru memiliki 5 menu, saya sesuaikan penempatannya
    _screens = [
      PetugasBerandaPage(petugasId: userId), // Indeks 0: Beranda
      const PersetujuanPage(),               // Indeks 1: Persetujuan
      const PetugasPengembalianPage(), // Indeks 2: Pengembalian
      const PetugasLaporanPage(),            // Indeks 3: Laporan
      const PetugasPengaturanPage(),   // Indeks 4: Pengaturan
    ];
  }

  String getTitle() {
    switch (_currentIndex) {
      case 0:
        return "Beranda";
      case 1:
        return "Persetujuan";
      case 2:
        return "Pengembalian";
      case 3:
        return "Laporan";
      case 4:
        return "Pengaturan";
      default:
        return "";
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff01386C),
        elevation: 0,
        title: Text(getTitle(), style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menu Profil (belum dibuat)")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), 
            onPressed: logout
          ),
        ],
      ),
      body: _screens[_currentIndex],
      
      // ✅ CUSTOM BOTTOM NAVBAR SESUAI GAMBAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10), // Memberi sedikit jarak agar melayang seperti di gambar
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF4292C6), // Warna biru sesuai gambar
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Beranda", 0),
            _buildNavItem(Icons.assignment, "Persetujuan", 1),
            _buildNavItem(Icons.reply, "Pengembalian", 2),
            _buildNavItem(Icons.description, "Laporan", 3),
            _buildNavItem(Icons.settings, "Pengaturan", 4),
          ],
        ),
      ),
    );
  }

  // ✅ WIDGET HELPER UNTUK ITEM NAVBAR
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black87,
            size: 26,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}