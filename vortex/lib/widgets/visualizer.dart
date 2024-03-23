import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  const MusicVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _buildEqualizerBars(),
      ),
    );
  }

  List<Widget> _buildEqualizerBars() {
    // Sample static values for demonstration purposes
    Map<double, Color> bandColors = {
      6250: Colors.purple,
      2500: Colors.blue,
      1000: Colors.green,
      400: Colors.yellow,
      160: Colors.orange,
      63: Colors.red,
    };

    Map<double, double> bandValues = {
      6250: 0.9,  // 90% of max height
      2500: 0.75,  // 75% of max height
      1000: 0.6,  // 60% of max height
      400: 0.45,  // 45% of max height
      160: 0.3,  // 30% of max height
      63: 0.15,  // 15% of max height
    };

    List<Widget> bars = [];
    for (var band in bandColors.keys) {
      bars.add(_buildBar(bandValues[band]!, bandColors[band]!));
    }

    // Since you want a mirrored visualization
    bars.addAll(bars.reversed.toList());

    return bars;
  }

  Widget _buildBar(double value, Color color) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 50,  // set your desired width
        height: 300 * value,  // assuming 200 is max height
        color: color,
      ),
    );
  }
}
