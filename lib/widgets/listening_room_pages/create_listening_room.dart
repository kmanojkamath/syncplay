import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/pages/listening_room.dart';

///Widget which is displayed when the user clicks on the "Create Room" button in the listening room home page.
Widget createRoomScreen(RoomDetails roomDetails, Function setState) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: roomDetails.roomNamecontroller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Room Name",
      ),
      onSubmitted: (value) async {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        final random = Random();
        final id = List.generate(
          6,
          (_) => chars[random.nextInt(chars.length)],
        ).join();
    
        await FirebaseFirestore.instance
            .collection("rooms")
            .doc(id)
            .set(
              Room(name: roomDetails.roomNamecontroller.text, id: id).toFire(),
            );
    
        roomDetails.room = Room(
          name: roomDetails.roomNamecontroller.text,
          id: id,
        );
    
        roomDetails.room!.startListening(syncRoom: roomDetails.syncRoom);
    
        setState(() {
          roomDetails.listeningRoomPage = ListeningRoomPage.room;
        });
      },
    ),
  );
}
