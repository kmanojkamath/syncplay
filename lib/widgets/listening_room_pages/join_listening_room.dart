import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/pages/listening_room.dart';

Widget joinRoomScreen(RoomDetails roomDetails, Function setState) {
  return Column(
    children: [
      TextField(controller: roomDetails.roomNamecontroller),
      TextField(controller: roomDetails.roomIDcontroller),
      ElevatedButton(
        onPressed: () {
          setState(() {
            roomDetails.roomID = roomDetails.roomIDcontroller.text;
            roomDetails.roomName = roomDetails.roomNamecontroller.text;
            roomDetails.listeningRoomPage = ListeningRoomPage.room;
          });
        },
        child: Text("Submit"),
      ),
    ],
  );
}
