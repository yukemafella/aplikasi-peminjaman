import 'package:flutter/material.dart';
import 'login_page.dart';
import 'alat_page.dart'; // Import halaman alat baru

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0; // Index untuk navbar

  // Daftar halaman
  late final List<Widget> _pages = [
    _buildBeranda(context), // Halaman Beranda
    const AlatPage(),       // Halaman Alat
    const Center(child: Text("Halaman Pengguna")),
    const Center(child: Text("Halaman Aktivitas")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Aktivitas'),
        ],
      ),
    );
  }

  // --- Fungsi Beranda (Logika lama Anda dipindah ke sini) ---
  Widget _buildBeranda(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showProfileDialog(context),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yuke", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Admin!", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Total alat", "10"),
                _buildStatCard("Pinjaman aktif", "8"),
                _buildStatCard("Barang rusak", "3"),
              ],
            ),
            const SizedBox(height: 30),
            const Center(child: Text("Grafik alat yang sering di pinjam", style: TextStyle(fontWeight: FontWeight.w500))),
            const SizedBox(height: 10),
            _buildChart(),
            const SizedBox(height: 30),
            _buildActivityItem("Sanjaya", "30/01/2026", "Peminjam", Colors.grey),
            _buildActivityItem("Clara", "30/01/2026", "Petugas", Colors.blue.shade300),
            _buildActivityItem("Aisya", "30/01/2026", "Peminjam", Colors.grey),
            _buildActivityItem("Rara", "30/01/2026", "Petugas", Colors.blue.shade300),
          ],
        ),
      ),
    );
  }

  // Widget Chart
  Widget _buildChart() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar(100, Colors.black12),
          _buildBar(80, Colors.blue),
          _buildBar(50, Colors.black12),
          _buildBar(120, Colors.blue),
          _buildBar(40, Colors.black12),
          _buildBar(70, Colors.blue),
        ],
      ),
    );
  }

  // --- Dialog & Helper Widgets Tetap Sama (Logika Anda Tidak Berubah) ---
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("pengaturan", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              const CircleAvatar(radius: 40, backgroundColor: Colors.black12, child: Icon(Icons.person, size: 50)),
              const Text("Yuke", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildDisabledField("Nama", "Yuke"),
              _buildDisabledField("Email", "Yuke@gmail.com"),
              _buildDisabledField("Password", "**********", isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showLogoutConfirmation(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3488BC)),
                child: const Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Apakah anda yakin keluar dari akun ini !"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Iya"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledField(String label, String value, {bool isPassword = false}) {
    return TextField(controller: TextEditingController(text: value), enabled: false, obscureText: isPassword, decoration: InputDecoration(labelText: label));
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100, padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(children: [Text(title, style: const TextStyle(fontSize: 10)), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(width: 30, height: height, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)));
  }

  Widget _buildActivityItem(String name, String date, String role, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Nama : $name"), Text("Tanggal : $date")]),
        Chip(label: Text(role, style: const TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: color),
      ]),
    );
  }
}