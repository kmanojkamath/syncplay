import 'package:flutter/material.dart';
import 'package:syncplay/widgets/music_card.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _homePageAppBar(), body: MusicCardsList());
  }
}

PreferredSizeWidget _homePageAppBar() {
  return AppBar(title: Text("SyncPlay"));
}
