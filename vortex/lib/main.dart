import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vortex/models/song.dart';

import 'package:vortex/pages/index.dart' show MusicAnalyzerPage, SongSelectionPage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Song> songs = [
    Song(title: "Panorama", artist: "DROELOE", audioFilename: "droeloe_panorama.mp3", visualizationDataFilename: "droeloe_panorama_data_lufs_standardization.json"),
    Song(title: "Sunburn", artist: "DROELOE", audioFilename: "droeloe_sunburn.mp3", visualizationDataFilename: "droeloe_sunburn_data_lufs_standardization.json"),
    Song(title: "Statues", artist: "DROELOE", audioFilename: "DROELOE_Statues.wav", visualizationDataFilename: "DROELOE_Statues_data_lufs_standardization.json"),
    Song(title: "Blank", artist: "MELVV", audioFilename: "MELVV_Blank.wav", visualizationDataFilename: "MELVV_Blank_data_lufs_standardization.json"),
    // Add more songs here
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
  Future<List<AudioPlayer>> _preloadSongs(List<Song> songs) async {
    List<AudioPlayer> preloadedPlayers = [];
    for (Song song in songs) {
      AudioPlayer player = AudioPlayer();
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///songs/${song.audioFilename}'),
          tag: {'id': 'songs/${song.audioFilename}'},
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
