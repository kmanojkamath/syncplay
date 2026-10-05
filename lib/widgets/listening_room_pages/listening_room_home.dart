import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/pages/listening_room.dart';

///Widget which is displayed when the user clicks on the "Listening Room" button in the home page.
///It is the home page of the listening room.
///Here, the user can click on the "Create Room" button to create a new room, or the "Join Room" button to join an existing room.
Widget listeningRoomHome(Function setState, RoomDetails roomDetails) {
  return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    roomDetails.listeningRoomPage = ListeningRoomPage.createRoom;
                  });
                },
                child: Text("Create Room"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    roomDetails.listeningRoomPage = ListeningRoomPage.joinRoom;
                  });
                },
                child: Text(" Join Room "),
              ),
            ],
          ),
        );
}