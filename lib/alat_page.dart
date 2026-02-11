import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

// Import halaman navigasi lainnya
import 'admin_dashboard_page.dart';
import 'aktivitas_page.dart';
import 'admin_pengguna_page.dart';
import 'pengembalian_admin_page.dart';
import 'peminjaman_page.dart';
import 'kategori_crud.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  String selectedCategory = 'All'; 
  bool isLoading = true;          
  List<Map<String, dynamic>> alatList = []; 
  int _currentIndex = 2;          

  @override
  void initState() {
    super.initState();
    fetchAlat(); 
  }

  Future<void> fetchAlat() async {
    try {
      setState(() => isLoading = true); 
      final response = await Supabase.instance.client
          .from('alat')
          .select() 
          .order('id_alat', ascending: true); 

      setState(() {
        alatList = List<Map<String, dynamic>>.from(response); 
        isLoading = false; 
      });
    } catch (e) {
      debugPrint("ERROR SUPABASE: $e");
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> get filteredAlat {
    if (selectedCategory == 'All') return alatList;
    int kategoriId = selectedCategory == 'Olahraga' ? 1 : (selectedCategory == 'Seni' ? 2 : 3);
    return alatList.where((a) => a['id_kategori'] == kategoriId).toList();
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    Widget targetPage;
    switch (index) {
      case 0: targetPage = const AdminDashboardPage(); break;
      case 1: targetPage = const AktivitasPage(); break;
      case 3: targetPage = const AdminPenggunaPage(); break;
      case 4: targetPage = const PengembalianAdminPage(); break;
      case 5: targetPage = const PeminjamanPage(); break;
      default: return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => targetPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) 
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari.....',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['All', 'Olahraga', 'Seni'].map((cat) => _buildCategoryBtn(cat)).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredAlat.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75, // Disesuaikan agar kotak lebih tinggi sedikit
                      ),
                      itemBuilder: (context, index) {
                        final alat = filteredAlat[index];
                        final bool tersedia = alat['status'] == 'Tersedia';
                        return _buildAlatCard(alat, tersedia);
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "tambah",
              backgroundColor: const Color(0xFF3488BC),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormTambahAlatPage()),
                );
                if (result == true) fetchAlat(); 
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: "kategori",
              backgroundColor: Colors.orange,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KategoriCrud())),
              child: const Icon(Icons.category, color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3488BC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_outlined), label: 'Pengembalian'),
          BottomNavigationBarItem(icon: Icon(Icons.handshake_outlined), label: 'Peminjaman'),
        ],
      ),
    );
  }

  Widget _buildCategoryBtn(String title) {
    final isActive = selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3488BC) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3488BC)),
        ),
        child: Text(title, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF3488BC), fontSize: 12)),
      ),
    );
  }

  // PERBAIKAN UTAMA DI SINI AGAR GAMBAR TIDAK TERPOTONG
  Widget _buildAlatCard(Map<String, dynamic> alat, bool tersedia) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: tersedia ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(alat['status'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
          const SizedBox(height: 4),
          // Menggunakan Expanded agar gambar mengambil sisa ruang yang tersedia
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: (alat['foto'] != null && alat['foto'].toString().isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        alat['foto'],
                        fit: BoxFit.contain, // Gambar akan tampil penuh tanpa terpotong
                        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            alat['nama_alat'] ?? '', 
            style: const TextStyle(fontWeight: FontWeight.bold), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis
          ),
          Text('Stok : ${alat['stok']} Unit', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class FormTambahAlatPage extends StatefulWidget {
  const FormTambahAlatPage({super.key});

  @override
  State<FormTambahAlatPage> createState() => _FormTambahAlatPageState();
}

class _FormTambahAlatPageState extends State<FormTambahAlatPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  String _selectedKategori = 'Olahraga';
  bool _isSaving = false; 

  XFile? _pickedFile;    
  Uint8List? _webImage;  
  final ImagePicker _picker = ImagePicker();
  
  final Map<String, int> _kategoriMap = {'Olahraga': 1, 'Seni': 2, 'Camera': 3};

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, 
    );
    
    if (image != null) {
      final bytes = await image.readAsBytes(); 
      setState(() {
        _webImage = bytes;
        _pickedFile = image;
      });
    }
  }

  Future<void> _saveData() async {
    if (_namaController.text.isEmpty || _stokController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi semua data!')));
      return;
    }
    
    setState(() => _isSaving = true); 

    try {
      String? imageUrl;

      if (_pickedFile != null && _webImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg'; 
        final path = 'alat_images/$fileName';

        await Supabase.instance.client.storage
            .from('foto_alat') 
            .uploadBinary(path, _webImage!);

        imageUrl = Supabase.instance.client.storage
            .from('foto_alat')
            .getPublicUrl(path);
      }

      await Supabase.instance.client.from('alat').insert({
        'nama_alat': _namaController.text,
        'stok': int.parse(_stokController.text),
        'status': 'Tersedia',
        'id_kategori': _kategoriMap[_selectedKategori],
        'foto': imageUrl, 
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alat berhasil ditambahkan!')));
        Navigator.pop(context, true); 
      }
    } catch (e) {
      debugPrint("Gagal simpan: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal menyimpan data ke database!"),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("tambah alat", style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150, width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black26), 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _webImage != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.memory(_webImage!, fit: BoxFit.cover), 
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50, color: Colors.grey),
                          Text("Pilih Foto", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage, 
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3488BC), minimumSize: const Size(120, 35)),
              child: const Text("Pilih Gambar", style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            _buildField("Nama Alat", _namaController),
            const SizedBox(height: 15),
            _buildField("Jumlah Stok", _stokController, isNum: true),
            const SizedBox(height: 15),
            _buildDropdown(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3488BC), 
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isSaving 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Simpan Alat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: "Masukkan $label",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Kategori", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedKategori,
              items: _kategoriMap.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (v) => setState(() => _selectedKategori = v!),
            ),
          ),
        ),
      ],
    );
  }
}