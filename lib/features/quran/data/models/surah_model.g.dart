// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahModelAdapter extends TypeAdapter<SurahModel> {
  @override
  final int typeId = 0;

  @override
  SurahModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahModel(
      id: fields[0] as int,
      nameAr: fields[1] as String,
      nameEn: fields[2] as String,
      revelationType: fields[3] as String,
      totalVerses: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SurahModel obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.nameAr);
    writer.writeByte(2);
    writer.write(obj.nameEn);
    writer.writeByte(3);
    writer.write(obj.revelationType);
    writer.writeByte(4);
    writer.write(obj.totalVerses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
