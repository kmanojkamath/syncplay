import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncplay/data/audios.dart';
import 'package:syncplay/logic/asset_to_file.dart';
import 'package:syncplay/logic/filter.dart';
import 'package:syncplay/pages/listening_room.dart';
import 'package:syncplay/widgets/music_card/home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Filter filter = Filter(List.empty());
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<File> audioFiles = List.filled(audioList.length, File(""));
      for (int i = 0; i < audioList.length; i++) {
        audioFiles[i] = await assetToFile(audioList[i]);
      }
      filter = Filter(audioFiles);
      setState(() {
        filter = Filter(audioFiles);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageAppBar(),
      body: [homePageBody(setState, filter), ListeningRoom()][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.music_note),
            label: "Listening Room",
          ),
        ],
        onDestinationSelected: (value) => setState(() {
          currentPageIndex = value;
        }),
        selectedIndex: currentPageIndex,
      ),
    );
  }
}
