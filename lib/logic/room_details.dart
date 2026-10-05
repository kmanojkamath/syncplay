
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:syncplay/pages/listening_room.dart';

class RoomDetails {
  String? roomName;
  String? roomID;
  TextEditingController roomNamecontroller = TextEditingController();
  TextEditingController roomIDcontroller = TextEditingController();
  int currentPageIndex = 0;
  ListeningRoomPage listeningRoomPage = ListeningRoomPage.home;

  List<AudioPlayer> audioPlayers = List.generate(audioList.length, (i) {
    final player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    return player;
  });

  final List<File> audioFiles;

  List<AudioMetadata> metadatas = List.empty();

  bool favouritesOnly = false;
  TextEditingController controller = .new();

  bool show(int index) {
    if (audioFiles.isEmpty) return false;

    final fauvouriteCondition = favouritesOnly ? isFavourite[index] : true;

    final metadata = readMetadata(audioFiles[index], getImage: false);
    String songName = (metadata.title ?? "").toLowerCase();
    String artist = (metadata.artist ?? "").toLowerCase();
    final searchCondition =
        songName.contains(controller.text.toLowerCase()) ||
        artist.contains(controller.text.toLowerCase());

    return fauvouriteCondition && searchCondition;
  }

  Future<void> initializePlayers() async {
    for (int i = 0; i < audioPlayers.length; i++) {
      final audioPath = audioList[i];
      await audioPlayers[i].setSource(AssetSource(audioPath));
    }
  }

  RoomDetails(this.audioFiles) {
    metadatas = List.generate(
      audioFiles.length,
      (i) => readMetadata(audioFiles[i], getImage: true),
    );
  }
}
