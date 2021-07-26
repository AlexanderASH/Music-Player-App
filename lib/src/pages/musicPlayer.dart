import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player_app/main.dart';
import 'package:music_player_app/src/utils/BaDumTss.dart';
import 'package:music_player_app/src/widgets/customListItem.dart';


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

  List music = [];

  void playMusic(String url) async {
    if (this.isPlaying && this.currentSong != this.url) {
      this.audioPlayer.pause();
      int result = await this.audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          this.currentSong = url;
        });
      }
    }
    if (!this.isPlaying) {
      int result = await this.audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          this.isPlaying = true;
          this.btnIcon = Icons.play_arrow;
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

  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    this.audioPlayer.seek(newDuration);
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
            child: ListView.builder(
              itemCount: this.music.length,
              itemBuilder: (context, index) {
                return customListItem(
                  title: music[index]['title'],
                  singer: music[index]['singer'],
                  cover: music[index]['coverUrl'],
                  onTap: () async {
                    setState(() {
                      this.currentTitle = this.music[index]['title'];
                      this.currentSinger = this.music[index]['singer'];
                      this.currentCover = this.music[index]['coverUrl'];
                      this.url = this.music[index]['url'];
                    });
                    playMusic(this.url);
                    this.box.put('playedOnce', 'true');
                    this.box.put('currentCover', this.currentCover);
                    this.box.put('currentSinger', this.currentSinger);
                    this.box.put('currentTitle', this.currentTitle);
                    this.box.put('url', this.url);
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
                  min: 0,
                  max: this.position.inSeconds.toDouble(),
                  onChanged: (value) {
                    seekToSecond(value.toInt());
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        this.position.inSeconds.toDouble().toString(),
                      ),
                      Text(
                        this.duration.inSeconds.toDouble().toString(),
                      ),
                    ],
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                          image: NetworkImage(this.currentCover)
                        )
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.currentTitle,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Text(
                            this.currentSinger,
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
                        if (this.box.get('playedOnce') == 'true' && this.isPlaying == false) {
                          this.playMusic(this.url);
                        }

                        if (this.isPlaying) {
                          this.audioPlayer.pause();
                          setState(() {
                            this.btnIcon = Icons.pause;
                            this.isPlaying = false;
                          });
                        } else {
                          this.audioPlayer.resume();
                          setState(() {
                            this.btnIcon = Icons.play_arrow;
                            this.isPlaying = true;
                          });
                        }
                      }, 
                      icon: Icon(this.btnIcon, size: 42.0,),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}