import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';

import 'package:syncplay/widgets/listening_room_pages/create_listening_room.dart';
import 'package:syncplay/widgets/listening_room_pages/join_listening_room.dart';
import 'package:syncplay/widgets/listening_room_pages/listening_room.dart';
import 'package:syncplay/widgets/listening_room_pages/listening_room_home.dart';

enum ListeningRoomPage { home, createRoom, joinRoom, room }

///Page which is displayed when the user clicks on the "Listening Room" button in the home page.
///It contains the home page of the listening room, the create room page, the join room page, and the room page.
///The home page is displayed by default, and the create room page, join room page, and room page are displayed when the user clicks on the corresponding buttons.
class ListeningRoom extends StatefulWidget {
  final RoomDetails roomDetails;
  const new({super.key, required this.roomDetails});

  @override
  State<ListeningRoom> createState() => _ListeningRoomState();
}

class _ListeningRoomState extends State<ListeningRoom> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            widget.roomDetails.listeningRoomPage = ListeningRoomPage.home;
            widget.roomDetails.room = null;
          });
        }
      },
      child: switch (widget.roomDetails.listeningRoomPage) {
        ListeningRoomPage.home => listeningRoomHome(
          setState,
          widget.roomDetails,
        ),
        ListeningRoomPage.createRoom => createRoomScreen(
          widget.roomDetails,
          setState,
        ),
        ListeningRoomPage.joinRoom => joinRoomScreen(
          widget.roomDetails,
          setState,
        ),
        ListeningRoomPage.room => listeningRoom(widget.roomDetails),
      },
    );
  }
}
