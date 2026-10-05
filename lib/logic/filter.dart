import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';

class Filter(final List<File> audioFiles) {
  bool favouritesOnly = false;
  TextEditingController controller = .new();
  bool show(int index) {
    if (audioFiles.isEmpty) return false;

    final fauvouriteCondition = favouritesOnly ? isFavourite[index] : true;

    final metadata = readMetadata(audioFiles[index], getImage: false);
    String songName = (metadata.title ?? "").toLowerCase();
    String artist = (metadata.artist ?? "").toLowerCase();
    final searchCondition =
        songName.contains(controller.text.toLowerCase()) || artist.contains(controller.text.toLowerCase());

    return fauvouriteCondition && searchCondition;
  }
}