import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncplay/pages/home_page.dart';
import 'package:syncplay/pages/listening_room.dart';

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