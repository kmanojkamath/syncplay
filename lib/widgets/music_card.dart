import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicCardsList extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: List.generate(1, (i) => _MusicCard()));
  }
}

class _MusicCard extends StatefulWidget {
  const new();

  @override
  State<_MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<_MusicCard> {
  late AudioPlayer player;
  Duration? totalDuration;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('audios/Tere Paas Main.mp3'));

      totalDuration = await player.getDuration();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(children: [_PausePlayButton(player: player), Text("Tere Pyar Me")]),
          StreamBuilder(
            stream: player.onPositionChanged,
            builder: (context, spanshot) => ProgressBar(
              progress: spanshot.data ?? Duration.zero,
              total: totalDuration ?? Duration.zero,
              onSeek: (value) {
                player.seek(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PausePlayButton extends StatefulWidget {
  final AudioPlayer player;
  const new({required this.player});

  @override
  State<_PausePlayButton> createState() => _PausePlayButtonState();
}

class _PausePlayButtonState extends State<_PausePlayButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        switch (widget.player.state) {
          case PlayerState.paused:
            await widget.player.resume();
            break;
          case PlayerState.playing:
            await widget.player.pause();
            break;
          case PlayerState.completed || PlayerState.stopped:
            await widget.player.seek(Duration.zero);
            await widget.player.resume();
            break;
          case PlayerState.disposed:
            break;
        }
      },
      icon: StreamBuilder(
        initialData: Icon(Icons.play_arrow),
        stream: widget.player.onPlayerStateChanged,
        builder: (context, playerState) {
          return Icon(switch (widget.player.state) {
            PlayerState.playing => Icons.pause,
            PlayerState.paused || PlayerState.stopped => Icons.play_arrow,
            PlayerState.completed => Icons.replay,
            PlayerState.disposed => Icons.error,
          });
        },
      ),
    );
  }
}
