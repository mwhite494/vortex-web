import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vortex/models/song.dart';
import 'package:vortex/models/visualization_player.dart';

import 'package:vortex/pages/index.dart' show MusicAnalyzerPage, SongSelectionPage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Song> songs = [
    // Song(title: "Panorama", artist: "DROELOE", audioFilename: "droeloe_panorama.mp3", visualizationDataFilename: "droeloe_panorama_data_lufs_standardization.json"),
    // Song(title: "Statues", artist: "DROELOE", audioFilename: "DROELOE_Statues.wav", visualizationDataFilename: "DROELOE_Statues_data_lufs_standardization.json"),
    // Song(title: "Sunburn", artist: "DROELOE", audioFilename: "droeloe_sunburn.mp3", visualizationDataFilename: "droeloe_sunburn_data_lufs_standardization.json"),
    Song(title: "Runaway", artist: "Kanye West", audioFilename: "Kanye_West_Runaway.wav", visualizationDataFilename: "Kanye_West_Runaway_data_lufs_standardization.json"),
    // Song(title: "Blank", artist: "MELVV", audioFilename: "MELVV_Blank.wav", visualizationDataFilename: "MELVV_Blank_data_lufs_standardization.json"),
    // Add more songs here
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<VisualizationPlayer>>(
        future: _preloadSongs(songs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<VisualizationPlayer> preloadedPlayers = snapshot.data!;
            return Builder(builder: (context) {
              return SongSelectionPage(
                songs: songs,
                onSelect: (song) {
                  VisualizationPlayer player = preloadedPlayers.firstWhere((element) => element.id == song.header);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicAnalyzerPage(
                        song: song,
                        player: player,
                      ),
                    ),
                  );
                }
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
  Future<List<VisualizationPlayer>> _preloadSongs(List<Song> songs) async {
    // Initialize array to hold each visualization player (containing audio player and visualization data json)
    List<VisualizationPlayer> preloadedPlayers = [];
    
    // Iterate over each song
    for (Song song in songs) {
      
      // Load the audio player
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///songs/${song.audioFilename}'),
        ),
      );
      
      // Load the visualization data json
      final String visualizationJsonRaw = await rootBundle.loadString('assets/visualizer_data/${song.visualizationDataFilename}');
      final Map<String, dynamic> visualizationJson = json.decode(visualizationJsonRaw);

      // Package the audio player and visualization data into a VisualizationPlayer object and add it to preloadedPlayers
      VisualizationPlayer visualizationPlayer = VisualizationPlayer(id: song.header, audioPlayer: audioPlayer, visualizationJson: visualizationJson);
      preloadedPlayers.add(visualizationPlayer);
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
