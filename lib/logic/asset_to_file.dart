import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Converts an asset from the app bundle into a temporary local File.
///
/// This is useful when a library or API requires a real file path rather than
/// an asset URI. The asset is loaded from `assets/` and saved into the app's
/// temporary directory before being returned.
Future<File> assetToFile(String assetPath) async {
  final ByteData data = await rootBundle.load('assets/$assetPath');

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${assetPath.split('/').last}');

  await file.writeAsBytes(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );

  return file;
}