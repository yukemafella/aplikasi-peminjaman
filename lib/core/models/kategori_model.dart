class KategoriModel {
  final int? idKategori;
  final String namaKategori;

  KategoriModel({
    this.idKategori,
    required this.namaKategori,
  });

  // Mengubah data dari Map Supabase (JSON) ke Object Dart
  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'] ?? '',
    );
  }

  // Mengubah Object Dart ke Map untuk kebutuhan Insert/Update ke Supabase
  Map<String, dynamic> toJson() {
    return {
      if (idKategori != null) 'id_kategori': idKategori,
      'nama_kategori': namaKategori,
    };
  }
}