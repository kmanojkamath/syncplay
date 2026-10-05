import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncplay/firebase_options.dart';

import 'pages/home_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

///Sets up the Firebase emulator for Firestore if the app is running in debug mode.
void setupFirebaseEmulator() {
  if(kDebugMode) FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupFirebaseEmulator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}
