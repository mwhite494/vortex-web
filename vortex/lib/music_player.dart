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

      await _audioPlayer.seek(Duration.zero);
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
            StreamBuilder<Duration?>(
              stream: _audioPlayer.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    var position = snapshot.data ?? Duration.zero;
                    if (position > duration) {
                      position = duration;
                    }
                    return Slider(
                      onChanged: (newValue) {
                        _audioPlayer.seek(Duration(milliseconds: newValue.toInt()));
                      },
                      value: position.inMilliseconds.toDouble(),
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                    );
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Volume'),
                SizedBox(width: 8),
                StreamBuilder<double>(
                  stream: _audioPlayer.volumeStream,
                  builder: (context, snapshot) {
                    final volume = snapshot.data ?? 1.0;
                    return Slider(
                      onChanged: (newValue) {
                        _audioPlayer.setVolume(newValue);
                      },
                      value: volume,
                      min: 0.0,
                      max: 1.0,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(widget.song),
          ],
        ),
      ),
    );
  }
}
