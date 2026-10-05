import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:syncplay/logic/asset_to_file.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/pages/listening_room.dart';
import 'package:syncplay/widgets/home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RoomDetails roomDetails = RoomDetails(List.empty());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<File> audioFiles = List.filled(audioList.length, File(""));
      for (int i = 0; i < audioList.length; i++) {
        audioFiles[i] = await assetToFile(audioList[i]);
      }
      roomDetails = RoomDetails(audioFiles);
      await roomDetails.initializePlayers();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageAppBar(),
      body: [
        homePageBody(setState, roomDetails),
        ListeningRoom(roomDetails: roomDetails),
      ][roomDetails.currentPageIndex],
      bottomNavigationBar: homePageNavigationBar(setState, roomDetails),
    );
  }
}