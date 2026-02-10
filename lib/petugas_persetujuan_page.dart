import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPersetujuanPage extends StatefulWidget {
  const PetugasPersetujuanPage({super.key});

  @override
  State<PetugasPersetujuanPage> createState() =>
      _PetugasPersetujuanPageState();
}

class _PetugasPersetujuanPageState
    extends State<PetugasPersetujuanPage> {

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listPersetujuan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersetujuan();
  }

  // ================= AMBIL DATA =================
  Future<void> fetchPersetujuan() async {
    try {
      final response = await supabase
          .from('peminjaman')
          .select()
          .eq('status', 'menunggu')
          .order('created_at', ascending: false);

      setState(() {
        listPersetujuan =
            List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch: $e');
      setState(() => isLoading = false);
    }
  }

  // ================= UPDATE STATUS =================
  Future<void> updateStatus(
      int id, String statusBaru) async {
    try {
      await supabase
          .from('peminjaman')
          .update({'status': statusBaru})
          .eq('id_peminjaman', id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Peminjaman berhasil $statusBaru")),
      );

      fetchPersetujuan();
    } catch (e) {
      debugPrint('Error update: $e');
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Persetujuan Peminjaman"),
        backgroundColor:
            const Color(0xFF2E86C1),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator())
          : listPersetujuan.isEmpty
              ? const Center(
                  child: Text(
                      "Tidak ada peminjaman menunggu"))
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount:
                      listPersetujuan.length,
                  itemBuilder:
                      (context, index) {
                    final item =
                        listPersetujuan[index];

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
                              "ID Peminjaman: ${item['id_peminjaman']}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            const SizedBox(
                                height: 5),
                            Text(
                                "User ID: ${item['id_user']}"),
                            Text(
                                "Tanggal Pinjam: ${item['tanggal_pinjam']}"),
                            Text(
                                "Tanggal Kembali: ${item['tanggal_kembali']}"),
                            const SizedBox(
                                height: 10),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .end,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      updateStatus(
                                          item[
                                              'id_peminjaman'],
                                          'disetujui'),
                                  style: ElevatedButton
                                      .styleFrom(
                                    backgroundColor:
                                        Colors.green,
                                  ),
                                  child:
                                      const Text(
                                          "Setujui"),
                                ),
                                const SizedBox(
                                    width: 10),
                                ElevatedButton(
                                  onPressed: () =>
                                      updateStatus(
                                          item[
                                              'id_peminjaman'],
                                          'ditolak'),
                                  style: ElevatedButton
                                      .styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),
                                  child:
                                      const Text(
                                          "Tolak"),
                                ),
                              ],
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
