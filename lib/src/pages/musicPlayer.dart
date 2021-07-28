import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player_app/main.dart';
import 'package:music_player_app/src/models/Music.dart';
import 'package:music_player_app/src/utils/BaDumTss.dart';
import 'package:music_player_app/src/utils/constants.dart';
import 'package:music_player_app/src/utils/localdata.dart';
import 'package:music_player_app/src/utils/time.dart';
import 'package:music_player_app/src/widgets/customListItem.dart';


class MusicPlayerScreen extends StatefulWidget {

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with WidgetsBindingObserver {
  Duration duration;
  Duration position;
  bool isPlaying = false;
  bool isLoading = true;
  IconData btnIcon = Icons.play_arrow;

  BaDumTss instance;
  AudioPlayer audioPlayer;

  LocalData localData;
  Music music;
  List<Music> songs;

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this.localData = getIt<LocalData>();
    this.instance = getIt<BaDumTss>();
    this.audioPlayer = this.instance.audio;
    this.duration = new Duration();
    this.position = new Duration();
    this.music = new Music();
    this.songs = [];

    if (this.localData.getValue('playedOnce') == "true") {
      this.music = this.localData.getValue('music');
    }
    
    this._loadLocalData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      this.audioPlayer.pause();
      setState(() {
        this.btnIcon = Icons.play_arrow;
      });
    }

    if (state == AppLifecycleState.resumed) {
      if (this.isPlaying) {
        audioPlayer.resume();
        setState(() {
          btnIcon = Icons.pause;
        });
      }
    }

    if (state == AppLifecycleState.detached) {
      this.audioPlayer.stop();
      this.audioPlayer.release();
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.localData.close();
    WidgetsBinding.instance.removeObserver(this);
  }

  void playMusic(String path) async {
    this.position = Duration(seconds: 0);
    if (this.isPlaying && this.music.path != path) {
      this.audioPlayer.pause();
      int result = await this.audioPlayer.play(path);
      if (result == 1) {
        setState(() {
          this.btnIcon = Icons.pause;
        });
      }
    }

    if (!this.isPlaying) {
      int result = await this.audioPlayer.play(path);
      if (result == 1) {
        setState(() {
          this.isPlaying = true;
          this.btnIcon = Icons.pause;
        });
      }
    }
    
    this.audioPlayer.onDurationChanged.listen((event) { 
      setState(() {
        this.duration = event;
      });
    });

    this.audioPlayer.onAudioPositionChanged.listen((event) {
        setState(() {
          this.position = event;
        });
    });

    this.audioPlayer.onPlayerCompletion.listen((event) { 
      setState(() {
        this.btnIcon = Icons.play_arrow;
      });
    });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    this.audioPlayer.seek(newDuration);
  }

  Future<void> _loadLocalData() async {
    final files = Directory(PATH).listSync().where((file) => file.path.endsWith('.mp3')).toList();
    await Future.forEach<FileSystemEntity>(files, (file) async {
      MetadataRetriever retriever = MetadataRetriever();
      await retriever.setFile(File(file.path));
      Metadata metadata = await retriever.metadata;
      this.songs.add(Music(
        albumArt: retriever.albumArt,
        albumArtistName: metadata.albumArtistName,
        albumLength: metadata.albumLength,
        albumName: metadata.albumName,
        authorName: metadata.authorName,
        bitrate: metadata.bitrate,
        discNumber: metadata.discNumber,
        genre: metadata.genre,
        mimeType: metadata.mimeType,
        trackArtistNames: metadata.trackArtistNames,
        trackDuration: metadata.trackDuration,
        trackName: metadata.trackName,
        trackNumber: metadata.trackNumber,
        writerName: metadata.writerName,
        year: metadata.year,
        path: file.path
      ));
    });

    setState(() {
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: this.isLoading
            ? Center(child: CircularProgressIndicator(),)
            : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: this.songs.length,
                itemBuilder: (context, index) {
                  return customListItem(
                    music: this.songs[index],
                    onTap: () {
                      this.playMusic(this.songs[index].path);
                      this.music = this.songs[index];
                      this.localData.addValue('playedOnce', "true");
                      this.localData.addValue('music', this.music);
                    }
                  );
                }
              )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x55212121),
                  blurRadius: 8.0
                ),
              ],
            ),
            child: Column(
              children: [
                Slider.adaptive(
                  value: this.position.inSeconds.toDouble(),
                  min: 0.0,
                  max: this.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    seekToSecond(value.toInt());
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Time.getDuration(this.position)),
                      Text(Time.getDuration(this.duration)),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: music.albumArt == null
                            ? AssetImage('assets/no_logo.jpg')
                            : MemoryImage(music.albumArt)
                          )
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              this.music.trackName ?? "Choose a song to play",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Text(
                              this.music.authorName ?? "Unknown",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0
                              ),
                            )
                          ],
                        )
                      ),
                      IconButton(
                        onPressed: () {
                          if (this.localData.getValue('playedOnce') == 'true' && this.isPlaying == false) {
                            this.playMusic(this.music.path);
                          }

                          if (this.isPlaying) {
                            this.audioPlayer.pause();
                            setState(() {
                              this.btnIcon = Icons.play_arrow;
                              this.isPlaying = false;
                            });
                          } else {
                            this.audioPlayer.resume();
                            setState(() {
                              this.btnIcon = Icons.pause;
                              this.isPlaying = true;
                            });
                          }
                        }, 
                        icon: Icon(this.btnIcon, size: 42.0,),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}