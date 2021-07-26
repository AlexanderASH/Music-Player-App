import 'package:flutter/material.dart';
import 'package:music_player_app/src/models/Music.dart';

Widget customListItem({
  Music music,
  onTap
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 80.0,
            width: 80.0,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                music.trackName ?? 'Unknown',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600
                ), 
              ),
              SizedBox(height: 5.0,),
              Text(
                music.authorName ?? 'Unknown',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0
                )
              )
            ],
          )
        ],
      ),
    ),
  );
}