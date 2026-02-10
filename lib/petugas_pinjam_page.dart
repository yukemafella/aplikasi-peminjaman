import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasPinjamPage extends StatefulWidget {
  const PetugasPinjamPage({super.key});

  @override
  State<PetugasPinjamPage> createState() => _PetugasPinjamPageState();
}

class _PetugasPinjamPageState extends State<PetugasPinjamPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> dataPinjam = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  // ================= FETCH DATA =================
  Future<void> fetchPeminjaman() async {
    try {
      final response = await supabase
          .from('peminjaman')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        dataPinjam = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch: $e');
    }
  }

  // ================= UPDATE STATUS =================
  Future<void> updateStatus(int id, String statusBaru) async {
    try {
      await supabase
          .from('peminjaman')
          .update({'status': statusBaru}).eq('id_peminjaman', id);

      fetchPeminjaman();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status berhasil diubah menjadi $statusBaru')),
      );
    } catch (e) {
      debugPrint('Error update: $e');
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Persetujuan Peminjaman"),
        backgroundColor: const Color(0xFF90AFC5),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dataPinjam.isEmpty
              ? const Center(child: Text("Tidak ada data peminjaman"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dataPinjam.length,
                  itemBuilder: (context, index) {
                    final item = dataPinjam[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID: ${item['id_peminjaman']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text("User ID: ${item['id_user']}"),
                            Text("Tanggal Pinjam: ${item['tanggal_pinjam']}"),
                            Text("Status: ${item['status']}"),
                            const SizedBox(height: 10),

                            // BUTTON
                            if (item['status'] == 'menunggu')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => updateStatus(
                                        item['id_peminjaman'],
                                        'disetujui'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    child: const Text("Setujui"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => updateStatus(
                                        item['id_peminjaman'],
                                        'ditolak'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text("Tolak"),
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
