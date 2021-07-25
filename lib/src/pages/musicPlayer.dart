import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/main.dart';


class MusicPlayerScreen extends StatefulWidget {

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with WidgetsBindingObserver {
  Duration duration;
  Duration position;
  bool isPlaying = false;
  IconData btnIcon = Icons.play_arrow;

  BaDumTss instance;
  AudioPlayer audioPlayer;

  Box box;

  String currentSong = "";
  String currentCover = "";
  String currentTitle = "";
  String currentSinger = "";
  String url = "";

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this.box = Hive.box<String>('myBox');
    this.instance = getIt<BaDumTss>();
    this.audioPlayer = this.instance.audio;
    this.duration = new Duration();
    this.position = new Duration();

    if (this.box.get('playedOnce') == "false") {
      setState(() {
        this.currentCover = "";
        this.currentTitle = "Choose a song to play";
      });
    }

    if (this.box.get('playedOnce') == "true") {
      this.currentCover = this.box.get('currentCover');
      this.currentSinger = this.box.get('currentSinger');
      this.currentTitle = this.box.get('currentTitle');
      this.url = this.box.get('url');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      this.audioPlayer.pause();
      setState(() {
        this.btnIcon = Icons.pause;
      });
    }

    if (state == AppLifecycleState.resumed) {
      if (this.isPlaying) {
        audioPlayer.resume();
        setState(() {
          btnIcon = Icons.play_arrow;
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
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}