import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:syncplay/logic/filter.dart';

import 'dart:io';

import 'music_card_buttons.dart';

class MusicCardsList extends StatelessWidget {
  final Filter filter;
  const new({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audioList.length,
      itemBuilder: (context, index) => _MusicCard(
        index: index,
        show: filter.show(index),
        audioFile: filter.audioFiles[index],
      ),
    );
  }
}

class _MusicCard extends StatefulWidget {
  final int index;
  final bool show;
  final File audioFile;
  const new({required this.index, this.show = true, required this.audioFile});

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
    metadata = readMetadata(widget.audioFile, getImage: true);

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final audioPath = audioList[widget.index];
    await player.setSource(AssetSource(audioPath));
    final duration = await player.getDuration();
    setState(() {
      totalDuration = duration;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.sizeOf(context).width;
    return widget.show
        ? Card(
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
                        PausePlayButton(player: player),
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
                        StarButton(index: widget.index),
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
          )
        : SizedBox.shrink();
  }
}
