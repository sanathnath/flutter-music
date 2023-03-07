class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song(
      {required this.title,
      required this.description,
      required this.url,
      required this.coverUrl});

  static List<Song> songs = [
    Song(
        title: 'vinee heights',
        description: 'vinee heights',
        url: 'assets/music/vinee-heights-126947.mp3',
        coverUrl: 'assets/images/image1.jpg'),
    Song(
        title: 'speed',
        description: 'speed',
        url: 'assets/music/speed-122837.mp3',
        coverUrl: 'assets/images/image2.jpg'),
    Song(
        title: 'downfall',
        description: 'downfall',
        url: 'assets/music/downfall-21371.mp3',
        coverUrl: 'assets/images/image3.jpg'),
  ];
}
