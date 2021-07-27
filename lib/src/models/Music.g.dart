// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Music.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicAdapter extends TypeAdapter<Music> {
  @override
  final int typeId = 0;

  @override
  Music read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Music(
      trackName: fields[0] as String,
      trackArtistNames: (fields[1] as List)?.cast<dynamic>(),
      albumName: fields[2] as String,
      albumArtistName: fields[3] as String,
      trackNumber: fields[4] as int,
      albumLength: fields[5] as int,
      year: fields[6] as int,
      genre: fields[7] as String,
      authorName: fields[8] as String,
      writerName: fields[9] as String,
      discNumber: fields[10] as int,
      mimeType: fields[11] as String,
      trackDuration: fields[12] as int,
      bitrate: fields[13] as int,
      albumArt: fields[14] as Uint8List,
      path: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Music obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.trackName)
      ..writeByte(1)
      ..write(obj.trackArtistNames)
      ..writeByte(2)
      ..write(obj.albumName)
      ..writeByte(3)
      ..write(obj.albumArtistName)
      ..writeByte(4)
      ..write(obj.trackNumber)
      ..writeByte(5)
      ..write(obj.albumLength)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.genre)
      ..writeByte(8)
      ..write(obj.authorName)
      ..writeByte(9)
      ..write(obj.writerName)
      ..writeByte(10)
      ..write(obj.discNumber)
      ..writeByte(11)
      ..write(obj.mimeType)
      ..writeByte(12)
      ..write(obj.trackDuration)
      ..writeByte(13)
      ..write(obj.bitrate)
      ..writeByte(14)
      ..write(obj.albumArt)
      ..writeByte(15)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
