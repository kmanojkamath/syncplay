import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:syncplay/logic/room_details.dart';

import 'music_card_buttons.dart';

///Widget which displays the list of music cards. It is used in the home page of the app.
class MusicCardsList extends StatelessWidget {
  final RoomDetails roomDetails;
  const new({super.key, required this.roomDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audioList.length,
      itemBuilder: (context, index) =>
          MusicCard(index: index, roomDetails: roomDetails),
    );
  }
}

///Widget which displays a music card. It is used is the MusicCardsList widget.
///It displays the title, artist, and album art of the audio file
///It also displays the pause/play button, the progress bar, and the star button.
class MusicCard extends StatefulWidget {
  final int index;
  final RoomDetails roomDetails;
  const new({super.key, required this.index, required this.roomDetails});

  @override
  State<MusicCard> createState() => MusicCardState();
}

class MusicCardState extends State<MusicCard> {
  @override
  void initState() {
    super.initState();
  }

  AudioMetadata get metadata => widget.roomDetails.metadatas[widget.index];
  AudioPlayer get player => widget.roomDetails.audioPlayers[widget.index];

  DocumentReference<Map<String, dynamic>>? get roomRef =>
      widget.roomDetails.roomRef;
  Room get room => widget.roomDetails.room!;

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
                          roomDetails: widget.roomDetails,
                          index: widget.index,
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
                            onSeek: (value) async {
                              await player.seek(value);
                              if (player.state == PlayerState.playing &&
                                  roomRef != null) {
                                final duration = await player
                                    .getCurrentPosition();
                                room.update(
                                  index: widget.index,
                                  duration: duration,
                                  isPlay: true,
                                );
                                await roomRef!.update(room.toFire());
                              }
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
