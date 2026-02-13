import 'package:flutter/material.dart';
// Import semua halaman yang akan ditampilkan di dalam navigasi utama
import 'package:flutter_application_1/user_crud_page.dart';
import 'package:flutter_application_1/petugas_dashboard.dart';
import 'package:flutter_application_1/admin_dashboard_page.dart';
import 'alat_page.dart';
import 'aktivitas_page.dart';
import 'peminjaman_page.dart';
import 'admin_pengembalian.dart';

// Menggunakan StatefulWidget karena kita perlu mengubah variabel '_currentIndex' 
// saat user mengklik menu di bar bawah (BottomNavigationBar)
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Variabel untuk menyimpan index halaman yang aktif saat ini (dimulai dari 0 = Beranda)
  int _currentIndex = 0;

  // Daftar list halaman yang akan dimasukkan ke dalam navigasi
  // Pastikan urutannya sama dengan urutan di 'items' BottomNavigationBar di bawah
  final List<Widget> _pages = const [
    AdminDashboardPage(),     // Index 0
    AlatPage(),               // Index 1
    UserCrudPage(),      // Index 2
    AktivitasPage(),          // Index 3
    PeminjamanPage(),         // Index 4
    PengembalianAdminPage(),  // Index 5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 'body' menggunakan IndexedStack. 
      // FUNGSINYA: Menumpuk semua halaman, tapi hanya menampilkan satu berdasarkan index.
      // KEUNGGULAN: Halaman tidak akan me-reload ulang saat kita berpindah menu (status terjaga).
      body: IndexedStack(
        index: _currentIndex, // Halaman mana yang muncul ditentukan oleh angka ini
        children: _pages,     // Daftar halaman yang sudah kita buat di atas
      ),

      // Desain BottomNavigationBar yang dibungkus Container agar bisa diberi Margin dan Border Radius
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12), // Memberikan jarak luar agar navbar terlihat melayang (floating)
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF3F7FA6), // Warna biru navbar
          borderRadius: BorderRadius.circular(18), // Membuat sudut navbar melengkung
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Digunakan jika item lebih dari 3 agar label tetap muncul
          backgroundColor: Colors.transparent, // Transparan karena mengikuti warna Container pembungkusnya
          elevation: 0, // Menghilangkan bayangan default navbar
          currentIndex: _currentIndex, // Memberitahu navbar item mana yang sedang aktif (menyala)
          selectedItemColor: Colors.white, // Warna ikon saat diklik/dipilih
          unselectedItemColor: Colors.white70, // Warna ikon saat sedang tidak aktif
          selectedFontSize: 11,
          unselectedFontSize: 11,
          
          // Fungsi yang dipanggil saat salah satu ikon di-klik
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update nilai index agar layar berpindah halaman
            });
          },
          
          // Daftar ikon dan label yang muncul di navbar
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined), label: 'Alat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Pengguna'),
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined), label: 'Aktivitas'),
            BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism_outlined),
                label: 'Peminjaman'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                label: 'Pengembalian'),
          ],
        ),
      ),
    );
  }
}