import 'package:flutter/material.dart';
import 'song_selection.dart';
import 'music_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (context) {
        return SongSelection(
          songs: [
            'droeloe_panorama.wav',
            'droeloe_sunburn.wav',
            // Add more song file names here
          ],
          onSelect: (song) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicPlayer(song: song),
            ),
          ),
        );
      }),
    );
  }
}
