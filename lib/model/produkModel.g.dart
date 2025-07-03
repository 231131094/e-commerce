part of 'produkModel.dart';

class ProdukAdapter extends TypeAdapter<Produk> {
  @override
  final int typeId = 1;

  @override
  Produk read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Produk(
      nama: fields[0] as String,
      harga: fields[1] as num,
      deskripsi: fields[2] as String,
      gambar: fields[3] as String,
      namaToko: fields[4] as String,
      kota: fields[5] as String,
      id: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Produk obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.harga)
      ..writeByte(2)
      ..write(obj.deskripsi)
      ..writeByte(3)
      ..write(obj.gambar)
      ..writeByte(4)
      ..write(obj.namaToko)
      ..writeByte(5)
      ..write(obj.kota)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdukAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
