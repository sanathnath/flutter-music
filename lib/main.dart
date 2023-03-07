import 'package:fltr_music/screens/home_screen.dart';
import 'package:fltr_music/screens/playlist_screen.dart';
import 'package:fltr_music/screens/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const ScreenSong(),
      getPages: [
        GetPage(name: '/', page: () => const ScreenHome()),
        GetPage(name: '/song', page: () => const ScreenSong()),
        GetPage(name: '/playlist', page: () => const ScreenPlaylist()),
      ],
    );
  }
}
