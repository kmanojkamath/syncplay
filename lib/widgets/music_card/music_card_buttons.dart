import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:syncplay/logic/room_details.dart';

class PausePlayButton extends StatefulWidget {
  final RoomDetails roomDetails;
  final int index;
  const new({super.key, required this.roomDetails, required this.index});

  @override
  State<PausePlayButton> createState() => _PausePlayButtonState();
}

class _PausePlayButtonState extends State<PausePlayButton> {
  DocumentReference<Map<String, dynamic>>? get roomRef =>
      widget.roomDetails.roomRef;

  Room get room => widget.roomDetails.room!;

  AudioPlayer get player => widget.roomDetails.audioPlayers[widget.index];

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        switch (player.state) {
          case PlayerState.paused:
            await player.resume();
            if (player.state == PlayerState.playing && roomRef != null) {
              final duration = await player.getCurrentPosition();
              room.update(
                index: widget.index,
                duration: duration,
                isPlay: true,
                lastUpdate: DateTime.now(),
              );
              await roomRef!.update(room.toFire());
            }
            break;
          case PlayerState.playing:
            await player.pause();
            if (player.state == PlayerState.paused && roomRef != null) {
              final duration = await player.getCurrentPosition();
              room.update(
                index: widget.index,
                duration: duration,
                isPlay: false,
                lastUpdate: DateTime.now(),
              );
              await roomRef!.update(room.toFire());
            }
            break;
          case PlayerState.completed || PlayerState.stopped:
            await player.seek(Duration.zero);
            await player.resume();
            if (player.state == PlayerState.playing && roomRef != null) {
              final duration = await player.getCurrentPosition();
              room.update(
                index: widget.index,
                duration: duration,
                isPlay: true,
                lastUpdate: DateTime.now(),
              );
              await roomRef!.update(room.toFire());
            }
            break;
          case PlayerState.disposed:
            break;
        }
      },
      icon: StreamBuilder(
        initialData: Icon(Icons.play_arrow),
        stream: player.onPlayerStateChanged,
        builder: (context, playerState) {
          return Icon(switch (player.state) {
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
