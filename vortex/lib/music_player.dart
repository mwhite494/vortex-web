import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  final String song;
  final List<AudioPlayer> preloadedPlayers;

  MusicPlayer({required this.song, required this.preloadedPlayers});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAndPlayAudio();
    _audioPlayer.playingStream.listen((isPlaying) {
      setState(() {});
    });
  }

  Future<void> _loadAndPlayAudio() async {
    try {
      _audioPlayer = widget.preloadedPlayers.firstWhere(
        (player) => player.sequence != null && player.sequence!.first.tag['id'] == 'songs/${widget.song}',
      );

      await _audioPlayer.play();
    } catch (e) {
      print('Error: Audio player not found for song ${widget.song}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Could not load song ${widget.song}'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.pause();
    // Do not dispose of the audio player here, as we want to keep the preloaded players active.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.song)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_audioPlayer.playing ? Icons.pause : Icons.play_arrow),
              iconSize: 48,
              onPressed: () {
                setState(() {
                  _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
                });
              },
            ),
            SizedBox(height: 16),
            Text(widget.song),
          ],
        ),
      ),
    );
  }
}
