import 'package:hive/hive.dart';
part 'produkModel.g.dart';

@HiveType(typeId: 1)
class Produk {
  @HiveField(0)
  final String nama;
  
  @HiveField(1)
  final num harga;
  
  @HiveField(2)
  final String deskripsi;
  
  @HiveField(3)
  final String gambar;
  
  @HiveField(4)
  final String namaToko;
  
  @HiveField(5)
  final String kota;
  
  @HiveField(6)
  final String id;

  Produk({
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
    required this.namaToko,
    required this.kota,
    required this.id,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      nama: json['nama'],
      harga: json['harga'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
      namaToko: json['namaToko'],
      kota: json['kota'],
      id: json['id'],
    );
  }
}