import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';

Widget listeningRoom(RoomDetails roomDetials) {
  return Column(
    children: [
      Text(roomDetials.roomName ?? "No Name"),
      Text(roomDetials.roomID ?? "No ID"),
    ],
  );
}