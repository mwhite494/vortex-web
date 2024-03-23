class Song {
  final String title;
  final String artist;
  final String audioFilename;
  final String visualizationDataFilename;

  Song({
    required this.title,
    required this.artist,
    required this.audioFilename,
    required this.visualizationDataFilename,
  });

  get header => '$artist - $title';

}
