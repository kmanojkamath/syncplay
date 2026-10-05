import 'dart:math';

import 'package:flutter/material.dart';

enum ListeningRoomPage { home, createRoom, joinRoom, room }

class ListeningRoom extends StatefulWidget {
  const new({super.key});

  @override
  State<ListeningRoom> createState() => _ListeningRoomState();
}

class _ListeningRoomState extends State<ListeningRoom> {
  final roomDetials = RoomDetails(roomNamecontroller: TextEditingController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            roomDetials.listeningRoomPage = ListeningRoomPage.home;
          });
        }
      },
      child: switch (roomDetials.listeningRoomPage) {
        ListeningRoomPage.home => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    roomDetials.listeningRoomPage = ListeningRoomPage.createRoom;
                  });
                },
                child: Text("Create Room"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    roomDetials.listeningRoomPage = ListeningRoomPage.joinRoom;
                  });
                },
                child: Text(" Join Room "),
              ),
            ],
          ),
        ),
        ListeningRoomPage.createRoom => createRoomScreen(
          roomDetials,
          setState,
        ),
        ListeningRoomPage.joinRoom => Placeholder(),
        ListeningRoomPage.room => listeningRoom(roomDetials),
      },
    );
  }
}

Widget createRoomScreen(
  RoomDetails roomDetials,
  Function setState,
) {
  return TextField(
    controller: roomDetials.roomNamecontroller,
    onSubmitted: (value) {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      final random = Random();
      final id = List.generate(
        6,
        (_) => chars[random.nextInt(chars.length)],
      ).join();

      setState(() {
        roomDetials.roomID = id;
        roomDetials.roomName = roomDetials.roomNamecontroller.text;
        roomDetials.listeningRoomPage = ListeningRoomPage.room;
      });
    },
  );
}

Widget listeningRoom(RoomDetails roomDetials) {
  return Column(
    children: [
      Text(roomDetials.roomName ?? "No Name"),
      Text(roomDetials.roomID ?? "No ID"),
    ],
  );
}

class RoomDetails {
  String? roomName;
  String? roomID;
  TextEditingController roomNamecontroller;
  ListeningRoomPage listeningRoomPage = ListeningRoomPage.home;

  RoomDetails({this.roomID, this.roomName, required this.roomNamecontroller});
}
