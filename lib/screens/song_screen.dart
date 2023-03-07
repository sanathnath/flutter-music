import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/song_model.dart';
import '../widgets/seekbar.dart';

class ScreenSong extends StatefulWidget {
  const ScreenSong({Key? key}) : super(key: key);

  @override
  State<ScreenSong> createState() => _ScreenSongState();
}

class _ScreenSongState extends State<ScreenSong> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Song.songs[0];

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          Uri.parse('asset:///${song.url}'),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream,
          (Duration position, Duration? duration) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          _MusicPlayer(
              seekBarDataStream: _seekBarDataStream, audioPlayer: audioPlayer)
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          PlayerButtons(audioPlayer: audioPlayer)
        ],
      ),
    );
  }
}

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final playerState = snapshot.data;
                final processingState =
                    (playerState! as PlayerState).processingState;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(),
                  );
                } else if (!audioPlayer.playing) {
                  return IconButton(
                      onPressed: audioPlayer.play,
                      iconSize: 75,
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.white,
                      ));
                }else if(processingState != ProcessingState.completed){
                    return IconButton(
                      onPressed: audioPlayer.pause,
                      iconSize: 75,
                      icon: const Icon(
                        Icons.pause_circle,
                        color: Colors.white,
                      ));
                }else{
                    return IconButton(
                        onPressed: () => audioPlayer.seek(
                          Duration.zero, 
                          index: audioPlayer.effectiveIndices!.first),
                        iconSize: 75,
                        icon: const Icon(
                          Icons.replay_circle_filled_outlined,
                          color: Colors.white,
                        ));
                }
              }else{
                return const CircularProgressIndicator();
              }
            })
      ],
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ])),
      ),
    );
  }
}
