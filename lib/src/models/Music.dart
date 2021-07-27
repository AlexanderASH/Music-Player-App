import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'Music.g.dart';

@HiveType(typeId: 0)
class Music extends HiveObject {
  @HiveField(0)
  final String trackName;
  @HiveField(1)
  final List<dynamic> trackArtistNames;
  @HiveField(2)
  final String albumName;
  @HiveField(3)
  final String albumArtistName;
  @HiveField(4)
  final int trackNumber;
  @HiveField(5)
  final int albumLength;
  @HiveField(6)
  final int year;
  @HiveField(7)
  final String genre;
  @HiveField(8)
  final String authorName;
  @HiveField(9)
  final String writerName;
  @HiveField(10)
  final int discNumber;
  @HiveField(11)
  final String mimeType;
  @HiveField(12)
  final int trackDuration;
  @HiveField(13)
  final int bitrate;
  @HiveField(14)
  final Uint8List albumArt;
  @HiveField(15)
  final String path;


  Music({
    this.trackName,
    this.trackArtistNames,
    this.albumName,
    this.albumArtistName,
    this.trackNumber,
    this.albumLength,
    this.year,
    this.genre,
    this.authorName,
    this.writerName,
    this.discNumber,
    this.mimeType,
    this.trackDuration,
    this.bitrate,
    this.albumArt,
    this.path,
  });
}