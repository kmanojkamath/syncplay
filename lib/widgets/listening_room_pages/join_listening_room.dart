import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/pages/listening_room.dart';

Widget joinRoomScreen(RoomDetails roomDetails, Function setState) {
  return Column(
    children: [
      TextField(controller: roomDetails.roomIDcontroller),
      ElevatedButton(
        onPressed: () async {
          final id = roomDetails.roomIDcontroller.text;
          final doc = await FirebaseFirestore.instance
              .collection("rooms")
              .doc(id)
              .get();
          final data = doc.data();
          if (data == null) {
            //No Such Room
          } else {
            roomDetails.room = Room.fromFire(id, data);

            roomDetails.room!.startListening(syncRoom: roomDetails.syncRoom);
            setState(() {
              roomDetails.listeningRoomPage = ListeningRoomPage.room;
            });
          }
        },
        child: Text("Join"),
      ),
    ],
  );
}
