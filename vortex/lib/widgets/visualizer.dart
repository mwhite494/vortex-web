import 'dart:async';

import 'package:flutter/material.dart';

class MusicVisualizer extends StatefulWidget {
  final Map<String, dynamic> visualizationJson;

  const MusicVisualizer({
    super.key,
    required this.visualizationJson,
  });

  @override
  MusicVisualizerState createState() => MusicVisualizerState();
}

class MusicVisualizerState extends State<MusicVisualizer> {
  final Map<double, double> _bandValues = {
      63: 0.0,
      160: 0.0,
      400: 0.0,
      1000: 0.0,
      2500: 0.0,
      6250: 0.0,
  };
  StreamSubscription<List<double>>? _visualizationStream;

  @override
  void initState() {
    super.initState();
    List<dynamic> visualizationData = widget.visualizationJson['visualization_data'];
    
    print('Init visualizer');
    _visualizationStream = getVisualizationDataStream(visualizationData).listen((data) {
      setState(() {
        print('Setting band values: $data');
        _bandValues[63] = data[0] / 100;
        _bandValues[160] = data[1] / 100;
        _bandValues[400] = data[2] / 100;
        _bandValues[1000] = data[3] / 100;
        _bandValues[2500] = data[4] / 100;
        _bandValues[6250] = data[5] / 100;
      });
    });
  }

  @override
  void dispose() {
    _visualizationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: _buildEqualizerBars(),
      ),
    );
  }

  List<Widget> _buildEqualizerBars() {
    // Sample static values for demonstration purposes
    Map<double, Color> bandColors = {
      63: Colors.red,
      160: Colors.orange,
      400: Colors.yellow,
      1000: Colors.green,
      2500: Colors.blue,
      6250: Colors.purple,
    };

    List<Widget> bars = [];
    for (var band in bandColors.keys) {
      bars.add(_buildBar(_bandValues[band]!, bandColors[band]!));
    }

    // Since you want a mirrored visualization
    bars.addAll(bars.reversed.toList());

    return bars;
  }

  Widget _buildBar(double value, Color color) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 50,
        height: 300 * value,
        color: color,
      ),
    );
  }

  Stream<List<double>> getVisualizationDataStream(List<dynamic> data) async* {
    for (var d in data) {
      List<double> bands = List<double>.from(d as List);
      await Future.delayed(const Duration(microseconds: 11609));
      yield bands;
    }
  }

}
