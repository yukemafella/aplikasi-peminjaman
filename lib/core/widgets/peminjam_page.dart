import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Peminjam',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(), // Menggunakan MainPage sebagai pembungkus
    );
  }
}

// 1. KELAS UTAMA UNTUK MENGATUR NAVIGASI NAVBAR
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 4; // Set ke 4 agar defaultnya membuka menu 'Peminjam'

  // Daftar halaman untuk setiap menu navbar
  final List<Widget> _pages = [
    const Center(child: Text('Halaman Beranda')),
    const Center(child: Text('Halaman Alat')),
    const Center(child: Text('Halaman Pengguna')),
    const Center(child: Text('Halaman Aktivitas')),
    const PeminjamPage(), // Halaman sesuai gambar kamu
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      // Navbar dipindah ke sini agar selalu ada di setiap halaman
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF3489BC),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: NavIcon(icon: Icons.home_outlined, label: 'Beranda', isActive: _selectedIndex == 0),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: NavIcon(icon: Icons.inventory_2_outlined, label: 'Alat', isActive: _selectedIndex == 1),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: NavIcon(icon: Icons.person_outline, label: 'Pengguna', isActive: _selectedIndex == 2),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(3),
              child: NavIcon(icon: Icons.grid_view_outlined, label: 'Aktivitas', isActive: _selectedIndex == 3),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(4),
              child: NavIcon(icon: Icons.front_hand_outlined, label: 'Peminjam', isActive: _selectedIndex == 4),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. HALAMAN DATA PEMINJAM (SESUAI GAMBAR)
class PeminjamPage extends StatelessWidget {
  const PeminjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back otomatis
        title: const Text(
          'Data Peminjam',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.person_outline, size: 60),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Yukemafella@gmail.com',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const PeminjamCard(
                  name: 'Sanjaya',
                  item: 'Bola futsal',
                  date: '08, jan 2026 - 09, jan 2026',
                  iconData: Icons.sports_soccer,
                ),
                const PeminjamCard(
                  name: 'Adit',
                  item: 'Bola Basket',
                  date: '08, jan 2026 - 09, jan 2026',
                  iconData: Icons.sports_basketball,
                ),
                const PeminjamCard(
                  name: 'Elingga',
                  item: 'Seruling',
                  date: '1, jan 2026 - 5, jan 2026',
                  iconData: Icons.music_note,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      child: const Text('Tambah data peminjam', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. WIDGET KARTU PEMINJAM
class PeminjamCard extends StatelessWidget {
  final String name;
  final String item;
  final String date;
  final IconData iconData;

  const PeminjamCard({
    super.key,
    required this.name,
    required this.item,
    required this.date,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[100],
                child: Icon(iconData, size: 30, color: Colors.brown),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(item, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, size: 20, color: Colors.black54),
            ],
          ),
          const Divider(height: 25, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.orange),
                    SizedBox(width: 5),
                    Text('Dipinjam', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline, size: 14, color: Colors.red),
                    SizedBox(width: 5),
                    Text('Hapus', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 4. WIDGET IKON NAVBAR
class NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const NavIcon({super.key, required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(isActive ? 1.0 : 0.6), size: 22),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(isActive ? 1.0 : 0.6),
            fontSize: 10,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 15,
            color: Colors.white,
          )
      ],
    );
  }
}