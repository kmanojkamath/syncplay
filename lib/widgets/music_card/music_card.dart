import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:syncplay/logic/room_details.dart';

import 'music_card_buttons.dart';

class MusicCardsList extends StatelessWidget {
  final RoomDetails roomDetails;
  const new({super.key, required this.roomDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audioList.length,
      itemBuilder: (context, index) =>
          _MusicCard(index: index, roomDetails: roomDetails),
    );
  }
}

class _MusicCard extends StatefulWidget {
  final int index;
  final RoomDetails roomDetails;
  const new({required this.index, required this.roomDetails});

  @override
  State<_MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<_MusicCard> {
  @override
  void initState() {
    super.initState();
  }

  AudioMetadata get metadata => widget.roomDetails.metadatas[widget.index];
  AudioPlayer get player => widget.roomDetails.audioPlayers[widget.index];

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.sizeOf(context).width;
    return widget.roomDetails.show(widget.index)
        ? Card(
            child: Row(
              children: [
                SizedBox(
                  width: maxWidth / 5,
                  height: maxWidth / 5,
                  child:
                      widget.roomDetails.metadatas.isNotEmpty &&
                          metadata.pictures.isNotEmpty
                      ? Image.memory(metadata.pictures.first.bytes)
                      : Icon(Icons.music_note),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        PausePlayButton(
                          player: widget.roomDetails.audioPlayers[widget.index],
                        ),
                        SizedBox(
                          width: maxWidth * 0.8 - 104,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                metadata.title ?? "Unknown",
                                overflow: TextOverflow.fade,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                metadata.artist ?? "Unknown Artist",
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
                          width: maxWidth * 0.8 - 24,
                          child: ProgressBar(
                            progress: spanshot.data ?? Duration.zero,
                            total: metadata.duration ?? Duration.zero,
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
