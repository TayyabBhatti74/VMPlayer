// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteSongAdapter extends TypeAdapter<FavoriteSong> {
  @override
  final int typeId = 2;

  @override
  FavoriteSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteSong(
      songName: fields[0] as String,
      songDescription: fields[1] as String,
      isFavorite: fields[2] as bool,
      audioPath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteSong obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.songName)
      ..writeByte(1)
      ..write(obj.songDescription)
      ..writeByte(2)
      ..write(obj.isFavorite)
      ..writeByte(3)
      ..write(obj.audioPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
