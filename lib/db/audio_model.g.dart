// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioModelAdapter extends TypeAdapter<AudioModel> {
  @override
  final int typeId = 1;

  @override
  AudioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioModel(
      songName: fields[0] as String,
      songDescription: fields[2] as String,
      isFavorite: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AudioModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.songName)
      ..writeByte(2)
      ..write(obj.songDescription)
      ..writeByte(3)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
