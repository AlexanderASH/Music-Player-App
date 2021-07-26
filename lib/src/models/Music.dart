import 'package:meta/meta.dart';
import 'dart:typed_data';

class Music {
  final String trackName;
  final List<dynamic> trackArtistNames;
  final String albumName;
  final String albumArtistName;
  final int trackNumber;
  final int albumLength;
  final int year;
  final String genre;
  final String authorName;
  final String writerName;
  final int discNumber;
  final String mimeType;
  final int trackDuration;
  final int bitrate;
  final Uint8List albumArt;

  Music({
    @required this.trackName,
    @required this.trackArtistNames,
    @required this.albumName,
    @required this.albumArtistName,
    @required this.trackNumber,
    @required this.albumLength,
    @required this.year,
    @required this.genre,
    @required this.authorName,
    @required this.writerName,
    @required this.discNumber,
    @required this.mimeType,
    @required this.trackDuration,
    @required this.bitrate,
    @required this.albumArt
  });
}