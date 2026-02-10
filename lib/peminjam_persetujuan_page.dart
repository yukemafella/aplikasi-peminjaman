import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: PersetujuanPage(),
      debugShowCheckedModeBanner: false,
    ));

// ==========================================
// 1. HALAMAN UTAMA: PERSETUJUAN (DAFTAR ALAT)
// ==========================================
class PersetujuanPage extends StatelessWidget {
  const PersetujuanPage({super.key});

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
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
              _buildCategoryChip("Olahraga", false, isBlue: true),
              const SizedBox(width: 10),
              _buildCategoryChip("Seni", false, isBlue: true),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildAlatCard(context, "Bola Basket", "Olahraga"),
                _buildAlatCard(context, "SAMSUNG Galaxy Book4", "Laptop"),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, 1),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, {bool isBlue = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : (isBlue ? const Color(0xFF2E86C1) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isSelected ? Colors.black54 : Colors.transparent),
      ),
      child: Text(label,
          style: TextStyle(
              color: isSelected ? Colors.black : Colors.white, fontSize: 12)),
    );
  }

  Widget _buildAlatCard(BuildContext context, String title, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(category,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              SizedBox(width: 5),
              Text("Tersedia",
                  style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailAlatPage(title: title))),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFF90AFC5),
                    borderRadius: BorderRadius.circular(5)),
                child: const Text("Lihat Detail",
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN: DETAIL ALAT
// ==========================================
class DetailAlatPage extends StatelessWidget {
  final String title;
  const DetailAlatPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Detail Alat',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: Icon(Icons.laptop_chromebook, size: 100, color: Colors.blueGrey)),
              const SizedBox(height: 20),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const Text("• Spesifikasi Alat Pilihan", style: TextStyle(fontSize: 13)),
              const Text("• Kualitas Standar Nasional", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQtyBtn(Icons.remove),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: const Text("1",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  _buildQtyBtn(Icons.add),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    _buildOutlineBtn("Stok Tersedia: 1"),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KeranjangPage())),
                      child: _buildOutlineBtn("Keranjang"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon) => Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Icon(icon, size: 20));
  Widget _buildOutlineBtn(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(5)),
      child: Text(text, style: const TextStyle(fontSize: 12)));
}

// ==========================================
// 3. HALAMAN: KERANJANG
// ==========================================
class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Keranjang',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
              child: Row(
                children: [
                  const Icon(Icons.laptop_mac, size: 50, color: Colors.blueGrey),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SAMSUNG Galaxy Book4", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text("Laptop", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                    child: const Text("-  1  +", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Total: 1 alat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E86C1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormPeminjamanPage())),
                child: const Text("Ajukan Peminjaman", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. HALAMAN: FORM AJUKAN PEMINJAMAN
// ==========================================
class FormPeminjamanPage extends StatelessWidget {
  const FormPeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ajukan Peminjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.laptop_mac, size: 50, color: Colors.blueGrey),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SAMSUNG Galaxy Book4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const Text("Laptop", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(5)),
                          child: const Text("Tersedia", style: TextStyle(color: Colors.green, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                    child: const Text("-  1  +", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildInputLabel("Ambil"),
            Row(
              children: [
                Expanded(child: _buildDateField("06/01/2026")),
                const SizedBox(width: 10),
                Expanded(child: _buildTimeField("10:00")),
              ],
            ),
            const SizedBox(height: 15),
            _buildInputLabel("Kembali"),
            Row(
              children: [
                Expanded(child: _buildDateField("10/01/2026")),
                const SizedBox(width: 10),
                Expanded(child: _buildTimeField("14:00")),
              ],
            ),
            const SizedBox(height: 15),
            _buildInputLabel("Tenggat Pengembalian"),
            Row(
              children: [
                Expanded(child: _buildDateField("09/01/2026")),
                const SizedBox(width: 10),
                Expanded(child: _buildTimeField("14:00")),
              ],
            ),
            const Spacer(),
            const Text("Total: 1 alat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E86C1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuksesKirimPage())),
                child: const Text("Ajukan Peminjaman", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));

  Widget _buildDateField(String val) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(5)),
        child: Row(children: [const Icon(Icons.calendar_month, size: 18), const SizedBox(width: 5), Text(val)]),
      );

  Widget _buildTimeField(String val) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(5)),
        child: Row(children: [const Icon(Icons.access_time, size: 18), const SizedBox(width: 5), Text(val)]),
      );
}

// ==========================================
// 5. HALAMAN: SUKSES KIRIM (SESUAI GAMBAR)
// ==========================================
class SuksesKirimPage extends StatelessWidget {
  const SuksesKirimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Persetujuan',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Pengajuan Berhasil dikirim",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              "Permintaan peminjamanmu sudah dikirim ke Petugas. Silahkan tunggu persetujuan petugas.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            // Card Detail Alat
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.laptop_mac, size: 40, color: Colors.blueGrey),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SAMSUNG Galaxy Book4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("Laptop", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Text("1", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Lihat Riwayat
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E86C1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Tambahkan aksi liat riwayat jika ada
                },
                child: const Text("Lihat Riwayat", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            // Tombol Kembali ke Beranda
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Kembali ke halaman awal (PersetujuanPage)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const PersetujuanPage()),
                    (route) => false,
                  );
                },
                child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Global untuk Bottom Nav
Widget _buildBottomNav(BuildContext context, int index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: const Color(0xFF2E86C1),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
    currentIndex: index,
    onTap: (i) {},
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
      BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Persetujuan'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pinjam'),
      BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Kembali'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
    ],
  );
}