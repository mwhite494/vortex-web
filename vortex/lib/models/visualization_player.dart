import 'package:just_audio/just_audio.dart';

class VisualizationPlayer {
  final String id;
  final AudioPlayer audioPlayer;
  final Map<String, dynamic> visualizationData;

  VisualizationPlayer({
    required this.id,
    required this.audioPlayer,
    required this.visualizationData,
  });

}