import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/pages/listening_room.dart';

Widget createRoomScreen(RoomDetails roomDetails, Function setState) {
  return TextField(
    controller: roomDetails.roomNamecontroller,
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

      setState(() {
        roomDetails.room = Room(
          name: roomDetails.roomNamecontroller.text,
          id: id,
        );
        roomDetails.listeningRoomPage = ListeningRoomPage.room;
      });
    },
  );
}
