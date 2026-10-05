import 'package:flutter/material.dart';
import 'package:syncplay/logic/room_details.dart';

Widget listeningRoom(RoomDetails roomDetials) {
  return Column(
    children: [
      Text(roomDetials.room?.name ?? "No Name"),
      Text(roomDetials.room?.id ?? "No ID"),
    ],
  );
}