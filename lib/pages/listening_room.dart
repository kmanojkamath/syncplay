import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';

import 'package:syncplay/widgets/listening_room_pages/create_listening_room.dart';
import 'package:syncplay/widgets/listening_room_pages/join_listening_room.dart';
import 'package:syncplay/widgets/listening_room_pages/listening_room.dart';
import 'package:syncplay/widgets/listening_room_pages/listening_room_home.dart';

enum ListeningRoomPage { home, createRoom, joinRoom, room }

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
        ListeningRoomPage.joinRoom => joinRoomScreen(widget.roomDetails, setState),
        ListeningRoomPage.room => listeningRoom(widget.roomDetails),
      },
    );
  }
}