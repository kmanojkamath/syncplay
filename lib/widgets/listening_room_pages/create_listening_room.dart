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

      FirebaseFirestore.instance.collection("rooms").doc(id).set({
        "name": roomDetails.roomNamecontroller.text,
        "lastUpdated": FieldValue.serverTimestamp(),
        "isPlaying": false
      });
      
      setState(() {
        roomDetails.roomID = id;
        roomDetails.roomName = roomDetails.roomNamecontroller.text;
        roomDetails.listeningRoomPage = ListeningRoomPage.room;
      });
    },
  );
}
