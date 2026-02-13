import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class PetugasBerandaPage extends StatefulWidget {
  final String petugasId;

  const PetugasBerandaPage({
    super.key,
    required this.petugasId,
  });

  @override
  State<PetugasBerandaPage> createState() => _PetugasBerandaPageState();
}

class _PetugasBerandaPageState extends State<PetugasBerandaPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> peminjamanList = [];
  bool loading = true;

  int totalDisetujui = 0;
  int totalDikembalikan = 0;
  int totalMenunggu = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    setState(() => loading = true);

    try {
      final data = await supabase
          .from('peminjaman')
          .select('*, alat(*)')
          .order('created_at', ascending: false);

      final list = List<Map<String, dynamic>>.from(data);

      setState(() {
        peminjamanList = list;

        totalDisetujui =
            list.where((e) => e['status'] == 'disetujui').length;

        totalDikembalikan =
            list.where((e) => e['status'] == 'dikembalikan').length;

        totalMenunggu =
            list.where((e) => e['status'] == 'menunggu').length;

        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchDashboard,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      "Dashboard Petugas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    /// ====== CARD STATISTIK ======
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                            "Disetujui", totalDisetujui, Colors.blue),
                        _buildStatCard(
                            "Dikembalikan", totalDikembalikan, Colors.green),
                        _buildStatCard(
                            "Menunggu", totalMenunggu, Colors.orange),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ====== LIST PEMINJAMAN ======
                    const Text(
                      "Data Peminjaman",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    ...peminjamanList.map((item) {
                      final alat = item['alat'];
                      final namaAlat =
                          alat?['nama_alat'] ?? "Alat tidak ditemukan";

                      final foto = item['foto'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          leading: foto != null
                              ? Image.network(
                                  foto,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.inventory),
                          title: Text(namaAlat),
                          subtitle: Text(
                              "Status: ${item['status']}\nTanggal: ${item['tanggal_pinjam']}"),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}