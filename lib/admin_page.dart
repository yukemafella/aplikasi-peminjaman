import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pengguna_page.dart';
import 'package:flutter_application_1/petugas_Dashboard_page.dart';
import 'package:flutter_application_1/admin_dashboard_page.dart';
import 'alat_page.dart';
import 'admin_pengguna_page.dart';
import 'aktivitas_page.dart';
import 'peminjaman_page.dart';
import 'pengembalian_admin_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardPage(),
    AlatPage(),
    AdminPenggunaPage(),
    AktivitasPage(),
    PeminjamanPage(),
    PengembalianAdminPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF3F7FA6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
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