import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPengembalianPage extends StatefulWidget {
  const PetugasPengembalianPage({super.key});

  @override
  State<PetugasPengembalianPage> createState() =>
      _PetugasPengembalianPageState();
}

class _PetugasPengembalianPageState
    extends State<PetugasPengembalianPage> {

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listPengembalian = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ================= AMBIL DATA =================
  Future<void> fetchData() async {
    try {
      final response = await supabase
          .from('peminjaman')
          .select()
          .eq('status', 'disetujui')
          .order('created_at', ascending: false);

      setState(() {
        listPengembalian =
            List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= PROSES PENGEMBALIAN =================
  Future<void> prosesPengembalian(
      Map<String, dynamic> data) async {

    try {
      DateTime sekarang = DateTime.now();
      DateTime tanggalKembali =
          DateTime.parse(data['tanggal_kembali']);

      int selisihHari =
          sekarang.difference(tanggalKembali).inDays;

      int denda = 0;

      if (selisihHari > 0) {
        denda = selisihHari * 5000; // denda 5000/hari
      }

      // insert ke tabel pengembalian
      await supabase.from('pengembalian').insert({
        'id_peminjaman': data['id_peminjaman'],
        'tanggal_dikembalikan': sekarang.toIso8601String(),
        'denda': denda,
      });

      // update status peminjaman
      await supabase
          .from('peminjaman')
          .update({'status': 'dikembalikan'})
          .eq('id_peminjaman',
              data['id_peminjaman']);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
              denda > 0
                  ? "Terlambat! Denda Rp $denda"
                  : "Berhasil dikembalikan"),
        ),
      );

      fetchData();
    } catch (e) {
      debugPrint("Error proses: $e");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Pengembalian"),
        backgroundColor:
            const Color(0xFF2E86C1),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator())
          : listPengembalian.isEmpty
              ? const Center(
                  child: Text(
                      "Tidak ada alat yang dipinjam"))
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount:
                      listPengembalian.length,
                  itemBuilder:
                      (context, index) {

                    final item =
                        listPengembalian[index];

                    return Card(
                      margin:
                          const EdgeInsets.only(
                              bottom: 15),
                      elevation: 3,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(10),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets
                                .all(15),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Text(
                              "ID: ${item['id_peminjaman']}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                                "User ID: ${item['id_user']}"),
                            Text(
                                "Tanggal Pinjam: ${item['tanggal_pinjam']}"),
                            Text(
                                "Batas Kembali: ${item['tanggal_kembali']}"),
                            const SizedBox(height: 10),

                            Align(
                              alignment:
                                  Alignment
                                      .centerRight,
                              child:
                                  ElevatedButton(
                                onPressed: () =>
                                    prosesPengembalian(
                                        item),
                                style: ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                      Colors.green,
                                ),
                                child: const Text(
                                    "Proses"),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
