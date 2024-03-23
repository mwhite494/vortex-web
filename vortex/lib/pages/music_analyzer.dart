import 'package:flutter/material.dart';
import 'package:vortex/models/song.dart';
import 'package:vortex/models/visualization_player.dart';
import 'package:vortex/widgets/index.dart';
import 'package:vortex/widgets/visualizer.dart';

class MusicAnalyzerPage extends StatelessWidget {
  final Song song;
  final VisualizationPlayer player;
  final double musicPlayerHeight = 200;
  final double controlPanelWidth = 250;

  const MusicAnalyzerPage({super.key, required this.song, required this.player});

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    double visualizerContentHeight = windowSize.height - (musicPlayerHeight + 128);
    double visualizerContentWidth = windowSize.width - (controlPanelWidth + 72);
    return Scaffold(
      appBar: AppBar(title: Text(song.header)),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.all(24),
                width: visualizerContentWidth,
                height: visualizerContentHeight,
                child: MusicVisualizer(visualizationData: player.visualizationData,),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                width: controlPanelWidth,
                height: visualizerContentHeight,
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            height: musicPlayerHeight,
            width: windowSize.width,
            child: MusicPlayer(song: song.audioFilename, audioPlayer: player.audioPlayer,),
          )
        ],
      ),
    );
  }
}
