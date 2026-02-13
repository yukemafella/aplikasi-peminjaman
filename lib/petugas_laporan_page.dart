import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PetugasLaporanPage extends StatefulWidget {
  const PetugasLaporanPage({super.key});

  @override
  State<PetugasLaporanPage> createState() => _PetugasLaporanPageState();
}

class _PetugasLaporanPageState extends State<PetugasLaporanPage> {
  List<Map<String, dynamic>> laporan = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    ambilLaporan();
  }

  // ================= AMBIL DATA =================
  Future<void> ambilLaporan() async {
    setState(() => loading = true);

    try {
      final res = await Supabase.instance.client
          .from('peminjaman')
          .select('*, alat(*)') // AMBIL SEMUA KOLOM ALAT (AMAN)
          .order('created_at', ascending: false);

      setState(() {
        laporan = List<Map<String, dynamic>>.from(res);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ambil laporan: $e")),
      );
    }
  }

  // ================= FORMAT TANGGAL =================
  String formatTanggal(dynamic tgl) {
    if (tgl == null) return "-";
    try {
      return DateFormat("dd-MM-yyyy").format(DateTime.parse(tgl.toString()));
    } catch (e) {
      return tgl.toString();
    }
  }

  // ================= CETAK STRUK =================
  Future<void> cetakStruk(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // AMAN walaupun nama kolom beda
    final namaAlat =
        data['alat']?['nama_alat'] ??
        data['alat']?['nama'] ??
        "Alat tidak ditemukan";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        margin: const pw.EdgeInsets.all(16),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "SMK BRAKA PERMESINAN",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "STRUK PEMINJAMAN ALAT",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text("Nama Alat"),
            pw.Text(
              namaAlat,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text("Tanggal Sewa"),
            pw.Text(
              formatTanggal(data['tgl_sewa']),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text("Jumlah"),
            pw.Text(
              "${data['jumlah'] ?? '-'}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text("Peminjam"),
                    pw.SizedBox(height: 40),
                    pw.Text("(____)"),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text("Petugas"),
                    pw.SizedBox(height: 40),
                    pw.Text("(____)"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                "Terima kasih telah meminjam alat",
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ================= WARNA STATUS =================
  Color warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'dipinjam':
        return Colors.orange.shade100;
      case 'dikembalikan':
        return Colors.green.shade100;
      case 'menunggu':
        return Colors.grey.shade200;
      case 'pengembalian':
        return Colors.purple.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Peminjaman")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : laporan.isEmpty
              ? const Center(child: Text("Belum ada data laporan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: laporan.length,
                  itemBuilder: (context, index) {
                    final data = laporan[index];

                    final namaAlat =
                        data['alat']?['nama_alat'] ??
                        data['alat']?['nama'] ??
                        "Alat tidak ditemukan";

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaAlat,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("Tanggal: ${formatTanggal(data['tgl_sewa'])}"),
                            Text("Jumlah: ${data['jumlah'] ?? '-'}"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(data['status'] ?? "-"),
                                  backgroundColor:
                                      warnaStatus(data['status'] ?? ""),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => cetakStruk(data),
                                  icon: const Icon(Icons.print),
                                  label: const Text("Cetak Struk"),
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