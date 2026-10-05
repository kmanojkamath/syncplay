import 'package:flutter/material.dart';
import 'package:syncplay/pages/home_page.dart';
import 'package:syncplay/pages/listening_room.dart';

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