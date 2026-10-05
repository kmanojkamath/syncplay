import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/widgets/music_card/music_card.dart';

///App bar for HomePage
///It displays the title of the app.
PreferredSizeWidget homePageAppBar() {
  return AppBar(title: Text("SyncPlay"));
}

///Body for Home Page
///It displays the search bar and filter for favourites in the top.
///It diaplays MusicCardsList widget which displays the list of music cards bellow the search bar and filter for favourites.
Widget homePageBody(Function setState, RoomDetails roomDetails) {
  return Column(
    children: [
      _filters(setState, roomDetails),
      if (roomDetails.audioFiles.isNotEmpty)
        Expanded(child: MusicCardsList(roomDetails: roomDetails))
      else
        CircularProgressIndicator(),
    ],
  );
}

Widget _filters(Function setState, RoomDetails roomDetails) {
  return Row(
    children: [
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.search)),
      Expanded(
        child: TextField(
          controller: roomDetails.searchController,
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
              roomDetails.favouritesOnly = !roomDetails.favouritesOnly;
            });
          },
          child: Text("Favourites"),
        ),
      ),
    ],
  );
}

///Bottom Navigation Bar for Home Page
///It is used to navigate between the Home Page and the Listening Room Page.
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
