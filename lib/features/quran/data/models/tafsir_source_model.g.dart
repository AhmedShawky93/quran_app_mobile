// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_source_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TafsirSourceModelAdapter extends TypeAdapter<TafsirSourceModel> {
  @override
  final int typeId = 1;

  @override
  TafsirSourceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TafsirSourceModel();
  }

  @override
  void write(BinaryWriter writer, TafsirSourceModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TafsirSourceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
