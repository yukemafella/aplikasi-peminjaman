import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==================== CONFIG SUPABASE ====================
const supabaseUrl = 'https://uddtkqdljfgenjibxrwv.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkZHRrcWRsamZnZW5qaWJ4cnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODIzMTIsImV4cCI6MjA4NDE1ODMxMn0.vHKA2q91ByXYmgte9bjQi4_21SJaSxOqrHhsSJZ6kbI';
final supabase = Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  final supabase = Supabase.instance.client;


  runApp(const MaterialApp(
    home: PersetujuanPage(),
    debugShowCheckedModeBanner: false,
  ));
}

// ==========================================
// 1. HALAMAN UTAMA: PERSETUJUAN (DAFTAR ALAT)
// ==========================================
class PersetujuanPage extends StatefulWidget {
  const PersetujuanPage({super.key});

  @override
  State<PersetujuanPage> createState() => _PersetujuanPageState();
}

class _PersetujuanPageState extends State<PersetujuanPage> {
  List<Map<String, dynamic>> alatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  Future<void> fetchAlat() async {
    try {
      final response = await supabase.from('alat').select().order('id_alat', ascending: true);;

      setState(() {
        alatList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetch alat: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Alat',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari.....",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryChip("All", true),
              const SizedBox(width: 10),
              _buildCategoryChip("Olahraga", false,
                  isBlue: true),
              const SizedBox(width: 10),
              _buildCategoryChip("Seni", false,
                  isBlue: true),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    itemCount: alatList.length,
                    itemBuilder: (context, index) {
                      final alat = alatList[index];
                      return _buildAlatCard(
                        context,
                        alat['nama'] ?? '-',
                        alat['kategori'] ?? '-',
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar:
          _buildBottomNav(context, 1),
    );
  }

  Widget _buildCategoryChip(String label,
      bool isSelected,
      {bool isBlue = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : (isBlue
                ? const Color(0xFF2E86C1)
                : Colors.white),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
            color: isSelected
                ? Colors.black54
                : Colors.transparent),
      ),
      child: Text(label,
          style: TextStyle(
              color: isSelected
                  ? Colors.black
                  : Colors.white,
              fontSize: 12)),
    );
  }

  Widget _buildAlatCard(BuildContext context,
      String title, String category) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 16)),
          Text(category,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14)),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.check_circle,
                  color: Colors.green,
                  size: 16),
              SizedBox(width: 5),
              Text("Tersedia",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 12)),
            ],
          ),
          Align(
            alignment:
                Alignment.bottomRight,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (context) =>
                      const PersetujuanPage(
                      ))),
              child: Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                            horizontal: 10,
                            vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(
                        0xFF90AFC5),
                    borderRadius:
                        BorderRadius
                            .circular(
                                5)),
                child: const Text(
                    "Lihat Detail",
                    style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// BOTTOM NAV (SAMA PERSIS)
// ==========================================
Widget _buildBottomNav(
    BuildContext context,
    int index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor:
        const Color(0xFF2E86C1),
    selectedItemColor: Colors.white,
    unselectedItemColor:
        Colors.white70,
    currentIndex: index,
    onTap: (i) {},
    items: const [
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda'),
      BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: 'Persetujuan'),
      BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Pinjam'),
      BottomNavigationBarItem(
          icon: Icon(Icons.refresh),
          label: 'Kembali'),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Pengaturan'),
    ],
  );
}
