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
    return TafsirSourceModel(
      id: fields[0] as int,
      name: fields[1] as String,
      author: fields[2] as String,
      language: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TafsirSourceModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.language);
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
