import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vortex/enums/volume_state.dart';

class MusicPlayer extends StatefulWidget {
  final String song;
  final AudioPlayer audioPlayer;

  const MusicPlayer({
    super.key,
    required this.song,
    required this.audioPlayer
  });

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer _audioPlayer;
  final double _initVolume = 0.0;
  VolumeState volumeState = VolumeState.mute;
  StreamSubscription<double>? _volumeSubscription;
  Duration _position = Duration.zero;
  bool _isUserDraggingSeekBar = false;


  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAndPlayAudio();
    _audioPlayer.playingStream.listen((isPlaying) {
      setState(() {});
    });
    _volumeSubscription = _audioPlayer.volumeStream.listen((volume) {
      _checkForVolumeStateUpdate(volume);
    });
  }

  Future<void> _loadAndPlayAudio() async {
    try {
      _audioPlayer = widget.audioPlayer;

      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.setVolume(_initVolume);
      await _audioPlayer.play();
    } catch (e) {
      // print('Error: Audio player not found for song ${widget.song}');
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
    _volumeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pausePlayButton(),
            _seekBar(),
            _volumeControl(),
          ],
        ),
      )
    );
  }

  Widget _pausePlayButton () =>
    IconButton(
      icon: Icon(_audioPlayer.playing ? Icons.pause : Icons.play_arrow),
      iconSize: 48,
      onPressed: () {
        setState(() {
          _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
        });
      },
    );
  
  Widget _seekBar () =>
    StreamBuilder<Duration?>(
      stream: _audioPlayer.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration?>(
          stream: _audioPlayer.positionStream,
          builder: (context, snapshot) {
            if (!_isUserDraggingSeekBar) {
              _position = snapshot.data ?? Duration.zero;
            }
            if (_position > duration) {
              _position = duration;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    onChanged: (newValue) {
                      setState(() {
                        _isUserDraggingSeekBar = true;
                        _position = Duration(milliseconds: newValue.toInt());
                      });
                    },
                    onChangeEnd: (newValue) {
                      _isUserDraggingSeekBar = false;
                      _audioPlayer.seek(Duration(milliseconds: newValue.toInt()));
                    },
                    value: _position.inMilliseconds.toDouble(),
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        );
      },
    );

  Widget _volumeControl () {
    IconData volumeIcon;
    switch (volumeState) {
      case VolumeState.loud:
        volumeIcon = Icons.volume_up;
        break;
      case VolumeState.medium:
        volumeIcon = Icons.volume_down;
        break;
      case VolumeState.low:
        volumeIcon = Icons.volume_mute;
        break;
      case VolumeState.mute:
        volumeIcon = Icons.volume_off;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          volumeIcon,
          size: 24,
        ),
        const SizedBox(width: 8),
        StreamBuilder<double>(
          stream: _audioPlayer.volumeStream,
          builder: (context, snapshot) {
            final volume = snapshot.data ?? _initVolume;
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
    );
  }

  // Checks to see if the volume icon needs to be updated
  void _checkForVolumeStateUpdate(double volume) {
    VolumeState newState = volumeState;
    bool hasChanged = false;
    switch (volumeState) {
      case VolumeState.loud:
        if (volume < 0.6) {
          newState = _doubleToVolumeState(volume);
          hasChanged = true;
        }
        break;
      case VolumeState.medium:
        if (volume <= 0.3 || volume > 0.6) {
          newState = _doubleToVolumeState(volume);
          hasChanged = true;
        }
        break;
      case VolumeState.low:
        if (volume <= 0 || volume > 0.3) {
          newState = _doubleToVolumeState(volume);
          hasChanged = true;
        }
        break;
      case VolumeState.mute:
        if (volume > 0) {
          newState = _doubleToVolumeState(volume);
          hasChanged = true;
        }
        break;
    }
    if (hasChanged) {
      setState(() {
        volumeState = newState;
      });
    }
  }

  VolumeState _doubleToVolumeState (double volume) {
    if (volume <= 0) {
      return VolumeState.mute;
    } else if (volume > 0 && volume <= 0.3) {
      return VolumeState.low;
    } else if (volume > 0.3 && volume <= 0.6) {
      return VolumeState.medium;
    } else {
      return VolumeState.loud;
    }
  }
}
