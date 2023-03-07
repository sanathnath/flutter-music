import 'package:fltr_music/models/song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String imageUrl;

  Playlist({required this.title, required this.songs, required this.imageUrl});

  static List<Playlist> playlists = [
    Playlist(
      title: 'hip-hop', 
      songs: Song.songs, 
      imageUrl: "assets/images/image3.jpg"
      ),
      Playlist(
      title: 'Rock&roll', 
      songs: Song.songs, 
      imageUrl: "assets/images/image2.jpg"
      ),
      Playlist(
      title: 'Techno', 
      songs: Song.songs, 
      imageUrl: "assets/images/image1.jpg"
      ),
  ];
}
