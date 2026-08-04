// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadingProgressModelAdapter extends TypeAdapter<ReadingProgressModel> {
  @override
  final int typeId = 3;

  @override
  ReadingProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadingProgressModel(
      userId: fields[0] as String,
      lastSurahId: fields[1] as int,
      lastVerseId: fields[2] as int,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReadingProgressModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.lastSurahId)
      ..writeByte(2)
      ..write(obj.lastVerseId)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
