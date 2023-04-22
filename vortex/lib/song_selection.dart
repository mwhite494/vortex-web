import 'package:flutter/material.dart';

class SongSelection extends StatelessWidget {
  final List<String> songs;
  final Function(String) onSelect;

  SongSelection({required this.songs, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Song')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songs[index]),
            onTap: () => onSelect(songs[index]),
          );
        },
      ),
    );
  }
}
