import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';

class PausePlayButton extends StatefulWidget {
  final AudioPlayer player;
  const new({super.key, required this.player});

  @override
  State<PausePlayButton> createState() => _PausePlayButtonState();
}

class _PausePlayButtonState extends State<PausePlayButton> {
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

class StarButton extends StatefulWidget {
  final int index;
  const new({super.key, required this.index});

  @override
  State<StarButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavourite[widget.index] = !isFavourite[widget.index];
        });
      },
      icon: Icon(
        isFavourite[widget.index] ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
    );
  }
}
