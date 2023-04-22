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
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAndPlayAudio();
  }

  Future<void> _loadAndPlayAudio() async {
    try {
      _audioPlayer = widget.preloadedPlayers.firstWhere(
        (player) => player.sequence != null && player.sequence!.first.tag['id'] == 'songs/${widget.song}',
      );

      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
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
    _audioPlayer.dispose();
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
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 48,
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                  _isPlaying ? _audioPlayer.play() : _audioPlayer.pause();
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
