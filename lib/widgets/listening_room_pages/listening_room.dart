import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncplay/logic/room_details.dart';
import 'package:syncplay/widgets/music_card/music_card.dart';

///Widget which is displayed when the user is in a listening room.
Widget listeningRoom(RoomDetails roomDetails) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 32, 0, 0),
        child: Text(
          roomDetails.room?.name ?? "No Name",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Room ID: "),
            Text(roomDetails.room?.id ?? "No ID"),
            if (roomDetails.room?.id != null)
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: roomDetails.room!.id));
                },
                icon: const Icon(Icons.copy, size: 18),
              ),
          ],
        ),
      ),
      if (roomDetails.room?.audioIndex != null)
        MusicCard(
          index: roomDetails.room!.audioIndex!,
          roomDetails: roomDetails,
        ),
    ],
  );
}
