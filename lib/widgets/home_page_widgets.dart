import 'package:flutter/material.dart';
import 'package:syncplay/logic/filter.dart';
import 'package:syncplay/pages/home_page.dart';
import 'package:syncplay/widgets/music_card/music_card.dart';

PreferredSizeWidget homePageAppBar() {
  return AppBar(title: Text("SyncPlay"));
}

Widget homePageBody(Function setState, Filter filter) {
  return Column(
    children: [
      _filters(setState, filter),
      if (filter.audioFiles.isNotEmpty)
        Expanded(child: MusicCardsList(filter: filter)),
    ],
  );
}

Widget _filters(Function setState, Filter filter) {
  return Row(
    children: [
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.search)),
      Expanded(
        child: TextField(
          controller: filter.controller,
          onChanged: (_) {
            setState(() {});
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              filter.favouritesOnly = !filter.favouritesOnly;
            });
          },
          child: Text("Favourites"),
        ),
      ),
    ],
  );
}

Widget homePageNavigationBar(Function setState, RoomDetails roomDetials) {
  return NavigationBar(
    destinations: [
      NavigationDestination(icon: Icon(Icons.home), label: "Home"),
      NavigationDestination(
        icon: Icon(Icons.music_note),
        label: "Listening Room",
      ),
    ],
    onDestinationSelected: (value) => setState(() {
      roomDetials.currentPageIndex = value;
    }),
    selectedIndex: roomDetials.currentPageIndex,
  );
}