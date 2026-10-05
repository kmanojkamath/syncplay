import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> assetToFile(String assetPath) async {
  final ByteData data = await rootBundle.load('assets/$assetPath');

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${assetPath.split('/').last}');

  await file.writeAsBytes(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );

  return file;
}