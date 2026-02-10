import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasLaporanPage extends StatefulWidget {
  const PetugasLaporanPage({super.key});

  @override
  State<PetugasLaporanPage> createState() =>
      _PetugasLaporanPageState();
}

class _PetugasLaporanPageState
    extends State<PetugasLaporanPage> {

  final supabase = Supabase.instance.client;

  int totalPinjam = 0;
  int totalKembali = 0;
  int totalDenda = 0;

  List<Map<String, dynamic>> laporanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    try {
      // ===== TOTAL PEMINJAMAN =====
      final pinjam =
          await supabase.from('peminjaman').select();

      // ===== TOTAL PENGEMBALIAN =====
      final kembali =
          await supabase.from('pengembalian').select();

      // ===== TOTAL DENDA =====
      final denda =
          await supabase.from('pengembalian')
              .select('denda');

      int totalDendaSum = 0;
      for (var item in denda) {
        totalDendaSum +=
            (item['denda'] ?? 0) as int;
      }

      setState(() {
        totalPinjam = pinjam.length;
        totalKembali = kembali.length;
        totalDenda = totalDendaSum;
        laporanList =
            List<Map<String, dynamic>>.from(pinjam);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error laporan: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
        backgroundColor:
            const Color(0xFF2E86C1),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator())
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // ===== CARD SUMMARY =====
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      _buildSummaryCard(
                          "Total Pinjam",
                          totalPinjam
                              .toString(),
                          Colors.blue),
                      _buildSummaryCard(
                          "Total Kembali",
                          totalKembali
                              .toString(),
                          Colors.green),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _buildSummaryCard(
                      "Total Denda",
                      "Rp $totalDenda",
                      Colors.red),

                  const SizedBox(height: 30),

                  const Text(
                    "Riwayat Peminjaman",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  // ===== LIST DATA =====
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount:
                        laporanList.length,
                    itemBuilder:
                        (context, index) {
                      final data =
                          laporanList[index];
                      return Card(
                        margin:
                            const EdgeInsets
                                .only(bottom: 10),
                        child: ListTile(
                          title: Text(
                              data['nama_alat'] ??
                                  '-'),
                          subtitle: Text(
                              "Tanggal: ${data['tanggal_pinjam'] ?? '-'}"),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }

  // ===== SUMMARY CARD =====
  Widget _buildSummaryCard(
      String title,
      String value,
      Color color) {
    return Container(
      width: MediaQuery.of(context)
              .size
              .width *
          0.43,
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 12)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}
  