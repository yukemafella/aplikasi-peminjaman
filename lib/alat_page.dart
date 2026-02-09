import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart';
import 'aktivitas_page.dart';
import 'admin_pengguna_page.dart';
import 'pengembalian_admin_page.dart';
import 'peminjaman_page.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  String selectedCategory = 'All';
  bool isLoading = true;
  bool isAdding = false;
  int? editingId; 
  List<Map<String, dynamic>> alatList = [];
  List<Map<String, dynamic>> kategoriList = [];
  Map<String, dynamic>? selectedKategoriMap;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      setState(() => isLoading = true);
      final katResponse = await Supabase.instance.client.from('kategori').select();
      final alatResponse = await Supabase.instance.client
          .from('alat')
          .select()
          .order('id_alat', ascending: false);

      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(katResponse);
        if (kategoriList.isNotEmpty && selectedKategoriMap == null) {
          selectedKategoriMap = kategoriList.firstWhere(
            (k) => k['nama_kategori'] == 'Olahraga', 
            orElse: () => kategoriList[0]
          );
        }
        alatList = List<Map<String, dynamic>>.from(alatResponse);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _simpanAlat() async {
    if (_namaController.text.isEmpty || _stokController.text.isEmpty || selectedKategoriMap == null) {
      _showMsg("Lengkapi semua data", Colors.orange);
      return;
    }

    try {
      final data = {
        'nama_alat': _namaController.text,
        'stok': int.parse(_stokController.text),
        'id_kategori': selectedKategoriMap!['id_kategori'],
        'status': 'Tersedia',
      };

      if (editingId == null) {
        await Supabase.instance.client.from('alat').insert(data);
        _showMsg("Berhasil disimpan", Colors.green);
      } else {
        await Supabase.instance.client.from('alat').update(data).eq('id_alat', editingId!);
        _showMsg("Alat berhasil diperbarui", Colors.blue);
      }

      _namaController.clear();
      _stokController.clear();
      setState(() {
        isAdding = false;
        editingId = null;
        selectedCategory = selectedKategoriMap!['nama_kategori'];
      });
      fetchInitialData(); 
    } catch (e) {
      _showMsg("Gagal memproses data", Colors.red);
    }
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Apakah anda yakin\nhapus alat ini !",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _hapusAlat(id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("Iya", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("Tidak", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _hapusAlat(int id) async {
    try {
      await Supabase.instance.client.from('alat').delete().eq('id_alat', id);
      _showMsg("Alat berhasil dihapus", Colors.redAccent);
      fetchInitialData();
    } catch (e) {
      _showMsg("Gagal menghapus data", Colors.red);
    }
  }

  void _showMsg(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));

  List<Map<String, dynamic>> get filteredAlat {
    if (selectedCategory == 'All') return alatList;
    return alatList.where((a) {
      final kat = kategoriList.firstWhere((k) => k['id_kategori'] == a['id_kategori'], orElse: () => {});
      return kat['nama_kategori'] == selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : Column(
                  children: [
                    _buildHeader(),
                    _buildGrid(),
                  ],
                ),
          ),
          if (isAdding) _buildOverlay(), 
        ],
      ),
      floatingActionButton: isAdding ? null : _buildFAB(),
      bottomNavigationBar: _buildNavbar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari.....', 
              prefixIcon: const Icon(Icons.search), 
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
            )
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _catBtn('All'),
                const SizedBox(width: 8),
                _catBtn('Olahraga'),
                const SizedBox(width: 8),
                _catBtn('Seni'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _catBtn(String t) {
    bool active = selectedCategory == t;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = t),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1F4E79) : Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: const Color(0xFF3488BC))
        ),
        child: Text(t, style: TextStyle(color: active ? Colors.white : const Color(0xFF3488BC), fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.82
        ),
        itemCount: filteredAlat.length,
        itemBuilder: (context, i) {
          final a = filteredAlat[i];
          return Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                    Text(a['nama_alat'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Stok: ${a['stok']} Unit", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 35),
                  ],
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () {
                          setState(() {
                            isAdding = true;
                            editingId = a['id_alat'];
                            _namaController.text = a['nama_alat'];
                            _stokController.text = a['stok'].toString();
                            selectedKategoriMap = kategoriList.firstWhere((k) => k['id_kategori'] == a['id_kategori']);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _showDeleteDialog(a['id_alat']),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(editingId == null ? "tambah alat" : "edit alat", style: const TextStyle(color: Colors.grey, fontSize: 14))),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 90, width: 90,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.image, size: 40),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF3488BC), borderRadius: BorderRadius.circular(15)),
                      child: const Text("Tambah gambar", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("Nama", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              TextField(controller: _namaController, decoration: InputDecoration(hintText: 'bola voli', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 10))),
              const SizedBox(height: 12),
              const Text("Stok", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              TextField(controller: _stokController, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: '1', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 10))),
              const SizedBox(height: 12),
              const Text("Kategori", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedKategoriMap,
                items: kategoriList.map((k) => DropdownMenuItem(value: k, child: Text(k['nama_kategori']))).toList(),
                onChanged: (v) => setState(() => selectedKategoriMap = v),
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isAdding = false;
                        editingId = null;
                        _namaController.clear();
                        _stokController.clear();
                      });
                    }, 
                    child: const Text("Batal", style: TextStyle(color: Colors.purple))
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _simpanAlat, 
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3488BC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), 
                    child: Text(editingId == null ? "Tambah" : "Simpan", style: const TextStyle(color: Colors.white))
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(heroTag: 'add', backgroundColor: const Color(0xFF3488BC), onPressed: () => setState(() => isAdding = true), child: const Icon(Icons.add, color: Colors.white)),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'cat', 
          backgroundColor: Colors.orange, 
          onPressed: () {
            // NAVIGASI KE KATEGORI
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const KategoriPage())
            ).then((_) => fetchInitialData()); // Refresh data saat kembali
          }, 
          child: const Icon(Icons.category, color: Colors.white)
        ),
      ],
    );
  }

  Widget _buildNavbar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, backgroundColor: const Color(0xFF3488BC), selectedItemColor: Colors.white, unselectedItemColor: Colors.white70, currentIndex: 2,
      onTap: (i) {
        if (i == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const DashboardPage()));
        if (i == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AktivitasPage()));
        if (i == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminPenggunaPage()));
        if (i == 4) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PengembalianAdminPage()));
        if (i == 5) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PeminjamanPage()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Aktivitas'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Alat'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
        BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_outlined), label: 'Pengembalian'),
        BottomNavigationBarItem(icon: Icon(Icons.handshake_outlined), label: 'Peminjaman'),
      ],
    );
  }
}

// --- HALAMAN KATEGORI (KODE YANG DITAMBAHKAN) ---
class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> kategoriList = [];

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    try {
      setState(() => isLoading = true);
      final response = await Supabase.instance.client
          .from('kategori')
          .select()
          .order('id_kategori', ascending: true);
      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("kategori", style: TextStyle(color: Colors.grey, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            color: Colors.grey.shade300,
            child: const Center(
              child: Text("Daftar Kategori", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari.....',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Tambah kategori", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: kategoriList.length,
                    itemBuilder: (context, index) {
                      final item = kategoriList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['nama_kategori'], 
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3488BC),
                                    minimumSize: const Size(80, 30),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text("edit", style: TextStyle(color: Colors.black)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}