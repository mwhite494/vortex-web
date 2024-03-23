import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:vortex/pages/index.dart' show MusicAnalyzerPage, SongSelectionPage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> songs = [
    'droeloe_panorama.mp3',
    'droeloe_sunburn.mp3',
    'DROELOE_Statues.wav',
    'MELVV_Blank.wav'
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
              return SongSelectionPage(
                songs: songs,
                onSelect: (song) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicAnalyzerPage(
                      song: song,
                      preloadedPlayers: snapshot.data!,
                    ),
                  ),
                ),
              );
            });
          } else {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              )
            );
          }
        },
      ),
    );
  }

  // Function to preload audio files
  Future<List<AudioPlayer>> _preloadSongs(List<String> songs) async {
    List<AudioPlayer> preloadedPlayers = [];
    for (String song in songs) {
      AudioPlayer player = AudioPlayer();
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///songs/$song'),
          tag: {'id': 'songs/$song'},
        ),
      );
      preloadedPlayers.add(player);
    }
    return preloadedPlayers;
  }

  // Function to preload visualization data
  Future<List<Map<String, double>>> readJsonBandData(String filePath) async {
    final String jsonString = await rootBundle.loadString(filePath);
    final List<dynamic> jsonResponse = json.decode(jsonString);
    // Convert dynamic to your band data type
    return jsonResponse.map((e) => Map<String, double>.from(e)).toList();
  }

}
