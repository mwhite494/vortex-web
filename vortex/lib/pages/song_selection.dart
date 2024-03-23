import 'package:flutter/material.dart';
import 'package:vortex/models/song.dart';

class SongSelectionPage extends StatelessWidget {
  final List<Song> songs;
  final Function(Song) onSelect;

  const SongSelectionPage({super.key, required this.songs, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Song')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          Song song = songs[index];
          return ListTile(
            title: Text(song.header),
            onTap: () => onSelect(songs[index]),
          );
        },
      ),
    );
  }
}
