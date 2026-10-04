import 'package:flutter/material.dart';

class MusicCardsList extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: List.generate(10, (i) => _MusicCard()));
  }
}

class _MusicCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text("Music Card")),
    );
  }
}
