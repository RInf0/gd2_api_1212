import 'dart:convert';

class Barang {
  int id;
  String nama;
  String deskripsi;
  int stok;

  Barang(
      {required this.id,
      required this.nama,
      required this.deskripsi,
      required this.stok});

  // untuk membuat objek barang dari data json yang diterima dari API
  factory Barang.fromRawJson(String str) => Barang.fromJson(json.decode(str));
  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"],
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        stok: json["stok"],
      );

  // untuk membuat data json dari objek barang yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "deskripsi": deskripsi,
        "stok": stok,
      };
}
