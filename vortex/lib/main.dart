import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'song_selection.dart';
import 'music_player.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> songs = [
    'droeloe_panorama.mp3',
    'droeloe_sunburn.mp3',
    // Add more song file names here
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<AudioPlayer>>(
        future: _preloadSongs(songs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Builder(builder: (context) {
              return SongSelection(
                songs: songs,
                onSelect: (song) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicPlayer(
                      song: song,
                      preloadedPlayers: snapshot.data!,
                    ),
                  ),
                ),
              );
            });
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<List<AudioPlayer>> _preloadSongs(List<String> songs) async {
    List<AudioPlayer> preloadedPlayers = [];
    for (String song in songs) {
      AudioPlayer player = AudioPlayer();
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse('songs/$song'),
          tag: {'id': 'songs/$song'},
        ),
      );
      preloadedPlayers.add(player);
    }
    return preloadedPlayers;
  }
}
