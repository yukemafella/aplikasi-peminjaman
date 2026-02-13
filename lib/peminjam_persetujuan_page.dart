import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==================== CONFIG SUPABASE ====================
const supabaseUrl = 'https://uddtkqdljfgenjibxrwv.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkZHRrcWRsamZnZW5qaWJ4cnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODIzMTIsImV4cCI6MjA4NDE1ODMxMn0.vHKA2q91ByXYmgte9bjQi4_21SJaSxOqrHhsSJZ6kbI';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainNavigation(),
  ));
}

// ==================== GLOBAL DATA ====================
List<Map<String, dynamic>> keranjang = [];

// ==================== MAIN NAVIGATION (NAVBAR TETAP) ====================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Fungsi untuk mengganti tab secara programatik
  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    const AlatPage(),
    const PersetujuanPage(),
    const KeranjangPage(),
    const KembaliPlaceholder(),
    const PengaturanPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF2E86C1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, "Beranda", 0),
            _navItem(Icons.inventory_2, "Persetujuan", 1),
            _navItem(Icons.assignment, "Pinjam", 2),
            _navItem(Icons.refresh, "Kembali", 3),
            _navItem(Icons.settings, "Pengaturan", 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => changeTab(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 26),
          Text(label, 
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70, 
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== HALAMAN LIST ALAT ====================
class AlatPage extends StatefulWidget {
  const AlatPage({super.key});
  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> alatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  Future<void> fetchAlat() async {
    try {
      final response = await supabase.from('alat').select().order('id_alat');
      setState(() {
        alatList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.only(left: 5, bottom: 15),
          alignment: Alignment.bottomLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                onPressed: () {
                  context.findAncestorStateOfType<_MainNavigationState>()?.changeTab(0);
                },
              ),
              const Text(
                'Alat',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: alatList.length,
                  itemBuilder: (context, index) => _buildAlatCard(alatList[index]),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "Cari.....",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildAlatCard(Map<String, dynamic> data) {
    String nama = data["nama_alat"] ?? data["nama"] ?? "Alat Tanpa Nama";
    String kategori = data["kategori"] ?? "Umum";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(kategori, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade200)),
            child: const Text("● Tersedia", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF90AFC5), elevation: 0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(data: data)));
              },
              child: const Text("Lihat Detail", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

// ==================== DETAIL PAGE ====================
class DetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailPage({super.key, required this.data});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    String nama = widget.data["nama_alat"] ?? widget.data["nama"] ?? "Alat";
    int stok = widget.data["stok"] ?? 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        elevation: 0,
        automaticallyImplyLeading: false, 
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            Text(nama, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.data["gambar"] ?? "",
                height: 200,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200, width: double.infinity, color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () => setState(() { if(jumlah > 1) jumlah--; }), icon: const Icon(Icons.remove_circle_outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("$jumlah", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                IconButton(onPressed: () => setState(() { if(jumlah < stok) jumlah++; }), icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E86C1),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                keranjang.add({...widget.data, "jumlah": jumlah});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil masuk keranjang!")));
              },
              child: const Text("TAMBAH KE KERANJANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== PERSETUJUAN PAGE ====================
class PersetujuanPage extends StatelessWidget {
  const PersetujuanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () {
                context.findAncestorStateOfType<_MainNavigationState>()?.changeTab(0);
              },
            ),
            const Text("Persetujuan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _statusCard("Bola Futsal", "Menunggu", Colors.orange),
          _statusCard("Bola Basket", "Disetujui", Colors.green),
        ],
      ),
    );
  }

  Widget _statusCard(String nama, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
            child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }
}

// ==================== KERANJANG PAGE ====================
class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9D9D9),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () {
                context.findAncestorStateOfType<_MainNavigationState>()?.changeTab(0);
              },
            ),
            const Text("Keranjang Pinjam", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: keranjang.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: keranjang.length,
                    itemBuilder: (context, index) {
                      final item = keranjang[index];
                      return Card(
                        child: ListTile(
                          title: Text(item["nama_alat"] ?? item["nama"] ?? "Alat"),
                          subtitle: Text("${item["jumlah"]} unit"),
                          trailing: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E86C1), minimumSize: const Size(double.infinity, 55)),
                    onPressed: () {},
                    child: const Text("AJUKAN PEMINJAMAN", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
    );
  }
}

// ==================== PLACEHOLDERS ====================
class KembaliPlaceholder extends StatelessWidget {
  const KembaliPlaceholder({super.key});
  @override build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFD9D9D9),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () {
              context.findAncestorStateOfType<_MainNavigationState>()?.changeTab(0);
            },
          ),
          const Text("Kembali", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    body: const Center(child: Text("Halaman Kembali")),
  );
}

class PengaturanPlaceholder extends StatelessWidget {
  const PengaturanPlaceholder({super.key});
  @override build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFD9D9D9),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () {
              context.findAncestorStateOfType<_MainNavigationState>()?.changeTab(0);
            },
          ),
          const Text("Pengaturan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    body: const Center(child: Text("Halaman Pengaturan")),
  );
}