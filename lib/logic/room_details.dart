import 'dart:async';
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:syncplay/pages/listening_room.dart';

class RoomDetails {
  Room? room;

  DocumentReference<Map<String, dynamic>>? get roomRef => room != null
      ? FirebaseFirestore.instance.collection("rooms").doc(room!.id)
      : null;

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
  TextEditingController searchController = .new();

  bool show(int index) {
    if (audioFiles.isEmpty) return false;

    final fauvouriteCondition = favouritesOnly ? isFavourite[index] : true;

    String songName = (metadatas[index].title ?? "").toLowerCase();
    String artist = (metadatas[index].artist ?? "").toLowerCase();
    final searchCondition =
        songName.contains(searchController.text.toLowerCase()) ||
        artist.contains(searchController.text.toLowerCase());

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

  Future<void> syncRoom() async {
    for (int i = 0; i < audioPlayers.length; i++) {
      if (i == room!.audioIndex) {
        await audioPlayers[i].seek(room!.currentDuration ?? Duration.zero);

        if (room!.isPlaying == true) {
          await audioPlayers[i].resume();
        } else {
          await audioPlayers[i].pause();
        }
      } else {
        await audioPlayers[i].pause();
      }
    }
  }
}

class Room {
  final String name;
  final String id;
  int? audioIndex;
  Duration? currentDuration;
  bool? isPlaying;
  StreamSubscription? _subscription;

  Room({
    required this.name,
    required this.id,
    this.audioIndex,
    this.currentDuration,
    this.isPlaying,
  });

  void startListening({required Future<void> Function() syncRoom}) {
    if (_subscription != null) return;

    _subscription = FirebaseFirestore.instance
        .collection("rooms")
        .doc(id)
        .snapshots()
        .listen((snapshot) async {
          final data = snapshot.data();
          if (data == null) return;

          final storedDuration = data["currentDuration"] != null
              ? Duration(milliseconds: (data["currentDuration"] as num).toInt())
              : Duration.zero;

          final lastUpdated = (data["lastUpdated"] as Timestamp?)?.toDate();

          Duration currentDuration = storedDuration;

          if (data["isPlaying"] == true && lastUpdated != null) {
            final elapsed = DateTime.now().difference(lastUpdated);
            currentDuration += elapsed;
          }

          update(
            index: data["audioIndex"],
            duration: currentDuration,
            isPlay: data["isPlaying"],
          );
          await syncRoom.call();
          print("yo");
        });
  }

  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Map<String, dynamic> toFire() {
    return {
      "name": name,
      "audioIndex": audioIndex,
      "currentDuration": currentDuration?.inMilliseconds,
      "isPlaying": isPlaying,
      "lastUpdated": FieldValue.serverTimestamp(),
    };
  }

  factory Room.fromFire(String id, Map<String, dynamic> data) {
    return Room(
      id: id,
      name: data["name"],
      audioIndex: data["audioIndex"],
      currentDuration: data["currentDuration"] != null
          ? Duration(milliseconds: data["currentDuration"])
          : null,
      isPlaying: data["isPlaying"],
    );
  }

  void update({int? index, Duration? duration, bool? isPlay}) {
    if (index != null) audioIndex = index;
    if (duration != null) currentDuration = duration;
    if (isPlay != null) isPlaying = isPlay;
  }
}
