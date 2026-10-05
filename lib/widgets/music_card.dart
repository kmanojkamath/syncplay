import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncplay/data/audios.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class MusicCardsList extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(audioList.length, (i) => _MusicCard(index: i)),
    );
  }
}

class _MusicCard extends StatefulWidget {
  final int index;
  const new({required this.index});

  @override
  State<_MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<_MusicCard> {
  late AudioPlayer player;
  Duration? totalDuration;
  AudioMetadata? metadata;
  double? maxWidth;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    final audioPath = audioList[widget.index];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      maxWidth = MediaQuery.sizeOf(context).width;
      await player.setSource(AssetSource(audioPath));
      totalDuration = await player.getDuration();
      final audioFile = await _assetToFile(audioPath);
      metadata = readMetadata(audioFile, getImage: true);
      setState(() {});
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
      child: Row(
        children: [
          SizedBox(
            width: (maxWidth ?? 0) / 5,
            height: (maxWidth ?? 0) / 5,
            child: metadata != null && metadata!.pictures.isNotEmpty
                ? Image.memory(metadata!.pictures.first.bytes)
                : Icon(Icons.music_note),
          ),
          Column(
            children: [
              Row(
                children: [
                  _PausePlayButton(player: player),
                  SizedBox(
                    width: maxWidth == null ? 0 : maxWidth! * 0.8 - 104,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metadata?.title ?? "Unknown",
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          metadata?.artist ?? "Unknown Artist",
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                  _StarButton(index: widget.index),
                ],
              ),
              StreamBuilder(
                stream: player.onPositionChanged,
                builder: (context, spanshot) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: maxWidth == null ? 0 : maxWidth! * 0.8 - 24,
                    child: ProgressBar(
                      progress: spanshot.data ?? Duration.zero,
                      total: totalDuration ?? Duration.zero,
                      onSeek: (value) {
                        player.seek(value);
                      },
                    ),
                  ),
                ),
              ),
            ],
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

class _StarButton extends StatefulWidget {
  final int index;
  const new({required this.index});

  @override
  State<_StarButton> createState() => __StarButtonState();
}

class __StarButtonState extends State<_StarButton> {
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

Future<File> _assetToFile(String assetPath) async {
  final ByteData data = await rootBundle.load('assets/$assetPath');

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${assetPath.split('/').last}');

  await file.writeAsBytes(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );

  return file;
}
